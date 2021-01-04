#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#DEFINE CRLF chr(13) + chr(10)
/*
=====================================================================================
Programa.:              MGFCRM39
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              04/07/2017
Descricao / Objetivo:   Metas BI
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
user function MGFCRM39()
	local oBrowse
	local aSeek			:= {}

	//Pesquisa que sera exibido
	/*
	aadd(aSeek,{"Representant"	, { {"","C",tamSx3("ZBI_REPRES")[1]	, 0, "Representant"	,,} }})
	aadd(aSeek,{"Desc.Represe"	, { {"","C",tamSx3("A3_NOME")[1]	, 0, "Desc.Represe"	,,} }})
	aadd(aSeek,{"Codigo"		, { {"","C",tamSx3("ZBI_CODIGO")[1]	, 0, "Codigo"		,,} }})
	aadd(aSeek,{"Descricao"		, { {"","C",tamSx3("ZBI_DESCRI")[1]	, 0, "Descricao"	,,} }})
	*/


    //Cria um Browse Simples instanciando o FWMBrowse
	oBrowse := FWMBrowse():New()
	//Define um alias para o Browse
	oBrowse:SetAlias('ZBI')
	//Adiciona uma descrição para o Browse
	oBrowse:SetDescription('Metas BI')

	oBrowse:setSeek( , aSeek)

	//Ativa o Browse
	oBrowse:Activate()
return nil

//---------------------------------------------------------------
static function MenuDef()
	local aRotina := {}

	//ADD OPTION aRotina TITLE 'Pesquisar'	ACTION 'PesqBrw'			OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'		ACTION 'VIEWDEF.MGFCRM39'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar'	ACTION 'VIEWDEF.MGFCRM39'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'		ACTION 'VIEWDEF.MGFCRM39'	OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Exportar CSV'	ACTION 'U_MGFCRM40'			OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE 'Importar CSV'	ACTION 'U_MGFCRM41'			OPERATION 8 ACCESS 0

return aRotina

