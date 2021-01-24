/*
=====================================================================================
Programa............: CT010TOK
Autor...............: Renato V.B.Jr
Data................: 15/05/2020
Descri��o / Objetivo: PE para confirmar altera��es no Calendario Contabil
Doc. Origem.........: RTASK0011088
Solicitante.........: Cliente
Uso.................: Marfrig
=====================================================================================
*/
#include "Protheus.ch"

User Function CT010TOK()

If ParamIXB[1]	==	4	.and.	Findfunction('U_MGFCTB28')
	U_MGFCTB28()
EndIf

Return .T.
