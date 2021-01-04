#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM38
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              04/07/2017
Descricao / Objetivo:   Cadastro de Categoria de Produtos (ZBP)
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
user function MGFCRM38()
	local oBrowse       

    //Cria um Browse Simples instanciando o FWMBrowse
	oBrowse := FWMBrowse():New()
	//Define um alias para o Browse
	oBrowse:SetAlias('ZBP')
	//Adiciona uma descrição para o Browse
	oBrowse:SetDescription('Cadastro de Categoria de Produtos')      
	//Ativa o Browse
	oBrowse:Activate()

return nil

//-------------------------------------------------------------------
static function MenuDef()
	local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'	ACTION 'PesqBrw'			OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar'	ACTION 'VIEWDEF.MGFCRM38'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'		ACTION 'VIEWDEF.MGFCRM38'	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'		ACTION 'VIEWDEF.MGFCRM38'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'		ACTION 'VIEWDEF.MGFCRM38'   OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Exportar CSV'	ACTION 'U_MGFCRM42'			OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE 'Importar CSV'	ACTION 'U_MGFCRM43'			OPERATION 8 ACCESS 0

return aRotina

//-------------------------------------------------------------------
Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZBP	:= FWFormStruct( 1, 'ZBP', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oStruZBR	:= FWFormStruct( 1, 'ZBR', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel
	local aZBRRel	:= {}

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('CRM38MDL',/*bPreValidacao*/, {|oModel|U_exclusao(oModel)}/*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

	aAux := FwStruTrigger(;
	'ZBR_PRODUT'		,;		// DOMINIO
	'ZBR_DESPRO'		,;		// CONTRA DOMINIO
	"POSICIONE('SB1',1,XFILIAL('SB1') + M->ZBR_PRODUT, 'B1_DESC')"	,;	// REGRA PREENCHIMENTO
	.F.,;	// POSICIONA
	,;	// ALIAS
	,;	// ORDEM
	,;	// CHAVE
	,;	// CONDICAO
	)

	oStruZBR:AddTrigger( ;
	aAux[1], ;                                                      // [01] Id do campo de origem
	aAux[2], ;                                                      // [02] Id do campo de destino
	aAux[3], ;                                                      // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] )                                                       // [04] Bloco de codigo de execucao do gatilho

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'ZBPMASTER', /*cOwner*/	, oStruZBP, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	oModel:AddGrid	( 'ZBRDETAIL', 'ZBPMASTER'	, oStruZBR, {|a,b,c,d,e| prevldZBR(a,b,c,d,e)} /*bPreValidacao*/ )

    //Fazendo o relacionamento entre o Pai e Filho
    aadd(aZBRRel, {'ZBR_FILIAL', 'xFilial( "ZBR" )'	})
    aadd(aZBRRel, {'ZBR_CATEGO', 'ZBP_CODIGO'		})

    oModel:SetRelation( 'ZBRDETAIL' , aZBRRel , ZBR->( IndexKey( 1 ) ) )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Categoria de Produtos' )
	
	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'ZBPMASTER' ):SetDescription( 'Categoria de Produtos' )
	oModel:GetModel( 'ZBRDETAIL' ):SetDescription( 'Produtos da Categoria' )

	oModel:SetPrimaryKey({})

	oModel:GetModel( 'ZBRDETAIL' ):SetOptional(.T.)
Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFCRM38' )
	// Cria a estrutura a ser usada na View
	Local oStruZBP := FWFormStruct( 2, 'ZBP'	, {| cCampo | ! allTrim( cCampo ) $ "ZBP_FILIAL" } )
	local oStruZBR := FWFormStruct( 2, 'ZBR'	, {| cCampo | ! allTrim( cCampo ) $ "ZBR_FILIAL | ZBR_DESCAT | ZBR_CATEGO" } )

	Local oView  

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZBP'	, oStruZBP, 'ZBPMASTER' )
	oView:AddGrid( 'VIEW_ZBR'	, oStruZBR, 'ZBRDETAIL' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'CATEG'	, 30 )
	oView:CreateHorizontalBox( 'PRODU'	, 70 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_ZBP', 'CATEG' )
	oView:SetOwnerView( 'VIEW_ZBR', 'PRODU' )

    //Habilitando titulo
    oView:EnableTitleView( 'ZBPMASTER', 'Categoria' )
    oView:EnableTitleView( 'ZBRDETAIL', 'Produtos' )

Return oView

//------------------------------------------------
// 
//------------------------------------------------
Static Function prevldZBR(oModel, nLin, cPonto, cCpo, e)
	local nI			:= 0
	local xRet			:= .T.
	local oModel 		:= FWModelActive()
	local oMdlZBR		:= oModel:GetModel('ZBRDETAIL')
	local aSaveLines	:= FWSaveRows()

	if cPonto == 'SETVALUE'
		if cCpo == 'ZBR_PRODUT'
			for nI := 1 to oMdlZBR:length()
				oMdlZBR:goLine(nI)
				if M->ZBR_PRzODUT == oMdlZBR:getValue("ZBR_PRODUT") .and. nLin <> nI
					Help( ,, 'Nao  permitido',, "Este produto j� foi cadastrado para este SKU.", 1, 0 )
					xRet := .F.
					exit
				endif
			next
		endif
	endif

	FWRestRows( aSaveLines )
return xRet


User Function exclusao( oModel )

Local lRet := .T.
Local nOperation := oModel:GetOperation()	
	
IF 	nOperation == 5
	DbSelectArea('ZBQ')
	ZBQ->(DbGotop())
	ZBQ->(DbSetorder(1))//ZBQ_FILIAL+ZBQ_CATEGO+ZBQ_VENDED                                                                                                                                
	IF ZBQ->(DbSeek(xFilial("ZBQ")+ZBP->ZBP_CODIGO))
		lRet := .F.
			Help( ,, 'Help',, 'Nao e possivel fazer a exclusao desse regitro, pois o mesmo encontra-se vinculado ao cadastro de Metas!', 1, 0 )
	ENDIF
ENDIF
Return lRet