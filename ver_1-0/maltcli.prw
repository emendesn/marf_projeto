#include 'protheus.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MALTCLI
Autor....:              Gustavo Ananias Afonso
Data.....:              26/10/2016
Descricao / Objetivo:   
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              http://tdn.totvs.com/display/public/PROT/MALTCLI
=====================================================================================
*/
user function MALTCLI()

	If FindFunction("U_MGFFAT25") 
		U_MGFFAT25("A")
	Endif
	If FindFunction("U_MGFINT17") 
		U_MGFINT17()
	Endif
	If findfunction("u_MGFINT47")
		u_MGFINT47(4)
	Endif

return