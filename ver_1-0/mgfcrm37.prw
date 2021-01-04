#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM37
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              19/04/2017
Descricao / Objetivo:   Cadastro de Usuarios RAMI
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
user function MGFCRM37()
	local oBrowse

    //Cria um Browse Simples instanciando o FWMBrowse
	oBrowse := FWMBrowse():New()
	//Define um alias para o Browse
	oBrowse:SetAlias('ZBK')
	//Adiciona uma descrição para o Browse
	oBrowse:SetDescription('Cadastro de Usuarios RAMI')      
	//Ativa o Browse
	oBrowse:Activate()

return nil

//-------------------------------------------------------------------
static function MenuDef()
	local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'PesqBrw'			OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MGFCRM37'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MGFCRM37'	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MGFCRM37'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MGFCRM37'	OPERATION 5 ACCESS 0

return aRotina

//-------------------------------------------------------------------
Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZBK := FWFormStruct( 1, 'ZBK', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('CRM37MDL', /*bPreValidacao*/, {| oModel | CRM37POS( oModel ) }/*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'ZBKMASTER', /*cOwner*/, oStruZBK, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Cadastro de Usuarios RAMI' )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'ZBKMASTER' ):SetDescription( 'Dados de Usuarios RAMI' )

	oModel:SetPrimaryKey({})

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFCRM37' )
	// Cria a estrutura a ser usada na View
	Local oStruZBK := FWFormStruct( 2, 'ZBK' )
	Local oView  

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZBK', oStruZBK, 'ZBKMASTER' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'TELA' , 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_ZBK', 'TELA' )
Return oView

//-------------------------------------------------------------------
//-------------------------------------------------------------------
static function CRM37POS( oModel )
	local nOpcChk	:= 0
	local lRet		:= .T.
	local oModel	:= FWModelActive()
	local oModelZBK	:= oModel:GetModel('ZBKMASTER')
	local nOper		:= oModel:getOperation()
	local cQryZBK	:= ""

	if nOper == MODEL_OPERATION_INSERT
		cQryZBK := "SELECT *"																	+ CRLF
		cQryZBK += " FROM " + retSQLName("ZBK") + " ZBK"										+ CRLF
		cQryZBK += " WHERE"																		+ CRLF
		cQryZBK += "		ZBK.ZBK_CODUSR	=	'" + oModelZBK:getValue("ZBK_CODUSR")	+ "'"	+ CRLF
		cQryZBK += "	AND	ZBK.ZBK_FILIAL	=	'" + xFilial("ZBK") + "'"						+ CRLF
		cQryZBK += "	AND	ZBK.D_E_L_E_T_	<>	'*'"											+ CRLF

		TcQuery cQryZBK New Alias "QRYZBK"

		if !QRYZBK->(EOF())
			Help( ,, 'Usuario j� cadastrado',, 'Este Usuario j� esta cadastrado.', 1, 0 )
			lRet := .F.
		endif

		QRYZBK->(DBCloseArea())
	endif
return lRet
