#include 'totvs.ch'
#include 'protheus.ch'
#include 'topconn.ch'
#include 'fwmvcdef.ch'

/*
=====================================================================================
Programa.:              MGFINT33
Autor....:              Leonardo Hideaki Kume
Data.....:              06/02/2016
Descricao / Objetivo:   Tela de cadastro de Categoria
Doc. Origem:            GAP
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MGFINT33()
	local oBrowse       

    //Cria um Browse Simples instanciando o FWMBrowse
	oBrowse := FWMBrowse():New()
	//Define um alias para o Browse
	oBrowse:SetAlias('ZA4')
	//Adiciona uma descriÃ§Ã£o para o Browse
	oBrowse:SetDescription('Cadastro de Categoria de Venda')
	//Ativa o Browse
	oBrowse:Activate()

return nil

//-------------------------------------------------------------------
static function MenuDef()
	local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'PesqBrw'			OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MGFINT33'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MGFINT33'	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MGFINT33'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MGFINT33'	OPERATION 5 ACCESS 0

return aRotina

//-------------------------------------------------------------------
Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZA4 := FWFormStruct( 1, 'ZA4', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel
	                         
	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('INT29MDL', /*bPreValidacao*/, /*bPosValidacao*/, { |oModel| cmtZA4(oModel) }/*bCommit*/, /*bCancel*/ )
	
	// Adiciona ao modelo uma estrutura de formulÃ¡rio de ediÃ§Ã£o por campo
	oModel:AddFields( 'ZA4MASTER', /*cOwner*/, oStruZA4, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Cadastro de Categoria de Venda' )
	
	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'ZA4MASTER' ):SetDescription( 'Cadastro de Categoria de Venda' )

	oModel:SetPrimaryKey({})
	
Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFINT33' )
	// Cria a estrutura a ser usada na View
	Local oStruZA4 := FWFormStruct( 2, 'ZA4' )
	Local oView  

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados serÃ¡ utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZA4', oStruZA4, 'ZA4MASTER' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'TELA' , 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_ZA4', 'TELA' )
Return oView

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
static function cmtZA4(oModel)
	local lRetCommit	:= .T.
	local oMdlZA4		:= oModel:GetModel('ZA4MASTER')
	local cTime			:= time()
	local dDate			:= dDataBase

	if oMdlZA4:getOperation() <> 5
		//oModel:SetValue( 'ZA4MASTER', 'ZA4_XINTEG', 'P' )
	endif

	fwFormCommit(oModel)

return lRetCommit