/*
=====================================================================================
Programa............: SF1140I
Autor...............: Barbieri
Data................: 01/2018 
Descricao / Objetivo: Ponto de entrada no final da gravacao da pre-nota de entrada
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/

User function SF1140I()

	If FindFunction("U_MGFUS103")
		U_MGFUS103()
	Endif

	If FindFunction("U_COM65PreNota")
		U_COM65PreNota()
	Endif	
	
return