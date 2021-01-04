#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"

/*
=====================================================================================
Programa............: MGFFAT12
Autor...............: Joni Lima
Data................: 31/10/2016
Descricao / Objetivo: Consulta de Bloqueio
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza a consulta de bloqueio
=====================================================================================
*/
User Function MGFFAT12(lItem,cxFil,cPedido,cCliente,cLoja)
	
	Local aArea		:= GetArea()
	Local cPerg		:= "MGFFAT12"
	Local cField	:= ""
	Local aParIn	:= {}
	Local ni		:= 0
	
	Local lMsTel	:= IsInCallStack('U_xMF10BlCon') .or. IsInCallStack('MATA410')
	Local lCont		:= .F.
	
	Local aOldRotina := {}	
	
	If !lMsTel		
		If Pergunte(cPerg,.T.)
			lItem := ( MV_PAR01 == 1 )
			lCont := .T.
		EndIf
	EndIf
	
	If lMsTel				
		
		Pergunte(cPerg,.F.)
		
		lCont := .T.
		If IsInCallStack('U_xMF10BlCon')
			MV_PAR02 := cxFil		//Filial De? 
			MV_PAR03 := cxFil		//Filial Ate?
			MV_PAR04 := cPedido		//Pedido De?
			MV_PAR05 := cPedido		//Pedido Ate?
			MV_PAR06 := cCliente	//Cliente De?
			MV_PAR07 := cLoja		//Loja De?
			MV_PAR08 := cCliente	//Cliente Ate?
			MV_PAR09 := cLoja		//Loja Ate?			
		ElseIf IsInCallStack('MATA410')
			
			aOldRotina := aRotina
			aRotina :={}
			MV_PAR01 := 2
			MV_PAR02 := SC5->C5_FILIAL	//Filial De? 
			MV_PAR03 := SC5->C5_FILIAL	//Filial Ate?
			MV_PAR04 := SC5->C5_NUM		//Pedido De?
			MV_PAR05 := SC5->C5_NUM		//Pedido Ate?
			MV_PAR06 := SC5->C5_CLIENTE	//Cliente De?
			MV_PAR07 := SC5->C5_LOJACLI	//Loja De?
			MV_PAR08 := SC5->C5_CLIENTE	//Cliente Ate?
			MV_PAR09 := SC5->C5_LOJACLI	//Loja Ate?
			
			lItem := .F.			
		EndIf
		
	EndIf		
	
	If lCont
		xMF12Brows(lItem)
		If IsInCallStack('MATA410')
			aRotina := aOldRotina
		EndIf
	EndIf
	
	RestArea(aArea)
	
Return

