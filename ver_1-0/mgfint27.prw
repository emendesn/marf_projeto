#include 'totvs.ch'
#include 'protheus.ch'
#include 'topconn.ch'
#include 'fwmvcdef.ch'

/*
=====================================================================================
Programa.:              MGFINT27
Autor....:              Gustavo Ananias Afonso
Data.....:              16/12/2016
Descricao / Objetivo:   Tela de cadastro de Conservação
Doc. Origem:            GAP
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MGFINT27()
	local oBrowse       

    //Cria um Browse Simples instanciando o FWMBrowse
	oBrowse := FWMBrowse():New()
	//Define um alias para o Browse
	oBrowse:SetAlias('ZZW')
	//Adiciona uma descriÃ§Ã£o para o Browse
	oBrowse:SetDescription('Cadastro de Conserva��o')
	//Ativa o Browse
	oBrowse:Activate()

return nil

//-------------------------------------------------------------------
static function MenuDef()
	local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'PesqBrw'				OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MGFINT27'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MGFINT27'	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MGFINT27'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MGFINT27'	OPERATION 5 ACCESS 0

return aRotina

//-------------------------------------------------------------------
Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZZW := FWFormStruct( 1, 'ZZW', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel
	                         
	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('INT27MDL', /*bPreValidacao*/, /*bPosValidacao*/, { |oModel| cmtZZW(oModel) }/*bCommit*/, /*bCancel*/ )
	
	// Adiciona ao modelo uma estrutura de formulÃ¡rio de ediÃ§Ã£o por campo
	oModel:AddFields( 'ZZWMASTER', /*cOwner*/, oStruZZW, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Cadastro de Conserva��o' )
	
	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'ZZWMASTER' ):SetDescription( 'Cadastro de Conserva��o' )

	oModel:SetPrimaryKey({})
	
Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFINT27' )
	// Cria a estrutura a ser usada na View
	Local oStruZZW := FWFormStruct( 2, 'ZZW' )
	Local oView  

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados serÃ¡ utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZZW', oStruZZW, 'ZZWMASTER' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'TELA' , 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_ZZW', 'TELA' )
Return oView

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
static function cmtZZW(oModel)
	local lRetCommit	:= .T.
	local oMdlZZW		:= oModel:GetModel('ZZWMASTER')
	local cTime			:= time()
	local dDate			:= dDataBase

	if oMdlZZW:getOperation() <> 5
		oModel:SetValue( 'ZZWMASTER', 'ZZW_XINTEG', 'P' )
	endif

	fwFormCommit(oModel)

return lRetCommit