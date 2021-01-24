#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
=========================================================================================================
Programa.................: MGFGFE31
Autor:...................: Flávio Dentello
Data.....................: 16/06/2018
Descrição / Objetivo.....: Cadastro de Grupo de empresa x Filial
Doc. Origem..............: 
Solicitante..............: Cliente
Uso......................: Marfrig
Obs......................: 
=========================================================================================================
*/

User Function MGFGFE31()

	Local oMBrowse := nil
	Local aAux := {}
	oMBrowse:= FWmBrowse():New()

	oMBrowse:SetAlias("ZE4")
	oMBrowse:SetDescription("Filial x Grupo")
	oMBrowse:Setmenudef("MGFGFE31")
	
	oMBrowse:Activate()
	
Return

**********************************************************
Static Function MenuDef()
	
	Local	aRotina	:= {}
	
	ADD OPTION aRotina TITLE "Pesquisar"  	  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.MGFGFE31" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	  ACTION "VIEWDEF.MGFGFE31" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    	  ACTION "VIEWDEF.MGFGFE31" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	  ACTION "VIEWDEF.MGFGFE31" OPERATION MODEL_OPERATION_DELETE ACCESS 0
	
Return aRotina
**********************************************************
Static Function ModelDef()

Local oStruZE4 := FWFormStruct( 1, 'ZE4', /*bAvalCampo*/,/*lViewUsado*/ )
Local oModel

oModel := MPFormModel():New('XMGFGFE31', /*bPreValidacao*/,  , /*bCommit*/, /*bCancel*/ )

oModel:AddFields( 'ZE4MASTER', /*cOwner*/, oStruZE4, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

oModel:SetDescription( 'Filial x Grupo' )

oModel:SetPrimaryKey({"ZE4_FILIAL","ZE4_FIL", "ZE4_GRUPO"})

//oStruZD3:setValue('ZD3MASTER','ZD3_EXPRES', xcExpressao)

oModel:GetModel( 'ZE4MASTER' ):SetDescription( 'Filial x Grupo' )

Return oModel

**********************************************************
Static Function ViewDef()

Local oModel   := FWLoadModel( 'MGFGFE31' )
Local oStruZD3 := FWFormStruct( 2, 'ZE4' )
Local oView
Local cCampos := {}

oView := FWFormView():New()

oView:SetModel( oModel )

oView:AddField( 'VIEW_ZE4', oStruZD3, 'ZE4MASTER' )

oView:CreateHorizontalBox( 'TELA' , 100 )

oView:SetOwnerView( 'VIEW_ZE4', 'TELA' )

Return oView

