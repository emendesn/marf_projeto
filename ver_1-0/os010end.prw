#include 'protheus.ch'
#include 'parmtype.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              OS010END
Autor....:              Gustavo Ananias Afonso
Data.....:              24/10/2016
Descricao / Objetivo:   
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              
Obs......:              http://tdn.totvs.com/pages/releaseview.action?pageId=6091350
=====================================================================================
*/
user function OS010END()

	If findfunction("U_MGFFAT20")
		U_MGFFAT20()
	Endif

return
