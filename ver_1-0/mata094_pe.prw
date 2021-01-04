#include "Protheus.ch"
#include "FWMVCDEF.ch"

/*
=====================================================================================
Programa............: MATA094
Autor...............: Totvs
Data................: 02/02/2018 
Descricao / Objetivo: Compras 
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: 
Obs.................: Ponto de Entrada na rotina padrao de liberacao de documentos ( MVC )
=====================================================================================
*/
User Function MATA094()

Local uRet := .T.

If FindFunction("U_MGFCOM69")
	uRet := U_MGFCOM69()
Endif		                       

Return(uRet)

