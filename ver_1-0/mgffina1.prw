#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#define CRLF chr(13) + chr(10)
/*
============================================================================================
Programa.:              MGFFINA1
Autor....:              Natanael Filho
Data.....:               12/04/2018
Descricao / Objetivo:    Realizar o desconto do FUNDESA no título do financeiro como solução paliativa até a liberação da Totvs. 
							Rotina acionada pelo ponto de entrada MT100GE2
Doc. Origem:            
Solicitante:            Carlos Amorim
Uso......:              
Obs......:               Rotina entrou em desuso no dia 02/05/2018, pois a Totvs lan�ou a solucao padrao na mesma data. Ticket 2607738
=============================================================================================
*/

//
User Function MGFFINA1()

Local nValFunds := SF1->F1_VALFUND
Local aCols   := PARAMIXB[1]
Local nOpc    := PARAMIXB[2]
Local aHeadSE2:= PARAMIXB[3]
Local nPosValor:=Ascan(aHeadSE2,{|x| Alltrim(x[2]) == 'E2_VALOR'})
Local nPosVarc :=Ascan(aHeadSE2,{|x| Alltrim(x[2]) == 'E2_PARCELA'})

If aCols[nPosValor]>0 .AND. (EMPTY(aCols[nPosVarc]) .OR. aCols[nPosVarc]== '01' )
	If nValFunds > 0 .AND. nOpc == 1 //.. inclusao
		If SE2->E2_VALOR > nValFunds
			SE2->E2_VALOR -= nValFunds
			SE2->E2_SALDO := SE2->E2_VALOR
			SE2->E2_VLCRUZ := SE2->E2_VALOR
		EndIf
	EndIf
EndIf

Return Nil