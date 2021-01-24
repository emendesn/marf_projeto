#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
=========================================================================================================
Programa.................: MGFGFE18
Autor:...................: Flávio Dentello
Data.....................: 24/10/2017
Descrição / Objetivo.....: Cadastro de Seguro Nacional de carga
Doc. Origem..............: GAP - GFE93
Solicitante..............: Cliente
Uso......................: Marfrig
Obs......................: 
=========================================================================================================
*/

User Function MGFGFE18()

	Local oMBrowse := nil
	Local aAux := {}
	Private lGravaincl := .F.
	Private lGravaAlt := .F.

	oMBrowse:= FWmBrowse():New()

	oMBrowse:SetAlias("ZBV")
	oMBrowse:SetDescription("Averbação - Taxas")

	oMBrowse:AddLegend("ZBV_STATUS=='1'", "GREEN", "Ativo"  )
	oMBrowse:AddLegend("ZBV_STATUS=='2'", "RED"  , "Finalizado")

	oMBrowse:Activate()

return oMBrowse

Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  	  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.MGFGFE18" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	  ACTION "VIEWDEF.MGFGFE18" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    	  ACTION "VIEWDEF.MGFGFE18" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Finalizar"	  ACTION "U_MGFGFEF18" 	  	OPERATION 7 					 ACCESS 0


Return aRotina