/*
=====================================================================================
Programa............: xMF12Brows
Autor...............: Joni Lima
Data................: 31/10/2016
Descricao / Objetivo: Monta o Browse para Consulta dos Bloqueios
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza a montagem do Browse
=====================================================================================
*/
Static Function xMF12Brows(lItem)

	Local oFWLayer    	:= Nil 
	Local oDlgPrinc		:= Nil //Add AGora???
	Local oPnUp 		:= Nil
	Local oPnDown 		:= Nil
	Local oBwUp   		:= Nil 
	Local oBwDown 		:= Nil
	Local oRelacSZV   	:= Nil
	
	Local aCoors      	:= FWGetDialogSize( oMainWnd )
	
	Local cTitle    	:= 'Liberacao de Pedidos' 
	Local cxAlias		:= IIF(lItem,'SC6','SC5')
	Local cxDesc		:= IIF(lItem,'Itens Pedidos','Pedidos')
	//Local cFilCab		:= ''  
							
	Local cFilFil		:= xMF12Fit(SubStr(cxAlias,2,2) + '_FILIAL',MV_PAR02,MV_PAR03)
	Local cFilPed		:= xMF12Fit(SubStr(cxAlias,2,2) + '_NUM',MV_PAR04,MV_PAR05)
	Local cFilCli		:= xMF12Fit(IIF(lItem,'C6_CLI','C5_CLIENTE'),MV_PAR06,MV_PAR08)
	Local cFilLoj		:= xMF12Fit(IIF(lItem,'C6_LOJA','C5_LOJACLI'),MV_PAR07,MV_PAR09)
	
	Default lItem		:= .T.
	
	//cFilCab		:= SubStr(cxAlias,2,2) + '_NUM == "' + cPedido + '"'  
	
	Define MsDialog oDlgPrinc Title cTitle From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel 	
	
	// Cria o conteiner onde serao colocados os browses 
	oFWLayer:= FWLayer():New() 
	oFWLayer:Init( oDlgPrinc, .F., .T. )
	
	// Define Painel Superior 
	oFWLayer:AddLine( 'LINUP', 50, .F. )              // Cria uma 'linha' com 50% da tela. 
	oFWLayer:AddCollumn( 'COLUP' , 100, .F., 'LINUP' )   // Na 'linha' criada cria-se uma coluna com 100% do seu tamanho. 
	
	oPnUp := oFWLayer:GetColPanel( 'COLUP', 'LINUP' ) // Criar o objeto dessa parte do container.
		
	// Painel Inferior 
	oFWLayer:AddLine( 'LINDOWN', 50, .F. )                    // Cria uma 'linha' com 50% da tela. 
	oFWLayer:AddCollumn( 'COLDOWN'  , 100, .F., 'LINDOWN' )        // Na "linha" criada cria-se uma coluna com 100% de seu tamanho. 

	oPnDown := oFWLayer:GetColPanel( 'COLDOWN', 'LINDOWN' ) // Criar o objeto dessa parte do container.
	
	// 1. FWmBrowse Superior
	oBwUp:= FWmBrowse():New() 
	oBwUp:SetOwner( oPnUp )        // Aqui se associa o browse ao componente de tela superior. 
	oBwUp:SetDescription( cxDesc ) // 'Bilhetes'
	oBwUp:SetAlias( cxAlias )
	oBwUp:SetMenuDef( '' )     // Define de onde virao os botoes deste browse
	oBwUp:SetProfileID( '1' )        // Identificador (ID) para o Browse 
	oBwUp:ForceQuitButton()          // Forca exibicao do botao [Sair]
	
	If !Empty(cFilFil)
		oBwUp:AddFilter('Flt. Filial',cFilFil,.T.,.T.)
	EndIf

	If !Empty(cFilPed)
		oBwUp:AddFilter('Flt. Pedido',cFilPed,.T.,.T.)
	EndIf
	
	If !Empty(cFilCli)
		oBwUp:AddFilter('Flt. Cliente',cFilCli,.T.,.T.)
	EndIf
	
	If !Empty(cFilLoj)
		oBwUp:AddFilter('Flt. Loj.',cFilLoj,.T.,.T.)
	EndIf		
	
	oBwUp:DisableDetails()
	oBwUp:DisableReport()
	oBwUp:Activate() 
	
	// 2. FWmBrowse Baixo
	oBwDown:= FWMBrowse():New() 
	oBwDown:SetOwner( oPnDown ) 
	oBwDown:SetDescription( 'Bloqueios' ) // 'Forma Pagamento'
	
	oBwDown:AddLegend( "!Empty(ZV_DTAPR)"					  , "GREEN"	 , "Liberado"  )
	oBwDown:AddLegend( "Empty(ZV_DTAPR).AND.Empty(ZV_DTRJC).and. ZV_CODRGA <> '000099'" , "YELLOW"  , "Bloqueado" )
	oBwDown:AddLegend( "Empty(ZV_DTAPR).AND.!Empty(ZV_DTRJC).and. ZV_CODRGA <> '000099'", "RED"	 , "Rejeitado" )
	
	oBwDown:AddLegend( "Empty(ZV_DTAPR) .AND. Empty(ZV_DTRJC) .and. Empty(ZV_CODPER) .and. ZV_CODRGA == '000099'", "BR_LARANJA"	 , "Bloqueado S/ Classificacao" )
	oBwDown:AddLegend( "Empty(ZV_DTAPR) .AND. Empty(ZV_DTRJC).and. !Empty(ZV_CODPER) .and. ZV_CODRGA == '000099'", "BLUE"	 , "Bloqueado C/ Classificacao" )
	oBwDown:AddLegend( "Empty(ZV_DTAPR) .AND. !Empty(ZV_DTRJC).and. !Empty(ZV_CODPER) .and. ZV_CODRGA == '000099'","BR_MARROM"	 , "Rejeitado C/ Classificacao" )

	
	oBwDown:SetAlias( 'SZV' )
	oBwDown:SetMenuDef( '' ) 			// Referencia vazia para que nao exiba nenhum botao.
	oBwDown:SetProfileID( '2' )
	oBwDown:DisableDetails()
	oBwDown:SetFilterDefault( '' )     // Desabilita qualquer filtro. 	
	oBwDown:DisableReport()
	oBwDown:Activate() 
	
	//Cria relacionamento dos Browse
	oRelacSZV := FWBrwRelation():New()	
	
	If lItem
		oRelacSZV:AddRelation( oBwUp  ,oBwDown, { { 'ZV_FILIAL', 'xFilial( "SZV" )' }, {'ZV_PEDIDO','C6_NUM'},{'ZV_ITEMPED','C6_ITEM'} } ) 
	Else
		oRelacSZV:AddRelation( oBwUp  ,oBwDown, { { 'ZV_FILIAL', 'xFilial( "SZV" )' }, {'ZV_PEDIDO','C5_NUM'} } )
	EndIf
	
	oRelacSZV:Activate()
	
	oBwDown:Refresh()
		
	Activate MsDialog oDlgPrinc Center

Return

/*
=====================================================================================
Programa............: xMF12Fit
Autor...............: Joni Lima
Data................: 31/10/2016
Descricao / Objetivo: Cria Filtro para aplciacao do Browse Principal
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza a montagem, do Filtro
=====================================================================================
*/
Static Function xMF12Fit(cCamp,cCampDe,cCampAte)
	
	Local cRet := ''
	
	If !(Empty(cCampDe) .and. ( Empty(cCampAte) .or. (cCampAte == Replicate('Z',TamSx3(cCamp)[1]))))
		cRet := "(" + Alltrim(cCamp) + " >='" + cCampDe + "' .and. " + Alltrim(cCamp) + " <= '" + cCampAte + "'  )"
	EndIf

Return cRet