#Include "Protheus.ch"
#include "totvs.ch"
#include "FWMVCDEF.ch"


// FUNÇÃO DE LIBERAÇÃO DO FRETE COMBINADO

User Function FRETECOMB()

Local oMBrowse 	:= nil
Local cFilter 	:= ""
Local aRotOld := iif(Type("aRotina")<>"U",aRotina,{})
//	If Type("aRotina")<>"U"
//		aRotina := {}
//	EndIf

aRotina := MenuDef()

oMBrowse:= FWmBrowse():New()
oMBrowse:SetAlias("ZBO")
oMBrowse:SetDescription('Aprovação Frete Combinado')


oMBrowse:Activate()

//	if Type("aRotina")<>"U
//		aRotina := aOldRot
//	EndIf

Return

Static Function MenuDef()

Local	aRotina	:= {}

//	ADD OPTION aRotina TITLE "Pesquisar"  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.FRETECOMB" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
//	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.MGFEEC20" OPERATION MODEL_OPERATION_INSERT ACCESS 0
ADD OPTION aRotina TITLE "Aprovar"    ACTION  "U_APROV" OPERATION 4 ACCESS 0
//	ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.MGFEEC20" OPERATION MODEL_OPERATION_DELETE ACCESS 0

Return(aRotina)

Static Function ModelDef()

Local oModel	:= Nil

Local oStrZBO := FWFormStruct(1,"ZBO")

oModel := MPFormModel():New("XFRETECOMB",/*bPreValidacao*/,/*bPosValid*/,/*bCommit*/,/*bCancel*/ )

oModel:AddFields("ZBOMASTER",/*cOwner*/,oStrZBO, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )

oModel:SetDescription("Aprovação Frete Combinado")

oModel:SetPrimaryKey({"ZBO_FILIAL","ZBO_NRCALC"})

Return oModel

Static Function ViewDef()

Local oView
Local oModel  	:= FWLoadModel('FRETECOMB')

Local oStrZBA 	:= FWFormStruct( 2, "ZBO",)

oView := FWFormView():New()
oView:SetModel(oModel)

oView:AddField( 'VIEW_ZBO' , oStrZBA, 'ZBOMASTER' )

oView:CreateHorizontalBox( 'TELA' , 100 )

oView:SetOwnerView( 'VIEW_ZBO', 'TELA' )

Return oView

User Function APROV()

Local lRet := .F.
Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
Local lMsg := .F.

If ZBO->ZBO_STAUS = "1"
	dBselectArea("SZO")
	SZO->(dbSetOrder(1))//ZO_FILIAL+ZO_USUARIO
	If SZO->(dbSeek(xFilial("SZO")+cCodUser))
		
		While !SZO->(eof()) .AND. SZO->ZO_USUARIO = cCodUser .AND. !lRet .AND. U_GFE01VLDSUB()
			If SZO->ZO_TPAPROV $ '56'
				If ZBO->ZBO_VLFRE >= SZO->ZO_VLMIN .AND. ZBO->ZBO_VLFRE <= SZO->ZO_VLATE
					lRet := .T.
					lMsg := .T.
				EndIf
			EndIf
			SZO->(DBSKIP())
		Enddo
	EndIf
	
	If lRet = .T.
		
		lRet := MsgYesno("Confirma a aprovação do Frete Combinado?")
		
	Else
		
		MsgAlert ("Usuário não tem permissão para realizar aprovação!")
		
		Return
	EndIf
	
	If lRet = .T.
		
		dBselectArea("GWI")
		GWI->(dbSetOrder(1))//GWI_FILIAL+GWI_NRCALC+GWI_CDCLFR+GWI_CDTPOP+GWI_CDCOMP
		If GWI->(dbSeek(xFilial("GWI")+ZBO->ZBO_NRCALC))
			
			While(!eof()) .AND. XFILIAL('ZBO') == GWI->GWI_FILIAL .AND. ZBO->ZBO_NRCALC == GWI->GWI_NRCALC
				
				RecLock("GWI",.F.)
				GWI->GWI_VLFRET := GWI->GWI_XVLAPR
				//GWI->GWI_VLFRET := GWI->GWI_QTCALC
				MsUnlock()
				
				GWI->(DbSkip())
			Enddo
			
			
		EndIF
		//RecLock("ZBO",.F.)
		ZBO->ZBO_STAUS := "2"
		ZBO->ZBO_USER  := cCodUser
		// MsUnlock()
		
	EndIf
Else
	
	MsgAlert("Registro já aprovado!")
EndIf
Return
