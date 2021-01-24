#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM11
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              03/04/2017
Descricao / Objetivo:   Habilita a tecla F4 para amarracao da senha do RAMI
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MGFCRM11(aRet)
	default aRet := {}

	SetKey( VK_F4, { || U_MGFCRM12()  } ) // Relacao de RAMI anterior
	SetKey( VK_F2, { || U_MGFCRM52()  } ) // Relacao de RAMI nova

	aadd(aRet, "D1_ZRAMI")

	aadd(aRet, "D1_ZCODMOT")
	aadd(aRet, "D1_ZDESCMO")
	aadd(aRet, "D1_ZCODJUS")
	aadd(aRet, "D1_ZDESCJU")

	aadd(aRet, "D1_PRODESC")

return aRet
