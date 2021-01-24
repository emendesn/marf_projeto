#include 'Protheus.ch'

/*
=====================================================================================
Programa............: MA650ENOT
Autor...............: Gresele
Data................: Nov/2017
Descrição / Objetivo: Ponto de entrada apos exclusao da OP, fora da transacao
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MA650ENOT()
//ExecBlock("MA650ENOT",.F.,.F.,{cNum,cItem,cSeq})

If FindFunction("U_MGFEST34")
	U_MGFEST34()
Endif

Return()