#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
=====================================================================================
Programa............: MGFFIS21
Autor...............: Flavio Dentello
Data................: Outubro/2017 
Descricao / Objetivo: Fiscal
Doc. Origem.........: Marfrig
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Log Cadastro de Alíqtuota Efetiva de ICMS
=====================================================================================
*/

User Function MGFFIS21()

	Local oMBrowse := nil
	Local aAux := {}
	Private lGravaincl := .F.
	Private lGravaAlt := .F.

	oMBrowse:= FWmBrowse():New()

	oMBrowse:SetAlias("ZD7")
	oMBrowse:SetDescription("Log Cadastro de Alíquota Efetiva")

	oMBrowse:AddLegend("ZD7_OPER=='1'", "GREEN", "Inclusão"  )
	oMBrowse:AddLegend("ZD7_OPER=='2'", "BLUE" , "Alteração" )
	oMBrowse:AddLegend("ZD7_OPER=='3'", "RED"  , "Exclusão"  )

	oMBrowse:Activate()

return oMBrowse

Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  	  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.MGFFIS21" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	//ADD OPTION aRotina TITLE "Incluir"    	  ACTION "VIEWDEF.MGFFIS20" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	//ADD OPTION aRotina TITLE "Alterar"    	  ACTION "VIEWDEF.MGFFIS20" OPERATION MODEL_OPERATION_UPDATE ACCESS 0

Return aRotina


Static Function ModelDef()

	Local oStruZD7 := FWFormStruct( 1, 'ZD7', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel
	Local cHora := TIME()

	oModel := FWModelActive()
	oModel := MPFormModel():New('XMGFFIS21', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )


	oModel:AddFields( 'ZD7MASTER', /*cOwner*/, oStruZD7, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	oModel:SetDescription( 'Log Cadastro de Alíquota Efetiva' )

	oModel:SetPrimaryKey({"ZD7_FILIAL"})

	oModel:GetModel( 'ZD7MASTER' ):SetDescription( 'Log Cadastro de Alíquota Efetiva' )

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFFIS21' )

	Local oStruZD7 := FWFormStruct( 2, 'ZD7' )

	Local oView
	Local cCampos := {}


	oView := FWFormView():New()

	oView:SetModel( oModel )

	oView:AddField( 'VIEW_ZD7', oStruZD7, 'ZD7MASTER' )

	oView:CreateHorizontalBox( 'TELA' , 100 )

	oView:SetOwnerView( 'VIEW_ZD7', 'TELA' )

Return oView

