#include "protheus.ch"

/*
=====================================================================================
Programa............: M4601DUP()
Autor...............: Totvs
Data................: Marco/2018 
Descricao / Objetivo: Este ponto de entrada � executado uma unica vez para cada documento de saida que gere titulos a receber ( Tipo: NF).
					  Ele possibilita a alteracao do numero da primeira parcela dos titulos. As demais serao uma sequ�ncia alfan�merica destes.
Doc. Origem.........: Financeiro
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/
User Function M4601DUP()

// todo titulo deve ser iniciado com a parcela 1
Return(StrZero(1,Len(SE1->E1_PARCELA)))