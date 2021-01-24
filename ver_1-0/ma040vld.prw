#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: MA040VLD
Autor...............: Marcelo Carneiro
Data................: 23/06/2017 
Descricao / Objetivo: Integra��o 
Doc. Origem.........: CAD04 - Cadastro de Vendedor para monstrar msg
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ponto de Entrada antes de alterar
=====================================================================================
*/
User Function MA040VLD()
                             
Local _nOpc := PARAMIXB     //3- Inclus�o, 4- Altera��o e 5- Exclus�o
Local _lRet := .T.
 
If _nOpc == 4
	IF findfunction("U_MGFINT38")
		U_MGF38_CDM('SA3','A3')
	EndIF
EndIf
 
Return _lRet

