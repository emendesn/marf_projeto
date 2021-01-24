#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: MA010BUT
Autor...............: Marcelo Carneiro
Data................: 23/06/2017 
Descricao / Objetivo: Integração 
Doc. Origem.........: CAD04 - Cadastro de Produto para monstrar msg
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ponto de Entrada para cadastrar botao
=====================================================================================
*/

User Function MA010BUT

IF findfunction("U_MGFINT38") 
    U_MGF38_CDM('SB1','B1')
EndIF

Return 