#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#INCLUDE "FWMVCDEF.CH"
#define CRLF chr(13) + chr(10)

Static _aErr

/*
==========================================================================================================
Programa.:              MGFFAT27
Autor....:              Joni Lima do Carmo
Data.....:              03/11/2016
Descricao / Objetivo:   Verificacao de Regra Receita, Sintegra e Suframa
Doc. Origem:            Contrato GAP - FAT14- Regras de Bloqueio
Solicitante:            Cliente
Uso......:              
Obs......:              Envio Pedido de Compra de Gado - Parte WS Server consumir o Metodo Gerar Pedido
==========================================================================================================
*/
WSSTRUCT FTRG14_DADOS

	WSDATA EMPRES	    as String
	WSDATA FILIAL	    as String
	WSDATA PEDIDO    	as String
	WSDATA STAREC	    as String
	WSDATA STASIN	    as String
	WSDATA STASUF	    as String

ENDWSSTRUCT

WSSTRUCT FTRG14_RETORNO
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

WSSERVICE MGFFAT27 DESCRIPTION "Retorno Consulta" NAMESPACE "http://www.totvs.com.br/MGFFAT27"
	WSDATA WSDADOS 	 as FTRG14_DADOS
	WSDATA WSRETORNO as FTRG14_RETORNO

	WSMETHOD RetornoConsulta DESCRIPTION "Retorno de Consulta Governo"
ENDWSSERVICE

WSMETHOD RetornoConsulta WSRECEIVE WSDADOS WSSEND WSRETORNO WSSERVICE MGFFAT27

	Local cxEmp		:= ::WSDADOS:EMPRES
	Local cxFil 	:= ::WSDADOS:FILIAL
	Local cPedido 	:= ::WSDADOS:PEDIDO
	Local cStatREC	:= ::WSDADOS:STAREC //'L' = Liberado, 'B' = Bloqueado, 'I' = Indisponivel
	Local cStatSIN	:= ::WSDADOS:STASIN //'L' = Liberado, 'B' = Bloqueado, 'I' = Indisponivel
	Local cStatSUF	:= ::WSDADOS:STASUF //'L' = Liberado, 'B' = Bloqueado, 'I' = Indisponivel
	Local aRetorno	:= {}

	Local lConti	:= .T.

	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )

	BEGIN SEQUENCE

	If lConti .and. ( Empty(cxEmp) .or. Empty(cxFil) .or. Empty(cPedido))
		lConti := .F.
		aRetorno := {'E','Empresa e/ou Filial e/ou Pedido Nao Est�o Preenchidos'}
	EndIf

	If lConti .and. !(AllTrim(cStatREC) $ 'L|B|I')
		lConti := .F.
		aRetorno := {'E','Status Receita Federal deve ser "L" = Liberado, "B"=Bloqueado ou "I"=Indisponivel'}
	EndIf

	If lConti .and. !(AllTrim(cStatSIN) $ 'L|B|I')
		lConti := .F.
		aRetorno := {'E','Status Sintegra deve ser "L" = Liberado, "B"=Bloqueado ou "I"=Indisponivel'}
	EndIf

	If lConti .and. !(AllTrim(cStatSUF) $ 'L|B|I')
		lConti := .F.
		aRetorno := {'E','Status Suframa deve ser "L" = Liberado, "B"=Bloqueado ou "I"=Indisponivel'}
	EndIf

	If lConti
		// verifica se tem ambiente aberto pelo Job
		/*If Select("SM0") > 0
			RpcSetType(3)
			RESET ENVIRONMENT
		Endif*/

		//PREPARE ENVIRONMENT EMPRESA cxEmp FILIAL cxFil TABLES "SC5","SC6","SZS","SZT","SZU","SZV","SA1"
		cFilAnt := cxFil
		aRetorno := xMF27PcInf(cxFil,cPedido,cStatREC,cStatSIN,cStatSUF)
		//RESET ENVIRONMENT

		// abre Empresa padrao 01 antes de sair da rotina
		//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001"
	EndIf

	RECOVER
	   Conout('Problema Ocorreu as Horas: ' + TIME() )
	   KillApp(.T.)

	END SEQUENCE

	ErrorBlock( bError )


	If ValType(_aErr) == 'A'
		aRetorno := _aErr
	EndIf

	//Retorno
	::WSRETORNO := WSClassNew( "FTRG14_RETORNO")
	::WSRETORNO:STATUS  := aRetorno[1]
	::WSRETORNO:MSG	    := aRetorno[2]

