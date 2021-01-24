#include 'protheus.ch'
#include 'parmtype.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              F040DEL
Autor....:              Leonardo Kume
Data.....:              21/12/2016
Descricao / Objetivo:   PE na exclusão do Contas a Pagar
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function FA040DEL()

	If findfunction("u_MGFFAT22")
		u_MGFFAT22()
	Endif

return .T.