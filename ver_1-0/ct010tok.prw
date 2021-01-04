/*
=====================================================================================
Programa............: CT010TOK
Autor...............: Renato V.B.Jr
Data................: 15/05/2020
Descricao / Objetivo: PE para confirmar alteracoes no Calendario Contabil
Doc. Origem.........: RTASK0011088
Solicitante.........: Cliente
Uso.................: 
=====================================================================================
*/
#include "Protheus.ch"

User Function CT010TOK()

If ParamIXB[1]	==	4	.and.	Findfunction('U_MGFCTB28')
	U_MGFCTB28()
EndIf

Return .T.
