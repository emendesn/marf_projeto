#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: MA050PRE
Autor...............: Marcelo Carneiro
Data................: 23/06/2017 
Descricao / Objetivo: Integração 
Doc. Origem.........: CAD04 - Cadastro de Transportadora para monstrar msg
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ponto de Entrada antes de alterar
=====================================================================================
*/
User Function MA050PRE()
 
Local _nOpc := PARAMIXB     //3- Inclusão, 4- Alteração e 5- Exclusão
 
If _nOpc == 4
	IF findfunction("U_MGFINT38") 
	    U_MGF38_CDM('SA4','A4')
	EndIF
EndIf
 
Return Nil


