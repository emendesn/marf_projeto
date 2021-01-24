#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)

/*/{Protheus.doc} MGFEEC68

Gera Nota de Entrada Classificada apos lancamento de Despesas Nacionais no EEC
Chamado pelo PE EECPEM41

@type function
@author TOTVS
@since JUNHO/2019
@version P12

@param [lWeston], lógico, Indica se Despesa para Weston
/*/
user function MGFEEC68( lWeston )
	local aAreaX		:= getArea()
	local aAreaSC7		:= SC7->( getArea() )
	local aAreaSYB		:= SYB->( getArea() )
	local aAreaEET		:= EET->( getArea() )
	local aAreaEEB		:= EEB->( getArea() )
	local cQrySC7		:= ""
	local aSC7Cab		:= {}
	local aSC7Itens		:= {}
	local aSC7Aux		:= {}
	local aSF1			:= {}
	local aSD1			:= {}
	local aSD1Aux		:= {}
	local cItemSD1		:= ""
	local cItemSC7		:= ""
	local nStackSX8		:= getSx8Len()
	local aErro			:= {}
	local cErro			:= ""
	local nI			:= 0
	local nJ			:= 0
	local nX			:= 0
	local lItensSC7		:= .F.
	local aDocsSC7		:= {}
	local cDocsSC7		:= ""
	local aDocsSF1		:= {}
	local cDoctoAtu		:= ""
	local cLogProc		:= ""
	local cQrySD1		:= ""
	local cEETSeq		:= ""
	local cLibEmbarq	:= allTrim( superGetMv( "MGF_EEC68A", , "473" ) )
	local cQryEEB		:= ""
	local cCondPgtoX	:= ""
	local cDespFrete	:= allTrim( superGetMv( "MGF_EEC67A", , "416,419" ) )
	local aDespFrete	:= {}
	local nCountParc	:= 0
	local aDocsPreCa	:= {}	// CONTEM OS DOCUMENTOS DO PRE CALCULO
	local lPreCalc		:= .T.	// SE .T. PRE CALCULO OK
	local aC7Num		:= {}	// CONTEM OS PEDIDOS USADOS - PARA GERAR GRADE SE NECESSÁRIO
	local lItemFrete	:= .T.	// Indica se o Pedido de Compra contem algum item de Frete
	local cProdFrete	:= ""	// Produtos amarrados com as Despesas de Frete
	local aDocWeston	:= {}	// Documentos que nao serao gerados Nota - Lançamento Weston

	private lGradeSC7		:= .F.
	private lMsHelpAuto     := .T.
	private lMsErroAuto     := .F.
	private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros

	DBSelectArea("EET")

	// ORDENA POR DOCUMENTO E FORNECEDOR
	//aSort( aDespes, , , { | x,y | x[oDespesBrw:GetColByID("xEETDOCTO"	):nOrder] < y[oDespesBrw:GetColByID("xEETDOCTO"	):nOrder] .and. x[oDespesBrw:GetColByID("xY5COD"):nOrder] < y[oDespesBrw:GetColByID("xY5COD"):nOrder] } )
	aSort( aDespes, , , { | x,y | x[oDespesBrw:GetColByID("xEETDOCTO"	):nOrder] + x[oDespesBrw:GetColByID("xY5COD"):nOrder] < y[oDespesBrw:GetColByID("xEETDOCTO"	):nOrder] + y[oDespesBrw:GetColByID("xY5COD"):nOrder] } )

	if lWeston
		aDespFrete := strTokArr2( cDespFrete, ",", .T. )

		cProdFrete := ""
		for nI := 1 to len( aDespFrete )
			cProdFrete += "'" + getAdvFVal( "SYB" , "YB_PRODUTO"	, xFilial("SYB") + aDespFrete[ nI ] , 1 , "" ) + "',"
		next
		cProdFrete := left( cProdFrete , len( cProdFrete ) - 1 ) // remove ultima virgula
	endif

	nJ := 1
	nCountParc	:= 0
	for nI := 1 to len( aExps )
		lItensSC7	:= .F. // Se nao preencher o documento nao gera pedido
		aSC7Cab		:= {}
		aSC7Aux		:= {}
		aSC7Itens	:= {}

		nJ			:= 1
		while nJ <= len( aDespes )
			cDoctoAtu	:= aDespes[ nJ , oDespesBrw:GetColByID("xEETDOCTO"):nOrder ] + aDespes[ nJ , oDespesBrw:GetColByID("xY5COD"):nOrder ]
			aSC7Itens	:= {}
			cCondPgtoX	:= ""
			cCondPgtoX	:= getCndPgto( aDespes[ nJ , oDespesBrw:GetColByID("xEETDTVENC"	):nOrder ] , aDespes[ nJ , oDespesBrw:GetColByID("xEETDESADI"	):nOrder ] )
			while nJ <= len( aDespes ) .and.;
				cDoctoAtu == aDespes[ nJ , oDespesBrw:GetColByID("xEETDOCTO"):nOrder ] + aDespes[ nJ , oDespesBrw:GetColByID("xY5COD"):nOrder ]

				if !lItensSC7
					aSC7Cab := {}
					//aadd( aSC7Cab , { "C7_NUM"			, GetNumSC7()					, nil } )
					aadd( aSC7Cab , { "C7_EMISSAO"		, aDespes[ nJ , oDespesBrw:GetColByID("xEETDESADI"	):nOrder ]			, nil } )

					if aDespes[ nJ , oDespesBrw:GetColByID("xZEETIPODE"	):nOrder ] == "A"
						aadd( aSC7Cab , { "C7_FORNECE"		, aExps[ nI , 12 ]				, nil } )
						aadd( aSC7Cab , { "C7_LOJA"			, aExps[ nI , 13 ]				, nil } )
						aadd( aSC7Cab , { "C7_XCODAGE"		, aExps[ nI , 10 ]				, nil } )
					elseif aDespes[ nJ , oDespesBrw:GetColByID("xZEETIPODE"	):nOrder ] $ "D|T"
						// Despachantes e Terminais podem ter mais de um fornecedor
						// Para esses casos pegara o fornecedor digitado na linha das despesas
						aadd( aSC7Cab , { "C7_FORNECE"		, getAdvFVal("SY5" , "Y5_FORNECE"	, xFilial("SY5") + aDespes[ nJ , oDespesBrw:GetColByID("xY5COD"	):nOrder ]	, 1 , "")	, nil } )
						aadd( aSC7Cab , { "C7_LOJA"			, getAdvFVal("SY5" , "Y5_LOJAF"		, xFilial("SY5") + aDespes[ nJ , oDespesBrw:GetColByID("xY5COD"	):nOrder ]	, 1 , "")	, nil } )
						aadd( aSC7Cab , { "C7_XCODAGE"		, aDespes[ nJ , oDespesBrw:GetColByID("xY5COD"	):nOrder ]																	, nil } )
					endif

					aadd( aSC7Cab , { "C7_COND"			, cCondPgtoX					, nil } )
					aadd( aSC7Cab , { "C7_FILENT"		, aExps[ nI , 1 ]				, nil } )
					aadd( aSC7Cab , { "C7_FILIAL"		, aExps[ nI , 1 ]				, nil } )
					aadd( aSC7Cab , { "C7_FLUXO"		, "S"							, nil } )

					cItemSC7 := ""
					cItemSC7 := strZero ( 0 , tamSX3("C7_ITEM")[1] )
				endif

				if !empty( aDespes[ nJ , oDespesBrw:GetColByID("xEETDOCTO"	):nOrder ] )
					aSC7Aux		:= {}
					lItensSC7	:= .T.
					lItemFrete	:= .F.
					cItemSC7	:= soma1( cItemSC7 )

					if lWeston
						if allTrim( GetAdvFVal("SYB" , "YB_PRODUTO" , xFilial("SYB") + aDespes[ nJ , oDespesBrw:GetColByID("xEETDESPES"	):nOrder ]	, 1 , "" ) ) $ cProdFrete
							aadd( aDocWeston , padL( allTrim( aDespes[ nJ , oDespesBrw:GetColByID("xEETDOCTO"	):nOrder ] ) , tamSX3("F1_DOC")[1] , "0" ) )
						endif
					endif

					aadd( aSC7Aux , { "C7_ITEM"		, cItemSC7																														, nil } )
					aadd( aSC7Aux , { "C7_PRODUTO"	, GetAdvFVal("SYB" , "YB_PRODUTO" , xFilial("SYB") + aDespes[ nJ , oDespesBrw:GetColByID("xEETDESPES"	):nOrder ]	, 1 , "")	, nil } )
					aadd( aSC7Aux , { "C7_QUANT"	, 1																																, nil } )

					if aDespes[ nJ , oDespesBrw:GetColByID("xEETDESPES"	):nOrder ] == cLibEmbarq
						nCountParc++
						if nCountParc < len( aExps )
							aadd( aSC7Aux , { "C7_PRECO"	, round( aDespes[ nJ , oDespesBrw:GetColByID("xEETVALORR"	):nOrder ] / len( aExps ) , 2 ) , nil } )
						else
							// nFirstParc -> Valor das primeiras parcelas
							nFirstParc := ( len( aExps ) - 1 ) * ( aDespes[ nJ , oDespesBrw:GetColByID("xEETVALORR"	):nOrder ] / len( aExps ) )
							//round( aDespes[ nJ , 11 ] - nFirstParc , 2 )
							aadd( aSC7Aux , { "C7_PRECO"	, noRound( aDespes[ nJ , oDespesBrw:GetColByID("xEETVALORR"	):nOrder ] - nFirstParc , 2 )	, nil } )
						endif
					else
						aadd( aSC7Aux , { "C7_PRECO"	, aDespes[ nJ , oDespesBrw:GetColByID("xEETVALORR"	):nOrder ] / len( aExps )	, nil } )
					endif

					aadd( aSC7Aux , { "C7_CC"		, aDespes[ nJ , oDespesBrw:GetColByID("xEETZCCUST"	):nOrder ]													, nil } )
					aadd( aSC7Aux , { "C7_ZCC"		, aDespes[ nJ , oDespesBrw:GetColByID("xEETZCCUST"	):nOrder ]													, nil } )
					aadd( aSC7Aux , { "C7_SEQUEN"	, cItemSC7																										, nil } )
					aadd( aSC7Aux , { "C7_ORIGEM"	, "SIGAEEC"																										, nil } )
					aadd( aSC7Aux , { "C7_FLUXO"	, "S"																											, nil } )
					aadd( aSC7Aux , { "C7_QTDSOL"	, 1																												, nil } )
					aadd( aSC7Aux , { "C7_ZNATURE"	, aDespes[ nJ , oDespesBrw:GetColByID("xEETNATURE"	):nOrder ]													, nil } )
					aadd( aSC7Aux , { "C7_ZDOCTO"	, padL( allTrim( aDespes[ nJ , oDespesBrw:GetColByID("xEETDOCTO"	):nOrder ] ) , tamSX3("F1_DOC")[1] , "0" )	, nil } )
					aadd( aSC7Aux , { "C7_OBS"		, "Emb.Exp: " + aExps[ nI , 2 ]																					, nil } )
					aadd( aSC7Aux , { "C7_ITEMCTA"	, aDespes[ nJ , oDespesBrw:GetColByID("xEETZITEMD"	):nOrder ]													, nil } )
					aadd( aSC7Aux , { "C7_XSERIE"	, aDespes[ nJ , oDespesBrw:GetColByID("xC7XSERIE"	):nOrder ]													, nil } )
					aadd( aSC7Aux , { "C7_XESPECI"	, aDespes[ nJ , oDespesBrw:GetColByID("xC7XESPECI"	):nOrder ]													, nil } )
					aadd( aSC7Aux , { "C7_XOPER"	, aDespes[ nJ , oDespesBrw:GetColByID("xC7XOPER"	):nOrder ]													, nil } )
					aadd( aSC7Aux , { "C7_ZCODGRD"	, 'ZZZZZZZZZZ'																									, nil } )

					aadd( aSC7Itens , aSC7Aux )

					// VERIFICA PRE CALCULO DE CADA DOCUMENTO
					if !chkPreCalc( aDespes[ nJ , oDespesBrw:GetColByID("xEETDOCTO"	):nOrder ] )
						aadd( aDocsPreCa , padL( allTrim( aDespes[ nJ , oDespesBrw:GetColByID("xEETDOCTO"	):nOrder ] ) , tamSX3("F1_DOC")[1] , "0" ) )
					endif
					// FIM - VERIFICA PRE CALCULO DE CADA DOCUMENTO
				endif

				nJ++
			enddo

			if lItensSC7
				lItensSC7 := .F. // FLAG COMO .F. PARA REINICIAR CABECALHO
				varInfo( "aSC7Cab"		, aSC7Cab	)
				varInfo( "aSC7Itens"	, aSC7Itens	)

				lMsErroAuto := .F.

				//msExecAuto( { | x , y , z | mata120( x , y , z ) } , aSC7Cab , aSC7Itens , 3 )
				msExecAuto( { | v , w , x , y , z | mata120( v , w , x , y , z ) } , 1 , aSC7Cab , aSC7Itens , 3 , .f. )

				if lMsErroAuto
					while getSX8Len() > nStackSX8
						ROLLBACKSX8()
					enddo

					aErro := GetAutoGRLog() // Retorna erro em array
					cErro := ""

					for nI := 1 to len(aErro)
						cErro += aErro[nI] + CRLF
					next nI

					conout( " MGFEEC68 - MATA120 " + cErro )
				else
					while getSX8Len() > nStackSX8
						CONFIRMSX8()
					enddo

					if lWeston
						cLogProc += "Devido lançamento para Weston, despesas do tipo Frete não serão geradas Nota de Entrada." + CRLF
						cLogProc += "Pedido de Compra: " + SC7->C7_FILIAL + "/" + SC7->C7_NUM + CRLF
					endif

					aadd( aDocsSC7 , SC7->C7_FILIAL + SC7->C7_NUM , C7_ZDOCTO )

					conout( " MGFEEC68 - MATA120 - Pedido de Compra: " + SC7->C7_FILIAL + SC7->C7_NUM )

					// GRAVA EMPRESA - CASO NAO EXISTA
					cQryEEB := ""

					cQryEEB := "SELECT EEB_PEDIDO"											+ CRLF
					cQryEEB += " FROM " + retSQLName("EEB") + " EEB"						+ CRLF
					cQryEEB += " WHERE"														+ CRLF
					cQryEEB += "		EEB.EEB_PEDIDO	=	'" + aExps[ nI , 2 ]	+ "'"	+ CRLF
					cQryEEB += "	AND	EEB.EEB_CODAGE	=	'" + aExps[ nI , 10 ]	+ "'"	+ CRLF
					cQryEEB += "	AND	EEB.EEB_FILIAL	=	'" + SC7->C7_FILIAL		+ "'"	+ CRLF
					cQryEEB += " 	AND	EEB.D_E_L_E_T_	<>	'*'"							+ CRLF

					conout( cQryEEB )

					tcQuery cQryEEB New Alias "QRYEEB"

					if QRYEEB->(EOF())
						// SE EMPRESA NAO ESTIVER GRAVADA - INCLUI NA TABELA EEB
						recLock("EEB" , .T.)
							EEB->EEB_FILIAL	:= SC7->C7_FILIAL
							EEB->EEB_CODAGE	:= aExps[ nI , 10 ] // CODIGO DO ARMADOR
							EEB->EEB_PEDIDO	:= aExps[ nI , 2 ]	// NUMERO DA EXP

							EEB->EEB_TIPOAG	:= GetAdvFVal("SY5" , "Y5_TIPOAGE"	, xFilial("SY5") + SC7->C7_XCODAGE	, 1 , "")
							EEB->EEB_NOME	:= GetAdvFVal("SY5" , "Y5_NOME"		, xFilial("SY5") + SC7->C7_XCODAGE	, 1 , "")

							EEB->EEB_TXCOMI	:= 0
							EEB->EEB_OCORRE	:= "Q"
							EEB->EEB_TIPCOM	:= "2"
							EEB->EEB_TIPCVL	:= "1"
							EEB->EEB_VALCOM	:= 0
							EEB->EEB_TOTCOM	:= 0
							EEB->EEB_REFAGE	:= ""
							EEB->EEB_FORNEC	:= SC7->C7_FORNECE
							EEB->EEB_LOJAF	:= SC7->C7_LOJA
							EEB->EEB_FOBAGE	:= 0
							EEB->EEB_CONTR	:= ""
						EEB->( msUnlock() )
					endif

					QRYEEB->( DBCloseArea() )
					// FIM - GRAVA EMPRESA - CASO NAO EXISTA

					// INICIO - GRAVA DESPESAS NA TABELA EET
					cEETSeq := ""
					cEETSeq := strZero ( 0 , tamSX3("EET_SEQ")[1] )
					for nX := 1 to len( aDespes )
						if	!empty( aDespes[ nX , oDespesBrw:GetColByID("xEETDOCTO"	):nOrder ] )	;
							.and.																		;
							allTrim( SC7->C7_ZDOCTO ) == padL( allTrim( aDespes[ nX, oDespesBrw:GetColByID("xEETDOCTO"	):nOrder ] ) , tamSX3("F1_DOC")[1] , "0" )

							// SE A DESPESA FOR A MESMA QUE GEROU PEDIDO - VERIFICA PELO DOCUMENTO
							recLock("EET" , .T.)
								cEETSeq			:= soma1( cEETSeq )
								EET->EET_FILIAL	:= SC7->C7_FILIAL
								EET->EET_PEDIDO := aExps[ nI , 2 ]	// NUMERO DA EXP
								EET->EET_PEDCOM	:= SC7->C7_NUM		// NUMERO PEDIDO DE COMPRA
								EET->EET_FORNEC	:= SC7->C7_FORNECE
								EET->EET_LOJAF	:= SC7->C7_LOJA

								if aDespes[ nX , oDespesBrw:GetColByID("xZEETIPODE"	):nOrder ] == "A"
									// CODIGO DO ARMADOR
									EET->EET_CODAGE	:= aExps[ nI , 10 ]
									EET->EET_TIPOAG := GetAdvFVal("SY5" , "Y5_TIPOAGE"	, xFilial("SY5") + aExps[ nI , 10 ]	, 1 , "")
								elseif aDespes[ nX , oDespesBrw:GetColByID("xZEETIPODE"	):nOrder ] $ "D|T"
									// CODIGO DO DESPACHANTE / TERMINAL
									EET->EET_CODAGE	:= aDespes[ nX , oDespesBrw:GetColByID("xY5COD"	):nOrder ]
									EET->EET_TIPOAG := GetAdvFVal("SY5" , "Y5_TIPOAGE"	, xFilial("SY5") + aDespes[ nX , oDespesBrw:GetColByID("xY5COD"	):nOrder ]	, 1 , "")
								endif

								EET->EET_OCORRE	:= "Q"
								EET->EET_SEQ	:= cEETSeq
								EET->EET_DESPES	:= aDespes[ nX, oDespesBrw:GetColByID("xEETDESPES"	):nOrder ]
								EET->EET_XTABPR	:= aDespes[ nX, oDespesBrw:GetColByID("xZEECODIGO"	):nOrder ]
								EET->EET_XMOEPR	:= aDespes[ nX, oDespesBrw:GetColByID("xZEEMOEDA"	):nOrder ]
								EET->EET_XPRECA	:= aDespes[ nX, oDespesBrw:GetColByID("xValPreCal"	):nOrder ] / len( aExps )
								EET->EET_DOCTO	:= aDespes[ nX, oDespesBrw:GetColByID("xEETDOCTO"	):nOrder ]
								EET->EET_DESADI	:= aDespes[ nX, oDespesBrw:GetColByID("xEETDESADI"	):nOrder ]
								EET->EET_VALORR	:= aDespes[ nX, oDespesBrw:GetColByID("xEETVALORR"	):nOrder ] / len( aExps )
								EET->EET_ZMOED	:= aDespes[ nX, oDespesBrw:GetColByID("xEETZMOED"	):nOrder ]// MOEDA - 1-R$;2-US$;3-EUR;4-GBP
								EET->EET_ZTX	:= aDespes[ nX, oDespesBrw:GetColByID("xEETZTX"		):nOrder ]// Taxa Neg.
								EET->EET_ZVLMOE	:= aDespes[ nX, oDespesBrw:GetColByID("xEETZVLMOE"	):nOrder ]// Valor Moeda
								EET->EET_DTVENC	:= aDespes[ nX, oDespesBrw:GetColByID("xEETDTVENC"	):nOrder ]// Vencimento
								EET->EET_NATURE	:= aDespes[ nX, oDespesBrw:GetColByID("xEETNATURE"	):nOrder ]// Natureza
								EET->EET_PREFIX	:= aDespes[ nX, oDespesBrw:GetColByID("xEETPREFIX"	):nOrder ]// Prefixo
								EET->EET_ZCCUST	:= aDespes[ nX, oDespesBrw:GetColByID("xEETZCCUST"	):nOrder ]// Centro Custo
								EET->EET_ZITEMD	:= aDespes[ nX, oDespesBrw:GetColByID("xEETZITEMD"	):nOrder ]// Item Ctb.Deb
								EET->EET_ZNFORN	:= aDespes[ nX, oDespesBrw:GetColByID("xEETZNFORN"	):nOrder ]// NF FORNEC

								EET->EET_ZOBS	:= aDespes[ nX, oDespesBrw:GetColByID("xEETZOBS"	):nOrder ]// NF FORNEC

								// oDespesBrw:GetColByID("xC7XSERIE"	):nOrder
								// oDespesBrw:GetColByID("xC7XESPECI"	):nOrder
								// oDespesBrw:GetColByID("xC7XOPER"		):nOrder

							EET->( msUnlock() )
						endif
					next
					// FIM - GRAVA DESPESAS NA TABELA EET

				endif
			endif
		enddo
	next

	if !empty( aDocsSC7 )
		cDocsSC7 := ""

		for nI := 1 to len( aDocsSC7 )
			cDocsSC7 += "'" + aDocsSC7[ nI ] + "',"
		next

		cDocsSC7 := left( cDocsSC7 , len( cDocsSC7 ) - 1 ) // remove ultima virgula

		cQrySC7	:= ""
		cQrySC7 := "SELECT"
		cQrySC7 += " C7_FILIAL	, C7_ZDOCTO	, C7_EMISSAO	, C7_NUM	, C7_ITEM	,"	+ CRLF
		cQrySC7 += " C7_FORNECE	, C7_LOJA	, C7_ZNATURE	, C7_PRODUTO, C7_ZCC	,"	+ CRLF
		cQrySC7 += " C7_QUANT	, C7_PRECO	, C7_TOTAL		, C7_ITEMCTA,"				+ CRLF
		cQrySC7 += " C7_XSERIE	, C7_XESPECI, C7_XOPER		, C7_COND"					+ CRLF
		cQrySC7 += " FROM " + retSQLName("SC7") + " SC7"								+ CRLF
		cQrySC7 += " WHERE"																+ CRLF
		cQrySC7 += " 		SC7.C7_FILIAL || SC7.C7_NUM	IN	(" + cDocsSC7  + ")"		+ CRLF
		cQrySC7 += " 	AND	SC7.D_E_L_E_T_				<>	'*'"						+ CRLF

		if lWeston
			// Não lança Nota de Entrada para Documentos com Frete - Lançamento Weston
			cDespFrete := ""
			for nI := 1 to len( aDocWeston )
				cDespFrete += "'" + aDocWeston[ nI ] + "',"
			next
			cDespFrete := left( cDespFrete , len( cDespFrete ) - 1 ) // remove ultima virgula

			if !empty( cDespFrete )
				cQrySC7 += " 	AND	SC7.C7_ZDOCTO NOT IN (" + cDespFrete + ")"		+ CRLF
			endif
		endif

		cQrySC7 += " ORDER BY C7_ZDOCTO , C7_FORNECE , C7_LOJA"												+ CRLF

		conout( cQrySC7 )

		tcQuery cQrySC7 New Alias "QRYSC7"

		// Se lanaçamento de despesas estiver de acordo com o pre calculo gera Nota de Entrada + Titulo com Grade
		cDoctoAtu := ""
		while !QRYSC7->(EOF())
			aSF1 := {}

			aadd( aSF1 , {"F1_FILIAL"	, QRYSC7->C7_FILIAL			, nil } )
			aadd( aSF1 , {"F1_TIPO"   	, "N"						, nil } )
			aadd( aSF1 , {"F1_FORMUL" 	, "N"						, nil } )
			aadd( aSF1 , {"F1_DOC"		, padL( allTrim( QRYSC7->C7_ZDOCTO ) , tamSX3("F1_DOC")[1] , "0" )			, nil } )
			aadd( aSF1 , {"F1_SERIE"	, QRYSC7->C7_XSERIE			, nil } )
			aadd( aSF1 , {"F1_EMISSAO"	, sToD( QRYSC7->C7_EMISSAO ), nil } )
			aadd( aSF1 , {"F1_FORNECE"	, QRYSC7->C7_FORNECE		, nil } )
			aadd( aSF1 , {"F1_LOJA"   	, QRYSC7->C7_LOJA			, nil } )
			aadd( aSF1 , {"F1_ESPECIE"	, QRYSC7->C7_XESPECI		, nil } )
			aadd( aSF1 , {"F1_EST"		, getAdvFVal( "SA2" , "A2_EST" , xFilial("SA2") + QRYSC7->( C7_FORNECE + C7_LOJA ) , 1 , "")					, nil } )
			aadd( aSF1 , {"F1_COND"		, QRYSC7->C7_COND			, nil } )
			aadd( aSF1 , {"E2_NATUREZ"	, QRYSC7->C7_ZNATURE		, nil } )
			aadd( aSF1 , {"F1_DTDIGIT"	, dDataBase					, nil } )

			cItemSD1	:= ""
			cItemSD1	:= strZero ( 0 , tamSX3("D1_ITEM")[1] )
			cDoctoAtu	:= QRYSC7->( C7_ZDOCTO + C7_FORNECE + C7_LOJA )
			aSD1		:= {}
			lPreCalc	:= .T.

			// VERIFICA PRE CALCULO DE CADA DOCUMENTO
			for nI := 1 to len( aDocsPreCa )
				if allTrim( aDocsPreCa[ nI ] ) == allTrim( QRYSC7->C7_ZDOCTO )
					lPreCalc := .F.
					exit
				endif
			next
			// FIM - VERIFICA PRE CALCULO DE CADA DOCUMENTO

			aC7Num := {}
			while !QRYSC7->(EOF()) .and. cDoctoAtu == ( C7_ZDOCTO + C7_FORNECE + C7_LOJA )
				cItemSD1	:= soma1( cItemSD1 )
				aSD1Aux		:= {}

				//varInfo( "D1 1" , QRYSC7->C7_PRECO )
				//varInfo( "D1 2" , noRound( QRYSC7->C7_PRECO , 2 ) )

				aadd( aSD1Aux , { "D1_FILIAL"	, QRYSC7->C7_FILIAL					, nil } )
				aadd( aSD1Aux , { "D1_ITEM"		, cItemSD1							, nil } )
				aadd( aSD1Aux , { "D1_COD"		, QRYSC7->C7_PRODUTO				, nil } )
				aadd( aSD1Aux , { "D1_QUANT"	, QRYSC7->C7_QUANT					, nil } )
				//aadd( aSD1Aux , { "D1_VUNIT"	, noRound( QRYSC7->C7_PRECO , 2 )	, nil } )
				//aadd( aSD1Aux , { "D1_TOTAL"	, noRound( QRYSC7->C7_PRECO , 2 )	, nil } )
				aadd( aSD1Aux , { "D1_VUNIT"	, QRYSC7->C7_PRECO					, nil } )
				aadd( aSD1Aux , { "D1_TOTAL"	, QRYSC7->C7_PRECO					, nil } )

				if lPreCalc
					// SE PRE CALCULO OK -> NOTA CLASSIFICADA
					aadd( aSD1Aux , { "D1_OPER"		, QRYSC7->C7_XOPER		, nil } )
				endif

				aadd( aSD1Aux , { "D1_CC"		, QRYSC7->C7_ZCC		, nil } )

				aadd( aSD1Aux, { "D1_PEDIDO"	, QRYSC7->C7_NUM		, NIL } )
				aadd( aSD1Aux, { "D1_ITEMPC"	, QRYSC7->C7_ITEM		, NIL } )

				aadd( aSD1Aux, { "D1_ITEMCTA"	, QRYSC7->C7_ITEMCTA	, NIL } )
				aadd( aSD1Aux, { "D1_QTDPEDI"	, QRYSC7->C7_QUANT		, NIL } )

				aadd( aSD1 , aSD1Aux )

				aadd( aC7Num , QRYSC7->C7_NUM )

				QRYSC7->( DBSkip() )
			enddo

			varInfo( "aSD1" , aSD1 )
			varInfo( "aSF1" , aSF1 )

			lMsErroAuto := .F.

			if lPreCalc
				// SE PRE CALCULO OK -> NOTA CLASSIFICADA
				msExecAuto({|x,y,z| MATA103(x,y,z)}, aSF1, aSD1, 3)
			else
				// SE LANCAMENTO DIVERGENTE DE PRE CALCULO -> PRE NOTA
				msExecAuto({|x,y,z| MATA140(x,y,z)}, aSF1, aSD1, 3)
			endif

			if lMsErroAuto
				while getSX8Len() > nStackSX8
					ROLLBACKSX8()
				enddo

				aErro := GetAutoGRLog() // Retorna erro em array
				cErro := ""

				for nI := 1 to len(aErro)
					cErro += aErro[nI] + CRLF
				next nI

				if lPreCalc
					conout( " MGFEEC68 - MATA103 - " + cErro )
				else
					conout( " MGFEEC68 - MATA140 - " + cErro )
				endif
			else
				while getSX8Len() > nStackSX8
					CONFIRMSX8()
				enddo

				if lPreCalc
					conout( " MGFEEC68 - MATA103 - Nota de Entrada: " + SF1->( F1_FILIAL + F1_DOC ) )
				else
					conout( " MGFEEC68 - MATA140 - PRE Nota de Entrada: " + SF1->( F1_FILIAL + F1_DOC ) )
				endif

				aadd( aDocsSF1 , { SF1->F1_FILIAL , SF1->F1_DOC , SF1->F1_SERIE , SF1->F1_FORNECE , SF1->F1_LOJA } )

				// APOS PROCESSAMENTO - PROCESSAMENTO DE BLOQUEIOS - FAZ ISSO PARA NAO BLOQUEAR GERACAO DA PRE NOTA
				if !lPreCalc
					for nI := 1 to len( aC7Num )
						lGradeSC7 := .T.
						u_xMG8FIM( aC7Num[ nI ] , 3 , )
					next
				endif
				// FIM - PROCESSAMENTO DE BLOQUEIO
			endif
		enddo

		QRYSC7->(DBCloseArea())

		// Exibe as Notas e Pedidos de Compra gerados
		cLogProc := ""
		for nI := 1 to len( aDocsSF1 )
			cQrySD1	:= ""
			cQrySD1 := "SELECT D1_FILIAL , D1_DOC , D1_SERIE , D1_FORNECE , D1_LOJA, D1_PEDIDO, D1_ITEMPC"	+ CRLF
			cQrySD1 += " FROM " + retSQLName("SD1") + " SD1"												+ CRLF
			cQrySD1 += " WHERE"																				+ CRLF
			cQrySD1 += "		SD1.D1_LOJA		=	'" + aDocsSF1[ nI , 5 ]	+ "'"							+ CRLF
			cQrySD1 += "	AND SD1.D1_FORNECE	=	'" + aDocsSF1[ nI , 4 ]	+ "'"							+ CRLF
			cQrySD1 += "	AND SD1.D1_SERIE	=	'" + aDocsSF1[ nI , 3 ]	+ "'"							+ CRLF
			cQrySD1 += "	AND SD1.D1_DOC		=	'" + aDocsSF1[ nI , 2 ]	+ "'"							+ CRLF
			cQrySD1 += " 	AND SD1.D1_FILIAL	=	'" + aDocsSF1[ nI , 1 ]	+ "'"							+ CRLF
			cQrySD1 += " 	AND SD1.D_E_L_E_T_	<>	'*'"													+ CRLF

			tcQuery cQrySD1 new alias "QRYSD1"

			while !QRYSD1->( EOF() )
				cLogProc += "Nota de Entrada: " + QRYSD1->D1_DOC + " / " + QRYSD1->D1_SERIE + " Pedido " + QRYSD1->D1_PEDIDO + " Item " + QRYSD1->D1_ITEMPC + CRLF
				QRYSD1->( DBSkip() )
			enddo

			QRYSD1->( DBCloseArea() )
		next

		if !empty( cLogProc )
			if !lPreCalc
				cLogProc := "Devido a divergências com o Pré Cálculo, foram geradas as Pré Notas abaixo: " + CRLF + cLogProc
			endif

			staticCall( MGFEEC64 , showLog , cLogProc , "Resultado do Lançamento" , "Resultado do Lançamento: " )
		endif

		if !empty( cErro )
			staticCall( MGFEEC64 , showLog , cErro , "Erros encontrados" , "Erros encontrados: " )
		endif
	else
		if !empty( cErro )
			staticCall( MGFEEC64 , showLog , cErro , "Erros encontrados" , "Erros encontrados: " )
		endif
	endif

	restArea( aAreaEEB )
	restArea( aAreaEET )
	restArea( aAreaSYB )
	restArea( aAreaSC7 )
	restArea( aAreaX )
