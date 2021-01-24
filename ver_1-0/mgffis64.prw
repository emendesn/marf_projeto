#Include "TOTVS.CH"
#Include "PROTHEUS.CH"
#Include "FWMVCDEF.CH"
#Include "TOPCONN.CH"

#DEFINE CRLF Chr(13) + Chr(10)

/*/
{Protheus.doc} MGFFIS64
Função responsável manter a tabela ZH8
@type  User Function
@author Jairo O Junior
@since 23/09/2020
@version P12 12.1.17
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
@table ZH8
@history
@obs TASK - RTASK0011379 - Projeto Fiscal - CAT83
@menu Livros Fiscais-Atualizações-Especificos-Mantem Movto xTract
/*/
User Function MGFFIS64()
Local oBrowse

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('ZH8')
oBrowse:SetDescription('Manutenção Registros importados XTract')
oBrowse:Activate()
Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE '&Visualizar' ACTION 'VIEWDEF.MGFFIS64' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE '&Incluir'    ACTION 'VIEWDEF.MGFFIS64' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE '&Alterar'    ACTION 'VIEWDEF.MGFFIS64' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE '&Excluir'    ACTION 'VIEWDEF.MGFFIS64' OPERATION 5 ACCESS 0
Return aRotina

//-------------------------------------------------------------------
Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados
Local oStruZH8 := FWFormStruct( 1, 'ZH8', /*bAvalCampo*/,/*lViewUsado*/ )
Local oModel

// Cria o objeto do Modelo de Dados
oModel := FWModelActive()
oModel := MPFormModel():New('XMGFFIS64', /*bPreValidacao*/, /*{ |oModel| FISBIPOS( oModel )}pos valid*/, /*bCommit*/, /*bCancel*/ )

// Adiciona ao modelo uma estrutura de formulário de edição por campo
oModel:AddFields( 'ZH8MASTER', /*cOwner*/, oStruZH8,  /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

// Adiciona a descricao do Modelo de Dados
oModel:SetDescription( 'xTract' )
oModel:SetPrimaryKey({})

// Adiciona a descricao do Componente do Modelo de Dados
oModel:GetModel( 'ZH8MASTER' ):SetDescription( 'Registros xTract' )

Return oModel


//-------------------------------------------------------------------
Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
Local oModel   := FWLoadModel('MGFFIS64')
// Cria a estrutura a ser usada na View
Local oStruZH8 := FWFormStruct( 2, 'ZH8' )
Local oView
Local cCampos := {}

// Cria o objeto de View
oView := FWFormView():New()

// Define qual o Modelo de dados será utilizado
oView:SetModel( oModel )

//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
oView:AddField('VIEW_ZH8', oStruZH8, 'ZH8MASTER')

// Criar um "box" horizontal para receber algum elemento da view
oView:CreateHorizontalBox( 'TELA' , 100 )

// Relaciona o ID da View com o "box" para exibicao
oView:SetOwnerView( 'VIEW_ZH8', 'TELA' )

Return oView
