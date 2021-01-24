#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM25
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              07/04/2017
Descricao / Objetivo:   Cadastro de Supervis„o - Estrutura de Venda
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
user function MGFCRM25()
	local oBrowse

    //Cria um Browse Simples instanciando o FWMBrowse
	oBrowse := FWMBrowse():New()
	//Define um alias para o Browse
	oBrowse:SetAlias('ZBH')
	//Adiciona uma descri√ß√£o para o Browse
	oBrowse:SetDescription('Cadastro de Supervis„o')
	//Ativa o Browse
	oBrowse:Activate()

return nil

//-------------------------------------------------------------------
Static Function MenuDef()
	local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'PesqBrw'			OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MGFCRM25'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MGFCRM25'	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MGFCRM25'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MGFCRM25'	OPERATION 5 ACCESS 0

return aRotina

//-------------------------------------------------------------------
Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZBH := FWFormStruct( 1, 'ZBH', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('CRM25MDL', /*bPreValidacao*/, /*bPosValidacao*/, { | oModel | cmtCrm25( oModel ) }/*bCommit*/, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formul·rio de ediÁ„o por campo
	oModel:AddFields( 'ZBHMASTER', /*cOwner*/, oStruZBH, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Cadastro de Supervis„o' )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'ZBHMASTER' ):SetDescription( 'Dados de Supervis„o' )

	oModel:SetPrimaryKey({})

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFCRM25' )

	// Cria a estrutura a ser usada na View
	Local oStruZBH := FWFormStruct( 2, 'ZBH' )
	Local oView

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados ser√° utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZBH', oStruZBH, 'ZBHMASTER' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'TELA' , 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_ZBH', 'TELA' )
Return oView

//---------------------------------------------------------
// COMMIT
//---------------------------------------------------------
static function cmtCrm25( oModel )
	local nOperation	:= oModel:GetOperation()
	local lRet			:= .T.
	local cUpdTbl		:= ""

	If oModel:VldData()

		If nOperation <> MODEL_OPERATION_DELETE
			oModel:setValue('ZBHMASTER' , 'ZBH_INTSFO' , 'P' )

			//-------------------------------------------------------------------------------
			// Atualiza clientes amarrados ao nivel atualizado
			//-------------------------------------------------------------------------------
			U_MGFUPZBJ( oModel:getValue('ZBHMASTER' , 'ZBH_DIRETO' ) + oModel:getValue('ZBHMASTER' , 'ZBH_NACION' ) + oModel:getValue('ZBHMASTER' , 'ZBH_TATICA' ) + oModel:getValue('ZBHMASTER' , 'ZBH_REGION' ) + oModel:getValue('ZBHMASTER' , 'ZBH_CODIGO' ) , 5 )
		Else

			fAtuAOV(oModel:getValue('ZBHMASTER','ZBH_CODIGO'))

			ZBH->(RecLock("ZBH",.F.))
				ZBH->ZBH_INTSFO := 'P'
			ZBH->(MsUnlock())

			//-------------------------------------------------------------------------------
			// Atualiza clientes amarrados ao nivel atualizado
			//-------------------------------------------------------------------------------
			U_MGFUPZBJ( ZBH->ZBH_DIRETO + ZBH->ZBH_NACION + ZBH->ZBH_TATICA + ZBH->ZBH_REGION + ZBH->ZBH_CODIGO , 5 )
		EndIf

		cUpdTbl	:= ""

		cUpdTbl := "UPDATE " + RetSQLName("SA3")												+ CRLF
		cUpdTbl += "	SET"																	+ CRLF
		cUpdTbl += " 		A3_XINTSFO = 'P'"													+ CRLF
		cUpdTbl += " WHERE"																		+ CRLF
		cUpdTbl += " 		A3_COD = '" + oModel:getValue('ZBHMASTER' , 'ZBH_REPRES' ) + "'"	+ CRLF

		if tcSQLExec( cUpdTbl ) < 0
			conout("N„o foi possÌvel executar UPDATE." + CRLF + tcSqlError())
		endif

		fwFormCommit( oModel )

		If nOperation <> MODEL_OPERATION_VIEW .And. nOperation <> MODEL_OPERATION_DELETE
		   fGerAOV(oModel:getValue('ZBHMASTER','ZBH_CODIGO'),oModel:getValue('ZBHMASTER','ZBH_DESCRI'),nOperation)
		EndIf

		oModel:DeActivate()
	Else
		JurShowErro( oModel:GetModel():GetErrormessage() )
		lRet := .F.
		DisarmTransaction()
	EndIf

return lRet

/*
=====================================================================================
FunÁ„o...:              FGERAOV
Autor....:              Paulo da Mata - MARFRIG
Data.....:              18/02/2020
Descricao / Objetivo:   Gera ou altera dados na tabela AOV, baseado no R_E_C_N_O_ da ZBH
Doc. Origem:            RTASK0010772
Solicitante:            Contas a Receber
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fGerAov(cCodigo,cDescri,nOper)

Local cFilZBH := ""

If Select("FILZBH") > 0
	FILZBH->(dbClosearea())
Endif

If 		nOper == MODEL_OPERATION_INSERT

		cFilZBH := "SELECT MAX(R_E_C_N_O_) REGISTRO "+CRLF
		cFilZBH += "FROM "+RetSqlName("ZBH")+" "+CRLF
		cFilZBH += "WHERE D_E_L_E_T_ = ' ' "+CRLF

		TcQuery cFilZBH New Alias "FILZBH"

		AOV->(dbSetOrder(1))
		If !AOV->(dbSeek(xFilial("AOV")+StrZero(FILZBH->REGISTRO,6)))
   		   AOV->(RecLock("AOV",.T.))
   		   AOV->AOV_CODSEG := StrZero(FILZBH->REGISTRO,6)
   		   AOV->AOV_DESSEG := cDescri
   		   AOV->AOV_PRINC  := "1"
		   AOV->AOV_MSBLQL := "2"
   		   AOV->(MsUnLock())
		EndIf

ElseIf 	nOper == MODEL_OPERATION_UPDATE

		cFilZBH := "SELECT MAX(R_E_C_N_O_) REGISTRO "+CRLF
		cFilZBH += "FROM "+RetSqlName("ZBH")+" "+CRLF
		cFilZBH += "WHERE D_E_L_E_T_ = ' ' "+CRLF
		cFilZBH += "AND ZBH_CODIGO = '"+cCodigo+"' "+CRLF

		TcQuery cFilZBH New Alias "FILZBH"

		AOV->(dbSetOrder(1))
		If AOV->(dbSeek(xFilial("AOV")+StrZero(FILZBH->REGISTRO,6)))
		   AOV->(RecLock("AOV",.F.))
   		   AOV->AOV_DESSEG := cDescri
		   AOV->(MsUnLock())
		EndIf

ElseIf 	nOper == MODEL_OPERATION_DELETE

		cFilZBH := "SELECT MAX(R_E_C_N_O_) REGISTRO "+CRLF
		cFilZBH += "FROM "+RetSqlName("ZBH")+" "+CRLF
		cFilZBH += "WHERE D_E_L_E_T_ = ' ' "+CRLF
		cFilZBH += "AND ZBH_CODIGO = '"+cCodigo+"' "+CRLF

		TcQuery cFilZBH New Alias "FILZBH"

		AOV->(dbSetOrder(1))
		If AOV->(dbSeek(xFilial("AOV")+StrZero(FILZBH->REGISTRO,6)))
		   AOV->(RecLock("AOV",.F.))
   		   AOV->AOV_MSBLQL := "1"
		   AOV->(MsUnLock())
		EndIf

EndIf

Return

/*
=====================================================================================
FunÁ„o...:              FATUOV
Autor....:              Paulo da Mata - MARFRIG
Data.....:              19/02/2020
Descricao / Objetivo:   Bloqueia o registro na tabela AOV, baseado no R_E_C_N_O_ da ZBH
Doc. Origem:            RTASK0010772
Solicitante:            Contas a Receber
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fAtuAOV(cCodigo)

	Local cFilZBH := ""

	If Select("FILZBH") > 0
		FILZBH->(dbClosearea())
	Endif

	cFilZBH := "SELECT MAX(R_E_C_N_O_) REGISTRO "+CRLF
	cFilZBH += "FROM "+RetSqlName("ZBH")+" "+CRLF
	cFilZBH += "WHERE D_E_L_E_T_ = ' ' "+CRLF
	cFilZBH += "AND ZBH_CODIGO = '"+cCodigo+"' "+CRLF

	TcQuery cFilZBH New Alias "FILZBH"

	AOV->(dbSetOrder(1))
	If AOV->(dbSeek(xFilial("AOV")+StrZero(FILZBH->REGISTRO,6)))
	   AOV->(RecLock("AOV",.F.))
   	   AOV->AOV_MSBLQL := "1"
	   AOV->(MsUnLock())
	EndIf

Return