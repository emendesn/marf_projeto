#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
=========================================================================================================
Programa.................: MGFFIS23
Autor:...................: Flávio Dentello
Data.....................: 24/10/2017
Descrição / Objetivo.....: Cadastro de Grupo
Doc. Origem..............: GAP
Solicitante..............: Cliente
Uso......................: Marfrig
Obs......................: 
=========================================================================================================
*/

User Function MGFFIS23()

	Local oMBrowse := nil
	Local aAux := {}
	Private lGravaincl := .F.
	Private lGravaAlt := .F.

	oMBrowse:= FWmBrowse():New()

	oMBrowse:SetAlias("ZDB")
	oMBrowse:SetDescription("Cadastro de Grupos")

	oMBrowse:AddLegend("ZDB_STATUS=='1'", "GREEN", "Liberado " )
	oMBrowse:AddLegend("ZDB_STATUS=='2'", "RED"  , "Bloqueado" )

	oMBrowse:Activate()

return oMBrowse

Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  	  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	  ACTION "VIEWDEF.MGFFIS23" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    	  ACTION "VIEWDEF.MGFFIS23" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.MGFFIS23" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Bloquear" 	  ACTION "U_MGFBLQG" 	  	OPERATION 7 					 ACCESS 0
	ADD OPTION aRotina TITLE "Desbloquear" 	  ACTION "MGFLIBG" 		  	OPERATION 7 					 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	  ACTION "VIEWDEF.MGFFIS23" OPERATION MODEL_OPERATION_DELETE ACCESS 0

Return aRotina


Static Function ModelDef()

	Local oStruZDB := FWFormStruct( 1, 'ZDB', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel
	Local cHora := TIME()

	oModel := FWModelActive()
	oModel := MPFormModel():New('XMGFFIS23',/*bPreValidacao*/, {|oMdl| MGFEXCL(oMdl)}/*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )


	oModel:AddFields( 'ZDBMASTER', /*cOwner*/, oStruZDB, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	oModel:SetDescription( 'cadastro de Grupos' )

	oModel:SetPrimaryKey({"ZDB_FILIAL"})

	oModel:GetModel( 'ZDBMASTER' ):SetDescription( 'cadastro de Grupos' )

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFFIS23' )

	Local oStruZDB := FWFormStruct( 2, 'ZDB' )

	Local oView
	Local cCampos := {}


	oView := FWFormView():New()

	oView:SetModel( oModel )

	oView:AddField( 'VIEW_ZDB', oStruZDB, 'ZDBMASTER' )

	oView:CreateHorizontalBox( 'TELA' , 100 )

	oView:SetOwnerView( 'VIEW_ZDB', 'TELA' )

Return oView

//// Função que bloqueia o cadastro

User Function MGFBLQG()

	If ZDB->ZDB_STATUS == '1'

		RecLock("ZDB", .F.)
		ZDB->ZDB_STATUS := '2'
		ZDB->(msUnlock())
		MsgInfo('Cadastro bloqueado!')
	Else
		MsgAlert('Cadastro já encontra-se Bloqueado!')
	EndIf

Return


//// Função que Libera o cadastro

Static Function MGFLIBG()

	If ZDB->ZDB_STATUS == '2'

		RecLock("ZDB", .F.)
		ZDB->ZDB_STATUS := '1'
		ZDB->(msUnlock())
		
		MsgInfo('Cadastro Liberado!')
	Else
		MsgAlert('Cadastro já encontra-se Liberado!')
	EndIf

Return


/// valida exclusão
Static Function MGFEXCL(oMdl)
	
	Local lRet := .T.
	//Local oModel := oModelGrid:GetModel()
	//Local oModel	 := FWModelActive()
	Local nOperation := oMdl:GetOperation()

	If nOperation == 5
	
		dBselectArea("ZDC")
		ZDC->(dbSetOrder(1))
		If ZDC->(dbSeek(xFilial("ZDC")+ZDB->ZDB_COD))
			lRet := .F.					
		EndIf
		
		If !lRet
			Help( ,, 'MGFFIS23',, 'Grupo não pode ser excluído, pois está vinculado a um SubGrupo', 1, 0 )
		Else
			dBselectArea("ZDD")
			ZDD->(dbSetOrder(1))
			If ZDD->(dbSeek(xFilial("ZDC")+ZDD->ZDD_COD))
				lRet := .F.					
			EndIf
			
			If !lRet
				Help( ,, 'MGFFIS23-01',, 'Grupo não pode ser excluído, pois está vinculado a uma Familia', 1, 0 )
			EndIf
		EndIf
	EndIf
Return lRet