Return .T.

Static Function MyError(oError)

    Local nQtd := MLCount(oError:ERRORSTACK)
	Local ni
	Local cEr :=''

    nQtd := IIF(nQtd > 4,4,nQtd)
//Retorna as 4 linhas

    FOr ni:=1 to nQTd
        cEr += MemoLine(oError:ERRORSTACK,,ni)
    Next ni
    Conout( oError:Description + "Deu Erro" )
	_aErr := {'E',cEr}
    If InTransact()
        DisarmTransaction()
    EndIf

    BREAK

Return .T.

/*
==========================================================================================================
Programa.:              xMF27PcInf
Autor....:              Joni Lima
Data.....:              03/11/2016
Descricao / Objetivo:   Verifica qual o tipo de consulta e o status sera processado.
Doc. Origem:            Contrato GAPS - MIT044- FAT14
Solicitante:            Cliente
Uso......:              
Obs......:
==========================================================================================================
*/
Static Function xMF27PcInf(cxFil,cPedido,cStatREC,cStatSIN,cStatSUF)

	Local aArea		:= GetArea()
	Local aAreaSC5	:= SC5->(GetArea())

	Local aRet 		:= {'O','OK'}
	Local cRgaCons	:= ''
	Local cRgaCad	:= ''

	Local _aPedTau := {}

	DbSelectArea('SC5')
	SC5->(DbSetOrder(1))//C5_FILIAL, C5_NUM

	If SC5->(DbSeek(cxFil + cPedido))

		Begin Transaction

			//Receita
			cRgaCons := '000096'
			If cStatREC == 'L'
				aRet := xMF27AtSZV(cxFil,cPedido,cRgaCons,cRgaCad,aRet)
			ElseIf cStatREC == 'B'
				cRgaCad := '000090'//Bloqueio Receita Federal
				aRet := xMF27AtSZV(cxFil,cPedido,cRgaCons,cRgaCad,aRet)
			ElseIf cStatREC == 'I'
				cRgaCad := '000091'//Indisponibilidade Receita Federal
				aRet := xMF27AtSZV(cxFil,cPedido,cRgaCons,cRgaCad,aRet)
			EndIf

			If aRet[1] == 'O'
				//Sintegra
				cRgaCons := '000097'
				cRgaCad	:= ''
				If cStatSIN == 'L'
					aRet := xMF27AtSZV(cxFil,cPedido,cRgaCons,cRgaCad,aRet)
				ElseIf cStatSIN == 'B'
					cRgaCad := '000092' //Bloqueio Sintegra
					aRet := xMF27AtSZV(cxFil,cPedido,cRgaCons,cRgaCad,aRet)
				ElseIf cStatSIN == 'I'
					cRgaCad := '000091' //Indisponibilidade Receita Federal
					aRet := xMF27AtSZV(cxFil,cPedido,cRgaCons,cRgaCad,aRet)
				EndIf
			EndIf

			If aRet[1] == 'O'
				//Suframa
				cRgaCons := '000098'
				cRgaCad	:= ''
				If cStatSUF == 'L'
					aRet := xMF27AtSZV(cxFil,cPedido,cRgaCons,cRgaCad,aRet)
				ElseIf cStatSUF == 'B'
					cRgaCad := '000094' //Bloqueio Suframa
					aRet := xMF27AtSZV(cxFil,cPedido,cRgaCons,cRgaCad,aRet)
				ElseIf cStatSUF == 'I'
					cRgaCad := '000095' //Indisponibilidade Suframa
					aRet := xMF27AtSZV(cxFil,cPedido,cRgaCons,cRgaCad,aRet)
				EndIf
			EndIf

			If aRet[1] == 'O'

				sfaZC5( cxFil, cPedido )

				///RecLock('SC5',.F.)
				//	SC5->C5_ZCONWS  := 'S'
				//SC5->(MsUnlock())
				// Marcelo Carneiro  02/04/2018
				cQuery := " Update  "+RetSqlName("SC5")
				cQuery += " SET C5_ZCONWS  = 'S', C5_ZCONFIS = 'N' "
				cQuery += " Where R_E_C_N_O_ = "+STR( SC5->(Recno()) )
				IF (TcSQLExec(cQuery) < 0)
					bContinua   := .F.
					//MsgAlert('Update C5 Key Consult: '+TcSQLError())
					CONOUT('Update C5 Key Consult: '+TcSQLError())
				EndIF

				//Realiza o Bloqueio do Cliente
				If cStatREC == 'B' .or. cStatSIN == 'B' .or. cStatSUF == 'B'
					DbSelectArea('SA1')
					SA1->(DBSetOrder(1))//A1_FILIAL, A1_COD, A1_LOJA
					If SA1->(dbSeek(xFilial('SA1') + SC5->(C5_CLIENTE + C5_LOJACLI)))
						// GRADE DE APROVACAO - FINANCEIRO
						ALTERA := .T.

						// CARREGA EM MEMORIA PARA GERAR GRADE DE APROVACAO
						regToMemory( "SA1" , .F. , .F. )

						// DESBLOQUEIA PARA FORCAR GERAR GRADE DO FINANCEIRO
						recLock( "SA1" , .F. )
							SA1->A1_MSBLQL	:= "2"
							SA1->A1_XBLQREC	:= "N"
						SA1->( msUnlock() )

						M->A1_XBLQREC := "S"

						U_MGFINT38( 'SA1' , 'A1' )
						// FIM - GRADE DE APROVACAO - FINANCEIRO

						cQuery := " Update  "+RetSqlName("SA1")
						cQuery += " SET A1_MSBLQL  = '1' , A1_XBLQREC = 'S' "
						cQuery += " Where R_E_C_N_O_ = "+STR( SA1->(Recno() ))
						IF (TcSQLExec(cQuery) < 0)
							bContinua   := .F.
							//MsgAlert('Update A1 Key Consult: '+TcSQLError())
							CONOUT('Update A1 Key Consult: '+TcSQLError())
						EndIF

					EndIf
				EndIf

				//Realiza a Liberacao do Pedido
				If cStatREC == 'L' .or. cStatSIN == 'L' .or. cStatSUF == 'L'
					If SC5->C5_ZCONRGA == 'S'
						If !(U_xMF10ExiB(SC5->C5_FILIAL,SC5->C5_NUM))
							/*
							RecLock('SC5',.F.)
							SC5->C5_ZBLQRGA := 'L'
							SC5->C5_ZLIBENV := 'S'
							SC5->(MsUnlock())
							  */

							cQuery := " Update  "+RetSqlName("SC5")
							cQuery += " SET C5_ZBLQRGA = 'L', C5_ZLIBENV = 'S' "
							cQuery += " Where R_E_C_N_O_ = "+STR( SC5->(Recno()) )
							IF (TcSQLExec(cQuery) < 0)
								bContinua   := .F.
								//MsgAlert('Update C5 Key Consult: '+TcSQLError())
								CONOUT('Update C5 Key Consult: '+TcSQLError())
							Else
								AADD(_aPedTau,{SC5->C5_FILIAL,{SC5->C5_NUM,2,SC5->(Recno())}})

								If Len(_aPedTau) > 0
									StartJob( "U_xM64PRC", GetEnvServer(), .F., _aPedTau )
								EndIf
							EndIF

						EndIf
					EndIf
				endif
			EndIf
		End Transaction
	Else
		aRet := {'E',' Pedido nao encontrado, verificar Filial e Pedido ' + cxFil + '/' + cPedido }
	EndIf

	RestArea(aAreaSC5)
	RestArea(aArea)

