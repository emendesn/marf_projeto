#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
=========================================================================================================
Programa.................: MGFGFE15
Autor:...................: Flávio Dentello
Data.....................: 24/10/2017
Descrição / Objetivo.....: Log do cadastro de Taxas
Doc. Origem..............: GAP - GFE93
Solicitante..............: Cliente
Uso......................: Marfrig
Obs......................: 
=========================================================================================================
*/

User Function MGFGFE15()

	Local oMBrowse := nil
	Local aAux := {}
	Private lGravaincl := .F.
	Private lGravaAlt := .F.
	 
	oMBrowse:= FWmBrowse():New()

	oMBrowse:SetAlias("ZBW")
	oMBrowse:SetDescription("Log - Cadastro de Taxas")
	
	oMBrowse:AddLegend("ZBW_OPER=='1'", "GREEN", "Inclusão"  )
	oMBrowse:AddLegend("ZBW_OPER=='2'", "BLUE" , "Alteração" )
	
	oMBrowse:Activate()
	
return oMBrowse

Static Function MenuDef()
	
	Local	aRotina	:= {}
	
	ADD OPTION aRotina TITLE "Pesquisar"  	  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.MGFGFE15" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	
Return aRotina
 

Static Function ModelDef()

Local oStruZBW := FWFormStruct( 1, 'ZBW', /*bAvalCampo*/,/*lViewUsado*/ )
Local oModel
Local cHora := TIME()

oModel := FWModelActive()
oModel := MPFormModel():New('XMGFGFE15', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

	
oModel:AddFields( 'ZBWMASTER', /*cOwner*/, oStruZBW, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

oModel:SetDescription( 'Log cadastro de Taxas' )

oModel:SetPrimaryKey({"ZBW_FILIAL"})

oModel:GetModel( 'ZBWMASTER' ):SetDescription( 'Log cadastro de Taxas' )

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
Local oModel   := FWLoadModel( 'MGFGFE15' )

Local oStruZBV := FWFormStruct( 2, 'ZBW' )

Local oView
Local cCampos := {}

			
oView := FWFormView():New()

oView:SetModel( oModel )

oView:AddField( 'VIEW_ZBW', oStruZBV, 'ZBWMASTER' )

oView:CreateHorizontalBox( 'TELA' , 100 )

oView:SetOwnerView( 'VIEW_ZBW', 'TELA' )

Return oView

