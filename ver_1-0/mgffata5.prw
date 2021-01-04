#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr( 13 ) + chr( 10  )

static _aErr

//---------------------------------------------------------------------
//---------------------------------------------------------------------
user function MGFFATA5()
	ptinternal(1,"MGFFATA5 - START")
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001"
	ptinternal(1,"MGFFATA5 - AVAIABLE")
return .T.

//---------------------------------------------------------------------
//---------------------------------------------------------------------
user function runFATA5( cIdToProc, xFil )
	local nI				:= 0
	local nX				:= 0
	local aSC5				:= {}
	local aSC6				:= {}
	local aSC6Bonif			:= {}
	local aErro				:= {}
	local cErro				:= ""
	local aLine				:= {}
	local bError 			:= ErrorBlock( { |oError| errorFat53( oError ) } )
	local cSalesOrAt		:= ""
	local cTpFretECO		:= allTrim( superGetMv( "MGF_FREECO", , "C" ) )
	local cCondPgEco		:= allTrim( superGetMv( "MGFECOCDPG", , "999" ) )
	local cTpPedCC			:= allTrim( superGetMv( "MGFECOTPCC", , "CC" ) )

	local nStackSX8         := GetSx8Len()

	local cQrySC5			:= ""
	local cAliasSC5			:= getNextAlias()
	local cItemSC6			:= ""

	local nC5DescBol		:= 0
	local nC5DescCup		:= 0
	local nC5DescTot		:= 0 // Total de Desconto em Valor
	local nC5PercTot		:= 0 // Total de Desconto em Porcentual
	local nC6ValoTot		:= 0 // Total dos itens sem Desconto

	local cIdCard			:= ""
	local nCalc				:= 0
	local cPay				:= ""

	private aCustomer		:= {}
	private cAliasXC5		:= getNextAlias()
	private lMsHelpAuto     := .T.
	private lMsErroAuto     := .F.
	private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros

	default cIdToProc		:= ""
	default xFil			:= ""

	if !empty( xFil )
		cFilBkp := cFilAnt
		cFilAnt := xFil
	endif

	getXC5( cIdToProc )

	while !(cAliasXC5)->( EOF() )
		BEGIN SEQUENCE
			aCustomer := {}
			aCustomer := getCustome((cAliasXC5)->XC5_CLIENT)

			if len(aCustomer) == 0
				updXC5( (cAliasXC5)->XC5_IDECOM, "4", "Cliente não encontrado" ) // 1 - Recebido / 2 - Processando / 3 - Gerado Pedido / 4 - Erro
				(cAliasXC5)->( DBSkip() )
			else
				nCalc := (cAliasXC5)->XC5_VALCAU
				cPay  := (cAliasXC5)->XC5_PAYMID

				aSC5 := {}
				aadd(aSC5, {'C5_TIPO'   	, "N"									, NIL})
				aadd(aSC5, {'C5_CLIENTE'	, aCustomer[1, 1]						, NIL})
				aadd(aSC5, {'C5_LOJACLI'	, aCustomer[1, 2]						, NIL})
				aadd(aSC5, {'C5_TIPOCLI'	, aCustomer[1, 4]						, NIL})

				if !empty( (cAliasXC5)->XC5_NSU )
					// Condição de pagamento POR CARTAO
					aadd(aSC5, {'C5_CONDPAG'	, cCondPgEco						, NIL})
					aadd(aSC5, {'C5_ZNSU'		, (cAliasXC5)->XC5_NSU				, NIL})
				endif

				aadd(aSC5, {'C5_VEND1'		, (cAliasXC5)->XC5_VENDED				, NIL})

				if !empty( (cAliasXC5)->XC5_NSU )
					aadd(aSC5, {'C5_ZTIPPED'	, cTpPedCC				, NIL})
				else
					aadd(aSC5, {'C5_ZTIPPED'	, (cAliasXC5)->XC5_ZTIPPE				, NIL})
				endif

				aadd(aSC5, {'C5_ZTPOPER'	, (cAliasXC5)->XC5_ZTIPOP				, NIL})
				aadd(aSC5, {'C5_TABELA'		, allTrim( (cAliasXC5)->XC5_TABELA )	, NIL})

				if !empty( (cAliasXC5)->XC5_ZIDEND )
					aadd(aSC5, {'C5_ZIDEND'	, (cAliasXC5)->XC5_ZIDEND				, NIL})
				endif

				aadd(aSC5, {'C5_TPFRETE'		, cTpFretECO 						, NIL})

				if !empty( (cAliasXC5)->XC5_DTENTR )
					aadd(aSC5, {'C5_FECENT'		, sToD( (cAliasXC5)->XC5_DTENTR ) 			, NIL})
					aadd(aSC5, {'C5_ZDTEMBA'	, sToD( (cAliasXC5)->XC5_DTENTR ) 			, NIL})
				endif

				aadd(aSC5, {'C5_ZIDECOM'	, (cAliasXC5)->XC5_IDECOM					, NIL})

				/*
					Tratamento de Desconto
				*/
				nC5DescCup := 0
				if (cAliasXC5)->XC5_DESCPV > 0
					nC5DescCup := (cAliasXC5)->XC5_DESCPV
					aadd(aSC5, {'C5_ZDSCECO'	, (cAliasXC5)->XC5_DESCPV	, NIL})
				endif

				nC5DescBol := 0
				if (cAliasXC5)->XC5_DSCBOL > 0
					nC5DescBol := (cAliasXC5)->XC5_DSCBOL
					aadd(aSC5, {'C5_ZDSCBOL'	, (cAliasXC5)->XC5_DSCBOL	, NIL})
				endif
				/*
					FIM - Tratamento de Desconto
				*/

				aadd(aSC5, {'C5_ZUSANCC'	, (cAliasXC5)->XC5_USANCC		, NIL})

				if !empty( (cAliasXC5)->XC5_PROMOC )
					aadd(aSC5, {'C5_ZPROMOC'	, (cAliasXC5)->XC5_PROMOC	, NIL})
				endif

				if !empty( (cAliasXC5)->XC5_DTCARR )
					aadd(aSC5, {'C5_ZDTCARR'	, sToD((cAliasXC5)->XC5_DTCARR)	, NIL})
				endif

				aadd(aSC5, {'C5_XORIGEM'	, (cAliasXC5)->XC5_ORIGEM					, NIL})
				aadd(aSC5, {'C5_XCALLBA'	, "S"										, NIL})

				cSalesOrAt	:= (cAliasXC5)->XC5_IDECOM
				cIdCard		:= ""
				cIdCard		:= (cAliasXC5)->XC5_IDPROF

				aSC6		:= {}
				aSC6Bonif	:= {}

				cItemSC6 := ""
				cItemSC6 := strZero ( 0 , tamSX3("C6_ITEM")[1] )

				nC6ValoTot := 0
				while !(cAliasXC5)->( EOF() ) .and. cSalesOrAt == (cAliasXC5)->XC5_IDECOM

					nC6ValoTot += (cAliasXC5)->XC6_PRCVEN

					aLine := {}

					cItemSC6 := soma1( cItemSC6 )

					aadd(aLine, {'C6_ITEM'		, cItemSC6															, NIL})
					aadd(aLine, {'C6_PRODUTO'	, alltrim( (cAliasXC5)->XC6_PRODUT )								, NIL})
					aadd(aLine, {'C6_QTDVEN'	, (cAliasXC5)->XC6_QTDVEN											, NIL})

					if (cAliasXC5)->VALDESC <> (cAliasXC5)->XC6_PRCVEN
						// Normal
						aadd(aLine, {'C6_PRCVEN'	, ( (cAliasXC5)->XC6_PRCVEN / (cAliasXC5)->XC6_QTDVEN )				, NIL})

						if ( (cAliasXC5)->XC6_PRCVEN - (cAliasXC5)->XC6_DSCITE ) > 0
							aadd(aLine, {'C6_ZDSCITM'	, ( (cAliasXC5)->XC6_PRCVEN - (cAliasXC5)->XC6_DSCITE )	, NIL}) // GRAVA SOMENTE DESCONTO DO ITEM
							aadd(aLine, {'C6_VALDESC'	, ( (cAliasXC5)->XC6_PRCVEN - (cAliasXC5)->XC6_DSCITE )	, NIL}) // GRAVA SOMENTE DESCONTO DO ITEM
						endif
					else
						// Bonificação
						nValBonifi := 0
						nValBonifi := 0.0001 / ( 0.01 * (cAliasXC5)->XC6_QTDVEN )

						aadd(aLine, {'C6_PRCVEN'	, nValBonifi														, NIL})

						/*

							0,01		=	0,14
							x			=	0,01

							X * 0,14	=	0,01 * 0,01


							X			=	0,0001 / 0,14
							x			=	0,000714285714286
						*/
					endif

					aadd(aLine, {'C6_OPER'		, (cAliasXC5)->XC6_OPER												, NIL})

					aadd(aLine, {'C6_ZDTMIN'	, CTOD("  /  /  ")	, NIL})
					aadd(aLine, {'C6_ZDTMAX'	, CTOD("  /  /  ")	, NIL})

					aadd( aSC6, aLine )

					(cAliasXC5)->( DBSkip() )
				enddo

				/*
					Tratamento de Desconto
				*/
				nC5DescTot := 0
				nC5DescTot := ( nC5DescBol + nC5DescCup )

				nC5PercTot := 0
				if nC5DescTot > 0
					nC5PercTot := ( nC5DescTot * 100 ) / nC6ValoTot

					aadd(aSC5, {'C5_PDESCAB'		, nC5PercTot			, NIL})
				endif

				/*
					FIM - Tratamento de Desconto
				*/

				aSC5 := fwVetByDic( aSC5 /*aVetor*/ , "SC5" /*cTable*/ , .F. /*lItens*/ )
				aSC6 := fwVetByDic( aSC6 /*aVetor*/ , "SC6" /*cTable*/ , .T. /*lItens*/ )

				varInfo( "aSC5"	, aSC5 )
				varInfo( "aSC6"	, aSC6 )

				lMsErroAuto := .F.
				msExecAuto({|x,y,z|MATA410(x,y,z)}, aSC5, aSC6, 3)

				if lMsErroAuto
					while GetSX8Len() > nStackSX8
						ROLLBACKSX8()
					enddo

					aErro := GetAutoGRLog() // Retorna erro em array
					cErro := ""

					for nI := 1 to len(aErro)
						cErro += aErro[nI] + CRLF
					next nI

					//cNameLog := funName() + dToS(dDataBase) + strTran(time(),":")
					//memoWrite("\" + cNameLog , cErro)
				else
					while GetSX8Len() > nStackSX8
						CONFIRMSX8()
					enddo

					conout(' [E-COM] [MGFFATA5] [EMPRESA] ' + allTrim(cEmpAnt) + ' [FILIAL] ' + allTrim(cFilAnt) + ' Gerado Pedido para ID ECO ' + cSalesOrAt + ' ' + time() )

					updXC5( cSalesOrAt, "3", "Pedido Incluido", SC5->C5_NUM	, "" ) // 1 - Recebido / 2 - Processando / 3 - Gerado Pedido / 4 - Erro
					if !empty( SC5->C5_ZNSU )
						geraCaucao( cIdCard,SC5->C5_CLIENTE,SC5->C5_LOJACLI,SC5->C5_XNOMECL,SC5->C5_XCGCCPF,nCalc,cPay )
					endif

					if SC5->C5_ZUSANCC == "1"
						updSA1( aCustomer[1, 1], aCustomer[1, 2] )
					endif
				endif

				// TRATAMENTO FEITO POIS A ROTINA AUTOMATICA ESTAVA RETORNANDO ERRO POREM GERAVA PEDIDO
				// CASO INDIQUE ERRO FAZ UM CHECK NA SC5
				if lMsErroAuto
					cQrySC5 := ""
					cQrySC5 := "SELECT C5_FILIAL, C5_NUM, XC5_IDECOM, C5_VEND1"
					cQrySC5 += " FROM "			+ retSQLName("SC5") + " SC5"
					cQrySC5 += " INNER JOIN "	+ retSQLName("XC5") + " XC5"
					cQrySC5 += " ON"

					cQrySC5 += "         TRIM(SC5.C5_ZIDECOM)	=	'" + allTrim( cSalesOrAt ) + "'"

					cQrySC5 += "     AND XC5_FILIAL				=	'" + xFilial("SC5") + "'"
					cQrySC5 += "     AND XC5.D_E_L_E_T_			<>	'*'"
					cQrySC5 += " WHERE"
					cQrySC5 += "     SC5.D_E_L_E_T_		<>	'*'"
					cQrySC5 += " AND SC5.C5_FILIAL		=	'" + xFilial("SC5") + "'"

					tcQuery cQrySC5 new Alias (cAliasSC5)

					if !(cAliasSC5)->(EOF())
						while GetSX8Len() > nStackSX8
							CONFIRMSX8()
						enddo

						conout(' [E-COM] [MGFFATA5] [EMPRESA] ' + allTrim(cEmpAnt) + ' [FILIAL] ' + allTrim(cFilAnt) + ' Gerado Pedido para ID ECO ' + cSalesOrAt + ' ' + time() )

						updXC5( cSalesOrAt, "3", "Pedido Incluido", (cAliasSC5)->C5_NUM	, "" ) // 1 - Recebido / 2 - Processando / 3 - Gerado Pedido / 4 - Erro
						if !empty( SC5->C5_ZNSU )
							geraCaucao( cIdCard,SC5->C5_CLIENTE,SC5->C5_LOJACLI,SC5->C5_XNOMECL,SC5->C5_XCGCCPF,nCalc,cPay )
						endif

						if SC5->C5_ZUSANCC == "1"
							updSA1( aCustomer[1, 1], aCustomer[1, 2] )
						endif
					else
						updXC5( cSalesOrAt, "4", "Erro Pedido" + CRLF + cErro, "", "" ) // 1 - Recebido / 2 - Processando / 3 - Gerado Pedido / 4 - Erro

						conout(' [E-COM] [MGFFATA5] [EMPRESA] ' + allTrim(cEmpAnt) + ' [FILIAL] ' + allTrim(cFilAnt) + ' Erro na geracao do Pedido ID ECO: ' + cSalesOrAt + ' Erro gerado: ' + cErro + ' ' + time() )
					endif

					(cAliasSC5)->(DBCloseArea())
				endif
			endif
		RECOVER
			Conout(' [E-COM] [MGFFATA5] [EMPRESA] ' + allTrim(cEmpAnt) + ' [FILIAL] ' + allTrim(cFilAnt) + ' Problema Ocorreu em : ' + dToC(dDataBase) + " - " + time() )
		END SEQUENCE
	enddo

	(cAliasXC5)->( DBCloseArea() )

	if !empty( xFil )
		cFilAnt := cFilBkp
	endif

	delClassINTF()
