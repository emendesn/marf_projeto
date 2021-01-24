#include 'protheus.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MA040TOK
Autor....:              Gustavo Ananias Afonso
Data.....:              25/10/2016
Descricao / Objetivo:   
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              http://tdn.totvs.com/pages/releaseview.action?pageId=6784256
=====================================================================================
*/
user function MA040TOK()
Local lRet :=  .T.

	If findfunction("U_MGFFAT23")
		U_MGFFAT23()
	Endif
	IF findfunction("U_MGFINT38") 
		lRet := U_MGFINT38('SA3','A3')           
	EndIF

	

return lRet