#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MTA265I
Autor...............: Totvs
Data................: Agosto/2018
Descri��o / Objetivo: Ponto de Entrada para gravar arquivos ou campos do usu�rio, complementando a inclus�o
Doc. Origem.........: Estoque
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MTA265I() 

If FindFunction("U_MGFEST42")	
	U_MGFEST42()
Endif
	
Return()