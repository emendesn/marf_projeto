#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: MGFINT39
Autor...............: Marcelo Carneiro
Data................: 28/03/2017
Descricao / Objetivo: Integração De Cadastros
Doc. Origem.........: Contrato GAPS - MIT044- BLOQUEIO DE CADASTROS
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ponto de Entrada bloquear registros com MSBLQL = 1 e Inclusão
nTipo == 1 para não alterar registro Bloqueado
nTipo == 2 para incluir pendencia de aprovação
nTipo == 3 para bloquear o cadastro após a alteração/inclusão
=====================================================================================
*/
User Function MGFINT39(nTipo,cTab,cCampo)

	Local bRet			:= .T.
	Local aRet			:= {}
	local cZB1USER		:= ""
	local cUsrSaForc	:= AllTrim( superGetMv( "MGF_INT39A" , , "004703" ) )

	If !IsInCallStack("U_MGFIMP01") .And. !IsInCallStack("U_XEXEC")

		IF nTipo == 1
			IF &(cTab+"->"+cCampo) == '1'
				Help( ,, 'Help',, 'Não é possivel Alterar, pois o registro está Bloqueado!', 1, 0 )
				bRet := .F.
			EndIF

		ElseIF nTipo == 2

			IF IsInCallStack("U_MGFINT37") .AND. cTab == 'SA4'
			     Return .T.
			EndIF

			nID  := U_INT38_ID()
			cCad := U_INT38_CAD(cTab)
			aRet := U_INT38_ROT(cCad,nID)

			IF !aRet[01]
				Help( ,, 'Help',, 'Não existe roteiro de Aprovação', 1, 0 )
				Return .F.
			EndIF

			if isInCallStack( "INSERTORUPDATECUSTOMER" ) .AND. FunName() == "MGFWSS11" .AND. cTab == "SA1"
				// SE ORIGEM SALESFORCE COLOCA CODIGO DO VENDEDOR
				cZB1USER := cUsrSaForc
			else
				cZB1USER := RetCodUsr()
			endif

			RecLock("ZB1", .T.)
			ZB1->ZB1_ID     := nID
			ZB1->ZB1_TIPO   := '1'
			ZB1->ZB1_CAD    := cCad
			ZB1->ZB1_RECNO  := &(cTab+'->(Recno())')
			ZB1->ZB1_USER   := cZB1USER
			ZB1->ZB1_DATA   := Date()
			ZB1->ZB1_HORA   := Time()
			ZB1->ZB1_STATUS := '3'
			ZB1->ZB1_EMAIL  := 'N'
			ZB1->ZB1_IDSET  := aRet[02]

			DO CASE
				CASE cCad  == '1'
					 ZB1->ZB1_COD   := SA1->A1_COD
					 ZB1->ZB1_COD   := SA1->A1_COD + '-' + SA1->A1_LOJA
					 ZB1->ZB1_DADOS := SA1->A1_NOME
				CASE cCad  == '2'
					 ZB1->ZB1_COD   := SZ9->Z9_ZCLIENT
					 ZB1->ZB1_COD   := SZ9->Z9_ZCLIENT + '-' + SZ9->Z9_ZLOJA 
					 ZB1->ZB1_DADOS := SZ9->Z9_ZRAZEND
				CASE cCad  == '3'
					 ZB1->ZB1_COD   := SA2->A2_COD+'-'+SA2->A2_LOJA
					 ZB1->ZB1_COD   := SA2->A2_COD + '-' + SA2->A2_LOJA
					 ZB1->ZB1_DADOS := SA2->A2_NOME
				CASE cCad  == '4'
					 ZB1->ZB1_COD   := SA4->A4_COD
					 ZB1->ZB1_DADOS := SA4->A4_NOME
				CASE cCad  == '5'
					 ZB1->ZB1_COD   := SA3->A3_COD
					 ZB1->ZB1_DADOS := SA3->A3_NOME
				CASE cCad  == '6'
					 ZB1->ZB1_COD   := DA3->DA3_COD
					 ZB1->ZB1_DADOS := DA3->DA3_DESC
				CASE cCad  == '7'
					 ZB1->ZB1_COD   := DA4->DA4_COD
					 ZB1->ZB1_DADOS := DA4->DA4_NOME
				CASE cCad  == '8'
					 ZB1->ZB1_COD   := SB1->B1_COD
					 ZB1->ZB1_DADOS := SB1->B1_DESC
			ENDCASE

			ZB1->(msUnlock())
			
			IF !(cTab$'SZ9/DA3/DA4')
				RecLock(cTab, .f.)
				&(cTab+"->"+cCampo) := '1'
				&(cTab+"->(msUnlock())")
			EndIF

			If U_xMG38Alc(nID)
				//Determina a Aprovação no Registro
				IF !(cTab$'SZ9/DA3/DA4')

					RecLock(cTab, .f.)
					&(cTab+"->"+cCampo) := '2'
					&(cTab+"->(msUnlock())")

					ZB1->(dbSetOrder(1))
				
					If ZB1->(dbSeek(nID))
						Reclock("ZB1",.F.)
						ZB1->ZB1_STATUS := '1'
						ZB1->(MsUnLock())
					EndIf
				EndIf
			EndIf
		ElseIF nTipo == 3
			IF U_MGF38_PED(cTab,cCampo)
				RecLock(cTab, .f.)
				If cTab == 'SA1'
				   &(cTab+"->"+cCampo+'_MSBLQL') := '1'
				ElseIf cTab == 'SA2'
				   &(cTab+"->"+cCampo) := '1'
				EndIf
				&(cTab+"->(msUnlock())")
			EndIF
		EndIF
	EndIf

Return bRet

User Function INT39_EMAIL

Local lRet := .T.

If SA2->(FieldPos("A2_ZTRANSP")) > 0
   IF M->A2_ZTRANSP == '1'
       IF Empty(M->A2_EMAIL)
            MsgAlert('Campo E-Mail obrigatorio para Transportadora !!')
            lRet := .F.
       EndIF
   EndIF
EndIF

Return lRet
