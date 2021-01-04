#include 'protheus.ch'

#define CRLF chr(13) + chr(10)
/*
=====================================================================================
Programa.:              MT261TDOK
Autor....:              Marcelo de Almeida Carneiro
Data.....:              22/01/2019
Descricao / Objetivo:   
Doc. Origem:            GAP TAURA ENTRADA - PRODUCAO
Solicitante:            Cliente
Uso......:              Marfrig
=====================================================================================
*/
User Function MT261TDOK(aParam)
                            
If isInCallStack("U_MGFTAP20")
	If FindFunction("U_TAP20_CP")
		U_TAP20_CP()                    
	Endif    
EndIF

Return