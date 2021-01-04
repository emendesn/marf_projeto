#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*/
=============================================================================
{Protheus.doc} MGFINT69
Cadastro de Sistemas de Origem
@description
Cadastro de Sistemas de Origem
@author TOTVS
@since 15/10/2019
@type Function
@table
ZF5 - Sistema de Origem
@return
Sem retorno
@menu
Sem menu
/*/
user function MGFINT69()
	local oBrowse

    //Cria um Browse Simples instanciando o FWMBrowse
	oBrowse := FWMBrowse():New()
	//Define um alias para o Browse
	oBrowse:SetAlias('ZF5')
	//Adiciona uma descrição para o Browse
	oBrowse:SetDescription('Sistemas de Origem')

	//Ativa o Browse
	oBrowse:Activate()

return nil

//-------------------------------------------------------------------
static function MenuDef()
	local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'PesqBrw'			OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MGFINT69'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MGFINT69'	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MGFINT69'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MGFINT69'	OPERATION 5 ACCESS 0

return aRotina

//-------------------------------------------------------------------
Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	local oStruZF5 := FWFormStruct( 1, 'ZF5', /*bAvalCampo*/,/*lViewUsado*/ )
	local oModel

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('INT67MODEL', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'ZF5MASTER', /*cOwner*/, oStruZF5, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Modelo de Sistemas de Origem' )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'ZF5MASTER' ):SetDescription( 'Sistemas de Origem' )

	oModel:SetPrimaryKey({})

return oModel

//-------------------------------------------------------------------
static function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	local oModel   := FWLoadModel( 'MGFINT69' )
	// Cria a estrutura a ser usada na View
	local oStruZF5 := FWFormStruct( 2, 'ZF5' )
	local oView

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZF5', oStruZF5, 'ZF5MASTER' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'TELA' , 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_ZF5', 'TELA' )
return oView