return

//-------------------------------------------------------
//-------------------------------------------------------
static function geraCaucao( cIdCard, cCliente, cLoja, cNome, cCGC, nCalc, cPay )

	local aSE1			:= {}
	local cPrefixECO	:= allTrim( superGetMv( "MGF_PREFEC", , "ECO" ) )
	local cTipoECO		:= allTrim( superGetMv( "MGF_TIPOEC", , "CC" ) )
	local nPorcCauca	:= superGetMv( "MGF_PORCCA", , 25 )
	local nTotalSE1		:= 0
	local cHistor		:= "Caução gerado com acréscimo de " + allTrim( str( nPorcCauca ) ) + "%"
	local aErro			:= {}
	local cErro			:= ""
	local cQrySC6Sum	:= ""
	local cAccessTok	:= ""
	local nStackSX8		:= GetSx8Len()

	local cQryZEC		:= ""
	local cCard			:= ""
	local cUpdSC5		:= ""
	local oCard			:= nil

	local aArea			:= getArea()
	local aAreaSZV		:= SZV->( getArea() )
	local aAreaSC5		:= SC5->( getArea() )

	cAccessTok := ""
	cAccessTok := u_authGtnt() // Retorna Token para utilizar os metodos da GetNet

	if !empty( cAccessTok )
		cCard := ""
		cCard := u_recoCard( cAccessTok, allTrim( cIdCard ) ) // Retorna dados do cartao em JSON 'string'

		oCard := nil
		if fwJsonDeserialize( cCard, @oCard ) // Transforma a string JSON em OBJETO
			if u_chkCard( cAccessTok, oCard:CARDHOLDER_NAME, oCard:EXPIRATION_MONTH, oCard:EXPIRATION_YEAR, oCard:NUMBER_TOKEN ) // Verifica se Cartao esta VALIDO
				cQryZEC := "SELECT "																	+ CRLF
				cQryZEC += "    ZEC_FILIAL, "															+ CRLF
				cQryZEC += "    ZEC_CODIGO, "															+ CRLF
				cQryZEC += "    ZEC_DESCRI, "															+ CRLF
				cQryZEC += "    ZEC_DIAS,   "															+ CRLF
				cQryZEC += "    ZEC_TAXA,   "															+ CRLF
				cQryZEC += "    ZEC_VENCTO  "															+ CRLF
				cQryZEC += "FROM " + retSQLName("ZEC") + " ZEC "										+ CRLF
				cQryZEC += "WHERE "																		+ CRLF
				cQryZEC += "    ZEC.D_E_L_E_T_ = ' ' "													+ CRLF
				cQryZEC += "    AND ZEC.ZEC_FILIAL = '" + xFilial("SA1")	+ "' "						+ CRLF
				cQryZEC += "    AND ZEC.ZEC_DESCRI LIKE '%" + upper( allTrim( oCard:brand ) )	+ "%'"	+ CRLF

				conout(' [E-COM] [MGFFATA5] geraCaucao ' + cQryZEC )

				tcQuery cQryZEC New Alias "QRYZEC"

				If !QRYZEC->(EOF())
					If nCalc > 0

	/*
							xFilCore := Filial Corrente
						    cCliente := Cliente do pedido
						    cLoja	 := Loja do Pedido
						    cCnpj	 := CNPJ do Cliente
						    cNome    := Nome do Cliente
						    cNSU     := Numero do NSU
						    cIdTrans := Id De transação
						    cPedido  := Numero do Pedido de Venda
						    dDtPedido:= Data de Inclusão do Pedido
						    nValorCau:= Valor do Caução
						    cCodAdm  := Código Administradora
						    cDesAdm  := Descrição Administradora
	*/

						U_xFINB2Ped(	xFilial("ZE6")		,;
										cCliente			,;
										cLoja				,;
										cCGC				,;
										cNome				,;
										SC5->C5_ZNSU		,;
										cPay				,;
										SC5->C5_NUM			,;
										dDataBase			,;
										nCalc				,;
										QRYZEC->ZEC_CODIGO	,;
										QRYZEC->ZEC_DESCRI	)

						conout(' [E-COM] [MGFFATA5] [EMPRESA] ' + allTrim(cEmpAnt) + ' [FILIAL] ' + allTrim(cFilAnt) + ' Gerado Caução ' + time() )
					endif
				else
					conout(' [E-COM] [MGFFATA5] Nao foi encontrada operadora de cartao para gerar caucao (Verificar Tabela ZEC)')

					U_xFINB2Ped(	xFilial("ZE6")		,;
									cCliente			,;
									cLoja				,;
									cCGC				,;
									cNome				,;
									SC5->C5_ZNSU		,;
									cPay				,;
									SC5->C5_NUM			,;
									dDataBase			,;
									nCalc				,;
									""					,;
									""					,;
									fwTimeStamp(2) + " - Nao foi encontrada operadora de cartao para gerar caucao (Verificar Tabela ZEC)"	,;
									"3"					)

					cUpdSC5	:= ""

					cUpdSC5 := "UPDATE " + retSQLName("SC5")							+ CRLF
					cUpdSC5 += "	SET"												+ CRLF
					cUpdSC5 += " 		C5_ZBLQRGA = 'B'"								+ CRLF
					cUpdSC5 += " WHERE"													+ CRLF
					cUpdSC5 += " 		C5_NUM		=	'" + SC5->C5_NUM	+ "'"		+ CRLF
					cUpdSC5 += " 	AND	C5_FILIAL	=	'" + SC5->C5_FILIAL	+ "'"		+ CRLF
					cUpdSC5 += " 	AND	D_E_L_E_T_	<>	'*'"							+ CRLF

					if tcSQLExec( cUpdSC5 ) < 0
						conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
					endif

					DBSelectArea( 'SZV' )
					SZV->( DBSetOrder( 1 ) ) //ZV_FILIAL, ZV_PEDIDO, ZV_ITEMPED, ZV_CODRGA
					if !SZV->( DBSeek( xFilial('SZV') + SC5->C5_NUM + "01" + "999999" ) )
						recLock("SZV", .T.)
							SZV->ZV_FILIAL	:= xFilial("SZV")
							SZV->ZV_PEDIDO	:= SC5->C5_NUM
							SZV->ZV_ITEMPED	:= "01"
							SZV->ZV_CODRGA	:= "999999"
							SZV->ZV_CODRJC	:= "000000"
							SZV->ZV_DTRJC	:= dDataBase
							SZV->ZV_HRRJC	:= left( time() , 5 )
						SZV->(msUnlock())
					endif
				endif

				QRYSAE->(DBCloseArea())
			else
				// cartão invalido
				conout(' [E-COM] [MGFFATA5] [GERACAUCAO] Cartão não verificado')

				U_xFINB2Ped(	xFilial("ZE6")		,;
								cCliente			,;
								cLoja				,;
								cCGC				,;
								cNome				,;
								SC5->C5_ZNSU		,;
								cPay				,;
								SC5->C5_NUM			,;
								dDataBase			,;
								nCalc				,;
								""					,;
								""					,;
								fwTimeStamp(2) + " - Cartão não verificado"	,;
								"3"					)

				cUpdSC5	:= ""

				cUpdSC5 := "UPDATE " + retSQLName("SC5")							+ CRLF
				cUpdSC5 += "	SET"												+ CRLF
				cUpdSC5 += " 		C5_ZBLQRGA = 'B'"								+ CRLF
				cUpdSC5 += " WHERE"													+ CRLF
				cUpdSC5 += " 		C5_NUM		=	'" + SC5->C5_NUM	+ "'"		+ CRLF
				cUpdSC5 += " 	AND	C5_FILIAL	=	'" + SC5->C5_FILIAL	+ "'"		+ CRLF
				cUpdSC5 += " 	AND	D_E_L_E_T_	<>	'*'"							+ CRLF

				if tcSQLExec( cUpdSC5 ) < 0
					conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
				endif

				DBSelectArea( 'SZV' )
				SZV->( DBSetOrder( 1 ) ) //ZV_FILIAL, ZV_PEDIDO, ZV_ITEMPED, ZV_CODRGA
				if !SZV->( DBSeek( xFilial('SZV') + SC5->C5_NUM + "01" + "999999" ) )
					recLock("SZV", .T.)
						SZV->ZV_FILIAL	:= xFilial("SZV")
						SZV->ZV_PEDIDO	:= SC5->C5_NUM
						SZV->ZV_ITEMPED	:= "01"
						SZV->ZV_CODRGA	:= "999999"
						SZV->ZV_CODRJC	:= "000000"
						SZV->ZV_DTRJC	:= dDataBase
						SZV->ZV_HRRJC	:= left( time() , 5 )
					SZV->(msUnlock())
				endif
			endif
		else
			// cartão nao encontrado no cofre
			conout(' [E-COM] [MGFFATA5] [GERACAUCAO] não recuperado no Cofre GETNET')

			U_xFINB2Ped(	xFilial("ZE6")		,;
							cCliente			,;
							cLoja				,;
							cCGC				,;
							cNome				,;
							SC5->C5_ZNSU		,;
							cPay				,;
							SC5->C5_NUM			,;
							dDataBase			,;
							nCalc				,;
							""					,;
							""					,;
							fwTimeStamp(2) + " - Cartão não recuperado no Cofre GETNET: " + CRLF + cCard	,;
							"3"					)

			cUpdSC5	:= ""

			cUpdSC5 := "UPDATE " + retSQLName("SC5")							+ CRLF
			cUpdSC5 += "	SET"												+ CRLF
			cUpdSC5 += " 		C5_ZBLQRGA = 'B'"								+ CRLF
			cUpdSC5 += " WHERE"													+ CRLF
			cUpdSC5 += " 		C5_NUM		=	'" + SC5->C5_NUM	+ "'"		+ CRLF
			cUpdSC5 += " 	AND	C5_FILIAL	=	'" + SC5->C5_FILIAL	+ "'"		+ CRLF
			cUpdSC5 += " 	AND	D_E_L_E_T_	<>	'*'"							+ CRLF

			if tcSQLExec( cUpdSC5 ) < 0
				conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
			endif

			DBSelectArea( 'SZV' )
			SZV->( DBSetOrder( 1 ) ) //ZV_FILIAL, ZV_PEDIDO, ZV_ITEMPED, ZV_CODRGA
			if !SZV->( DBSeek( xFilial('SZV') + SC5->C5_NUM + "01" + "999999" ) )
				recLock("SZV", .T.)
					SZV->ZV_FILIAL	:= xFilial("SZV")
					SZV->ZV_PEDIDO	:= SC5->C5_NUM
					SZV->ZV_ITEMPED	:= "01"
					SZV->ZV_CODRGA	:= "999999"
					SZV->ZV_CODRJC	:= "000000"
					SZV->ZV_DTRJC	:= dDataBase
					SZV->ZV_HRRJC	:= left( time() , 5 )
				SZV->(msUnlock())
			endif
		endif
	endif

	restArea( aAreaSC5 )
	restArea( aAreaSZV )
	restArea( aArea )
