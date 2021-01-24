#include "protheus.ch"

/*
=====================================================================================
Programa............: M4601DUP()
Autor...............: Totvs
Data................: Março/2018 
Descricao / Objetivo: Este ponto de entrada é executado uma unica vez para cada documento de saída que gere títulos a receber ( Tipo: NF).
					  Ele possibilita a alteração do número da primeira parcela dos títulos. As demais serão uma sequência alfanúmerica destes.
Doc. Origem.........: Financeiro
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function M4601DUP()

// todo titulo deve ser iniciado com a parcela 1
Return(StrZero(1,Len(SE1->E1_PARCELA)))