Return aRet

/*
==========================================================================================================
Programa.:              xMF27AtSZV
Autor....:              Joni Lima
Data.....:              03/11/2016
Descricao / Objetivo:   Fazer Liberacao do Bloqueio de Consulta e se preciso cadastrar bloqueio/indisponibilidade
Doc. Origem:            Contrato GAPS - MIT044- FAT14
Solicitante:            Cliente
Uso......:              
Obs......:
==========================================================================================================
*/
Static Function xMF27AtSZV(cxFil,cPedido,cRgaCons,cRgaCad,aRetOld)

	Local aArea 	:= GetArea()
	Local aAreaSZV	:= SZV->(GetArea())
	Local aRet		:= {}
	local lRet		:= .T.
	Local lCont		:= .T.
	Local oModMF10	:= nil
	Local oMdlSVZ	:= nil
	Local cItem		:= '01'

	//Atualiza o Regra de Consulta
	DbSelectArea('SZV')
	SZV->(dbSetOrder(1))//ZV_FILIAL+ZV_PEDIDO+ZV_ITEMPED+ZV_CODRGA
	If (SZV->(DbSeek(cxFil + cPedido + cItem + cRgaCons)))

		oModMF10:= FWLoadModel( 'MGFFAT10' )
		oModMF10:SetOperation( MODEL_OPERATION_UPDATE )

		If oModMF10:Activate()

			oMdlSVZ := oModMF10:GetModel('SZVMASTER')

			oMdlSVZ:LoadValue('ZV_CODAPR',Replicate('9',TamSx3('ZV_CODAPR')[1])	)
			oMdlSVZ:LoadValue('ZV_DTAPR'  ,dDataBase						   	)
			oMdlSVZ:LoadValue('ZV_HRAPR' ,LEFT(Time(),5)						)

			lRet := !(oModMF10:HasErrorMessage())

			sfaZC5( cxFil, cPedido )

			If !lRet .and. IsBlind()
				Conout(OEmToAnsi(xMF27EMVC( oModMF10 )))
			EndIF

			If lRet.and.oModMF10:VldData()
				lRet := FwFormCommit(oModMF10)
				oModMF10:DeActivate()
				oModMF10:Destroy()
			Else
				aRet := {'E', xMF27EMVC( oModMF10 )}
				lRet := .F.
			EndIf
		EndIf

	Else
		lCont:= .F.
		aRet := {'E', 'Nao Foi Encontrado Bloqueio (Filial + Pedido + ItemPed + Cod. Regra): ' + cxFil + '/' + cPedido + '/' + cItem + '/' + cRgaCons }
	EndIf

	//Cria Regra de bloqueio ou indisponibilidade
	If lCont .and. !Empty(cRgaCad)

		DbSelectArea('SZV')
		SZV->(dbSetOrder(1))//ZV_FILIAL+ZV_PEDIDO+ZV_ITEMPED+ZV_CODRGA
		If (!SZV->(DbSeek(cxFil + cPedido + cItem + cRgaCad)))//Nao encontrou Registro

			oModMF10:= FWLoadModel( 'MGFFAT10' )
			oModMF10:SetOperation( MODEL_OPERATION_INSERT )

			If oModMF10:Activate()

				oMdlSVZ := oModMF10:GetModel('SZVMASTER')

				oMdlSVZ:SetValue('ZV_FILIAL' ,cxFil		)
				oMdlSVZ:SetValue('ZV_PEDIDO' ,cPedido	)
				oMdlSVZ:SetValue('ZV_ITEMPED',cItem		)
				oMdlSVZ:SetValue('ZV_CODRGA' ,cRgaCad	)

				lRet := !(oModMF10:HasErrorMessage())

				sfaZC5( cxFil, cPedido )

				If !lRet .and. IsBlind()
					Conout(OEmToAnsi(xMF27EMVC( oModMF10 )))
				EndIF

				If lRet.and.oModMF10:VldData()
					lRet := FwFormCommit(oModMF10)
					oModMF10:DeActivate()
					oModMF10:Destroy()
				Else
					aRet := {'E', xMF27EMVC( oModMF10 )}
					lRet := .F.
				EndIf
			EndIf

		Else//Encontrou Registro

			oModMF10:= FWLoadModel( 'MGFFAT10' )
			oModMF10:SetOperation( MODEL_OPERATION_UPDATE )

			If oModMF10:Activate()

				oMdlSVZ := oModMF10:GetModel('SZVMASTER')

				oMdlSVZ:SetValue('ZV_DTBLQ'  ,dDataBase		)
				oMdlSVZ:SetValue('ZV_HRBLQ'  ,LEFT(Time(),5))
				oMdlSVZ:LoadValue('ZV_CODAPR','' 			)
				oMdlSVZ:SetValue('ZV_DTAPR'  ,cToD('//')	)
				oMdlSVZ:LoadValue('ZV_HRAPR' ,''			)
				oMdlSVZ:LoadValue('ZV_CODRJC',''			)
				oMdlSVZ:SetValue('ZV_DTRJC'  ,cToD('//')	)
				oMdlSVZ:LoadValue('ZV_HRRJC' ,''			)

				lRet := !(oModMF10:HasErrorMessage())

				sfaZC5( cxFil, cPedido )

				If !lRet .and. IsBlind()
					Conout(OEmToAnsi(xMF27EMVC( oModMF10 )))
				EndIF

				If lRet.and.oModMF10:VldData()
					lRet := FwFormCommit(oModMF10)
					oModMF10:DeActivate()
					oModMF10:Destroy()
				Else
					aRet := {'E', xMF27EMVC( oModMF10 )}
					lRet := .F.
				EndIf
			EndIf

		EndIf
	EndIf

	If lRet
		 aRet := aRetOld
	EndIf

