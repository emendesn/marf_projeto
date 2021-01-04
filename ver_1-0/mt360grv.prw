#include 'protheus.ch'
#include 'parmtype.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MT360GRV
Autor....:              Gustavo Ananias Afonso
Data.....:              25/10/2016
Descricao / Objetivo:   
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              http://tdn.totvs.com/display/public/PROT/MT360GRV
=====================================================================================
*/
user function MT360GRV()

	If findfunction("U_MGFFAT24")
		U_MGFFAT24()
	endif

return