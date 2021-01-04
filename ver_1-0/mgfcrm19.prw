#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM19
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              07/04/2017
Descricao / Objetivo:   Cadastro de Nacional - Estrutura de Venda
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
user function MGFCRM19()
	local oBrowse

    //Cria um Browse Simples instanciando o FWMBrowse
	oBrowse := FWMBrowse():New()
	//Define um alias para o Browse
	oBrowse:SetAlias('ZBE')
	//Adiciona uma descrição para o Browse
	oBrowse:SetDescription('Cadastro de Nacional')
	//Ativa o Browse
	oBrowse:Activate()

return nil

//-------------------------------------------------------------------
static function MenuDef()
	local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'PesqBrw'				OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MGFCRM19'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MGFCRM19'	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MGFCRM19'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MGFCRM19'	OPERATION 5 ACCESS 0

return aRotina

//-------------------------------------------------------------------
Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZBE := FWFormStruct( 1, 'ZBE', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('CRM19MDL', /*bPreValidacao*/, /*bPosValidacao*/, { | oModel | cmtCrm19( oModel ) }/*bCommit*/, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'ZBEMASTER', /*cOwner*/, oStruZBE, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Cadastro de Nacional' )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'ZBEMASTER' ):SetDescription( 'Dados de Motivos' )

	oModel:SetPrimaryKey({})

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFCRM19' )
	// Cria a estrutura a ser usada na View
	Local oStruZBE := FWFormStruct( 2, 'ZBE' )
	Local oView

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZBE', oStruZBE, 'ZBEMASTER' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'TELA' , 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_ZBE', 'TELA' )
Return oView

//---------------------------------------------------------
// COMMIT
//---------------------------------------------------------
static function cmtCrm19( oModel )
	local nOperation	:= oModel:GetOperation()
	local lRet			:= .T.
	local cUpdTbl		:= ""

	if oModel:VldData()
		if nOperation <> MODEL_OPERATION_DELETE
			oModel:setValue('ZBEMASTER' , 'ZBE_INTSFO' , 'P' )

			//-------------------------------------------------------------------------------
			// Atualiza clientes amarrados ao nivel atualizado
			//-------------------------------------------------------------------------------
			U_MGFUPZBJ( oModel:getValue('ZBEMASTER' , 'ZBE_DIRETO' ) + oModel:getValue('ZBEMASTER' , 'ZBE_CODIGO' ) , 2 )
		else
			recLock( "ZBE" , .F. )
				ZBE->ZBE_INTSFO := 'P'
			ZBE->( msUnlock() )

			//-------------------------------------------------------------------------------
			// Atualiza clientes amarrados ao nivel atualizado
			//-------------------------------------------------------------------------------
			U_MGFUPZBJ( ZBE->ZBE_DIRETO + ZBE->ZBE_CODIGO , 2 )
		endif

		cUpdTbl	:= ""

		cUpdTbl := "UPDATE " + retSQLName("SA3")												+ CRLF
		cUpdTbl += "	SET"																	+ CRLF
		cUpdTbl += " 		A3_XINTSFO = 'P'"													+ CRLF
		cUpdTbl += " WHERE"																		+ CRLF
		cUpdTbl += " 		A3_COD = '" + oModel:getValue('ZBEMASTER' , 'ZBE_REPRES' ) + "'"	+ CRLF

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