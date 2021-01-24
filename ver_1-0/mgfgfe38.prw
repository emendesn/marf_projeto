#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
=========================================================================================================
Programa.................: MGFGFE38
Autor:...................: Flávio Dentello
Data.....................: 16/06/2018
Descrição / Objetivo.....: Cadastro de Grupo de empresa
Doc. Origem..............: 
Solicitante..............: Cliente
Uso......................: Marfrig
Obs......................: 
=========================================================================================================
*/

User Function MGFGFE38

	Local oMBrowse := nil
	Local aAux := {}
	oMBrowse:= FWmBrowse():New()

	oMBrowse:SetAlias("ZE3")
	oMBrowse:SetDescription("Cadastro de Grupos")
	oMBrowse:Setmenudef("MGFGFE38")
	
	oMBrowse:Activate()
	
Return

**********************************************************
Static Function MenuDef()
	
	Local	aRotina	:= {}
	
	ADD OPTION aRotina TITLE "Pesquisar"  	  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.MGFGFE38" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	  ACTION "VIEWDEF.MGFGFE38" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    	  ACTION "VIEWDEF.MGFGFE38" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	  ACTION "VIEWDEF.MGFGFE38" OPERATION MODEL_OPERATION_DELETE ACCESS 0
	
Return aRotina
**********************************************************
Static Function ModelDef()

Local oStruZE3 := FWFormStruct( 1, 'ZE3', /*bAvalCampo*/,/*lViewUsado*/ )
Local oModel

oModel := MPFormModel():New('XMGFGFE38', /*bPreValidacao*/,  , /*bCommit*/, /*bCancel*/ )

oModel:AddFields( 'ZE3MASTER', /*cOwner*/, oStruZE3, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

oModel:SetDescription( 'Cadastro de Grupo' )

oModel:SetPrimaryKey({"ZE3_FILIAL","ZE3_COD"})

//oStruZD3:setValue('ZD3MASTER','ZD3_EXPRES', xcExpressao)

oModel:GetModel( 'ZE3MASTER' ):SetDescription( 'Cadastro de Grupo' )

Return oModel

**********************************************************
Static Function ViewDef()

Local oModel   := FWLoadModel( 'MGFGFE38' )
Local oStruZD3 := FWFormStruct( 2, 'ZE3' )
Local oView
Local cCampos := {}

oView := FWFormView():New()

oView:SetModel( oModel )

oView:AddField( 'VIEW_ZE3', oStruZD3, 'ZE3MASTER' )

oView:CreateHorizontalBox( 'TELA' , 100 )

oView:SetOwnerView( 'VIEW_ZE3', 'TELA' )

Return oView