Static Function ModelDef()

	Local oStruZBV := FWFormStruct( 1, 'ZBV', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel
	Local cHora := TIME()

	oModel := FWModelActive()
	oModel := MPFormModel():New('XMGFGFE18', /*bPreValidacao*/, {||MGFGFE18V()}/*bPosValidacao*/, {|oModel|xCommAlt(oModel)} /*bCommit*/, /*bCancel*/ )


	oModel:AddFields( 'ZBVMASTER', /*cOwner*/, oStruZBV, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	oStruZBV:setProperty("ZBV_CODUSR",MODEL_FIELD_INIT,{|oModel|U_RetUser(oModel) })
	oStruZBV:setProperty("ZBV_NOMUSR",MODEL_FIELD_INIT,{||cUserName   })
	oStruZBV:setProperty("ZBV_DTHRIN",MODEL_FIELD_INIT,{|oModel|u_RetDados(oModel)})
	oStruZBV:setProperty("ZBV_DTHRAL",MODEL_FIELD_INIT,{|oModel|u_RetDad2(oModel)})

	oModel:SetDescription( 'Averbação - Taxas' )

	oModel:SetPrimaryKey({"ZBV_FILIAL","ZBV_STATUS"})

	oModel:GetModel( 'ZBVMASTER' ):SetDescription( 'Averbação - Taxas' )

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFGFE18' )

	Local oStruZBV := FWFormStruct( 2, 'ZBV' )

	Local oView
	Local cCampos := {}

	oStruZBV:AddGroup( 'GRP01', '        ', '', 1 )
	oStruZBV:AddGroup( 'GRP02', 'Controle', '', 2 )

	//oStruZBV:SetProperty( 'ZBV_FILIAL', MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZBV:SetProperty( 'ZBV_STATUS', MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZBV:SetProperty( 'ZBV_TAXA'  , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZBV:SetProperty( 'ZBV_TAXAIE', MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZBV:SetProperty( 'ZBV_TAXAIM', MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZBV:SetProperty( 'ZBV_TAXAUR', MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZBV:SetProperty( 'ZBV_VALCNT', MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZBV:SetProperty( 'ZBV_IOF'   , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZBV:SetProperty( 'ZBV_DATAIN', MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZBV:SetProperty( 'ZBV_DATAFI', MVC_VIEW_GROUP_NUMBER, 'GRP01' )

	oStruZBV:SetProperty( 'ZBV_CODUSR', MVC_VIEW_GROUP_NUMBER, 'GRP02' )
	oStruZBV:SetProperty( 'ZBV_NOMUSR', MVC_VIEW_GROUP_NUMBER, 'GRP02' )
	oStruZBV:SetProperty( 'ZBV_DTHRIN', MVC_VIEW_GROUP_NUMBER, 'GRP02' )
	oStruZBV:SetProperty( 'ZBV_DTHRAL', MVC_VIEW_GROUP_NUMBER, 'GRP02' )


	oView := FWFormView():New()

	oView:SetModel( oModel )

	oView:AddField( 'VIEW_ZBV', oStruZBV, 'ZBVMASTER' )

	oView:CreateHorizontalBox( 'TELA' , 100 )

	oView:SetOwnerView( 'VIEW_ZBV', 'TELA' )

Return oView

// Retorna o usuário da inclusão

User Function RetUser(oModel)

	Local cUser := ""

	//oModel := FWModelActive() 

	If oModel:GetOperation() == MODEL_OPERATION_INSERT 

		cUser := RetCodUsr() 
	Else

		If oModel:GetOperation() == MODEL_OPERATION_UPDATE

			cUser := RetCodUsr() 

		EndiF
	EndIf
Return cUser

///Retorna dados de controle da inclusão

User Function RetDados(oModel)

	Local cDados := ""

		If oModel:GetOperation() == MODEL_OPERATION_INSERT 

			cDados := CVALTOCHAR(DDATABASE)+ "-" + TIME()

		EndIf	

Return cDados


///Retorna dados de controle da alteração

User Function RetDad2(oModel)

	Local cDados := ""
	
		If oModel:GetOperation() == MODEL_OPERATION_UPDATE 

			cDados := CVALTOCHAR(DDATABASE)+ "-" + TIME()
		EndIf	
	
Return cDados


////Grava a tabela de Log

static Function xCommAlt(oModel)

	Local lRet		:= .T.
	Local oStruZBV	:= oModel:GetModel('ZBVMASTER')


	oStruZBV:LoadValue('ZBV_DTHRAL', CVALTOCHAR(DDATABASE)+ "-" + TIME())

	If oModel:GetOperation() == 4
		If !lGravaAlt
			RecLock("ZBW",.T.)
			ZBW->ZBW_FILIAL := XFILIAL('ZBW')
			ZBW->ZBW_OPER	:= '2'
			ZBW->ZBW_TAXA 	:= oModel:GetModel( 'ZBVMASTER'):GetValue('ZBV_TAXA')
			ZBW->ZBW_TAXAIE	:= oModel:GetModel( 'ZBVMASTER'):GetValue('ZBV_TAXAIE')
			ZBW->ZBW_TAXAIM	:= oModel:GetModel( 'ZBVMASTER'):GetValue('ZBV_TAXAIM')
			ZBW->ZBW_TAXAUR	:= oModel:GetModel( 'ZBVMASTER'):GetValue('ZBV_TAXAUR')
			ZBW->ZBW_VALCNT	:= oModel:GetModel( 'ZBVMASTER'):GetValue('ZBV_VALCNT')
			ZBW->ZBW_IOF	:= oModel:GetModel( 'ZBVMASTER'):GetValue('ZBV_IOF')
			ZBW->ZBW_DATAIN := oModel:GetModel( 'ZBVMASTER'):GetValue('ZBV_DATAIN')
			ZBW->ZBW_DATAFI	:= oModel:GetModel( 'ZBVMASTER'):GetValue('ZBV_DATAFI')
			ZBW->ZBW_CODUSR	:= RetCodUsr()
			ZBW->ZBW_NOMUSR := cUserName
			ZBW->ZBW_DTHRAL := CVALTOCHAR(DDATABASE)+ "-" + TIME()
			//ZBW->ZBW_DTHRAL := "" Somente será gravado na alteração.
			ZBW->(MsUnlock())
			lGravaAlt := .T.
		EndIf	

	Else

		If !lGravaincl
			RecLock("ZBW",.T.)
			ZBW->ZBW_FILIAL := XFILIAL('ZBW')
			ZBW->ZBW_OPER	:= '1'
			ZBW->ZBW_DTHRIN := CVALTOCHAR(DDATABASE) + "-" + TIME()
			ZBW->ZBW_TAXA 	:= oModel:GetModel( 'ZBVMASTER'):GetValue('ZBV_TAXA')
			ZBW->ZBW_TAXAIE	:= oModel:GetModel( 'ZBVMASTER'):GetValue('ZBV_TAXAIE')
			ZBW->ZBW_TAXAIM	:= oModel:GetModel( 'ZBVMASTER'):GetValue('ZBV_TAXAIM')
			ZBW->ZBW_TAXAUR	:= oModel:GetModel( 'ZBVMASTER'):GetValue('ZBV_TAXAUR')
			ZBW->ZBW_VALCNT	:= oModel:GetModel( 'ZBVMASTER'):GetValue('ZBV_VALCNT')
			ZBW->ZBW_IOF	:= oModel:GetModel( 'ZBVMASTER'):GetValue('ZBV_IOF')
			ZBW->ZBW_DATAIN := oModel:GetModel( 'ZBVMASTER'):GetValue('ZBV_DATAIN')
			ZBW->ZBW_DATAFI	:= oModel:GetModel( 'ZBVMASTER'):GetValue('ZBV_DATAFI')
			ZBW->ZBW_CODUSR	:= RetCodUsr()
			ZBW->ZBW_NOMUSR := cUserName
			
			//ZBW->ZBW_DTHRAL := "" Somente será gravado na alteração.
			ZBW->(MsUnlock())
			lGravaincl := .T.
		EndIf
	EndIf




	//Gravação comum do commit
	If oModel:VldData()
		FwFormCommit(oModel)
		oModel:DeActivate()
	Else
		JurShowErro( oModel:GetModel():GetErrormessage() )
		lRet := .F.
		DisarmTransaction()
	EndIf

return lRet

////Função que finaliza o cadastro.

User Function MGFGFEF18()

	Local lRet := .F.

	If ZBV->ZBV_STATUS <> "2"
		lRet := MsgYesno( " Deseja realmente bloquear esse cadastro? ")

		If lRet
			RecLock("ZBV",.F.)
			ZBV_STATUS := "2"
			MsUnLock()

			RecLock("ZBW",.T.)
			ZBW->ZBW_FILIAL := XFILIAL('ZBW')
			ZBW->ZBW_OPER	:= '2'
			ZBW->ZBW_TAXA 	:= ZBV->ZBV_TAXA 
			ZBW->ZBW_TAXAIE	:= ZBV->ZBV_TAXAIE
			ZBW->ZBW_TAXAIM	:= ZBV->ZBV_TAXAIM
			ZBW->ZBW_TAXAUR	:= ZBV->ZBV_TAXAUR
			ZBW->ZBW_VALCNT	:= ZBV->ZBV_VALCNT
			ZBW->ZBW_IOF	:= ZBV->ZBV_IOF
			ZBW->ZBW_DATAIN := ZBV->ZBV_DATAIN
			ZBW->ZBW_DATAFI	:= ZBV->ZBV_DATAFI
			ZBW->ZBW_CODUSR	:= RetCodUsr()
			ZBW->ZBW_NOMUSR := cUserName
			//ZBW->ZBW_DTHRIN := CVALTOCHAR(DDATABASE)+ "-" + TIME()
			ZBW->ZBW_DTHRAL := CVALTOCHAR(DDATABASE)+ "-" + TIME()
			ZBW->(MsUnlock())

		EndIf	
	Else
		MsgInfo( "Cadastro já está Finalizado!!!" )
	EndIf		

Return

/// Função que valida inclusão de regra para mesma filial com o status ativo.

Static Function MGFGFE18V()

	Local lRet := .T.

	oModel := FWModelActive()


	If oModel:GetOperation() <> 4	
		dBselectArea('ZBV')
		If DbSeek(xFilial('ZBV')+"1") 			
			lRet := .F.
			Help(,,'Não Gravado',,'Filial já possui cadastro de Taxas ativo!!!',1,0)	
		EndIf
	EndIf


Return lRet

