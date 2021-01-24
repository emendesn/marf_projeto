#include 'protheus.ch'

/*
=====================================================================================
Programa.:              MGFFIS04
Autor....:              Gustavo Ananias Afonso
Data.....:              08/11/2016
Descricao / Objetivo:   Ajuste Fiscal - NF de Saida
Doc. Origem:            GAP FIS040
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
User Function MGFFIS04()
	local aCoors  := FWGetDialogSize( oMainWnd )

	private oFWLayer
	private oPanelUp
	private oPanelMidd
	private oPanelDown
	private oBrowseUp
	private oBrowseMid
	private oRelacSF2
	private oDlgPrinc

	private nTipoNF	:= 2

	DEFINE MSDIALOG oDlgPrinc TITLE 'Ajuste Fiscal - Nota Fiscal de Saída' FROM aCoors[1], aCoors[2] TO aCoors[3], aCoors[4] PIXEL

		//
		// Cria o conteiner onde serÃ£o colocados os browses
		//
		oFWLayer := FWLayer():New()
		oFWLayer:Init( oDlgPrinc, .F., .T. )

		//
		// Define Painel Superior
		//
		oFWLayer:AddLine( 'UP', 40, .F. )                       // Cria uma "linha" com 40% da tela
		oFWLayer:AddCollumn( 'ALL', 100, .T., 'UP' )            // Na "linha" criada eu crio uma coluna com 100% da tamanho dela
		oPanelUp := oFWLayer:GetColPanel( 'ALL', 'UP' )         // Pego o objeto desse pedaÃ§o do container

		//
		// FWmBrowse Superior Albuns
		//
		oBrowseUp:= FWmBrowse():New()
		oBrowseUp:SetOwner( oPanelUp )                          // Aqui se associa o browse ao componente de tela
		oBrowseUp:SetDescription( "Notas Fiscais - SF2" )
		oBrowseUp:SetAlias( 'SF2' )
		oBrowseUp:SetMenuDef( 'MGFFIS04' )                   // Define de onde virao os botoes deste browse
		oBrowseUp:SetProfileID( '1' )
		oBrowseUp:ForceQuitButton()
		oBrowseUp:disableReport()
		oBrowseUp:DisableDetails()
		oBrowseUp:Activate()

		//
		// Painel central
		//
		oFWLayer:AddLine( 'MIDDLE', 60, .F. )                     // Cria uma "linha" com 60% da tela
		oFWLayer:AddCollumn( 'ALL' ,  100, .T., 'MIDDLE' )        // Na "linha" criada eu crio uma coluna com 50% da tamanho dela
		oPanelMidd  := oFWLayer:GetColPanel( 'ALL' , 'MIDDLE' )  // Pego o objeto do pedaÃ§o esquerdo

		// Meio
		oBrowseMid:= FWMBrowse():New()
		oBrowseMid:SetOwner( oPanelMidd )
		oBrowseMid:SetDescription( 'Itens da Nota Fiscal - SD2' )
		oBrowseMid:SetMenuDef( 'MGFFIS31' )                       // Referencia uma funcao que nao tem menu para que nao exiba nenhum botao
		oBrowseMid:DisableDetails()
		oBrowseMid:SetAlias( 'SD2' )
		oBrowseMid:SetProfileID( '2' )
		oBrowseMid:disableReport()
		oBrowseMid:Activate()

		//
		// Relacionamento entre os Paineis
		//
		oRelacSF2:= FWBrwRelation():New()

		//F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA
		//D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA

		oRelacSF2:AddRelation( oBrowseUp  , oBrowseMid , 	{ { 'D2_FILIAL', 'F2_FILIAL' }, { 'D2_DOC', 'F2_DOC' }, {  'D2_SERIE', 'F2_SERIE' } , {  'D2_CLIENTE', 'F2_CLIENTE' } , {  'D2_LOJA', 'F2_LOJA' } 	} )

		oRelacSF2:Activate()
	ACTIVATE MSDIALOG oDlgPrinc CENTER

return nil

//-------------------------------------------------------------------
static function MenuDef()
	local aRotina := {}

	aadd( aRotina, { 'Alteração de Cliente'			, 'U_MGFFIS05()()'	, 0, 4, 0, NIL } )
	aadd( aRotina, { 'Alteração da Transportadora'	, 'U_MGFFIS06()()'	, 0, 4, 0, NIL } )
	aadd( aRotina, { 'Alteração do Veículo'			, 'U_MGFFIS07()()'	, 0, 4, 0, NIL } )
	aadd( aRotina, { 'Alteração do Livro Fiscal'	, 'U_MGFFIS08()()'	, 0, 4, 0, NIL } )
	//aadd( aRotina, { 'Alteração do Produtos'		, 'U_MGFFIS31()()'	, 0, 4, 0, NIL } )

return aRotina