return

//-------------------------------------------------------
//-------------------------------------------------------
static function updXC5( cIDECO, cStatus, cObs, cPV, cPVBonif ) // 1 - Recebido / 2 - Processando / 3 - Gerado Pedido / 4 - Erro
	local aArea		:= getArea()
	local aAreaXC5	:= {}
	local cTimeProc	:= time()

	default cPVBonif	:= ""
	default cPV			:= ""

	DBSelectArea( "XC5" )

	aAreaXC5 := XC5->( getArea() )

	XC5->( DBSetOrder( 1 ) )
	if XC5->( DBSeek( xFilial("XC5") + cIDECO ) ) // XC5_FILIAL+XC5_IDECOM
		recLock("XC5", .F.)
		XC5->XC5_STATUS := cStatus //1 - Recebido / 2 - Processando / 3 - Gerado Pedido / 4 - Erro
		XC5->XC5_HRPROC := cTimeProc
		XC5->XC5_HRTOTA := elapTime(XC5->XC5_HRRECE, cTimeProc)

		if !empty( cPV )
			XC5->XC5_PVPROT := cPV
		endif

		if !empty( cPVBonif )
			XC5->XC5_BONIFI := cPVBonif
		endif

		if !empty(cObs)
			if !empty( XC5->XC5_OBS )
				XC5->XC5_OBS := XC5->XC5_OBS + " / " + cObs
			else
				XC5->XC5_OBS := cObs
			endif
		endif
		XC5->( msUnlock() )
	endif

	restArea(aAreaXC5)
	restArea(aArea)
