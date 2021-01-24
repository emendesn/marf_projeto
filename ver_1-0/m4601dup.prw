#include "protheus.ch"

/*
=====================================================================================
Programa............: M4601DUP()
Autor...............: Totvs
Data................: Mar�o/2018 
Descricao / Objetivo: Este ponto de entrada � executado uma unica vez para cada documento de sa�da que gere t�tulos a receber ( Tipo: NF).
					  Ele possibilita a altera��o do n�mero da primeira parcela dos t�tulos. As demais ser�o uma sequ�ncia alfan�merica destes.
Doc. Origem.........: Financeiro
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function M4601DUP()

// todo titulo deve ser iniciado com a parcela 1
Return(StrZero(1,Len(SE1->E1_PARCELA)))