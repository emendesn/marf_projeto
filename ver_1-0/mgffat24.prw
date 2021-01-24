#include 'protheus.ch'
#include 'parmtype.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFFAT24
Autor....:              Gustavo Ananias Afonso
Data.....:              25/10/2016
Descricao / Objetivo:   
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MGFFAT24()
	if SE4->E4_XSFA == "S"
		recLock("SE4", .F.)
			SE4->E4_XINTEGR	:= "P"
		SE4->(msUnLock())
	endif
return