return

//-------------------------------------------------------
//-------------------------------------------------------
static function errorFat53( oError )
	local nQtd := MLCount(oError:ERRORSTACK)
	local ni
	local cEr := ''

	for ni:=1 to nQtd
		cEr += memoLine(oError:ERRORSTACK,,ni)
	next ni

	conout( cEr )

	_aErr := { '0', cEr }

return .T.

//-------------------------------------------------------
//-------------------------------------------------------
static function getCustome(cCodEcom)
	local aRet		:= {}
	local cQrySA1	:= ""
	local cAliasSA1	:= getNextAlias()

	cCodEcom := allTrim( cCodEcom )

	cQrySA1 += "SELECT A1_COD, A1_LOJA, A1_ZVIDAUT, A1_TIPO, A1_NATUREZ"	+ CRLF
	cQrySA1 += " FROM " + retSQLName("SA1") + " SA1"						+ CRLF
	cQrySA1 += " WHERE"														+ CRLF
	cQrySA1 += " 		SA1.A1_ZCDECOM	=	'" + cCodEcom		+ "'"		+ CRLF
	//cQrySA1 += " 		SA1.A1_CGC		=	'" + cCodEcom		+ "'"		+ CRLF
	cQrySA1 += " 	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1") + "'"		+ CRLF
	cQrySA1 += " 	AND	SA1.D_E_L_E_T_	<>	'*'"							+ CRLF

	tcQuery changeQuery(cQrySA1) new Alias (cAliasSA1)

	if !(cAliasSA1)->(EOF())
		aadd( aRet, { (cAliasSA1)->A1_COD, (cAliasSA1)->A1_LOJA, (cAliasSA1)->A1_ZVIDAUT, (cAliasSA1)->A1_TIPO, (cAliasSA1)->A1_NATUREZ } )
	endif

	(cAliasSA1)->(DBCloseArea())
