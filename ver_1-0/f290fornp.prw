#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
 
#define CRLF chr(13) + chr(10)
                                           
/*
=====================================================================================
Programa.:              F290FORNP
Autor....:              TOTVS
Data.....:              25/05/2017
Descricao / Objetivo:   
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/	
user function F290FORNP()
	local lRet	:= .F.

	If FindFunction("U_MGFFIN55")
		U_MGFFIN55()
	endif

return lRet