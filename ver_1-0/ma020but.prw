#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: MA020BUT
Autor...............: Marcelo Carneiro
Data................: 23/06/2017 
Descricao / Objetivo: Integracao 
Doc. Origem.........: CAD04 - Cadastro de Fornecedor para monstrar msg
Solicitante.........: Cliente
Uso.................: 
Obs.................: Ponto de Entrada para cadastrar botao
=====================================================================================
*/

User Function MA020BUT

IF findfunction("U_MGFINT38") 
    U_MGF38_CDM('SA2','A2')
EndIF

Return 