#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
=========================================================================================================
Programa.................: MGFFIS24
Autor:...................: Flavio Dentello
Data.....................: 24/10/2017
Descricao / Objetivo.....: Cadastro de SubGrupo
Doc. Origem..............: GAP
Solicitante..............: Cliente
Uso......................: 
Obs......................: 
=========================================================================================================
*/

User Function MGFFIS24()

	Local oMBrowse := nil
	Local aAux := {}
	Private lGravaincl := .F.
	Private lGravaAlt := .F.

	oMBrowse:= FWmBrowse():New()

	oMBrowse:SetAlias("ZDC")
	oMBrowse:SetDescription("Cadastro de SubGrupo")

	oMBrowse:AddLegend("ZDC_STATUS=='1'", "GREEN", "Liberado " )
	oMBrowse:AddLegend("ZDC_STATUS=='2'", "RED"  , "Bloqueado" )

	oMBrowse:Activate()

return oMBrowse

Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  	  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	  ACTION "VIEWDEF.MGFFIS24" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    	  ACTION "VIEWDEF.MGFFIS24" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.MGFFIS24" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Bloquear" 	  ACTION "MGFBLQG"	 	  	OPERATION 7 					 ACCESS 0
	ADD OPTION aRotina TITLE "Desbloquear" 	  ACTION "MGFLIBG"	 	  	OPERATION 7 					 ACCESS 0
	//ADD OPTION aRotina TITLE "Excluir"    	  ACTION "VIEWDEF.MGFFIS24" OPERATION MODEL_OPERATION_DELETE ACCESS 0

Return aRotina


Static Function ModelDef()

	Local oStruZDC := FWFormStruct( 1, 'ZDC', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel
	Local cHora := TIME()

	oModel := FWModelActive()
	oModel := MPFormModel():New('XMGFFIS24', /*bPreValidacao*/, {|oMdl|ValidAlt(oMdl)} /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )


	oModel:AddFields( 'ZDCMASTER', /*cOwner*/, oStruZDC, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	oModel:SetDescription( 'cadastro de SubGrupo' )

	oModel:SetPrimaryKey({"ZDC_FILIAL"})

	oModel:GetModel( 'ZDCMASTER' ):SetDescription( 'cadastro de SubGrupo' )

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFFIS24' )

	Local oStruZDC := FWFormStruct( 2, 'ZDC' )

	Local oView
	Local cCampos := {}


	oStruZDC:AddGroup( 'GRP01', '                               ', '', 1 )
	oStruZDC:AddGroup( 'GRP02', 'Relacionar um Grupo ao SubGrupo', '', 2 )

	oStruZDC:SetProperty( 'ZDC_COD'   , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZDC:SetProperty( 'ZDC_DESCR' , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
		
	oStruZDC:SetProperty( 'ZDC_CODGRP', MVC_VIEW_GROUP_NUMBER, 'GRP02' )
	oStruZDC:SetProperty( 'ZDC_DESGRP', MVC_VIEW_GROUP_NUMBER, 'GRP02' )
	

	oView := FWFormView():New()

	oView:SetModel( oModel )

	oView:AddField( 'VIEW_ZDC', oStruZDC, 'ZDCMASTER' )

	oView:CreateHorizontalBox( 'TELA' , 100 )

	oView:SetOwnerView( 'VIEW_ZDC', 'TELA' )

Return oView

//// Funcao que bloqueia o cadastro

Static Function MGFBLQG()

	If ZDC->ZDC_STATUS == '1'

		RecLock("ZDC", .F.)
		ZDC->ZDC_STATUS := '2'
		ZDC->(msUnlock())
		MsgInfo('Cadastro bloqueado!')
	Else
		MsgAlert('Cadastro j� encontra-se Bloqueado!')
	EndIf

Return


//// Funcao que Libera o cadastro

Static Function MGFLIBG()

	If ZDC->ZDC_STATUS == '2'

		RecLock("ZDC", .F.)
		ZDC->ZDC_STATUS := '1'
		ZDC->(msUnlock())
		
		MsgInfo('Cadastro Liberado!')
	Else
		MsgAlert('Cadastro j� encontra-se Liberado!')
	EndIf

Return


/*===============================================
Valida alteracao do cadastro
================================================*/
Static Function ValidAlt(oModel)
Local nOperation := oModel:GetOperation()
Local lRet := .T.
Local cAliasTMP1 := GetNextAlias()
Local cQuery := ""

If nOperation == MODEL_OPERATION_UPDATE
	cQuery += "SELECT B1_COD FROM " + RetSQLName('SB1') + " SB1 WHERE SB1.B1_ZSUBGRP = '" + ZDC->ZDC_COD + "'"
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), (cAliasTMP1), .F., .T.)
	DBSelectArea(cAliasTMP1)
	If !EOF()
		lRet := .F.
		Help( ,, 'MGFFIS24-ALT',, 'O Registro j� foi relacionado a um Produto. Nao podera ser alterado', 1, 0)
	EndIf
	DBCloseArea()
EndIf

return lRet