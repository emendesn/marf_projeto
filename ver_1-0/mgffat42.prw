#include 'protheus.ch'
#include "topconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM42
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              11/07/2017
Descricao / Objetivo:   Bloquear execucao dos gatilhos para o campo de valor nos pedido de retorno de beneficiamento
Doc. Origem:           
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MGFFAT42(cSequen)
	local lRet		:= .T.
	local nPosCF	:= aScan( aHeader, { |x| allTrim( x[2] ) == "C6_CF" } )

	if ( subStr( acols[ n, nPosCF ], 1, 2 ) == "59" .or. subStr( acols[ n, nPosCF ], 1, 2 ) == "69" )
		lRet := .F.
	endif

	//if cSequen == "002" .or. cSequen == "003"
		lRet := ( !isInCallStack("U_XEXEC") .and. lRet )
	//endif

return lRet