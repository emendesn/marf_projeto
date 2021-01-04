#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MTA265I
Autor...............: Totvs
Data................: Agosto/2018
Descrição / Objetivo: Ponto de Entrada para gravar arquivos ou campos do usuário, complementando a inclusão
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