#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'FWMVCDEF.CH'

user function MGFGFE11()

	Local oMBrowse := nil
	Local aAux := {}
	oMBrowse:= FWmBrowse():New()

	oMBrowse:SetAlias("ZD4")
	oMBrowse:SetDescription("log de Regras Tipo de Operação")
	oMBrowse:Setmenudef("MGFGFE11")
	
	oMBrowse:Activate()	
return

**********************************************************
Static Function MenuDef()
	
	Local	aRotina	:= {}
	
	ADD OPTION aRotina TITLE "Pesquisar"  	  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.MGFGFE11" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	//ADD OPTION aRotina TITLE "Incluir"    	  ACTION "VIEWDEF.MGFGFE09" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	//ADD OPTION aRotina TITLE "Alterar"    	  ACTION "VIEWDEF.MGFGFE09" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	//ADD OPTION aRotina TITLE "Excluir"    	  ACTION "VIEWDEF.MGFGFE09" OPERATION MODEL_OPERATION_DELETE ACCESS 0
	
Return aRotina
**********************************************************

Static Function ModelDef()

Local oStruZD4 := FWFormStruct( 1, 'ZD4', /*bAvalCampo*/,/*lViewUsado*/ )
Local oModel
oModel := MPFormModel():New('XGFE11'/*'XGFE11'*/, /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

	
oModel:AddFields( 'ZD4MASTER', /*cOwner*/, oStruZD4, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

oModel:SetDescription( 'log de Regras Tipo de Operação' )

oModel:SetPrimaryKey({"ZD4_FILIAL","ZD4_CARGA", "ZD4_TPOP"})

oModel:GetModel( 'ZD4MASTER' ):SetDescription( 'log de Regras Tipo de Operação' )

Return oModel

**********************************************************
Static Function ViewDef()

Local oModel   := FWLoadModel( 'MGFGFE11' )
Local oStruZD4 := FWFormStruct( 2, 'ZD4' )
Local oView
Local cCampos := {}

oView := FWFormView():New()

oView:SetModel( oModel )

oView:AddField( 'VIEW_ZD4', oStruZD4, 'ZD4MASTER' )

oView:CreateHorizontalBox( 'TELA' , 100 )

oView:SetOwnerView( 'VIEW_ZD4', 'TELA' )

Return oView