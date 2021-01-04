#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
=========================================================================================================
Programa.................: MGFFIS29
Autor:...................: Flavio Dentello
Data.....................: 24/10/2017
Descricao / Objetivo.....: Cadastro de Tipo de Carcaca
Doc. Origem..............: GAP
Solicitante..............: Cliente
Uso......................: 
Obs......................: 
=========================================================================================================
*/

User Function MGFFIS29()

	Local oMBrowse := nil
	Local aAux := {}
	Private lGravaincl := .F.
	Private lGravaAlt := .F.

	oMBrowse:= FWmBrowse():New()

	oMBrowse:SetAlias("ZDG")
	oMBrowse:SetDescription("Cadastro tipo de Carcaca")

	oMBrowse:AddLegend("ZDG_STATUS=='1'", "GREEN", "Liberado " )
	oMBrowse:AddLegend("ZDG_STATUS=='2'", "RED"  , "Bloqueado" )

	oMBrowse:Activate()

return oMBrowse

Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  	  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	  ACTION "VIEWDEF.MGFFIS29" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    	  ACTION "VIEWDEF.MGFFIS29" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.MGFFIS29" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Bloquear" 	  ACTION "MGFBLQF"	 	  	OPERATION 7 					 ACCESS 0
	ADD OPTION aRotina TITLE "Desbloquear" 	  ACTION "MGFLIBF" 		  	OPERATION 7 					 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	  ACTION "VIEWDEF.MGFFIS29" OPERATION MODEL_OPERATION_DELETE ACCESS 0

Return aRotina


Static Function ModelDef()

	Local oStruZDG := FWFormStruct( 1, 'ZDG', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel
	Local cHora := TIME()

	oModel := FWModelActive()
	oModel := MPFormModel():New('XMGFFIS29', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )


	oModel:AddFields( 'ZDGMASTER', /*cOwner*/, oStruZDG, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	oModel:SetDescription( 'cadastro tipo de Carcaca' )

	oModel:SetPrimaryKey({"ZDG_FILIAL"})

	oModel:GetModel( 'ZDGMASTER' ):SetDescription( 'cadastro tipo de Carcaca' )

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFFIS29' )

	Local oStruZDG := FWFormStruct( 2, 'ZDG' )

	Local oView
	Local cCampos := {}

	oView := FWFormView():New()

	oView:SetModel( oModel )

	oView:AddField( 'VIEW_ZDG', oStruZDG, 'ZDGMASTER' )

	oView:CreateHorizontalBox( 'TELA' , 100 )

	oView:SetOwnerView( 'VIEW_ZDG', 'TELA' )

Return oView

//// Funcao que bloqueia o cadastro

Static Function MGFBLQF()

	If ZDG->ZDG_STATUS == '1'

		RecLock("ZDG", .F.)
		ZDG->ZDG_STATUS := '2'
		ZDG->(msUnlock())
		MsgInfo('Cadastro bloqueado!')
	Else
		MsgAlert('Cadastro j� encontra-se Bloqueado!')
	EndIf

Return


//// Funcao que Libera o cadastro

Static Function MGFLIBF()

	If ZDG->ZDG_STATUS == '2'

		RecLock("ZDG", .F.)
		ZDG->ZDG_STATUS := '1'
		ZDG->(msUnlock())
		
		MsgInfo('Cadastro Liberado!')
	Else
		MsgAlert('Cadastro j� encontra-se Liberado!')
	EndIf

Return
