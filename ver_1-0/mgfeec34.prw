#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"


/*/{Protheus.doc} mgfeec34
//TODO Programa gerado para Níveis de Aprovadores
GAP 033
@author leonardo.kume
@since 03/10/2017
@version 6

@type function
/*/
user function mgfeec34()
Local oBrowse

oBrowse := FWmBrowse():New()
oBrowse:SetAlias( 'ZBX' )
oBrowse:SetDescription( 'Nivel de Aprovadores' )
oBrowse:setMenuDef('mgfeec34')
oBrowse:Activate()

Return NIL


//-------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar' 		ACTION 'VIEWDEF.MGFEEC34' 	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    		ACTION 'VIEWDEF.MGFEEC34' 	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    		ACTION 'VIEWDEF.MGFEEC34' 	OPERATION 4 ACCESS 0
//	ADD OPTION aRotina TITLE 'Excluir'    		ACTION 'VIEWDEF.MGFEEC34' 	OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Copiar'			ACTION 'VIEWDEF.MGFEEC34'	OPERATION 9 ACCESS 0
	
Return aRotina


//-------------------------------------------------------------------
Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados
Local oStruZBX := FWFormStruct( 1, 'ZBX', /*bAvalCampo*/, /*lViewUsado*/ )
Local oStruZBY := FWFormStruct( 1, 'ZBY', /*bAvalCampo*/, /*lViewUsado*/ )
Local oModel


// Cria o objeto do Modelo de Dados
oModel := MPFormModel():New( 'EEC34', /*bPreValidacao*/,/*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
//oModel := MPFormModel():New( 'COMP021M', /*bPreValidacao*/, { | oMdl | COMP021POS( oMdl ) } , /*bCommit*/, /*bCancel*/ )

// Adiciona ao modelo uma estrutura de formulário de edição por campo
oModel:AddFields( 'ZBXMASTER', /*cOwner*/, oStruZBX )

// Adiciona ao modelo uma estrutura de formulário de edição por grid
oModel:AddGrid( 'ZBYDETAIL', 'ZBXMASTER', oStruZBY, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
//oModel:AddGrid( 'ZA2DETAIL', 'ZA1MASTER', oStruZA2, /*bLinePre*/,  { | oMdlG | COMP021LPOS( oMdlG ) } , /*bPreVal*/, /*bPosVal*/ )

// Faz relaciomaneto entre os compomentes do model
oModel:SetRelation( 'ZBYDETAIL', { { 'ZBY_FILIAL', 'xFilial( "ZBY" )' }, { 'ZBY_NIVEL', 'ZBX_NIVEL' } }, ZBY->( IndexKey( 1 ) ) )

// Liga o controle de nao repeticao de linha
oModel:GetModel( 'ZBYDETAIL' ):SetUniqueLine( { 'ZBY_APROVA' } )

// Indica que é opcional ter dados informados na Grid
//oModel:GetModel( 'ZA2DETAIL' ):SetOptional(.T.)
//oModel:GetModel( 'ZA2DETAIL' ):SetOnlyView(.T.)

//Adiciona chave Primária
oModel:SetPrimaryKey({"ZBX_FILIAL","ZBX_NIVEL"})

// Adiciona a descricao do Modelo de Dados
//oModel:SetDescription( 'Distribuicao de Orçamento' )


Return oModel


//-------------------------------------------------------------------
Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
// Cria a estrutura a ser usada na View
Local oModel   := FWLoadModel( 'mgfeec34' )
Local oView

Local oStruZBX 	:= FWFormStruct( 2, 'ZBX' )
Local oStruZBY 	:= FWFormStruct( 2, 'ZBY' )

oStruZBX:SetNoFolder()
oStruZBY:RemoveField("ZBY_NIVEL")
oStruZBY:RemoveField("ZBY_DNIVEL")
// Cria o objeto de View
oView := FWFormView():New()

// Define qual o Modelo de dados será utilizado
oView:SetModel( oModel )

//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
oView:AddField( 'VIEW_ZBX', oStruZBX, 'ZBXMASTER' )

//Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
oView:AddGrid(  'VIEW_ZBY', oStruZBY, 'ZBYDETAIL' )

// Criar um "box" horizontal para receber algum elemento da view
oView:CreateHorizontalBox( 'SUPERIOR', 30 )
oView:CreateHorizontalBox( 'CENTRAL', 70 )

// Relaciona o ID da View com o "box" para exibicao
oView:SetOwnerView( 'VIEW_ZBX', 'SUPERIOR' )
oView:SetOwnerView( 'VIEW_ZBY', 'CENTRAL' )

// Define campos que terao Auto Incremento
//oView:AddIncrementField( 'VIEW_ZA2', 'ZA2_ITEM' )

// Liga a Edição de Campos na FormGrid
//oView:SetViewProperty( 'VIEW_ZA2', "ENABLEDGRIDDETAIL", { 50 } )

Return oView

