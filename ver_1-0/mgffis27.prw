#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
=========================================================================================================
Programa.................: MGFFIS27
Autor:...................: Flavio Dentello
Data.....................: 24/10/2017
Descricao / Objetivo.....: Cadastro de Negocio
Doc. Origem..............: GAP
Solicitante..............: Cliente
Uso......................: 
Obs......................: 
=========================================================================================================
*/

User Function MGFFIS27()

	Local oMBrowse := nil
	Local aAux := {}
	Private lGravaincl := .F.
	Private lGravaAlt := .F.

	oMBrowse:= FWmBrowse():New()

	oMBrowse:SetAlias("ZDF")
	oMBrowse:SetDescription("Cadastro de Negocios")

	oMBrowse:AddLegend("ZDF_STATUS=='1'", "GREEN", "Liberado " )
	oMBrowse:AddLegend("ZDF_STATUS=='2'", "RED"  , "Bloqueado" )

	oMBrowse:Activate()

return oMBrowse

Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  	  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	  ACTION "VIEWDEF.MGFFIS27" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    	  ACTION "VIEWDEF.MGFFIS27" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.MGFFIS27" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Bloquear" 	  ACTION "U_MGFBLQN" 	  	OPERATION 7 					 ACCESS 0
	ADD OPTION aRotina TITLE "Desbloquear" 	  ACTION "U_MGFLIBN" 	  	OPERATION 7 					 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	  ACTION "VIEWDEF.MGFFIS27" OPERATION MODEL_OPERATION_DELETE ACCESS 0

Return aRotina


Static Function ModelDef()

	Local oStruZDF := FWFormStruct( 1, 'ZDF', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel
	Local cHora := TIME()

	oModel := FWModelActive()
	oModel := MPFormModel():New('XMGFFIS27', /*bPreValidacao*/, {|oMdl|ValidExcl(oMdl)}/*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )


	oModel:AddFields( 'ZDFMASTER', /*cOwner*/, oStruZDF, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	oModel:SetDescription( 'cadastro Negocios' )

	oModel:SetPrimaryKey({"ZDF_FILIAL"})

	oModel:GetModel( 'ZDFMASTER' ):SetDescription( 'cadastro de Negocio' )

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFFIS27' )

	Local oStruZDF := FWFormStruct( 2, 'ZDF' )

	Local oView
	Local cCampos := {}

	oView := FWFormView():New()

	oView:SetModel( oModel )

	oView:AddField( 'VIEW_ZDF', oStruZDF, 'ZDFMASTER' )

	oView:CreateHorizontalBox( 'TELA' , 100 )

	oView:SetOwnerView( 'VIEW_ZDF', 'TELA' )

Return oView

//// Funcao que bloqueia o cadastro

User Function MGFBLQN()

	If ZDF->ZDF_STATUS == '1'

		RecLock("ZDF", .F.)
		ZDF->ZDF_STATUS := '2'
		ZDF->(msUnlock())
		MsgInfo('Cadastro bloqueado!')
	Else
		MsgAlert('Cadastro j� encontra-se Bloqueado!')
	EndIf

Return


//// Funcao que Libera o cadastro

User Function MGFLIBN()

	If ZDF->ZDF_STATUS == '2'

		RecLock("ZDF", .F.)
		ZDF->ZDF_STATUS := '1'
		ZDF->(msUnlock())
		
		MsgInfo('Cadastro Liberado!')
	Else
		MsgAlert('Cadastro j� encontra-se Liberado!')
	EndIf

Return

/*===============================================
Valida exclusao do cadastro gerencial
================================================*/
Static Function ValidExcl(oModel)
Local nOperation := oModel:GetOperation()
Local lRet := .T.
Local cAliasTMP1 := GetNextAlias()
Local cQuery := ""

If nOperation == MODEL_OPERATION_DELETE
	cQuery += "SELECT B1_COD FROM " + RetSQLName('SB1') + " SB1 WHERE SB1.B1_ZNEGOC = '" + ZDF->ZDF_COD + "'"
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), (cAliasTMP1), .F., .T.)
	DBSelectArea(cAliasTMP1)
	If !EOF()
		lRet := .F.
		Help( ,, 'MGFFIS27-EXCL',, 'O Registro j� foi relacionado a um Produto.', 1, 0 )
	EndIf
	DBCloseArea()
EndIf

return lRet
