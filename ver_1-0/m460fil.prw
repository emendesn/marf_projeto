#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: M460FIL
Autor...............: Totvs
Data................: Agosto/2018
Descri��o / Objetivo: Ponto de Entrada utilizado antes da execu��o da Indregua na sele��o da Markbrowse
Doc. Origem.........: Faturamento
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function M460FIL() 

Local cFiltro := ""

If findfunction("U_MGFFAT98")	
	cFiltro := U_MGFFAT98(cFiltro)
Endif
	
Return(cFiltro)