return

//-----------------------------------------------------------------------
// Retorna a Condição de Pagamento de acordo com vencimento informado
//-----------------------------------------------------------------------
static function getCndPgto( dVencDespe , dDtEmissao )
	local cRetCondPg	:= ""
	local cQrySE4		:= ""
	local nDias			:= ( dVencDespe - dDtEmissao )

	cQrySE4 := "SELECT E4_CODIGO"											+ CRLF
	cQrySE4 += " FROM " + retSQLName("SE4") + " SE4"						+ CRLF
	cQrySE4 += " WHERE"														+ CRLF

	if nDias > 99
		cQrySE4 += "		SE4.E4_COND		=	'" + strZero( nDias , 3 ) + "'"	+ CRLF
	else
		cQrySE4 += "		SE4.E4_COND		=	'" + strZero( nDias , 2 ) + "'"	+ CRLF
	endif

	cQrySE4 += " 	AND	SE4.D_E_L_E_T_	<>	'*'"							+ CRLF

	conout( cQrySE4 )

	tcQuery cQrySE4 New Alias "QRYSE4"

	if !QRYSE4->( EOF() )
		cRetCondPg := QRYSE4->E4_CODIGO
	endif

	QRYSE4->( DBCloseArea() )

return cRetCondPg

//---------------------------------------------------------------------------------
// Verifica se Despesas lançadas estao dentro do pre calculo
// Caso estejam, deve gerar Nota de Entrada + Titulo a Pagar com Grade
// Caso sejam divergentes do Pre Calculo, deve gerar Pre Nota de Entrada com Grade
//---------------------------------------------------------------------------------
static function chkPreCalc( cChkDoc )
	local lPreCalcOk	:= .T.
	local nI			:= 0

	for nI := 1 to len( aDespes )
		if	!empty( aDespes[ nI , oDespesBrw:GetColByID("xEETDOCTO" ):nOrder ] )	;
			.and.																	;
			aDespes[ nI , oDespesBrw:GetColByID("xEETDOCTO" ):nOrder ] == cChkDoc

			if aDespes[ nI , oDespesBrw:GetColByID("xEETZTX" ):nOrder ] > 0
				// SE A TAXA FOR INFORMADA - DIVIDE VALOR DO DOCUMENTO PELA TAXA - RESULTADO NAO PODE SER MAIOR QUE O PRE CALCULO
				if	( aDespes[ nI , oDespesBrw:GetColByID("xEETVALORR" ):nOrder ] / aDespes[ nI , oDespesBrw:GetColByID("xEETZTX" ):nOrder ] )	;
					>																															;
					aDespes[ nI , oDespesBrw:GetColByID("xValPreCal" ):nOrder ]
					// VALOR DO DOCUMENTO MAIOR QUE O PRE CALCULO
					lPreCalcOk := .F.
					exit
				endif
			elseif aDespes[ nI , oDespesBrw:GetColByID("xEETVALORR" ):nOrder ] > aDespes[ nI , oDespesBrw:GetColByID("xValPreCal" ):nOrder ]
				// VALOR DO DOCUMENTO MAIOR QUE O PRE CALCULO
				lPreCalcOk := .F.
				exit
			else
				staticCall( MGFEEC67 , getDesp , aDespes[ nI , oDespesBrw:GetColByID("xEETDESPES"):nOrder ] )

				if QRYZED->( EOF() )
					QRYZED->( DBCloseArea() )
					// DESPESA LANCADA NAO EXISTE DESPESA NO PRE CALCULO
					lPreCalcOk := .F.
					exit
				endif
				QRYZED->( DBCloseArea() )
			endif
		endif
	next
return lPreCalcOk