#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: M460FIL
Autor...............: Totvs
Data................: Agosto/2018
Descricao / Objetivo: Ponto de Entrada utilizado antes da execucao da Indregua na selecao da Markbrowse
Doc. Origem.........: Faturamento
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/
User Function M460FIL() 

Local cFiltro := ""

If findfunction("U_MGFFAT98")	
	cFiltro := U_MGFFAT98(cFiltro)
Endif
	
Return(cFiltro)