return aRet


//-------------------------------------------------------------------
// Selecione pedidos a serem incluidos
//-------------------------------------------------------------------
static function getXC5( cIdToProc )
	local cQryXC5		:= ""

	default cIdToProc	:= ""

	cQryXC5 += "SELECT XC5_DESCPV, XC5_IDPROF, XC6_DSCITE, XC5_DSCBOL, XC5_USANCC, XC5_NSU, XC5_PROMOC, XC5_DTCARR, XC5.R_E_C_N_O_ XC5RECNO, XC6.R_E_C_N_O_ XC6RECNO, XC5_DTENTR, XC5_VALCAU, XC5_PAYMID, XC6_PRCLIS,"	+ CRLF
	cQryXC5 += " XC5_FILIAL, XC5_CLIENT, XC5_TABELA, XC5_CONDPG, XC5_ZTIPPE, XC5_VENDED, XC6_OPER,"	+ CRLF
	cQryXC5 += " XC5_ZIDEND, XC5_IDECOM, XC6_ITEM, XC6_PRODUT, XC6_QTDVEN, XC6_PRCVEN, XC5_ZTIPOP, XC6_DTMINI, XC6_DTMAXI,"		+ CRLF

	cQryXC5 += " ("																			+ CRLF
	cQryXC5 += "     SELECT"																+ CRLF

	cQryXC5 += "  	("																		+ CRLF
	cQryXC5 += "      ( XC5.XC5_DSCBOL * 100 ) / SUM( SUBXC6.XC6_DSCITE )"					+ CRLF
	cQryXC5 += "  	) / 100 * XC6.XC6_DSCITE + XC6.XC6_PRCVEN - XC6.XC6_DSCITE"				+ CRLF

	cQryXC5 += "     FROM "	+ retSQLName("XC6") + " SUBXC6"									+ CRLF
	cQryXC5 += "     WHERE"																	+ CRLF
	cQryXC5 += "         SUBXC6.XC6_IDECOM = XC6.XC6_IDECOM"								+ CRLF
	cQryXC5 += "     AND SUBXC6.XC6_FILIAL = XC6.XC6_FILIAL"								+ CRLF
	cQryXC5 += "     AND SUBXC6.D_E_L_E_T_ = ' '"											+ CRLF
	cQryXC5 += " ) VALDESC , XC5_ORIGEM"													+ CRLF

	cQryXC5 += " FROM "			+ retSQLName("XC5") + " XC5"								+ CRLF
	cQryXC5 += " INNER JOIN "	+ retSQLName("XC6") + " XC6"								+ CRLF
	cQryXC5 += " ON XC5.XC5_IDECOM = XC6.XC6_IDECOM"											+ CRLF
	cQryXC5 += " WHERE"																		+ CRLF

	if !empty(cIdToProc)
		cQryXC5 += " 		XC5.XC5_STATUS	=	'2'"											+ CRLF  //1 - Recebido / 2 - Processando / 3 - Gerado Pedido / 4 - Erro
		cQryXC5 += " 	AND	XC5.XC5_IDPROC	=	'" + cIdToProc + "'"							+ CRLF
	else
		cQryXC5 += " 		XC5.XC5_STATUS	=	'1'"											+ CRLF  //1 - Recebido / 2 - Processando / 3 - Gerado Pedido / 4 - Erro
		cQryXC5 += " 	AND	XC5.XC5_IDPROC	=	' '"											+ CRLF
	endif

	cQryXC5 += " 	AND	XC6.XC6_FILIAL	=	'" + xFilial("XC6") + "'"						+ CRLF
	cQryXC5 += " 	AND	XC6.D_E_L_E_T_	<>	'*'"											+ CRLF
	cQryXC5 += " 	AND	XC5.XC5_FILIAL	=	'" + xFilial("XC5") + "'"						+ CRLF
	cQryXC5 += " 	AND	XC5.D_E_L_E_T_	<>	'*'"											+ CRLF
	cQryXC5 += " ORDER BY XC5_IDECOM,XC6_ITEM"														+ CRLF

	conout( ' [E-COM] [MGFFATA5] [EMPRESA] ' + allTrim(cEmpAnt) + ' [FILIAL] ' + allTrim(cFilAnt) + ' Query - Selecao para processamento: ' + cQryXC5 )

	//memoWrite("C:\TEMP\MGFFATA5.SQL", cQryXC5)

	tcQuery changeQuery(cQryXC5) new Alias (cAliasXC5)
