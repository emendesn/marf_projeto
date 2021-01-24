#include "protheus.ch"

/*
=====================================================================================
Programa............: M521DNFS
Autor...............: Mauricio Gresele
Data................: 18/11/2016 
Descricao / Objetivo: Ponto de entrada apos a exclusao do documento de saida
Doc. Origem.........: Protheus-Taura Saida
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function M521DNFS()

// desfaz bloqueio de residuo dos itens bloqueados como residuo depois do faturamento
/*If FindFunction("U_MGFFAT28")
	U_MGFFAT28()
Endif*/

// FIS45 Taura
If FindFunction("U_MGFFAT49")
	U_MGFFAT49()
Endif

Return()