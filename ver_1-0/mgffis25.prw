#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
=========================================================================================================
Programa.................: MGFFIS25
Autor:...................: Flavio Dentello
Data.....................: 24/10/2017
Descricao / Objetivo.....: Cadastro de Familia
Doc. Origem..............: GAP
Solicitante..............: Cliente
Uso......................: 
Obs......................: 
=========================================================================================================
*/

User Function MGFFIS25()

	Local oMBrowse := nil
	Local aAux := {}
	Private lGravaincl := .F.
	Private lGravaAlt := .F.

	oMBrowse:= FWmBrowse():New()

	oMBrowse:SetAlias("ZDD")
	oMBrowse:SetDescription("Cadastro de Familia")

	oMBrowse:AddLegend("ZDD_STATUS=='1'", "GREEN", "Liberado " )
	oMBrowse:AddLegend("ZDD_STATUS=='2'", "RED"  , "Bloqueado" )

	oMBrowse:Activate()

return oMBrowse

Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  	  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	  ACTION "VIEWDEF.MGFFIS25" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    	  ACTION "VIEWDEF.MGFFIS25" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.MGFFIS25" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Bloquear" 	  ACTION "U_MGFBLQF" 	  	OPERATION 7 					 ACCESS 0
	ADD OPTION aRotina TITLE "Desbloquear" 	  ACTION "MGFLIBF"	 	  	OPERATION 7 					 ACCESS 0
	//ADD OPTION aRotina TITLE "Excluir"    	  ACTION "VIEWDEF.MGFFIS25" OPERATION MODEL_OPERATION_DELETE ACCESS 0

Return aRotina


Static Function ModelDef()

	Local oStruZDD := FWFormStruct( 1, 'ZDD', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel
	Local cHora := TIME()

	oModel := FWModelActive()
	oModel := MPFormModel():New('XMGFFIS25', /*bPreValidacao*/, {|oMdl|ValidAlt(oMdl)}/*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )


	oModel:AddFields( 'ZDDMASTER', /*cOwner*/, oStruZDD, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	oModel:SetDescription( 'cadastro de Familia' )

	oModel:SetPrimaryKey({"ZDD_FILIAL"})

	oModel:GetModel( 'ZDDMASTER' ):SetDescription( 'Cadastro de Familia' )

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFFIS25' )

	Local oStruZDD := FWFormStruct( 2, 'ZDD' )

	Local oView
	Local cCampos := {}


	oStruZDD:AddGroup( 'GRP01', '                                ', '', 1 )
	oStruZDD:AddGroup( 'GRP02', 'Relacionar um SubGrupo a Familia', '', 2 )
	oStruZDD:AddGroup( 'GRP03', 'Relacionar um Grupo a Familia '  , '', 3 )

	oStruZDD:SetProperty( 'ZDD_COD'   , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZDD:SetProperty( 'ZDD_DESCR' , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
		
	oStruZDD:SetProperty( 'ZDD_CODSUB' , MVC_VIEW_GROUP_NUMBER, 'GRP02' )
	oStruZDD:SetProperty( 'ZDD_SUBGRP' , MVC_VIEW_GROUP_NUMBER, 'GRP02' )
	
	oStruZDD:SetProperty( 'ZDD_CODGRP' , MVC_VIEW_GROUP_NUMBER, 'GRP03' )
	oStruZDD:SetProperty( 'ZDD_DESGRP' , MVC_VIEW_GROUP_NUMBER, 'GRP03' )	

	oView := FWFormView():New()

	oView:SetModel( oModel )

	oView:AddField( 'VIEW_ZDD', oStruZDD, 'ZDDMASTER' )

	oView:CreateHorizontalBox( 'TELA' , 100 )

	oView:SetOwnerView( 'VIEW_ZDD', 'TELA' )

Return oView

//// Funcao que bloqueia o cadastro

User Function MGFBLQF()

	If ZDD->ZDD_STATUS == '1'

		RecLock("ZDD", .F.)
		ZDD->ZDD_STATUS := '2'
		ZDD->(msUnlock())
		MsgInfo('Cadastro bloqueado!')
	Else
		MsgAlert('Cadastro j� encontra-se Bloqueado!')
	EndIf

Return


//// Funcao que Libera o cadastro

Static Function MGFLIBF()

	If ZDD->ZDD_STATUS == '2'

		RecLock("ZDD", .F.)
		ZDD->ZDD_STATUS := '1'
		ZDD->(msUnlock())
		
		MsgInfo('Cadastro Liberado!')
	Else
		MsgAlert('Cadastro j� encontra-se Liberado!')
	EndIf

Return


/*===============================================
Valida alteracao do cadastro.
================================================*/
Static Function ValidAlt(oModel)
Local nOperation := oModel:GetOperation()
Local lRet := .T.
Local cAliasTMP1 := GetNextAlias()
Local cQuery := ""

If nOperation == MODEL_OPERATION_UPDATE
	cQuery += "SELECT B1_COD FROM " + RetSQLName('SB1') + " SB1 WHERE SB1.B1_ZFAMILI = '" + ZDD->ZDD_COD + "'"
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), (cAliasTMP1), .F., .T.)
	DBSelectArea(cAliasTMP1)
	If !EOF()
		lRet := .F.
		Help( ,, 'MGFFIS25',, 'O Registro j� foi relacionado a um Produto. O mesmo nao podera ser alterado', 1, 0 )
	EndIf
	DBCloseArea()
EndIf

return lRet
