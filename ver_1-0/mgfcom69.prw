#include "Protheus.ch"
#include "FWMVCDEF.ch"

Static cMotDesblo := Space(Len(SCR->CR_ZMOTDES))

/*
=====================================================================================
Programa............: MGFCOM69
Autor...............: Totvs
Data................: 02/02/2018 
Descricao / Objetivo: Compras 
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Rotina chamada pelo ponto de entrada MATA094
=====================================================================================
*/
User Function MGFCOM69()

Local aArea := {GetArea()}
Local oObj := IIf(Type("ParamIxb[1]")!="U",ParamIxb[1],Nil)
Local cIdPonto := IIf(Type("ParamIxb[2]")!="U",ParamIxb[2],"")
Local cIdModel := IIf(Type("ParamIxb[3]")!="U",ParamIxb[3],"")
Local lNewReg := IIf(Type("ParamIxb[4]")!="U",ParamIxb[4],.F.)
Local nOpcx := 0
Local uRet := .T. 

If oObj == Nil .or. Empty(cIdPonto)
	Return(uRet)
Endif

If cIdPonto == "BUTTONBAR" //"FORMPRE" //"MODELPOS"//"MODELPRE" //"MODELPOS"//"MODELPRE"//"MODELPOS"//"BUTTONBAR"//"MODELVLDACTIVE"
	nOpcx := oObj:GetOperation()
	If nOpcx == MODEL_OPERATION_UPDATE .and. (IsInCallStack("A94ExLiber") .or. IsInCallStack("A94ExSuper") .or. IsInCallStack("A94ExTrans") .or. IsInCallStack("A94VISUAL"))
		uRet := { {'Mot. Desbloq. Div. Valor Total', 'Salvar', { || U_COM69Des() }, 'Mot. Desbloq. Div. Valor Total' } }
	Endif	
EndIf

If cIdPonto == "FORMPOS"
	nOpcx := oObj:GetOperation()
	If nOpcx == MODEL_OPERATION_UPDATE .and. (IsInCallStack("A94ExLiber") .or. IsInCallStack("A94ExSuper") .or. IsInCallStack("A94ExTrans")) 
		uRet := COM69PosVld()
	Endif	
EndIf

//If cIdPonto == "MODELVLDACTIVE"
//	nOpcx := oObj:GetOperation()
//	If nOpcx == MODEL_OPERATION_UPDATE .and. IsInCallStack("A094VldEst")
//		uRet := COM69ActVld(oObj)
//	Endif	
//EndIf

aEval(aArea,{|x| RestArea(x)})

Return(uRet)                            


// mostra tela para usuario informar o motivo do desbloqueio
User Function COM69Des()

Local oDlg                 
Local cTit := OemToAnsi("Motivo de Liberação - Bloqueio por Divergência de Valor Total da Nota - Marfrig")
Local oBut1
//Local oBut2
Local nOpcA := 0
Local lWhen := .T.
Local lRet := .T.

lRet := COM69NFDiv()

If lRet
	lWhen := IIf((IsInCallStack("A94ExLiber") .or. IsInCallStack("A94ExSuper") .or. IsInCallStack("A94ExTrans")),.T.,.F.)
	If !lWhen
		cMotDesblo := SCR->CR_ZMOTDES
	Endif	
			
	DEFINE MSDIALOG oDlg TITLE cTit FROM 200,001 TO 300,450 OF oMainWnd PIXEL 
	
	@ 10,05	SAY OemToAnsi("Motivo da Liberação:") OF oDlg SIZE 50,10 PIXEL
	@ 10,60 MSGET cMotDesblo Picture "@!" WHEN lWhen Valid !Empty(cMotDesblo) SIZE 160,10 PIXEL
		
	DEFINE SBUTTON oBut1 FROM 30,100 TYPE 1 ACTION IIf(!Empty(cMotDesblo),(nOpcA := 1,oDlg:End()),.F.) ENABLE OF oDlg
	//DEFINE SBUTTON oBut2 FROM 30,150 TYPE 2 ACTION (oDlg:End()) ENABLE OF oDlg
		
	ACTIVATE MSDIALOG oDlg CENTERED
Else
	APMsgAlert("Documento não é tipo 'NF' ou não foi bloqueado pela divergência de valor total."+CRLF+;
	"Não será permitido informar o motivo.")	
Endif
				
Return()		


// valida se o motivo de desbloqueio foi informado
Static Function COM69PosVld()

Local lRet := .T.
Local lValida := .F.

lValida := COM69NFDiv()

If lValida .and. Empty(cMotDesblo)
	lRet := .F.
	APMsgAlert("Não foi informado o motivo do desbloqueio."+CRLF+;
	"Acesse no menu 'Outras Ações' a opção 'Mot. Desbloq. Div. Valor Total' e informe o motivo.")
Endif

Return(lRet)	


// verifica se o documento foi bloqueado pela divergencia de valor total
Static Function COM69NFDiv()

Local lRet := .F.

If Alltrim(SCR->CR_TIPO) == "NF"
	If "_VALOR_NFE" $ Alltrim(SCR->CR_NUM)
		lRet := .T.
	Endif	
Endif

//If lRet
//	lRet := (GetAdvFVal("SF1","F1_ZBLQVAL",xFilial("SF1")+Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)),1,"")=="S") .or. (GetAdvFVal("SF1","F1_ZBLQVAL",xFilial("SF1")+Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)),1,"")=="N")
//Endif

Return(lRet)


/*
=====================================================================================
Programa............: MGFCOM71
Autor...............: Totvs
Data................: 02/02/2018 
Descricao / Objetivo: Compras 
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Rotina chamada pelo ponto de entrada MT094END
=====================================================================================
*/
// OBS: esta rotina estah dentro deste .PRW, para poder usar a variavel static cMotDesblo
User Function MGFCOM71()

Local aArea := {SF1->(GetArea()),GetArea()}
Local lGrava := .F.
Local nOpc := ParamIxb[3]

If nOpc == MODEL_OPERATION_UPDATE .and. (IsInCallStack("A94ExLiber") .or. IsInCallStack("A94ExSuper") .or. IsInCallStack("A94ExTrans"))
	lGrava := COM69NFDiv()
	If lGrava 
		SCR->(RecLock("SCR",.F.))
		SCR->CR_ZMOTDES := cMotDesblo
		SCR->(MsUnLock())
	Endif
Endif
		
/*		
		If SCR->CR_STATUS $ "03/05" // status de aprovacao
			// desbloqueia a nota
			SF1->(dbSetOrder(1))
			If SF1->(dbSeek(xFilial("SF1")+Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)))) .and. SF1->F1_ZBLQVAL == "S" .and. SF1->F1_STATUS != "B"
				SF1->(RecLock("SF1",.F.))
				SF1->F1_ZBLQVAL := "N"
				SF1->(MsUnLock())
			Endif	
		Endif
*/	

// limpa variavel para demais liberacoes
cMotDesblo := Space(Len(SCR->CR_ZMOTDES))
		
aEval(aArea,{|x| RestArea(x)})

Return()	

/*
Static Function COM69ActVld(oObj)

Local lRet := .f.

alert("entrei")

Return(lRet)
*/