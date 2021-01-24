
#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"

User Function MGFEEC20(cUnidade,cPedido)
	
	Local oMBrowse 	:= nil          
	Local cFilter 	:= ""
	Local aRotOld := iif(Type("aRotina")<>"U",aRotina,{})
	If Type("aRotina")<>"U"
		aRotina := {}
	EndIf
	
	Default cPedido := ZB8->(ZB8_EXP + ZB8_ANOEXP + ZB8_SUBEXP)
	Default cUnidade := ZB8->ZB8_FILIAL
//	Default cLoja	 := EEC->EEC_IMLOJA
	
	aRotina := MenuDef() 
	
	oMBrowse:= FWmBrowse():New()
	oMBrowse:SetAlias("ZBA")
	oMBrowse:SetDescription('Documentos de Exportação')
	
	//oMBrowse:SetMenuDef('MGFEEC20')
	
	If !(Empty(cPedido)) .and. !(Empty(cUnidade))
		cFilter := 'ALLTRIM(ZBA_PREEMB) == "' + ALLTRIM(ZB8->(ZB8_EXP + ZB8_ANOEXP + ZB8_SUBEXP)) + '" .and. ZBA_FILIAL == "' + ZB8->ZB8_FILIAL + '"' 
		oMBrowse:SetFilterDefault(cFilter)
	EndIf

	oMBrowse:Activate()
	
	if Type("aRotina")<>"U
		aRotina := aRotOld
	EndIf
	
Return

Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MGFEEC20" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.MGFEEC20" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.MGFEEC20" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.MGFEEC20" OPERATION MODEL_OPERATION_DELETE ACCESS 0

Return(aRotina)

Static Function ModelDef()

	Local oModel	:= Nil
	
	Local oStrZBA := FWFormStruct(1,"ZBA")
    
//	oStrZZJ:Setproperty('ZZJ_DTBASE', MODEL_FIELD_INIT, {||dDataBase})
		
	oModel := MPFormModel():New("XMGFEEC20",/*bPreValidacao*/,/*bPosValid*/,/*bCommit*/,/*bCancel*/ )

	oModel:AddFields("ZBAMASTER",/*cOwner*/,oStrZBA, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )

	oModel:SetDescription("Documento de Exportação")
	oModel:SetPrimaryKey({"ZBA_FILIAL","ZBA_PREEMB"})

Return oModel

Static Function ViewDef()

	Local oView
	Local oModel  	:= FWLoadModel('MGFEEC20')

	Local oStrZBA 	:= FWFormStruct( 2, "ZBA",)
    
	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_ZBA' , oStrZBA, 'ZBAMASTER' )

	oView:CreateHorizontalBox( 'TELA' , 100 )

	oView:SetOwnerView( 'VIEW_ZBA', 'TELA' )

Return oView
