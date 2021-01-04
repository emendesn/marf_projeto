#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"
#define CRLF chr(13) + chr(10)             
/*
============================================================================================
Programa.:              MGFTAE03
Autor....:              Marcelo Carneiro         
Data.....:              20/10/2016 
Descricao / Objetivo:   Integração TAURA - ENTRADAS
Doc. Origem:            Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Ponto de Entrada MT120ALT para não permitir alterar pedido do Taura
============================================================================================
*/


User Function MGFTAE03()
Local lExecuta := .T.

If isInCallStack("U_TAE02_ALT")
   Return lExecuta
Endif

If FunName() == 'MATA121' .And. (Paramixb[1] == 4 .OR. Paramixb[1] == 5) 
	dbSelectArea('SC7')
	If SC7->C7_ZTIPO  ==  '2'
		MsgAlert(FunName() +'Este Pedido foi integrado via Taura, não é possivel Alterar/Excluir')
		lExecuta := .F.
	EndIf
EndIf

Return lExecuta  