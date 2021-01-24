#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
=========================================================================================================
Programa.................: MGFFIS26
Autor:...................: Flávio Dentello
Data.....................: 24/10/2017
Descrição / Objetivo.....: Cadastro Gerencial
Doc. Origem..............: GAP
Solicitante..............: Cliente
Uso......................: Marfrig
Obs......................: 
=========================================================================================================
*/

User Function MGFFIS26()

	Local oMBrowse := nil
	Local aAux := {}
	Private lGravaincl := .F.
	Private lGravaAlt := .F.

	oMBrowse:= FWmBrowse():New()

	oMBrowse:SetAlias("ZDE")
	oMBrowse:SetDescription("Cadastro Gerencial")

	oMBrowse:AddLegend("ZDE_STATUS=='1'", "GREEN", "Liberado " )
	oMBrowse:AddLegend("ZDE_STATUS=='2'", "RED"  , "Bloqueado" )

	oMBrowse:Activate()

return oMBrowse

Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  	  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	  ACTION "VIEWDEF.MGFFIS26" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    	  ACTION "VIEWDEF.MGFFIS26" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.MGFFIS26" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Bloquear" 	  ACTION "MGFBLQG" 		  	OPERATION 7 					 ACCESS 0
	ADD OPTION aRotina TITLE "Desbloquear" 	  ACTION "MGFLIBG" 		  	OPERATION 7 					 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	  ACTION "VIEWDEF.MGFFIS26" OPERATION MODEL_OPERATION_DELETE ACCESS 0

Return aRotina


Static Function ModelDef()

	Local oStruZDE := FWFormStruct( 1, 'ZDE', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel
	Local cHora := TIME()

	oModel := FWFModelActive()
	oModel := MPFormModel():New('XMGFFIS26',/*bPreValidacao*/ ,{|oMdl|ValidExcl(oMdl)} /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )


	oModel:AddFields( 'ZDEMASTER', /*cOwner*/, oStruZDE, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	oModel:SetDescription( 'Cadastro Gerencial' )

	oModel:SetPrimaryKey({"ZDE_FILIAL"})

	oModel:GetModel( 'ZDEMASTER' ):SetDescription( 'Cadastro Gerencial' )
	

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFFIS26' )

	Local oStruZDE := FWFormStruct( 2, 'ZDE' )

	Local oView
	Local cCampos := {}


	oView := FWFormView():New()

	oView:SetModel( oModel )

	oView:AddField( 'VIEW_ZDE', oStruZDE, 'ZDEMASTER' )

	oView:CreateHorizontalBox( 'TELA' , 100 )

	oView:SetOwnerView( 'VIEW_ZDE', 'TELA' )

Return oView

//// Função que bloqueia o cadastro

Static Function MGFBLQG()

	If ZDE->ZDE_STATUS == '1'

		RecLock("ZDE", .F.)
		ZDE->ZDE_STATUS := '2'
		ZDE->(msUnlock())
		MsgInfo('Cadastro bloqueado!')
	Else
		MsgAlert('Cadastro já encontra-se Bloqueado!')
	EndIf

Return


//// Função que Libera o cadastro

Static Function MGFLIBG()

	If ZDE->ZDE_STATUS == '2'

		RecLock("ZDE", .F.)
		ZDE->ZDE_STATUS := '1'
		ZDE->(msUnlock())
		
		MsgInfo('Cadastro Liberado!')
	Else
		MsgAlert('Cadastro já encontra-se Liberado!')
	EndIf

Return


/*===============================================
Valida exclusão do cadastro gerencial
================================================*/
Static Function ValidExcl(oModel)
Local nOperation := oModel:GetOperation()
Local lRet := .T.
Local cAliasTMP1 := GetNextAlias()
Local cQuery := ""

If nOperation == MODEL_OPERATION_DELETE
	cQuery += "SELECT B1_COD FROM " + RetSQLName('SB1') + " SB1 WHERE SB1.B1_ZGERENC = '" + ZDE->ZDE_COD + "'"
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