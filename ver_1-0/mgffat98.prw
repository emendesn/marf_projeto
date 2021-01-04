#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MGFFAT98
Autor...............: Totvs
Data................: Agosto/2018
Descricao / Objetivo: Rotina chamada pelo Ponto de Entrada M460FIL
Doc. Origem.........: Faturamento
Solicitante.........: Cliente
Uso.................: 
Obs.................: Nao mostrar pedidos que integram com o Taura, na rotina de preparacao de documento de saida por pedido
=====================================================================================
*/
User Function MGFFAT98(cFiltro)

// preparacao de docto saida por pedido
If IsInCallStack("MATA460A")
	If !Empty(cFiltro)
		cFiltro := cFiltro+" .and. "
	Endif	
	cFiltro := cFiltro+' Posicione("SZJ",1,xFilial("SZJ")+Posicione("SC5",1,xFilial("SC5")+C9_PEDIDO,"C5_ZTIPPED"),"ZJ_TAURA") != "S" '
Endif	

Return(cFiltro)