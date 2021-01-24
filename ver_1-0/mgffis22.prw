#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
=========================================================================================================
Programa.................: MGFFIS22
Autor:...................: Flávio Dentello
Data.....................: 24/10/2017
Descrição / Objetivo.....: Cadastro de Origem
Doc. Origem..............: GAP 
Solicitante..............: Cliente
Uso......................: Marfrig
Obs......................: 
=========================================================================================================
*/

User Function MGFFIS22()

	Local oMBrowse := nil
	Local aAux := {}
	Private lGravaincl := .F.
	Private lGravaAlt := .F.

	oMBrowse:= FWmBrowse():New()

	oMBrowse:SetAlias("ZDA")
	oMBrowse:SetDescription("Cadastro de Origem")

	oMBrowse:AddLegend("ZDA_STATUS=='1'", "GREEN", "Liberado " )
	oMBrowse:AddLegend("ZDA_STATUS=='2'", "RED"  , "Bloqueado" )

	oMBrowse:Activate()

return oMBrowse

Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  	  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	  ACTION "VIEWDEF.MGFFIS22" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    	  ACTION "VIEWDEF.MGFFIS22" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.MGFFIS22" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Bloquear" 	  ACTION "U_MGFXBLQ" 	  	OPERATION 7 					 ACCESS 0
	ADD OPTION aRotina TITLE "Desbloquear" 	  ACTION "U_MGFXLIB" 	  	OPERATION 7 					 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	  ACTION "VIEWDEF.MGFFIS22" OPERATION MODEL_OPERATION_DELETE ACCESS 0

Return aRotina


Static Function ModelDef()

	Local oStruZDA := FWFormStruct( 1, 'ZDA', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel
	Local cHora := TIME()

	oModel := FWModelActive()
	oModel := MPFormModel():New('XMGFFIS22', /*bPreValidacao*/, {|oMdl|ValidExcl(oMdl)} /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )


	oModel:AddFields( 'ZDAMASTER', /*cOwner*/, oStruZDA, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	oModel:SetDescription( 'cadastro de Origem' )

	oModel:SetPrimaryKey({"ZDA_FILIAL"})

	oModel:GetModel( 'ZDAMASTER' ):SetDescription( 'cadastro de Origem' )

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFFIS22' )

	Local oStruZDA := FWFormStruct( 2, 'ZDA' )

	Local oView
	Local cCampos := {}


	oView := FWFormView():New()

	oView:SetModel( oModel )

	oView:AddField( 'VIEW_ZDA', oStruZDA, 'ZDAMASTER' )

	oView:CreateHorizontalBox( 'TELA' , 100 )

	oView:SetOwnerView( 'VIEW_ZDA', 'TELA' )

Return oView

//// Função que bloqueia o cadastro

User Function MGFXBLQ()

	If ZDA->ZDA_STATUS == '1'

		RecLock("ZDA", .F.)
		ZDA->ZDA_STATUS := '2'
		ZDA->(msUnlock())
		MsgInfo('Cadastro bloqueado!')
	Else
		MsgAlert('Cadastro já encontra-se Bloqueado!')
	EndIf

Return


//// Função que Libera o cadastro

User Function MGFXLIB()

	If ZDA->ZDA_STATUS == '2'

		RecLock("ZDA", .F.)
		ZDA->ZDA_STATUS := '1'
		ZDA->(msUnlock())

		MsgInfo('Cadastro Liberado!')
	Else
		MsgAlert('Cadastro já encontra-se Liberado!')
	EndIf

Return

/*===============================================
Valida exclusão do cadastro
================================================*/
Static Function ValidExcl(oModel)
Local nOperation := oModel:GetOperation()
Local lRet := .T.
Local cAliasTMP1 := GetNextAlias()
Local cQuery := ""

If nOperation == MODEL_OPERATION_DELETE
	cQuery += "SELECT B1_COD FROM " + RetSQLName('SB1') + " SB1 WHERE SB1.B1_ZORIGEM = '" + ZDA->ZDA_COD + "'"
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), (cAliasTMP1), .F., .T.)
	DBSelectArea(cAliasTMP1)
	If !EOF()
		lRet := .F.
		Help( ,, 'Validação de Registro',, 'O Registro já foi relacionado a um Produto.', 1, 0 )
	EndIf
	DBCloseArea()
EndIf

return lRet