return

//-------------------------------------------------------------------
//
//-------------------------------------------------------------------
static function getPrcList( cXC5Tabela, cProdXC6 )
	local nRetValor	:= 0
	local cQryDA1	:= ""

	cQryDA1 := "SELECT DA1_PRCVEN AS VALOR" 													+ CRLF
	cQryDA1 += " FROM "			+ retSQLName("DA0") + " DA0" 									+ CRLF
	cQryDA1 += " INNER JOIN "	+ retSQLName("DA1") + " DA1" 									+ CRLF
	cQryDA1 += " ON" 																			+ CRLF
	cQryDA1 += "		DA1.DA1_CODPRO	=	'" + cProdXC6 + "'" 								+ CRLF
	cQryDA1 += " 	AND	DA1.DA1_CODTAB	=	DA0.DA0_CODTAB" 									+ CRLF
	cQryDA1 += "	AND DA1.DA1_FILIAL	=	'" + xFilial("DA1") + "'" 							+ CRLF
	cQryDA1 += "	AND DA1.D_E_L_E_T_	<>	'*'" 												+ CRLF
	cQryDA1 += " INNER JOIN "	+ retSQLName("SA1") + " SA1" 									+ CRLF
	cQryDA1 += " ON" 																			+ CRLF
	cQryDA1 += " 		DA0.DA0_CODTAB	=	SA1.A1_ZPRCECO" 									+ CRLF
	cQryDA1 += " 	AND	SA1.A1_ZPRCECO	<>	' '" 												+ CRLF
	cQryDA1 += "	AND SA1.A1_FILIAL	=	'" + xFilial("SA1") + "'" 							+ CRLF
	cQryDA1 += " 	AND	SA1.D_E_L_E_T_	<>	'*'" 												+ CRLF
	cQryDA1 += " WHERE" 																		+ CRLF
	cQryDA1 += "		DA0.DA0_CODTAB	=	'" + allTrim( cXC5Tabela ) + "'" 					+ CRLF
	cQryDA1 += "	AND DA0.DA0_XENVEC	=	'1'" 												+ CRLF
	cQryDA1 += "	AND DA0.DA0_FILIAL	=	'" + xFilial("DA0") + "'" 							+ CRLF
	cQryDA1 += "	AND DA0.D_E_L_E_T_	<>	'*'" 												+ CRLF

	tcQuery cQryDA1 new alias "QRYDA1"

	if !QRYDA1->(EOF())
		nRetValor := QRYDA1->VALOR
	endif

	QRYDA1->(DBCloseArea())
return nRetValor

//-------------------------------------------------------------------
//
//-------------------------------------------------------------------
static function updSA1( cCodSA1, cLojaSA1 )
	local cUpdSA1	:= ""
	local aAreaX	:= getArea()

	cUpdSA1 := "UPDATE " + retSQLName("SA1")						+ CRLF
	cUpdSA1 += "	SET"											+ CRLF
	cUpdSA1 += " 		A1_XINTECO = '0',"							+ CRLF
	cUpdSA1 += " 		A1_XENVECO = '1'"							+ CRLF
	cUpdSA1 += " WHERE"												+ CRLF
	cUpdSA1 += " 		A1_LOJA		=	'" + cLojaSA1		+ "'"	+ CRLF
	cUpdSA1 += " 	AND	A1_COD		=	'" + cCodSA1		+ "'"	+ CRLF
	cUpdSA1 += " 	AND	A1_FILIAL	=	'" + xFilial("SA1")	+ "'"	+ CRLF
	cUpdSA1 += " 	AND	D_E_L_E_T_	<>	'*'"						+ CRLF

	if tcSQLExec( cUpdSA1 ) < 0
		conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
	endif

	restArea( aAreaX )
return