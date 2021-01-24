#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"
#define CRLF chr(13) + chr(10)             
/*
============================================================================================
Programa.:              MGFALME
Autor....:              Anderson Reis   
Data.....:              21/10/2019 
Descricao / Objetivo:   Integração PROTHEUS - MERCADO ELETRÔNICO
Doc. Origem:            Contrato Compras
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Ponto de Entrada MT120ALT para não permitir alterar pedido do ME
                        !Empty(SC7->C7_ZPEDME)
============================================================================================
*/


User Function MGFALTME()
Local lExecuta := .T.
Local cusers   := Getmv("MGF_MEFINA")


If FunName() == 'MATA121' .And. (Paramixb[1] == 4 .OR. Paramixb[1] == 5 .OR. Paramixb[1] == 9)  
	
	If  ! Empty(SC7->C7_ZPEDME)
		If Alltrim(cusername) $ alltrim(cusers) .and. FunName() == 'MATA121' .And. Paramixb[1] == 4 
			
			return .t.
		Else
			MsgAlert(FunName() +'Este Pedido foi integrado via Mercado Eletronico (ME), não é possivel Alterar/Excluir/Copiar')
			lExecuta := .F.
		endif
	EndIf
EndIf

Return lExecuta  