Return aRet


/*
=====================================================================================
Programa............: xMF27EMVC
Autor...............: Joni Lima
Data................: 21/10/2016
Descricao / Objetivo: Monta string de erro
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Monta a String de erro
=====================================================================================
*/
Static Function xMF27EMVC( ObjMVC )

	Local aErro := {}
	Local cRet	:= ''

	DEFAULT ObjMVC := nil

	If ValType(ObjMVC) == 'O'
		aErro := ObjMVC:GetErrorMessage()
		If Len(aErro) > 0
			cRet +=  '[' + AllToChar( aErro[MODEL_MSGERR_IDFORMERR] ) + ']' + CRLF
			cRet +=  '[' + AllToChar( aErro[MODEL_MSGERR_IDFIELDERR] ) + ']' + CRLF
			cRet +=  '[' + AllToChar( aErro[MODEL_MSGERR_ID] ) + ']' + CRLF
			cRet +=  '[' + AllToChar( aErro[MODEL_MSGERR_MESSAGE] ) + '|' + AllToChar( aErro[MODEL_MSGERR_SOLUCTION] ) + ']'
		EndIf
	EndIf

Return cRet

//-----------------------------------------------------------------
// Atualiza ZC5 para retorno do Pedido na integracao do SFA
//-----------------------------------------------------------------
static function sfaZC5( cFilZC5, cPedidoZC5 )
	local cUpdZC5 := ""

	cUpdZC5 := "UPDATE " + retSQLName("ZC5")
	cUpdZC5 += " SET "
	cUpdZC5 += "	ZC5_INTEGR = 'P'"
	cUpdZC5 += " WHERE"
	cUpdZC5 += "		ZC5_FILIAL	=	'" + cFilZC5	+ "'"
	cUpdZC5 += "	AND	ZC5_PVPROT	=	'" + cPedidoZC5	+ "'"
	cUpdZC5 += "	AND	D_E_L_E_T_	<>	'*'"

	tcSQLExec(cUpdZC5)

	// ATUALIZA PEDIDO DE VENDA - SC5
	cUpdZC5 := ""

	cUpdZC5 := "UPDATE " + retSQLName("SC5")
	cUpdZC5 += " SET "
	cUpdZC5 += "	C5_XINTEGR = 'P'"
	cUpdZC5 += " WHERE"
	cUpdZC5 += "		C5_FILIAL	=	'" + cFilZC5	+ "'"
	cUpdZC5 += "	AND	C5_NUM		=	'" + cPedidoZC5	+ "'"
	cUpdZC5 += "	AND	D_E_L_E_T_	<>	'*'"

	tcSQLExec(cUpdZC5)
return