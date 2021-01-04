#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM04
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              24/03/2017
Descricao / Objetivo:   Motivo x Justificativa RAMI
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
user function MGFCRM04()
	local oBrowse

    //Cria um Browse Simples instanciando o FWMBrowse
	oBrowse := FWMBrowse():New()
	//Define um alias para o Browse
	oBrowse:SetAlias('ZAU')
	//Adiciona uma descrição para o Browse
	oBrowse:SetDescription('Motivo x Justificativa RAMI')

	/*Define legenda para o Browse de acordo com uma variavel
	   Obs: Para visuzalir as legenda em MVC basta dar duplo clique no marcador de legenda*/
	//oBrowse:AddLegend( "ZA0_TIPO=='1'", "YELLOW", "Autor"  )
	//oBrowse:AddLegend( "ZA0_TIPO=='2'", "BLUE"  , "Interprete"  )      
	//Ativa o Browse
	oBrowse:Activate()

return nil

//-------------------------------------------------------------------
static function MenuDef()
	local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'PesqBrw'			OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MGFCRM04'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MGFCRM04'	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MGFCRM04'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MGFCRM04'	OPERATION 5 ACCESS 0

return aRotina

//-------------------------------------------------------------------
Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZAU := FWFormStruct( 1, 'ZAU', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel
	                         
	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('MGF12MODEL', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
	
	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'ZAUMASTER', /*cOwner*/, oStruZAU, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Motivo x Justificativa RAMI' )
	
	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'ZAUMASTER' ):SetDescription( 'Dados de Motivo x Justificativa RAMI' )

	oModel:SetPrimaryKey({})
	
Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFCRM04' )
	// Cria a estrutura a ser usada na View
	Local oStruZAU := FWFormStruct( 2, 'ZAU', {| cCampo | ! allTrim( cCampo ) $ "ZAU_FILIAL" } )
	Local oView  

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZAU', oStruZAU, 'ZAUMASTER' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'TELA' , 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_ZAU', 'TELA' )
Return oView
