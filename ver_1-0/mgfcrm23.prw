#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM23
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              07/04/2017
Descricao / Objetivo:   Cadastro de Regional - Estrutura de Venda
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
user function MGFCRM23()
	local oBrowse

    //Cria um Browse Simples instanciando o FWMBrowse
	oBrowse := FWMBrowse():New()
	//Define um alias para o Browse
	oBrowse:SetAlias('ZBG')
	//Adiciona uma descrição para o Browse
	oBrowse:SetDescription('Cadastro de Regional')
	//Ativa o Browse
	oBrowse:Activate()

return nil

//-------------------------------------------------------------------
static function MenuDef()
	local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'PesqBrw'				OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MGFCRM23'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MGFCRM23'	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MGFCRM23'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MGFCRM23'	OPERATION 5 ACCESS 0

return aRotina

//-------------------------------------------------------------------
Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZBG := FWFormStruct( 1, 'ZBG', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('CRM23MDL', /*bPreValidacao*/, /*bPosValidacao*/, { | oModel | cmtCrm23( oModel ) }/*bCommit*/, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'ZBGMASTER', /*cOwner*/, oStruZBG, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Cadastro de Regional' )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'ZBGMASTER' ):SetDescription( 'Dados de Regional' )

	oModel:SetPrimaryKey({})

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFCRM23' )
	// Cria a estrutura a ser usada na View
	Local oStruZBG := FWFormStruct( 2, 'ZBG' )
	Local oView

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZBG', oStruZBG, 'ZBGMASTER' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'TELA' , 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_ZBG', 'TELA' )
Return oView

//---------------------------------------------------------
// COMMIT
//---------------------------------------------------------
static function cmtCrm23( oModel )
	local nOperation	:= oModel:GetOperation()
	local lRet			:= .T.
	local cUpdTbl		:= ""

	if oModel:VldData()
		if nOperation <> MODEL_OPERATION_DELETE
			oModel:setValue('ZBGMASTER' , 'ZBG_INTSFO' , 'P' )

			//-------------------------------------------------------------------------------
			// Atualiza clientes amarrados ao nivel atualizado
			//-------------------------------------------------------------------------------
			U_MGFUPZBJ( oModel:getValue('ZBGMASTER' , 'ZBG_DIRETO' ) + oModel:getValue('ZBGMASTER' , 'ZBG_NACION' ) + oModel:getValue('ZBGMASTER' , 'ZBG_TATICA' ) + oModel:getValue('ZBGMASTER' , 'ZBG_CODIGO' ) , 4 )
		else
		   recLock( "ZBG" , .F. )
			   ZBG->ZBG_INTSFO := 'P'
		   ZBG->( msUnlock() )

			//-------------------------------------------------------------------------------
			// Atualiza clientes amarrados ao nivel atualizado
			//-------------------------------------------------------------------------------
			U_MGFUPZBJ( ZBG->ZBG_DIRETO + ZBG->ZBG_NACION + ZBG->ZBG_TATICA + ZBG->ZBG_CODIGO , 4 )
		endif

		cUpdTbl	:= ""

		cUpdTbl := "UPDATE " + retSQLName("SA3")												+ CRLF
		cUpdTbl += "	SET"																	+ CRLF
		cUpdTbl += " 		A3_XINTSFO = 'P'"													+ CRLF
		cUpdTbl += " WHERE"																		+ CRLF
		cUpdTbl += " 		A3_COD = '" + oModel:getValue('ZBGMASTER' , 'ZBG_REPRES' ) + "'"	+ CRLF

		if tcSQLExec( cUpdTbl ) < 0
			conout("Nao  foi possivel executar UPDATE." + CRLF + tcSqlError())
		endif

		fwFormCommit( oModel )
		oModel:DeActivate()
	else
		JurShowErro( oModel:GetModel():GetErrormessage() )
		lRet := .F.
		DisarmTransaction()
	endif

return lRet