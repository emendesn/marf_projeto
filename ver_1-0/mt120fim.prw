#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#define CRLF chr(13) + chr(10)
/*
=====================================================================================
Programa.:              MT120FIM
Autor....:              Marcelo Carneiro
Data.....:              20/10/2016
Descricao / Objetivo:   Integração TAURA - ENTRADAS
Doc. Origem:            Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Ponto de entrada MT120FIM salvar dados no Pedido de Compra
=====================================================================================
*/
User Function MT120FIM

	Local nOpx   := PARAMIXB[1]	// Opção Escolhida pelo usuario 
	Local cNumPc := PARAMIXB[2]	// Numero do Pedido de Compras
	Local nOpca  := PARAMIXB[3]	// Indica se a ação foi Cancelada = 0  ou Confirmada = 1

	If findfunction("U_MGFTAE05")
		U_MGFTAE05(PARAMIXB[1],PARAMIXB[2],PARAMIXB[3])
	Endif

    If Findfunction("U_MGFCOM48")
		U_MGFCOM48(cNumPc)
    Endif

	If FindFunction("U_xMG8FIM")
		U_xMG8FIM(cNumPc,nOpx,nOpca)
	EndIf

	If FindFunction("U_MGFEEC70")
		U_MGFEEC70( cNumPc , nOpx , nOpca )
	EndIf

	If FindFunction("U_EIC09EXC")	//RVBJ
		U_EIC09EXC( cNumPc , nOpx , nOpca )
	EndIf
Return