#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
=====================================================================================
Programa............: MGFOMS05()
Autor...............: Flávio Dentello
Data................: 13/04/2017
Descricao / Objetivo: Rotina de inclusão de mensagem nos pedidos à partir da carga
Doc. Origem.........: GAP - FIS29
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/

User Function MGFOMS05(cUnidade, cCarga)
Local oBrowse
Local aRotold := aRotina
Local cAliasDAI  := "DAI"
Local cxAlias	 := 'SC5'
Local cFilDAI    := ""
Local cCarDAI    := ""
Local cFilSC5	 := ""
Local cPedSC5	 := ""


Default cUnidade := DAK->DAK_FILIAL
Default cCarga	 := DAK->DAK_COD

If DAK->DAK_FEZNF == '2'
	
	DAI->(DBGoTop())
	DAI->(DBSetOrder(1))
	DAI->(DBSeek( xFilial("DAI") + DAK->DAK_COD ) )
	cDAKCod := DAI->DAI_COD
	cFilSC5 := ""
	cFilDAI := DAI->DAI_FILIAL
	while !DAI->(EOF()) .and. cDAKCod == DAI->DAI_COD .and. cFilDAI == DAI->DAI_FILIAL
		
		cFilSC5 += "C5_NUM == '" + DAI->DAI_PEDIDO + "'"
		
		DAI->(DBSkip())
		
		if !DAI->(EOF()) .and. cDAKCod == DAI->DAI_COD .and. cFilDAI == DAI->DAI_FILIAL
			cFilSC5 += " .or. "
		endif
	enddo
	
	
	aRotina := {}
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('SC5')
	oBrowse:SetDescription('Pedidos da Carga')
	oBrowse:SetMenuDef("MGFOMS05")
	
	oBrowse:SetFilterDefault(cFilSC5)
	
	
	oBrowse:Activate()
	aRotina := aRotold
Else
	MsgAlert("Apenas é possível incluir mensagens para cargas não faturadas.")
EndIf
Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MGFOMS05' OPERATION 2 ACCESS 0
//ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MGFOMS05' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MGFOMS05' OPERATION 4 ACCESS 0
//ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MGFOMS05' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.MGFOMS05' OPERATION 8 ACCESS 0
//ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.MGFOMS05' OPERATION 9 ACCESS 0
Return aRotina


//-------------------------------------------------------------------
Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados
Local oStruSC5 := FWFormStruct( 1, 'SC5', /*bAvalCampo*/,/*lViewUsado*/ )
Local oModel


// Cria o objeto do Modelo de Dados
oModel := MPFormModel():New('COMP011M', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
//oModel := MPFormModel():New('COMP011MODEL', /*bPreValidacao*/, { |oMdl| COMP011POS( oMdl ) }, /*bCommit*/, /*bCancel*/ )

// Adiciona ao modelo uma estrutura de formulário de edição por campo
oModel:AddFields( 'SC5MASTER', /*cOwner*/, oStruSC5, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
oStruSC5:SetProperty( '*' , MODEL_FIELD_WHEN,{||.F.})
oStruSC5:SetProperty( 'C5_XMSGFT' , MODEL_FIELD_WHEN,{||.T.})

// Adiciona a descricao do Modelo de Dados
oModel:SetDescription( 'Pedidos da carga' )

// Adiciona a descricao do Componente do Modelo de Dados
oModel:GetModel( 'SC5MASTER' ):SetDescription( 'Pedidos da Carga' )

// Liga a validação da ativacao do Modelo de Dados
//oModel:SetVldActivate( { |oModel| COMP011ACT( oModel ) } )

Return oModel


//-------------------------------------------------------------------
Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
Local oModel   := FWLoadModel( 'MGFOMS05' )
// Cria a estrutura a ser usada na View
Local oStruSC5 := FWFormStruct( 2, 'SC5' )
//Local oStruZA0 := FWFormStruct( 2, 'ZA0', { |cCampo| COMP11STRU(cCampo) } )
Local oView
Local cCampos := {}

// Cria o objeto de View
oView := FWFormView():New()

// Define qual o Modelo de dados será utilizado
oView:SetModel( oModel )

//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
oView:AddField( 'VIEW_SC5', oStruSC5, 'SC5MASTER' )

// Criar um "box" horizontal para receber algum elemento da view
oView:CreateHorizontalBox( 'TELA' , 100 )

// Relaciona o ID da View com o "box" para exibicao
oView:SetOwnerView( 'VIEW_SC5', 'TELA' )

//oView:SetViewAction( 'BUTTONOK'    , { |o| Help(,,'HELP',,'Ação de Confirmar ' + o:ClassName(),1,0) } )
//oView:SetViewAction( 'BUTTONCANCEL', { |o| Help(,,'HELP',,'Ação de Cancelar '  + o:ClassName(),1,0) } )
Return oView

