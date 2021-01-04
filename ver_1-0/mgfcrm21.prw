#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM21
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              07/04/2017
Descricao / Objetivo:   Cadastro de Tatica - Estrutura de Venda
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
user function MGFCRM21()
	local oBrowse

    //Cria um Browse Simples instanciando o FWMBrowse
	oBrowse := FWMBrowse():New()
	//Define um alias para o Browse
	oBrowse:SetAlias('ZBF')
	//Adiciona uma descrição para o Browse
	oBrowse:SetDescription('Cadastro de Tatica')
	//Ativa o Browse
	oBrowse:Activate()

return nil

//-------------------------------------------------------------------
static function MenuDef()
	local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'PesqBrw'				OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MGFCRM21'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MGFCRM21'	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MGFCRM21'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MGFCRM21'	OPERATION 5 ACCESS 0

return aRotina

//-------------------------------------------------------------------
Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZBF := FWFormStruct( 1, 'ZBF', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('CRM21MDL', /*bPreValidacao*/, /*bPosValidacao*/, { | oModel | cmtCrm21( oModel ) }/*bCommit*/, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'ZBFMASTER', /*cOwner*/, oStruZBF, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Cadastro de Tatica' )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'ZBFMASTER' ):SetDescription( 'Dados de Motivos' )

	oModel:SetPrimaryKey({})

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFCRM21' )
	// Cria a estrutura a ser usada na View
	Local oStruZBF := FWFormStruct( 2, 'ZBF' )
	Local oView

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZBF', oStruZBF, 'ZBFMASTER' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'TELA' , 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_ZBF', 'TELA' )
Return oView

//---------------------------------------------------------
// COMMIT
//---------------------------------------------------------
static function cmtCrm21( oModel )
	local nOperation	:= oModel:GetOperation()
	local lRet			:= .T.
	local cUpdTbl		:= ""

	if oModel:VldData()
		 if nOperation <> MODEL_OPERATION_DELETE
		 	oModel:setValue('ZBFMASTER' , 'ZBF_INTSFO' , 'P' )

			//-------------------------------------------------------------------------------
			// Atualiza clientes amarrados ao nivel atualizado
			//-------------------------------------------------------------------------------
			U_MGFUPZBJ( oModel:getValue('ZBFMASTER' , 'ZBF_DIRETO' ) + oModel:getValue('ZBFMASTER' , 'ZBF_NACION' ) + oModel:getValue('ZBFMASTER' , 'ZBF_CODIGO' ) , 3 )
		 else
			recLock( "ZBF" , .F. )
				ZBF->ZBF_INTSFO := 'P'
			ZBF->( msUnlock() )

			//-------------------------------------------------------------------------------
			// Atualiza clientes amarrados ao nivel atualizado
			//-------------------------------------------------------------------------------
			U_MGFUPZBJ( ZBF->ZBF_DIRETO + ZBF->ZBF_NACION + ZBF->ZBF_CODIGO , 3 )
		 endif

		cUpdTbl	:= ""

		cUpdTbl := "UPDATE " + retSQLName("SA3")												+ CRLF
		cUpdTbl += "	SET"																	+ CRLF
		cUpdTbl += " 		A3_XINTSFO = 'P'"													+ CRLF
		cUpdTbl += " WHERE"																		+ CRLF
		cUpdTbl += " 		A3_COD = '" + oModel:getValue('ZBFMASTER' , 'ZBF_REPRES' ) + "'"	+ CRLF

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