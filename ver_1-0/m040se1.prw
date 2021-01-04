#include 'protheus.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              M040SE1
Autor....:              Barbieri
Data.....:              10/02/2017
Descricao / Objetivo:   
Doc. Origem:            GAP CRE25
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
user function M040SE1()

If FindFunction("U_SEGMSE1") 
	U_SEGMSE1()
Endif
	
return