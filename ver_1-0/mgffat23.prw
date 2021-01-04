#include 'protheus.ch'
#include 'parmtype.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFFAT23
Autor....:              Gustavo Ananias Afonso
Data.....:              25/10/2016
Descricao / Objetivo:   
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
user function MGFFAT23(lDel)
	Default lDel := .F.
	If lDel
		if SA3->A3_XSFA == "S"
			recLock("SA3", .F.)
			SA3->A3_XINTEGR := "P"
			MsUnlock()
		endif
	Else
		if M->A3_XSFA == "S"
			M->A3_XINTEGR := "P"
		endif
	EndIf
return .t.