//--------------------------------------------------------
//--------------------------------------------------------
static function ModelDef()
	local aZBQRel	:= {}
	local oStruZBI 	:= FWFormStruct( 1, "ZBI")
	local oStruZBQ	:= FWFormStruct( 1, 'ZBQ' )
	local oModel	:= nil

	oModel := MPFormModel():New( 'MDLCRM39' , , , /*bCommit*/)

	aAux := FwStruTrigger(;
	'ZBQ_CATEGO'		,;		// DOMINIO
	'ZBQ_DESCAT'		,;		// CONTRA DOMINIO
	"POSICIONE('ZBP',1,xFilial('ZBP') + M->ZBQ_CATEGO, 'ZBP_DESCRI')"	,;	// REGRA PREENCHIMENTO
	.F.,;	// POSICIONA
	,;	// ALIAS
	,;	// ORDEM
	,;	// CHAVE
	,;	// CONDICAO
	)

	oStruZBQ:AddTrigger( ;
	aAux[1], ;                                                      // [01] Id do campo de origem
	aAux[2], ;                                                      // [02] Id do campo de destino
	aAux[3], ;                                                      // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] )                                                       // [04] Bloco de codigo de execucao do gatilho


	oStruZBI:SetProperty("*", MODEL_FIELD_OBRIGAT	, .F. )
	oStruZBI:SetProperty("*", MODEL_FIELD_VALID		, { || .T. } )

	oModel:AddFields( 'ZBIMASTER',				, oStruZBI )
	oModel:AddGrid	( 'ZBQDETAIL', 'ZBIMASTER'	, oStruZBQ, {|a,b,c,d,e| prevldZBQ(a,b,c,d,e)} )

    //Fazendo o relacionamento entre o Pai e Filho
    aadd(aZBQRel, {'ZBQ_FILIAL', 'xFilial( "ZBQ" )'	})
    aadd(aZBQRel, {'ZBQ_VENDED', 'ZBI_REPRES'		})

    oModel:SetRelation( 'ZBQDETAIL' , aZBQRel , ZBQ->(IndexKey( 2 )) )

	oModel:SetDescription( 'Metas do Vendedor' )

	oModel:setPrimaryKey( {} )

	oModel:GetModel( 'ZBIMASTER' ):SetDescription( 'Vendedor' )
	oModel:GetModel( 'ZBQDETAIL' ):SetDescription( 'Metas' )

	oModel:GetModel( 'ZBIMASTER' ):SetOnlyView( .T. )
	oModel:GetModel( 'ZBIMASTER' ):SetOnlyQuery( .T. )

	oStruZBQ:SetProperty('ZBQ_VENDED'	, MODEL_FIELD_OBRIGAT	, .F.)

return oModel

//--------------------------------------------------------
//--------------------------------------------------------
static function ViewDef()
	local oModel	:= FWLoadModel( 'MGFCRM39' )
	//local oStruZBI	:= FWFormStruct( 2, 'ZBI'	, {| cCampo | allTrim( cCampo ) $ "A3_COD | A3_NOME" })
	local oStruZBI	:= FWFormStruct( 2, 'ZBI'	,)
	local oStruZBQ	:= FWFormStruct( 2, 'ZBQ'	, {| cCampo | ! allTrim( cCampo ) $ "ZBQ_FILIAL | ZBQ_VENDED" } )
	local oView		:= nil

	oView := FWFormView():New()

	oView:SetModel( oModel )

	oView:AddField( 'VIEW_ZBI', oStruZBI, 'ZBIMASTER' )
	oView:AddGrid( 'VIEW_ZBQ', oStruZBQ, 'ZBQDETAIL' )

	oView:SetViewProperty("VIEW_ZBQ", "GRIDFILTER", {.T.})
	//oView:SetViewProperty("VIEW_ZBQ", "GRIDSEEK", {.T.})

	oView:CreateHorizontalBox( 'VENDEDOR'	, 25 )
	oView:CreateHorizontalBox( 'METAS'		, 75 )

	oView:SetOwnerView( 'VIEW_ZBI', 'VENDEDOR' )
	oView:SetOwnerView( 'VIEW_ZBQ', 'METAS' )

    //Habilitando titulo
    oView:EnableTitleView( 'ZBIMASTER', 'Vendedor' )
    oView:EnableTitleView( 'ZBQDETAIL', 'Metas' )

return oView

//--------------------------------------------------------
// Inicializador de Browse dos campos ZBI
//--------------------------------------------------------
user function brwCRM39(cCpoZBI)
	local cRet := ""

	if cCpoZBI == "ZBI_DESSUP"
		cRet := posicione("ZBH",2,xFilial("ZBH")+ZBI->(ZBI_SUPERV+ZBI_REGION+ZBI_TATICA+ZBI_NACION+ZBI_DIRETO),"ZBH_DESCRI")
	elseif cCpoZBI == "ZBI_DESTAT"
		cRet := posicione("ZBF",2,xFilial("ZBF")+ZBI->ZBI_TATICA+ZBI->ZBI_NACION+ZBI->ZBI_DIRETO,"ZBF_DESCRI")
	elseif cCpoZBI == "ZBI_DESREG"
		cRet := posicione("ZBG",2,xFilial("ZBG")+ZBI->ZBI_REGION+ZBI->ZBI_TATICA+ZBI->ZBI_NACION+ZBI->ZBI_DIRETO,"ZBG_DESCRI")   
	endif

return cRet

//------------------------------------------------
// 
//------------------------------------------------
Static Function prevldZBQ(oModel, nLin, cPonto, cCpo, e)
	local nI			:= 0
	local xRet			:= .T.
	local oModel 		:= FWModelActive()
	local oMdlZBQ		:= oModel:GetModel('ZBQDETAIL')
	local aSaveLines	:= FWSaveRows()


	if cPonto == 'SETVALUE'
		if cCpo == 'ZBQ_DTINIC'
			oMdlZBQ:goLine(nLin)
			if !empty( oMdlZBQ:getValue( "ZBQ_DTFIM" ) ) .AND. E > oMdlZBQ:getValue( "ZBQ_DTFIM" )
				Help( ,, 'Nao  permitido',, "Data inicial maior que a data final.", 1, 0 )
				xRet := .F.
			endif
		elseif cCpo == 'ZBQ_DTFIM'
			oMdlZBQ:goLine(nLin)
			if !empty( oMdlZBQ:getValue( "ZBQ_DTINIC" ) ) .AND. E < oMdlZBQ:getValue( "ZBQ_DTINIC" )
				Help( ,, 'Nao  permitido',, "Data inicial maior que a data final.", 1, 0 )
				xRet := .F.
			endif
		endif
	endif

	FWRestRows( aSaveLines )
return xRet