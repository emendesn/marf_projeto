#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
=========================================================================================================
Programa.................: MGFGFE34
Autor:...................: Flávio Dentello
Data.....................: 11/10/2018
Descrição / Objetivo.....: 
Doc. Origem..............: GAP 
Solicitante..............: Cliente
Uso......................: Marfrig
Obs......................: 
=========================================================================================================
*/

User Function MGFGFE34()

	Local oMBrowse := nil
	Local aAux := {}
	Private lGravaincl := .F.
	Private lGravaAlt := .F.
	 
	oMBrowse:= FWmBrowse():New()

	oMBrowse:SetAlias("ZF0")
	oMBrowse:SetDescription('Cadastro de CFOPs para averbação')
		
	oMBrowse:Activate()
	
return oMBrowse

Static Function MenuDef()
	
	Local	aRotina	:= {}
	
	ADD OPTION aRotina TITLE "Pesquisar"  	  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.MGFGFE34" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	  ACTION "VIEWDEF.MGFGFE34" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    	  ACTION "VIEWDEF.MGFGFE34" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	  ACTION "VIEWDEF.MGFGFE34" OPERATION MODEL_OPERATION_DELETE ACCESS 0
	
Return aRotina
 

Static Function ModelDef()

Local oStruZF0 := FWFormStruct( 1, 'ZF0', /*bAvalCampo*/,/*lViewUsado*/ )
Local oModel
Local cHora := TIME()

oModel := FWModelActive()
oModel := MPFormModel():New('XMGFGFE34', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

	
oModel:AddFields( 'ZF0MASTER', /*cOwner*/, oStruZF0, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

oModel:SetDescription( 'Cadastro de CFOPs para averbação' )

oModel:SetPrimaryKey({"ZF0_FILIAL"})

oModel:GetModel( 'ZF0MASTER' ):SetDescription( 'Cadastro de CFOPs para averbação' )

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
Local oModel   := FWLoadModel( 'MGFGFE34' )

Local oStruZF0 := FWFormStruct( 2, 'ZF0' )

Local oView
Local cCampos := {}

			
oView := FWFormView():New()

oView:SetModel( oModel )

oView:AddField( 'VIEW_ZF0', oStruZF0, 'ZF0MASTER' )

oView:CreateHorizontalBox( 'TELA' , 100 )

oView:SetOwnerView( 'VIEW_ZF0', 'TELA' )

Return oView

