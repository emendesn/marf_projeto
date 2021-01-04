#include "Protheus.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
/*
=====================================================================================
Programa............: MT130WF
Autor...............: Roberto Sidney
Data................: 23/09/2016
Descricao / Objetivo: Ponto de entrada no final da cota��o - Efetua a chamada da fun��o MGFCOM01 -Workflow de aprova��o
Doc. Origem.........: COM01 - GAP MGCOM01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Envio de Workflow de cota��o aos fornecedores
=====================================================================================
*/

User Function MT130WF(oProcess)

	If findfunction("U_MGFCOM01")
		U_MGFCOM01(IIF(!IsBlind(),1,2),PARAMIXB[1],oProcess)
	Endif

Return
