#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
=====================================================================================
Programa............: M290QSD2
Autor...............: Tarcisio Galeano
Data................: 10/2018
Descri��o / Objetivo: Ponto de entrada consumo m�dio para atender Sr. Amauri
Doc. Origem.........:
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/

User Function M290QSD3()

Local cQuery := ' '

cQuery := " AND D3_CF IN ('RE1','RE5','RE0') "


RETURN cQuery 


