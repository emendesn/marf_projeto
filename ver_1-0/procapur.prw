#include 'protheus.ch'
#include 'parmtype.ch'
#DEFINE CRLF chr(13) + chr(10)

//-------------------------------------------------------------------
/*/{Protheus.doc} PROCAPUR

Descri��o do PE:

	Permite o bloqueio do reprocessamento e exclus�o da apura��o de ICMS.
	http://tdn.totvs.com/pages/releaseview.action?pageId=407113308
	

@author Natanael Sim�es
@since 22/01/2019
@version P12.1.17
/*/
//-------------------------------------------------------------------


User Function PROCAPUR()
Local lMGFFIS42A := SuperGetMV("MGF_FIS42A",.T.,.F.) //Habilita GAP366/ MGFFIS42
Local aArea := GetArea()
Local cAno := ParamIXB[1]
Local cMes := ParamIXB[2]
Local lRet := .F. //L�gico indicando .T. para bloquear o reprocessamento ou .F. permitir o reprocessamento.


If FindFunction("U_MGFFIS43") .and. lMGFFIS42A //GAP 366 - Bloqueio para apura��o de ICMS
lRet := U_MGFFIS43(Int(cAno),Int(cMes))
EndIf

RestArea(aArea)	
return lRet