#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"


/*/
=============================================================================
{Protheus.doc} MGFFAT53
Job de criação de pedidos de venda a partir da tabela ZC5
@author TOTVS
@since 14/01/2020
/*/
User function MGFFAT53(_cfiliais)

Local _afiliais := StrTokArr(_cfiliais,",")
local _nhh

For _nhh := 1 to len(_afiliais)

	cfilant := _afiliais[_nhh]
	cfunname := "MGFFAT51"
	_cfunname := "MGFFAT51"
	MGFFAT53E(cfilant) //Executa criação de pedidos

Next


Return

/*/
=============================================================================
{Protheus.doc} MGFFAT53
Job de criação de pedidos de venda a partir da tabela ZC5
@author TOTVS
@since 14/01/2020
/*/
Static procedure MGFFAT53E(_cfiliais)

	local nI				:= 0
	local aSC5				:= {}
	local aSC6				:= {}
	local aErro				:= {}
	local cErro				:= ""
	local aLine				:= {}
	local aCustomer			:= {}
	local cSalesOrAt		:= ""
	local cTpFretSFA		:= ""

	local cTpPedMGF			:= ""
	Local nStackSX8         := ""
	Local cUltIdSFA         := ""

	local cQrySC5			:= ""
	local cAliasSC5			:= ""
	local cItemSC6			:= ""

	local nTamProd			:= 0
	local cUpdSC5			:= ""

	local cBlockRede		:= ""
	local cBlockOrca		:= ""

	Default _cfiliais       := ""

	private lMsHelpAuto     := .T.
	private lMsErroAuto     := .F.
	private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros

	nTamProd	:= superGetMv( "MFG_WSS17A" , , 6 			)
	cBlockRede	:= superGetMv( "MFG_WSS17B" , , "888888"	)
	cBlockOrca	:= superGetMv( "MFG_WSS17C" , , "777777"	)

	nStackSX8       := GetSx8Len()

    //Carrega linhas da ZC5 para processar
    U_MFCONOUT("Carregando pedidos da filial " + alltrim(_CFILIAIS) + " para processar...")
	FAT53QRY(_cfiliais)

    _ntot := 1
    _nni := 0

    If ZC5TMP->( EOF() )
        U_MFCONOUT("Não foram localizados pedidos pendentes na filial " + alltrim(_CFILIAIS) + ", finalizando job...")
        Return
    Endif

    _cult := alltrim(ZC5TMP->ZC5_IDSFA)

    Do while !ZC5TMP->( EOF() )
        If alltrim(ZC5TMP->ZC5_IDSFA) != _cult
            _ntot++
            _cult := alltrim(ZC5TMP->ZC5_IDSFA)
        Endif
        ZC5TMP->( Dbskip() )
    Enddo

	ZC5TMP->( Dbgotop() )

	Do while !ZC5TMP->( EOF() )

			lMsHelpAuto     := .T.
			lMsErroAuto     := .F.
			lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros

			_nni++
          	_lexecuta := .T.

            U_MFCONOUT("Preparando pedido " + strzero(_nni,6) + " de " + strzero(_ntot,6) + " da filial " + alltrim(_CFILIAIS) + "...")

		  	ZC5->(Dbgoto(ZC5TMP->ZC5RECNO))

			If !empty(ZC5->ZC5_IDPROC)

				U_MFCONOUT("Pedido já processado " + strzero(_nni,6) + " de " + strzero(_ntot,6) + " da filial " + alltrim(_CFILIAIS) + "...")
				_lexecuta := .F.

			Endif

			If _lexecuta

				If !ZC5->(MsRLock(ZC5->(RECNO())))

					U_MFCONOUT("Pedido já em processamento " + strzero(_nni,6) + " de " + strzero(_ntot,6) + " da filial " + alltrim(_CFILIAIS) + "...")
					_lexecuta := .F.

				else

					ZC5->(MsRunlock())

				Endif

			Endif

			If _lexecuta

				cQrySC5 := "SELECT R_E_C_N_O_ REC"
				cQrySC5 += " FROM " + retSQLName("SC5") + " SC5"
				cQrySC5 += " WHERE"
				cQrySC5 += " 		C5_XIDSFA	=	'" + allTrim( ZC5->ZC5_IDSFA ) + "' "
				cQrySC5 += "    AND C5_FILIAL = '" + alltrim( ZC5->ZC5_FILIAL ) + "' "
				cQrySC5 += "    AND C5_EMISSAO = '" + dtos(DATE()) + "' "
				cQrySC5 += " 	AND	D_E_L_E_T_	<>	'*'"


				If select("QRYSC5") > 0

					QRYSC5->(Dbclosearea())

				Endif

				tcQuery cQrySC5 new alias "QRYSC5"

				if !QRYSC5->(EOF())

					U_MFCONOUT("Pedido já processado " + strzero(_nni,6) + " de " + strzero(_ntot,6) + " da filial " + alltrim(_CFILIAIS) + "...")
					_lexecuta := .F.
					SC5->(Dbgoto(QRYSC5->REC))

					FAT53UZC5( cSalesOrAt, "3", "Pedido ja processado", SC5->C5_NUM )

				Endif

			Endif

			BEGIN TRANSACTION

			cpedold := ""
			cfilold := ""
			cstaold := ""

			cfilant := alltrim(ZC5TMP->ZC5_FILIAL)
			cSalesOrAt := ZC5TMP->ZC5_IDSFA

			cTpFretSFA		:= allTrim( getMv( "MGF_FRESFA" ) )

  			aRetSZJ := {}
			aRetSZJ := FAT53SZJ( ZC5TMP->ZC5_ZTIPPE ) //Tipo de pedido

			if _lexecuta .and. len( aRetSZJ ) == 0
				FAT53UZC5( ZC5TMP->ZC5_IDSFA, "4", "Tipo de Pedido não encontrado / Inválido" ) // 1 - Recebido / 2 - Processando / 3 - Gerado Pedido / 4 - Erro
				U_MFCONOUT("Tipo de pedido não encontrado - "  + alltrim(_CFILIAIS) + "/"+ alltrim(ZC5TMP->ZC5_IDSFA) + " inválido...")
                _lexecuta := .F.
			Endif

            If _lexecuta

            	aCustomer := {}
				aCustomer := FAT53CLI(ZC5TMP->ZC5_CLIENT) //Valida cliente

				if len(aCustomer) == 0
					FAT53UZC5( ZC5TMP->ZC5_IDSFA, "4", "Cliente não encontrado" ) // 1 - Recebido / 2 - Processando / 3 - Gerado Pedido / 4 - Erro
					U_MFCONOUT("Cliente não encontrado - "   + alltrim(_CFILIAIS) + "/"+ alltrim(ZC5TMP->ZC5_IDSFA) + " inválido...")
                    _lexecuta := .F.
				Endif

            Endif

			// VALIDACOES - PEDIDO DE REDE
			if !empty( ZC5TMP->ZC5_PVPAI )
				if !chkPvPai( ZC5TMP->ZC5_IDSFA )
					FAT53UZC5( ZC5TMP->ZC5_IDSFA, "4", "Pedido Pai não encontrado ou saldo insuficiente" ) // 1 - Recebido / 2 - Processando / 3 - Gerado Pedido / 4 - Erro
					U_MFCONOUT("Pedido Pai não encontrado ou saldo insuficiente - "   + alltrim(_CFILIAIS) + "/"+ alltrim(ZC5TMP->ZC5_IDSFA) + " inválido...")
                    _lexecuta := .F.
				else
					// SE PEDIDO PAI OK - ABATE QUANTIDADE
					DBSelectArea( "SC5" )
					SC5->( DBSetOrder( 1 ) ) // C5_FILIAL+C5_NUM

					if SC5->( DBSeek( ZC5TMP->ZC5_FILIAL + ZC5TMP->ZC5_PVPAI ) )
						if SC5->( DBRLock( SC5->( RECNO() ) ) )

							aSC5 := {}
							aSC6 := {}

							aadd( aSC5, { 'C5_FILIAL'	, SC5->C5_FILIAL	, NIL } )
							aadd( aSC5, { 'C5_NUM'		, SC5->C5_NUM		, NIL } )
							aadd( aSC5, { 'C5_CLIENTE'	, SC5->C5_CLIENTE	, NIL } )
							aadd( aSC5, { 'C5_LOJACLI'	, SC5->C5_LOJACLI	, NIL } )
							aadd( aSC5, { 'C5_TIPOCLI'	, SC5->C5_TIPOCLI	, NIL } )
							aadd( aSC5, { 'C5_ZTIPPED'	, SC5->C5_ZTIPPED	, NIL } )
							aadd( aSC5, { 'C5_TABELA'	, SC5->C5_TABELA	, NIL } )
							aadd( aSC5, { 'C5_CONDPAG'	, SC5->C5_CONDPAG	, NIL } )
							aadd( aSC5, { 'C5_VEND1'	, SC5->C5_VEND1		, NIL } )
							aadd( aSC5, { 'C5_ZIDEND'	, SC5->C5_ZIDEND	, NIL } )
							aadd( aSC5, { 'C5_FECENT'	, SC5->C5_FECENT	, NIL } )
							aadd( aSC5, { 'C5_ZDTEMBA'	, SC5->C5_ZDTEMBA	, NIL } )

							DBSelectArea( "SC6" )
							SC6->( DBSetOrder( 1 ) ) // C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO

							getItens( ZC5TMP->ZC5_IDSFA )

							if SC6->( DBSeek( allTrim( ZC5TMP->ZC5_FILIAL ) + allTrim( ZC5TMP->ZC5_PVPAI ) ) )
								while !SC6->( EOF() ) .and. SC6->( C6_FILIAL + C6_NUM ) == allTrim( ZC5TMP->ZC5_FILIAL ) + allTrim( ZC5TMP->ZC5_PVPAI )

									aLine	:= {}
									lCancel	:= .F.

									QRYZC52->( DBGoTop() )

									while !QRYZC52->( EOF() )
										if allTrim( SC6->C6_PRODUTO ) == padL( allTrim( QRYZC52->ZC6_PRODUT ) , nTamProd , "0" )
											if ( SC6->C6_QTDVEN - QRYZC52->ZC6_QTDVEN ) > 0
												// SE TIVER SALDO ALTERA A QTDE DO ITEM DO PEDIDO PAI
												aadd(aLine, {'C6_ITEM'			, SC6->C6_ITEM									, NIL})
												aadd(aLine, {'C6_PRODUTO'		, SC6->C6_PRODUTO								, NIL})
												aadd(aLine, {'C6_QTDVEN'		, ( SC6->C6_QTDVEN - QRYZC52->ZC6_QTDVEN )		, NIL})
												aadd(aLine, {'C6_PRCVEN'		, SC6->C6_PRCVEN								, NIL})
												aadd(aLine, {'C6_PRUNIT'		, SC6->C6_PRUNIT								, NIL})
												aadd(aLine, {'C6_ZDTMIN'		, SC6->C6_ZDTMIN								, NIL})
												aadd(aLine, {'C6_ZDTMAX'		, SC6->C6_ZDTMAX								, NIL})
											else
												lCancel	:= .T.
											endif

											exit
										endif

										QRYZC52->( DBSkip() )
									enddo

									if len( aLine ) == 0 .and. !lCancel
										// SE NAO ENCONTRAR O PRODUTO - PREENCHE COM SC6 EXISTENTE
										aadd(aLine, {'C6_ITEM'		, SC6->C6_ITEM		, NIL})
										aadd(aLine, {'C6_PRODUTO'	, SC6->C6_PRODUTO	, NIL})
										aadd(aLine, {'C6_QTDVEN'	, SC6->C6_QTDVEN	, NIL})

										aadd(aLine, {'C6_PRCVEN'	, SC6->C6_PRCVEN	, NIL})

										if !empty( SC6->C6_PRUNIT )
											aadd(aLine, {'C6_PRUNIT'	, SC6->C6_PRUNIT	, NIL})
										else
											aadd(aLine, {'C6_PRUNIT'	, staticCall( MGFFAT53 , FAT53PRC , 0 , allTrim( SC6->C6_PRODUTO ) , SC5->C5_TABELA ) , NIL})
										endif

										aadd(aLine, {'C6_ZDTMIN'	, SC6->C6_ZDTMIN	, NIL})
										aadd(aLine, {'C6_ZDTMAX'	, SC6->C6_ZDTMAX	, NIL})
									endif

									if len( aLine ) > 0
										aadd( aSC6, aLine )
									endif

									SC6->( DBSkip() )
								enddo
							endif

							QRYZC52->( DBCloseArea() )

							if len( aSC6 ) > 0
								// SE TEVE ITENS ABATIDOS
								aSC5 := fwVetByDic( aSC5 /*aVetor*/ , "SC5" /*cTable*/ , .F. /*lItens*/ )
								aSC6 := fwVetByDic( aSC6 /*aVetor*/ , "SC6" /*cTable*/ , .T. /*lItens*/ )

								varInfo( "aSC5" , aSC5 )
								varInfo( "aSC6" , aSC6 )

								U_MFCONOUT("Alterando Pedido Pai - "  + alltrim(_CFILIAIS) + "/"+ alltrim(ZC5TMP->ZC5_IDSFA) + " ...")

								msExecAuto( { | x , y , z | MATA410( x , y , z ) } , aSC5 , aSC6 , 4 )
							else
								U_MFCONOUT("Excluindo Pedido Pai - "  + alltrim(_CFILIAIS) + "/"+ alltrim(ZC5TMP->ZC5_IDSFA) + " ...")

								// SE NAO SOBROU ITENS EXCLUI O PEDIDO PAI
								msExecAuto( { | x , y , z | MATA410( x , y , z ) } , { { "C5_NUM" , SC5->C5_NUM , NIL } } , {} , 5 )
							endif

							if lMsErroAuto
								_lexecuta := .F.

								while GetSX8Len() > nStackSX8
									ROLLBACKSX8()
								enddo

								aErro := GetAutoGRLog() // Retorna erro em array
								cErro := ""

								for nI := 1 to len(aErro)
									cErro += aErro[nI] + CRLF
								next nI

								FAT53UZC5( ZC5TMP->ZC5_IDSFA, "4", "Pedido Pai não baixado parcial ou total: " + CRLF + cErro ) // 1 - Recebido / 2 - Processando / 3 - Gerado Pedido / 4 - Erro
								U_MFCONOUT("Pedido Pai não baixado parcial ou total: " + CRLF + cErro + alltrim(_CFILIAIS) + "/"+ alltrim(ZC5TMP->ZC5_IDSFA) )
							else
								while GetSX8Len() > nStackSX8
									CONFIRMSX8()
								enddo

								U_MFCONOUT("Fim Alteração Pedido Pai - "  + alltrim(_CFILIAIS) + "/"+ alltrim(ZC5TMP->ZC5_IDSFA) + " ...")
							endif
						endif
					endif
					// FIM - SE PEDIDO PAI OK - ABATE QUANTIDADE
				endif
			endif
			// FIM - VALIDACOES - PEDIDO DE REDE

            If _lexecuta

				cstaold := ZC5TMP->ZC5_STATUS

            	aSC5 := {}
				aadd(aSC5, {'C5_TIPO'   	, "N"										, NIL})
	        	aadd(aSC5, {'C5_CLIENTE'	, aCustomer[1, 1]							, NIL})
				aadd(aSC5, {'C5_LOJACLI'	, aCustomer[1, 2]							, NIL})
				aadd(aSC5, {'C5_ZTIPPED'	, aRetSZJ[ 1 ]								, NIL})

				if !empty( ZC5TMP->ZC5_IDEXTE )
					aadd(aSC5, {'C5_TABELA'		, ZC5TMP->ZC5_CODTAB					, NIL})
					aadd(aSC5, {'C5_CONDPAG'	, ZC5TMP->ZC5_CODCON					, NIL})
					aadd(aSC5, {'C5_XORCAME'	, ZC5TMP->ZC5_ORCAME					, NIL})
					aadd(aSC5, {'C5_XRESERV'	, ZC5TMP->ZC5_RESERV					, NIL})
				else
					aadd(aSC5, {'C5_TABELA'		, FAT53TAB( ZC5TMP->ZC5_TABELA )		, NIL})
					aadd(aSC5, {'C5_CONDPAG'	, FAT53SE4(ZC5TMP->ZC5_CONDPG)			, NIL})
				endif

				aadd(aSC5, {'C5_TIPOCLI'	, aCustomer[1, 4]							, NIL})
				aadd(aSC5, {'C5_ZTPOPER'	, ZC5TMP->ZC5_ZTIPOP						, NIL})
				aadd(aSC5, {'C5_VEND1'		, ZC5TMP->ZC5_VENDED						, NIL})

				if !empty( ZC5TMP->ZC5_ZIDEND )
					aadd(aSC5, {'C5_ZIDEND'	, ZC5TMP->ZC5_ZIDEND						, NIL})
				endif

				aadd(aSC5, {'C5_TPFRETE'		, cTpFretSFA 							, NIL})

				if !empty( ZC5TMP->ZC5_DTEMBA )
					aadd(aSC5, {'C5_ZDTEMBA'	, sToD( ZC5TMP->ZC5_DTEMBA ) 			, NIL})
				endif

				if !empty( ZC5TMP->ZC5_DTENTR )
					aadd(aSC5, {'C5_FECENT'		, sToD( ZC5TMP->ZC5_DTENTR ) 			, NIL})
				endif

				aadd(aSC5, {'C5_XIDSFA'		, ZC5TMP->ZC5_IDSFA							, NIL})
				aadd(aSC5, {'C5_XIDEXTE'	, ZC5TMP->ZC5_IDSFA							, NIL})
				aadd(aSC5, {'C5_XINTEGR'	, "P"										, NIL})

				aadd(aSC5, {'C5_XORIGEM'	, ZC5TMP->ZC5_ORIGEM						, NIL})
				aadd(aSC5, {'C5_XCALLBA'	, "S"										, NIL})

				if !empty( ZC5->ZC5_XOBSPE )
					aadd(aSC5, {'C5_XOBSPED'	, ZC5->ZC5_XOBSPE						, NIL})
				endif

				if !empty( ZC5TMP->ZC5_PEDCLI )
					aadd(aSC5, {'C5_ZPEDCLI'	, ZC5TMP->ZC5_PEDCLI					, NIL})
				endif

				if !empty( ZC5TMP->ZC5_MSGNOT )
					aadd(aSC5, {'C5_MENNOTA'	, ZC5TMP->ZC5_MSGNOT					, NIL})
				endif

				aadd(aSC5, {'C5_XREDE'	, ZC5TMP->ZC5_PVREDE							, NIL})

				cSalesOrAt := ZC5TMP->ZC5_IDSFA
				aSC6 := {}

				cTpPedMGF := ""
				cTpPedMGF := ZC5TMP->ZC5_ZTIPPE

				cItemSC6 := ""
				cItemSC6 := strZero ( 0 , tamSX3("C6_ITEM")[1] )

				while !ZC5TMP->( EOF() ) .and. cSalesOrAt == ZC5TMP->ZC5_IDSFA

           			If cUltIdSFA <> ZC5TMP->ZC5_IDSFA + ZC5TMP->ZC6_ITEM

						aLine := {}
						cItemSC6 := soma1(cItemSC6)

						aadd(aLine, {'C6_ITEM'		, cItemSC6						, NIL})
						aadd(aLine, {'C6_PRODUTO'	, alltrim( ZC5TMP->ZC6_PRODUT )	, NIL})
						aadd(aLine, {'C6_QTDVEN'	, ZC5TMP->ZC6_QTDVEN			, NIL})
						aadd(aLine, {'C6_PRCVEN'	, ZC5TMP->ZC6_PRCVEN			, NIL})

						if !empty( ZC5TMP->ZC5_PEDCLI )
							aadd(aLine, {'C6_ITEMPC'	, cItemSC6				, NIL})
							aadd(aLine, {'C6_NUMPCOM'	, ZC5TMP->ZC5_PEDCLI	, NIL})
						endif

						if !empty( ZC5TMP->ZC5_IDEXTE )
							aadd(aLine, {'C6_PRUNIT'	, FAT53PRC( 0 , ZC5TMP->ZC6_PRODUT , ZC5TMP->ZC5_CODTAB )	, NIL})

							// SE FOR PEDIDO DO SALESFORCE RESPEITA A DATA ENVIADA
							if !empty( ZC5TMP->ZC6_DTMINI ) .and. !empty( ZC5TMP->ZC6_DTMAXI )
								aadd(aLine, {'C6_ZDTMIN'	, sToD( ZC5TMP->ZC6_DTMINI )	, NIL})
								aadd(aLine, {'C6_ZDTMAX'	, sToD( ZC5TMP->ZC6_DTMAXI )	, NIL})
							else
								aadd(aLine, {'C6_ZDTMIN'	, CTOD("  /  /  ")				, NIL})
								aadd(aLine, {'C6_ZDTMAX'	, CTOD("  /  /  ")				, NIL})
							endif
						else
							aadd(aLine, {'C6_PRUNIT'	, FAT53PRC( ZC5TMP->ZC5_TABELA, ZC5TMP->ZC6_PRODUT )	, NIL})

							if aRetSZJ[ 4 ] == "S"
								aadd(aLine, {'C6_ZDTMIN'	, dDataBase + aRetSZJ[ 2 ]				, NIL})
								aadd(aLine, {'C6_ZDTMAX'	, dDataBase + aRetSZJ[ 3 ]				, NIL})
							else
								if !empty( ZC5TMP->ZC6_DTMINI ) .and. !empty( ZC5TMP->ZC6_DTMAXI )
									aadd(aLine, {'C6_ZDTMIN'	, sToD( ZC5TMP->ZC6_DTMINI )		, NIL})
									aadd(aLine, {'C6_ZDTMAX'	, sToD( ZC5TMP->ZC6_DTMAXI )		, NIL})
								else
									aadd(aLine, {'C6_ZDTMIN'	, CTOD("  /  /  ")					, NIL})
									aadd(aLine, {'C6_ZDTMAX'	, CTOD("  /  /  ")					, NIL})
								endif
							endif
						endif

						aadd( aSC6, aLine )
					endif

					cUltIdSFA := ZC5TMP->ZC5_IDSFA+ZC5TMP->ZC6_ITEM
					ZC5TMP->( DBSkip() )

                enddo

				aSC5 := fwVetByDic( aSC5 /*aVetor*/ , "SC5" /*cTable*/ , .F. /*lItens*/ )
				aSC6 := fwVetByDic( aSC6 /*aVetor*/ , "SC6" /*cTable*/ , .T. /*lItens*/ )

                U_MFCONOUT("Criando pedido "  + alltrim(_CFILIAIS) + "/"+ ALLTRIM(cSalesOrAt) + ", " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...")
				msExecAuto({|x,y,z|MATA410(x,y,z)}, aSC5, aSC6, 3)

				_lok := .T.

                //Valida se criou o pedido corretamente
			    if alltrim(SC5->C5_XIDSFA) == ALLTRIM(cSalesOrAt)

					SC6->(Dbsetorder(1)) //C6_FILIAL+C6_NUM
					If SC6->(Dbseek(SC5->C5_FILIAL+SC5->C5_NUM))

						Do while SC5->C5_FILIAL+SC5->C5_NUM == SC6->C6_FILIAL+SC6->C6_NUM

							//Validação de campos obrigatórios no pedido de vendas
							If empty(alltrim(SC6->C6_CF));
								 .OR. empty(alltrim(SC6->C6_CLASFIS));
								 .OR. empty(alltrim(SC6->C6_TES));
								 .OR. empty(alltrim(SC6->C6_LOCAL));
								 .OR. empty(alltrim(SC6->C6_TPOP))

								 _lok := .F.

							Endif

							SC6->(Dbskip())

						Enddo

					Else

						_lok := .F.

					Endif


				Else

					_lok := .F.

				Endif

				If _lok

	                 //Criou pedido de vendas com sucesso
                   	while GetSX8Len() > nStackSX8
						CONFIRMSX8()
					enddo

                    U_MFCONOUT("Pedido incluido com sucesso "  + CFILANT + "/" + SC5->C5_NUM + ", " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...")
					FAT53UZC5( cSalesOrAt, "3", "Pedido Incluido", SC5->C5_NUM ) // 1 - Recebido / 2 - Processando / 3 - Gerado Pedido / 4 - Erro

					// CASO PEDIDO DE REDE - GERA BLOQUEIO PARA NÃO FATURAR
					if SC5->C5_XREDE == "S"
						cUpdSC5	:= ""

						cUpdSC5 := "UPDATE " + retSQLName("SC5")						+ CRLF
						cUpdSC5 += "	SET"											+ CRLF
						cUpdSC5 += " 		C5_ZBLQRGA = 'B'"							+ CRLF
						cUpdSC5 += " WHERE"												+ CRLF
						cUpdSC5 += " 		C5_NUM		=	'" + SC5->C5_NUM	+ "'"	+ CRLF
						cUpdSC5 += " 	AND	C5_FILIAL	=	'" + SC5->C5_FILIAL	+ "'"	+ CRLF
						cUpdSC5 += " 	AND	D_E_L_E_T_	<>	'*'"						+ CRLF

						if tcSQLExec( cUpdSC5 ) < 0
							conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
						endif

						DBSelectArea( 'SZV' )
						SZV->( DBSetOrder( 1 ) ) //ZV_FILIAL, ZV_PEDIDO, ZV_ITEMPED, ZV_CODRGA
						if !SZV->( DBSeek( xFilial('SZV') + SC5->C5_NUM + "01" + cBlockRede ) )
							recLock("SZV", .T.)
								SZV->ZV_FILIAL	:= xFilial("SZV")
								SZV->ZV_PEDIDO	:= SC5->C5_NUM
								SZV->ZV_ITEMPED	:= "01"
								SZV->ZV_CODRGA	:= cBlockRede
							SZV->(msUnlock())
						endif
					elseif SC5->C5_XORCAME == "S"
						cUpdSC5	:= ""

						cUpdSC5 := "UPDATE " + retSQLName("SC5")						+ CRLF
						cUpdSC5 += "	SET"											+ CRLF
						cUpdSC5 += " 		C5_ZBLQRGA = 'B'"							+ CRLF
						cUpdSC5 += " WHERE"												+ CRLF
						cUpdSC5 += " 		C5_NUM		=	'" + SC5->C5_NUM	+ "'"	+ CRLF
						cUpdSC5 += " 	AND	C5_FILIAL	=	'" + SC5->C5_FILIAL	+ "'"	+ CRLF
						cUpdSC5 += " 	AND	D_E_L_E_T_	<>	'*'"						+ CRLF

						if tcSQLExec( cUpdSC5 ) < 0
							conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
						endif

						DBSelectArea( 'SZV' )
						SZV->( DBSetOrder( 1 ) ) //ZV_FILIAL, ZV_PEDIDO, ZV_ITEMPED, ZV_CODRGA
						if !SZV->( DBSeek( xFilial('SZV') + SC5->C5_NUM + "01" + cBlockOrca ) )
							recLock("SZV", .T.)
								SZV->ZV_FILIAL	:= xFilial("SZV")
								SZV->ZV_PEDIDO	:= SC5->C5_NUM
								SZV->ZV_ITEMPED	:= "01"
								SZV->ZV_CODRGA	:= cBlockOrca
							SZV->(msUnlock())
						endif
					endif
					// FIM - CASO PEDIDO DE REDE - GERA BLOQUEIO PARA NÃO FATURAR

					//Já grava integração keyconsult
					ZHL->(dbsetorder(2)) //ZHL_IDSFA   
					_lachou := .F.                                                                                                                                        
						
					//Verifica se tem consultas válidas
					If ZHL->(Dbseek(SC5->C5_XIDSFA))


						Do while alltrim(SC5->C5_XIDSFA) == alltrim(ZHL->ZHL_IDSFA)

							If ZHL->ZHL_STATUS == "C"
								cStatRec := ZHL->ZHL_STATR
								cStatSIN := ZHL->ZHL_STATS
								cStatSUF := ZHL->ZHL_STATU
								_lachou := .T.
							Endif

							ZHL->(Dbskip())

						Enddo

						If _lachou

							u_MGFAT53S(cStatRec,cStatSIN,cStatSUF) //Grava keyconsult no pedido

						Endif

					Endif

       			else

                    //Não criou o pedido de vendas
          			While GetSX8Len() > nStackSX8
						ROLLBACKSX8()
					EndDo

                    cerro := "Falha na chamada do execauto"

                    If lMsErroAuto

                      	aErro := GetAutoGRLog() // Retorna erro em array
					    cErro := ""

					    for nI := 1 to len(aErro)
						    cErro += aErro[nI] + CRLF
					    next nI

                    else

						_lexecuta := .F.
						Disarmtransaction()
						U_MFCONOUT("Erro ao criar pedido, cancelando transação " + cfilant + "/" + ALLTRIM(cSalesOrAt) + " - " +  cErro)

					Endif

					If _lexecuta

						//Se deu erro tenta reprocessar 3 vezes
						If cstaold = '9' .OR. cstaold = '2'
							Disarmtransaction()
							cpedold := cSalesOrAt
							cfilold := cfilant
							U_MFCONOUT("Erro ao criar pedido, cancelando transação " + cfilant + "/" + ALLTRIM(cSalesOrAt) + " - " +  cErro)
						Else
	                    	U_MFCONOUT("Erro ao criar pedido " + cfilant + "/" + ALLTRIM(cSalesOrAt) + " - " +  cErro)
    						FAT53UZC5( ALLTRIM(cSalesOrAt), "4", cErro ) // 1 - Recebido / 2 - Processando / 3 - Gerado Pedido / 4 - Erro
						Endif

					Endif

				endif

            else

				Disarmtransaction()
                //Pula para próximo id para não testar mais o pedido com erros
                cSalesOrAt := ZC5TMP->ZC5_IDSFA
                Do while !ZC5TMP->( EOF() ) .and. ALLTRIM(cSalesOrAt) == ALLTRIM(ZC5TMP->ZC5_IDSFA)
                    ZC5TMP->( Dbskip() )
                Enddo

            Endif

			END TRANSACTION

			If cstaold == "2" .or. cstaold == "9" .and. !(ZC5->ZC5_STATUS == '3')
				ZC5->( DBSetOrder( 1 ) )
				if ZC5->( DBSeek( cfilold + cpedold ) ) // ZC5_FILIAL+ZC5_IDSFA
					recLock("ZC5", .F.)
					ZC5->ZC5_STATUS := iif(cstaold == "2","9","8")
					ZC5->(mSUNLOCK())
				Endif
			Endif

	enddo

	ZC5TMP->( DBCloseArea() )

	U_MFCONOUT("Completou geração de pedidos de vendas dos tablets para filial " + _cfiliais + "...")

return

/*/
=============================================================================
{Protheus.doc} FAT53SZJ
Retorna dados do Tipo de Pedido
@author TOTVS
@since 14/01/2020
/*/
static function FAT53SZJ( cSZJCod )
	local cQrySZJ
	local aRetSZJ	:= {}
	local aArea		:= getArea()

	cQrySZJ := "SELECT ZJ_COD, ZJ_MINIMO, ZJ_MAXIMO, ZJ_FEFO"			+ CRLF
	cQrySZJ += " FROM " + retSQLName("SZJ") + " SZJ"					+ CRLF
	cQrySZJ += " WHERE"													+ CRLF
	cQrySZJ += " 		SZJ.ZJ_COD		=	'" + cSZJCod		+ "'"	+ CRLF
	cQrySZJ += " 	AND	SZJ.ZJ_FILIAL	=	'" + xFilial("SZJ")	+ "'"	+ CRLF
	cQrySZJ += " 	AND	SZJ.D_E_L_E_T_	<>	'*'"						+ CRLF

	TcQuery cQrySZJ New Alias "QRYSZJ"

	if !QRYSZJ->(EOF())
		aadd( aRetSZJ, QRYSZJ->ZJ_COD		)
		aadd( aRetSZJ, QRYSZJ->ZJ_MINIMO	)
		aadd( aRetSZJ, QRYSZJ->ZJ_MAXIMO	)
		aadd( aRetSZJ, QRYSZJ->ZJ_FEFO		)
	endif

	QRYSZJ->(DBCloseArea())

	restArea( aArea )
return aRetSZJ


/*/
=============================================================================
{Protheus.doc} FAT53CLI
Retorna dados do cliente
@author TOTVS
@since 14/01/2020
/*/
static function FAT53CLI(cCliCnpj)
	local aRet		:= {}
	local cQrySA1
	local cAliasSA1	:= getNextAlias()

	if len(allTrim(cCliCnpj)) > 14
		cCliCnpj := right(allTrim( cCliCnpj ), 14)
	endif

	cQrySA1 := "SELECT A1_COD, A1_LOJA, A1_ZVIDAUT, A1_TIPO, A1_NATUREZ"	+ CRLF
	cQrySA1 += " FROM " + retSQLName("SA1") + " SA1"						+ CRLF
	cQrySA1 += " WHERE"														+ CRLF
	cQrySA1 += " 		SA1.A1_CGC		=	'" + cCliCnpj		+ "'"		+ CRLF
	cQrySA1 += " 	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1") + "'"		+ CRLF
	cQrySA1 += " 	AND	SA1.D_E_L_E_T_	<>	'*'"							+ CRLF

	tcQuery changeQuery(cQrySA1) new Alias (cAliasSA1)

	if !(cAliasSA1)->(EOF())
		aadd( aRet, { (cAliasSA1)->A1_COD, (cAliasSA1)->A1_LOJA, (cAliasSA1)->A1_ZVIDAUT, (cAliasSA1)->A1_TIPO, (cAliasSA1)->A1_NATUREZ } )
	endif

	(cAliasSA1)->(DBCloseArea())
return aRet

/*/
=============================================================================
{Protheus.doc} FAT53QRY
Selecione pedidos a serem incluidos
@author TOTVS
@since 14/01/2020
/*/
static procedure FAT53QRY(_cfiliais)

    local cQryZC5
	Default _cfiliais   := ""

	cQryZC5 := "SELECT ZC5.ZC5_STATUS ZC5_STATUS, ZC5.R_E_C_N_O_ ZC5RECNO, ZC6.R_E_C_N_O_ ZC6RECNO, ZC5_DTENTR, ZC5_DTEMBA, ZC6_PRCLIS,"	+ CRLF
	cQryZC5 += " ZC5_FILIAL, ZC5_CLIENT, ZC5_TABELA, ZC5_CONDPG, ZC5_ZTIPPE, ZC5_VENDED, ZC6_OPER,"								+ CRLF
	cQryZC5 += " ZC5_ZIDEND, ZC5_IDSFA, ZC6_ITEM, ZC6_PRODUT, ZC6_QTDVEN, ZC6_PRCVEN, ZC5_ZTIPOP, ZC6_DTMINI, ZC6_DTMAXI,"		+ CRLF
	cQryZC5 += " ZC5_IDEXTE, ZC5_ORCAME, ZC5_RESERV, ZC5_CODTAB, ZC5_CODCON, ZC5_ORIGEM, ZC5_XOBSPE, ZC5_PEDCLI, ZC5_MSGNOT, ZC5_PVPAI, ZC5_PVREDE"										+ CRLF
	cQryZC5 += " FROM "			+ retSQLName("ZC5") + " ZC5"								+ CRLF
	cQryZC5 += " INNER JOIN "	+ retSQLName("ZC6") + " ZC6"								+ CRLF
	cQryZC5 += " ON ZC5.ZC5_IDSFA = ZC6.ZC6_IDSFA AND ZC5.ZC5_FILIAL = ZC6.ZC6_FILIAL"		+ CRLF
	cQryZC5 += " WHERE"																		+ CRLF
	cQryZC5 += " 		( ZC5.ZC5_STATUS	=	'2' OR "									+ CRLF  //1 - Recebido / 2 - Processando / 3 - Gerado Pedido / 4 - Erro
	cQryZC5 += " 			 ZC5.ZC5_STATUS	=	'9' OR "									+ CRLF  //Processado com erro uma vez
	cQryZC5 += " 			 ZC5.ZC5_STATUS	=	'8' OR "									+ CRLF  //Processado com erro duas vezes
	cQryZC5 += " 		( ZC5.ZC5_STATUS	=	'4' AND ZC5_DTRECE = '" + DTOS(date()) + "')) "	+ CRLF

	If !empty(_cfiliais)
		cQryZC5 += " 	AND	ZC5.ZC5_FILIAL	= '" + ALLTRIM(_CFILIAIS) + "' "				+ CRLF
	Endif

	cQryZC5 += " 	AND	ZC5.ZC5_IDPROC	=	' '"											+ CRLF
	cQryZC5 += " 	AND	ZC6.D_E_L_E_T_	<>	'*'"											+ CRLF
	cQryZC5 += " 	AND	ZC5.D_E_L_E_T_	<>	'*'"											+ CRLF

	cQryZC5 += " ORDER BY ZC5_FILIAL,ZC5_IDSFA,ZC6_ITEM"									+ CRLF

	If select("ZC5TMP") > 0
		("ZC5TMP")->(Dbclosearea())
	Endif

	TcQuery cQryZC5 New Alias "ZC5TMP"

return

/*/
=============================================================================
{Protheus.doc} FAT53TAB
Retorna codigo da tabela de Preco
@author TOTVS
@since 14/01/2020
/*/
static function FAT53TAB( cZC5Tabela )
	local cQryDA0
	local cRetDA0 := ""

	cQryDA0 := "SELECT DA0_CODTAB"
	cQryDA0 += " FROM " + retSQLName("DA0") + " DA0"
	cQryDA0 += " WHERE"
	cQryDA0 += " 		DA0.R_E_C_N_O_	=	'" + allTrim( str( cZC5Tabela ) ) + "'"
	cQryDA0 += " 	AND	DA0.D_E_L_E_T_	<>	'*'"

	tcQuery cQryDA0 new alias "QRYDA0"

	if !QRYDA0->(EOF())
		cRetDA0 := QRYDA0->DA0_CODTAB
	endif

	QRYDA0->(DBCloseArea())
return cRetDA0

/*/
=============================================================================
{Protheus.doc} FAT53TAB
Retorna codigo da Condicao de Pagto
@author TOTVS
@since 14/01/2020
/*/
static function FAT53SE4( cZC5Cond )
	local cQrySE4
	local cRetSE4 := ""

	cQrySE4 := "SELECT E4_CODIGO"
	cQrySE4 += " FROM " + retSQLName("SE4") + " SE4"
	cQrySE4 += " WHERE"
	cQrySE4 += " 		SE4.R_E_C_N_O_	=	'" + allTrim( str( cZC5Cond ) ) + "'"
	cQrySE4 += " 	AND	SE4.D_E_L_E_T_	<>	'*'"

	tcQuery cQrySE4 new alias "QRYSE4"

	if !QRYSE4->(EOF())
		cRetSE4 := QRYSE4->E4_CODIGO
	endif

	QRYSE4->(DBCloseArea())
return cRetSE4

/*/
=============================================================================
{Protheus.doc} FAT53PRC
Retorna preço para tem do produto
@author TOTVS
@since 14/01/2020
/*/
static function FAT53PRC( nZC5Tabela, cProdZC6 , cZC5Tabela )
	local nRetValor		:= 0
	local cQryDA1

	default nZC5Tabela := 0
	default cZC5Tabela := ""

	cQryDA1 := "SELECT
	cQryDA1 += "	ROUND(DA1_PRCVEN / (1 - (NVL( (	SELECT MAX(DESCONTO)
	cQryDA1 += "		FROM
	cQryDA1 += "			(
	cQryDA1 += "				SELECT MAX(ZL_PERDESC) AS DESCONTO
	cQryDA1 += "				FROM " + retSQLName("SZL") + " SZL" 							+ CRLF
	cQryDA1 += "				WHERE
	cQryDA1 += "					SZL.D_E_L_E_T_ <> '*' AND
	cQryDA1 += "					SZL.ZL_CODTAB = DA1.DA1_CODTAB
	cQryDA1 += "				UNION ALL
	cQryDA1 += "				SELECT MAX(ZM_PERDESC) AS DESCONTO
	cQryDA1 += "				FROM " + retSQLName("SZM") + " SZM" 							+ CRLF
	cQryDA1 += "				WHERE
	cQryDA1 += "					SZM.D_E_L_E_T_ <> '*' AND
	cQryDA1 += "					SZM.ZM_CODTAB = DA1.DA1_CODTAB
	cQryDA1 += "			)
	cQryDA1 += "    )  , 0) / 100)), 4) AS VALOR
	cQryDA1 += " FROM " + retSQLName("DA1") + " DA1
	cQryDA1 += " 	INNER JOIN DA0010 DA0
	cQryDA1 += " 	ON
	cQryDA1 += " 		DA0.DA0_CODTAB	=	DA1.DA1_CODTAB
	cQryDA1 += "  WHERE
	cQryDA1 += "		DA1.DA1_CODPRO	=	'" + cProdZC6 + "'" 								+ CRLF

	if nZC5Tabela > 0
		cQryDA1 += "	AND DA0.R_E_C_N_O_	=	'" + allTrim( str( nZC5Tabela ) ) + "'" 		+ CRLF
	else
		cQryDA1 += "	AND DA0.DA0_CODTAB	=	'" + allTrim( cZC5Tabela ) + "'" 				+ CRLF
	endif

	cQryDA1 += "	AND DA1.DA1_FILIAL	=	'" + xFilial("DA1") + "'" 							+ CRLF
	cQryDA1 += "	AND DA0.DA0_FILIAL	=	'" + xFilial("DA0") + "'" 							+ CRLF
	cQryDA1 += "	AND DA1.D_E_L_E_T_	<>	'*'" 												+ CRLF
	cQryDA1 += "	AND DA0.D_E_L_E_T_	<>	'*'" 												+ CRLF

	tcQuery cQryDA1 new alias "QRYDA1"

	if !QRYDA1->(EOF())
		nRetValor := QRYDA1->VALOR
	endif

	QRYDA1->(DBCloseArea())
return nRetValor

/*/
=============================================================================
{Protheus.doc} FAT53UZC5
Atualiza status do pedido na ZC5
@author TOTVS
@since 14/01/2020
/*/
static procedure FAT53UZC5( cIDSFA, cStatus, cObs, cPV )
	local aArea		:= getArea()
	local aAreaZC5	:= {}
	local cTimeProc	:= time()

	DBSelectArea( "ZC5" )

	aAreaZC5 := ZC5->( getArea() )

	ZC5->( DBSetOrder( 1 ) )
	if ZC5->( DBSeek( xFilial("ZC5") + cIDSFA ) ) // ZC5_FILIAL+ZC5_IDSFA
		recLock("ZC5", .F.)
		ZC5->ZC5_STATUS := cStatus //1 - Recebido / 2 - Processando / 3 - Gerado Pedido / 4 - Erro

		if !empty(cObs)
			ZC5->ZC5_OBS := cObs
		endif

		ZC5->ZC5_HRPROC := cTimeProc
		ZC5->ZC5_HRTOTA := elapTime(ZC5->ZC5_HRRECE, cTimeProc)

		if !empty(cPV)
			ZC5->ZC5_PVPROT := cPV
		endif
		ZC5->( msUnlock() )
	endif

	restArea(aAreaZC5)
	restArea(aArea)
return

//***********************************************
// Verifica se Pedido Pai é valido
//***********************************************
static function chkPvPai( cIdSfa )
	local lPvPai	:= .T.
	local cQryPVPai

	cQryPVPai := "SELECT ZC5_IDEXTE, C5_FILIAL, C5_NUM, C6_PRODUTO, ZC6_PRODUT, NVL( C6_QTDVEN , 0 ) C6_QTDVEN, ZC6_QTDVEN"	+ CRLF
	cQryPVPai += " FROM "		+ retSQLName( "ZC5" ) + " ZC5"														+ CRLF
	cQryPVPai += " INNER JOIN "	+ retSQLName( "ZC6" ) + " ZC6"														+ CRLF
	cQryPVPai += " ON"																								+ CRLF
	cQryPVPai += "		ZC5.ZC5_IDSFA	=	ZC6.ZC6_IDSFA"															+ CRLF
	cQryPVPai += "	AND ZC5.ZC5_FILIAL	=	ZC6.ZC6_FILIAL"															+ CRLF
	cQryPVPai += " 	AND	ZC6.D_E_L_E_T_	<>	'*'"																	+ CRLF
	cQryPVPai += " LEFT JOIN " + retSQLName( "SC5" ) + " SC5"														+ CRLF
	cQryPVPai += " ON"																								+ CRLF
	cQryPVPai += " 		SC5.C5_NUM		=	ZC5.ZC5_PVPAI"															+ CRLF
	cQryPVPai += " 	AND	SC5.C5_FILIAL	=	ZC5.ZC5_FILIAL"															+ CRLF
	cQryPVPai += " 	AND	SC5.D_E_L_E_T_	<>	'*'"																	+ CRLF
	cQryPVPai += " LEFT JOIN " + retSQLName( "SC6" ) + " SC6"														+ CRLF
	cQryPVPai += " ON"																								+ CRLF
	cQryPVPai += " 		SC6.C6_QTDVEN	>=	ZC6.ZC6_QTDVEN"															+ CRLF
	cQryPVPai += " 	AND	SC6.C6_PRODUTO	=	ZC6.ZC6_PRODUT"															+ CRLF
	cQryPVPai += " 	AND	SC6.C6_NUM		=	SC5.C5_NUM"																+ CRLF
	cQryPVPai += " 	AND	SC6.C6_FILIAL	=	SC5.C5_FILIAL"															+ CRLF
	cQryPVPai += " 	AND	SC6.D_E_L_E_T_	<>	'*'"																	+ CRLF
	cQryPVPai += " WHERE"																							+ CRLF
	cQryPVPai += " 		ZC5.ZC5_IDEXTE	=	'" + cIdSfa			+ "'"												+ CRLF
	cQryPVPai += " 	AND	ZC5.ZC5_FILIAL	=	'" + xFilial("ZC5") + "'"												+ CRLF
	cQryPVPai += " 	AND	ZC5.D_E_L_E_T_	<>	'*'"																	+ CRLF

	tcQuery cQryPVPai new alias "QRYPVPAI"

	if !QRYPVPAI->( EOF() )
		while !QRYPVPAI->( EOF() )
			if QRYPVPAI->C6_QTDVEN == 0
				lPvPai := .F.
			endif
			QRYPVPAI->( DBSkip() )
		enddo
	else
		lPvPai := .F.
	endif

	QRYPVPAI->( DBCloseArea() )
return lPvPai

//***********************************************
// Verifica se Pedido Pai é valido
//***********************************************
static procedure getItens( cIdSfa )
	local cQryZC52

	cQryZC52 := "SELECT ZC5_IDEXTE, ZC6_PRODUT, ZC6_QTDVEN"						+ CRLF
	cQryZC52 += " FROM "		+ retSQLName( "ZC5" ) + " ZC5"					+ CRLF
	cQryZC52 += " INNER JOIN "	+ retSQLName( "ZC6" ) + " ZC6"					+ CRLF
	cQryZC52 += " ON"															+ CRLF
	cQryZC52 += "		ZC5.ZC5_IDSFA	=	ZC6.ZC6_IDSFA"						+ CRLF
	cQryZC52 += "	AND ZC5.ZC5_FILIAL	=	ZC6.ZC6_FILIAL"						+ CRLF
	cQryZC52 += " 	AND	ZC6.D_E_L_E_T_	<>	'*'"								+ CRLF
	cQryZC52 += " WHERE"														+ CRLF
	cQryZC52 += " 		ZC5.ZC5_IDEXTE	=	'" + cIdSfa			+ "'"			+ CRLF
	cQryZC52 += " 	AND	ZC5.ZC5_FILIAL	=	'" + xFilial("ZC5") + "'"			+ CRLF
	cQryZC52 += " 	AND	ZC5.D_E_L_E_T_	<>	'*'"								+ CRLF

	tcQuery cQryZC52 new alias "QRYZC52"
return

/*/
=============================================================================
{Protheus.doc} MGFAT53S
Faz liberação ou bloqueio do pedido na SC5
@author Joni Lima
@since 03/11/2016
/*/
User Function MGFAT53S(cStatRec,cStatSIN,cStatSUF)

Local _llib := .T.
Local _aszv := SZV->(GetArea())

DbSelectArea('SZV')
SZV->(dbSetOrder(1))//ZV_FILIAL+ZV_PEDIDO+ZV_ITEMPED+ZV_CODRGA

If (SZV->(DbSeek(SC5->C5_FILIAL+SC5->C5_NUM)))

	Do while SZV->ZV_FILIAL == SC5->C5_FILIAL .AND. SZV->ZV_PEDIDO == SC5->C5_NUM

		If SZV->ZV_CODRGA == '000096' .OR. SZV->ZV_CODRGA == '000097' .OR. SZV->ZV_CODRGA == '000098'  

			Reclock("SZV",.F.)
			SZV->ZV_CODAPR := '999999'
			SZV->ZV_DTAPR := DATE()
			SZV->ZV_HRAPR := TIME()
			SZV->ZV_MOTAPRO := 'AUTO VIA KEYCONSULT'
			SZV->(Msunlock())

		Elseif empty(SZV->ZV_DTAPR)

			_llib := .F. //Tem bloqueio de outras regras
		
		Endif

		SZV->(Dbskip())

	Enddo


	If cstatRec == "B" //bloqueio da receita

		Reclock("SZV",.T.)
		SZV->ZV_FILIAL := SC5->C5_FILIAL
		SZV->ZV_PEDIDO := SC5->C5_NUM
		SZV->ZV_ITEMPED := '01'
		SZV->ZV_CODRGA := '000090'
		SZV->ZV_MOTAPRO := 'AUTO VIA KEYCONSULT'
		SZV->ZV_DTBLQ  := DATE()
		SZV->ZV_HRBLQ  := TIME()
		SZV->(Msunlock())

	Endif

	If cStatSIN == "B" //bloqueio do sintegra

		Reclock("SZV",.T.)
		SZV->ZV_FILIAL := SC5->C5_FILIAL
		SZV->ZV_PEDIDO := SC5->C5_NUM
		SZV->ZV_ITEMPED := '01'
		SZV->ZV_CODRGA := '000092'
		SZV->ZV_MOTAPRO := 'AUTO VIA KEYCONSULT'
		SZV->ZV_DTBLQ  := DATE()
		SZV->ZV_HRBLQ  := TIME()
		SZV->(Msunlock())

	Endif

	If cStatSUF == "B" //bloqueio do suframa

		Reclock("SZV",.T.)
		SZV->ZV_FILIAL := SC5->C5_FILIAL
		SZV->ZV_PEDIDO := SC5->C5_NUM
		SZV->ZV_CODRGA := '000094'
		SZV->ZV_MOTAPRO := 'AUTO VIA KEYCONSULT'
		SZV->ZV_DTBLQ  := DATE()
		SZV->ZV_HRBLQ  := TIME()
		SZV->(Msunlock())

	Endif

	If cstatRec == "L" .AND.  cStatSIN == "L" .AND. cStatSUF == "L"

		Reclock("SC5", .F.)
		SC5_XINTEGR = 'P'
		SC5->C5_ZCONWS := 'S'
		SC5->C5_ZLIBENV := 'S'
		SC5->C5_ZTAUREE := 'S'

		If _llib 

			SC5->C5_ZBLQRGA := 'L'

		Else

			SC5->C5_ZBLQRGA := 'B'

		Endif	

		SC5->(Msunlock())	


	Endif


Endif

RestArea(_aszv)

Return




