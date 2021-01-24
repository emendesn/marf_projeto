#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
=========================================================================================================
Programa.................: MGFGFE16
Autor:...................: Flávio Dentello
Data.....................: 24/10/2017
Descrição / Objetivo.....: Cadastro de excessão
Doc. Origem..............: GAP - GFE93
Solicitante..............: Cliente
Uso......................: Marfrig
Obs......................: 
=========================================================================================================
*/

User Function MGFGFE16()

	Local oMBrowse := nil
	Local aAux := {}
	Private lGravaincl := .F.
	Private lGravaAlt := .F.
	 
	oMBrowse:= FWmBrowse():New()

	oMBrowse:SetAlias("ZC3")
	oMBrowse:SetDescription("Cadastro de Excessão")
	
	oMBrowse:Activate()
	
return oMBrowse

Static Function MenuDef()
	
	Local	aRotina	:= {}
	
	ADD OPTION aRotina TITLE "Pesquisar"  	  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.MGFGFE16" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	  ACTION "VIEWDEF.MGFGFE16" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    	  ACTION "VIEWDEF.MGFGFE16" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	  ACTION "VIEWDEF.MGFGFE16" OPERATION MODEL_OPERATION_DELETE ACCESS 0
	
Return aRotina
 

Static Function ModelDef()

Local oStruZC3 := FWFormStruct( 1, 'ZC3', /*bAvalCampo*/,/*lViewUsado*/ )
Local oModel
Local cHora := TIME()

oModel := FWModelActive()
oModel := MPFormModel():New('XMGFGFE16', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

	
oModel:AddFields( 'ZC3MASTER', /*cOwner*/, oStruZC3, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

oModel:SetDescription( 'Cadastro de Excessão por Item' )

oModel:SetPrimaryKey({"ZC3_FILIAL"})

oModel:GetModel( 'ZC3MASTER' ):SetDescription( 'Cadastro de Excessão por Item' )

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
Local oModel   := FWLoadModel( 'MGFGFE16' )

Local oStruZC3 := FWFormStruct( 2, 'ZC3' )

Local oView
Local cCampos := {}

			
oView := FWFormView():New()

oView:SetModel( oModel )

oView:AddField( 'VIEW_ZC3', oStruZC3, 'ZC3MASTER' )

oView:CreateHorizontalBox( 'TELA' , 100 )

oView:SetOwnerView( 'VIEW_ZC3', 'TELA' )

Return oView

