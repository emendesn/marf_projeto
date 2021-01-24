#include 'totvs.ch'
#include 'protheus.ch'
#include 'topconn.ch'
#include 'fwmvcdef.ch'

/*
=====================================================================================
Programa.:              MGFINT30
Autor....:              Gustavo Ananias Afonso
Data.....:              16/12/2016
Descricao / Objetivo:   Tela de cadastro de Tipos de Pedido
Doc. Origem:            GAP
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MGFINT30()
	local oBrowse       

    //Cria um Browse Simples instanciando o FWMBrowse
	oBrowse := FWMBrowse():New()
	//Define um alias para o Browse
	oBrowse:SetAlias('SZJ')
	//Adiciona uma descriÃ§Ã£o para o Browse
	oBrowse:SetDescription('Cadastro de Tipos de Pedido')
	//Ativa o Browse
	oBrowse:Activate()

return nil

//-------------------------------------------------------------------
static function MenuDef()
	local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'PesqBrw'				OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MGFINT30'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MGFINT30'	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MGFINT30'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MGFINT30'	OPERATION 5 ACCESS 0

return aRotina

//-------------------------------------------------------------------
Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruSZJ := FWFormStruct( 1, 'SZJ', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('INT30MDL', /*bPreValidacao*/, /*bPosValidacao*/, { |oModel| cmtSZJ(oModel) }/*bCommit*/, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulÃ¡rio de ediÃ§Ã£o por campo
	oModel:AddFields( 'SZJMASTER', /*cOwner*/, oStruSZJ, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Cadastro de Tipos de Pedido' )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'SZJMASTER' ):SetDescription( 'Cadastro de Tipos de Pedido' )

	oModel:SetPrimaryKey({})

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFINT30' )
	// Cria a estrutura a ser usada na View
	Local oStruSZJ := FWFormStruct( 2, 'SZJ' )
	Local oView  

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados serÃ¡ utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_SZJ', oStruSZJ, 'SZJMASTER' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'TELA' , 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_SZJ', 'TELA' )
Return oView

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
static function cmtSZJ(oModel)
	local lRetCommit	:= .T.
	local oMdlSZJ		:= oModel:GetModel('SZJMASTER')
	local cTime			:= time()
	local dDate			:= dDataBase

	if oMdlSZJ:getOperation() <> 5
		oModel:SetValue( 'SZJMASTER', 'ZJ_XINTEGR', 'P' )
	endif

	fwFormCommit(oModel)

return lRetCommit