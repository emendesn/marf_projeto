#include 'protheus.ch'

/*
=====================================================================================
Programa.:              MGFFIS09
Autor....:              Gustavo Ananias Afonso
Data.....:              10/11/2016
Descricao / Objetivo:   Ajuste Fiscal - NF de Entrada
Doc. Origem:            GAP FIS040
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
User Function MGFFIS09()
	local aCoors  := FWGetDialogSize( oMainWnd )

	private oFWLayer
	private oPanelUp
	private oPanelMidd
	private oPanelDown
	private oBrowseUp
	private oBrowseMid
	private oRelacSF1
	private oDlgPrinc

	private nTipoNF	:= 1

	DEFINE MSDIALOG oDlgPrinc TITLE 'Ajuste Fiscal - Nota Fiscal de Entrada' FROM aCoors[1], aCoors[2] TO aCoors[3], aCoors[4] PIXEL

		//
		// Cria o conteiner onde ser√£o colocados os browses
		//
		oFWLayer := FWLayer():New()
		oFWLayer:Init( oDlgPrinc, .F., .T. )

		//
		// Define Painel Superior
		//
		oFWLayer:AddLine( 'UP', 40, .F. )                       // Cria uma "linha" com 40% da tela
		oFWLayer:AddCollumn( 'ALL', 100, .T., 'UP' )            // Na "linha" criada eu crio uma coluna com 100% da tamanho dela
		oPanelUp := oFWLayer:GetColPanel( 'ALL', 'UP' )         // Pego o objeto desse peda√ßo do container

		//
		// FWmBrowse Superior Albuns
		//
		oBrowseUp:= FWmBrowse():New()
		oBrowseUp:SetOwner( oPanelUp )                          // Aqui se associa o browse ao componente de tela
		oBrowseUp:SetDescription( "Notas Fiscais - SF1" )
		oBrowseUp:SetAlias( 'SF1' )
		oBrowseUp:SetFilterDefault( " F1_FORMUL == 'S' "  )
		oBrowseUp:SetMenuDef( 'MGFFIS09' )                   // Define de onde virao os botoes deste browse
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
		oPanelMidd  := oFWLayer:GetColPanel( 'ALL' , 'MIDDLE' )  // Pego o objeto do peda√ßo esquerdo

		// Meio
		oBrowseMid:= FWMBrowse():New()
		oBrowseMid:SetOwner( oPanelMidd )
		oBrowseMid:SetDescription( 'Itens da Nota Fiscal - SD1' )
		oBrowseMid:SetMenuDef( 'MGFFIS31' )                       // Referencia uma funcao que nao tem menu para que nao exiba nenhum botao
		oBrowseMid:DisableDetails()
		oBrowseMid:SetAlias( 'SD1' )
		oBrowseMid:SetProfileID( '2' )
		oBrowseMid:disableReport()
		oBrowseMid:Activate()

		//
		// Relacionamento entre os Paineis
		//
		oRelacSF1:= FWBrwRelation():New()

		//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA
		//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA

		oRelacSF1:AddRelation( oBrowseUp  , oBrowseMid , 	{ { 'D1_FILIAL', 'F1_FILIAL' }, { 'D1_DOC', 'F1_DOC' }, {  'D1_SERIE', 'F1_SERIE' } , {  'D1_FORNECE', 'F1_FORNECE' } , {  'D1_LOJA', 'F1_LOJA' } 	} )

		oRelacSF1:Activate()
	ACTIVATE MSDIALOG oDlgPrinc CENTER

return nil

//-------------------------------------------------------------------
static function MenuDef()
	local aRotina := {}

	aadd( aRotina, { 'AlteraÁ„o de Fornecedor'		, 'U_MGFFIS10()()'	, 0, 4, 0, NIL } )
	aadd( aRotina, { 'AlteraÁ„o do Livro Fiscal'	, 'U_MGFFIS11()()'	, 0, 4, 0, NIL } )

return aRotina
