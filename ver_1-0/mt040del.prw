#include 'protheus.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MA040DEL
Autor....:              Leonardo Hideaki Kume
Data.....:              21/12/2016
Descricao / Objetivo:   
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MT040DEL()

	If findfunction("U_MGFFAT23")
		U_MGFFAT23(.T.)
	Endif

return .T.