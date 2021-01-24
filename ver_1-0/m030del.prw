#include 'protheus.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              M030INC
Autor....:              Leonardo Hideaki Kume
Data.....:              21/12/2016
Descricao / Objetivo:   
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function M030DEL()

	If findfunction("U_MGFFAT25")
		U_MGFFAT25("E")
	Endif

return .t.