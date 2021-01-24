#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: OM040BRW
Autor...............: Marcelo Carneiro
Data................: 10/10/2017
Descricao / Objetivo: Inclusão da Base de Conhecimento no cadastro de Motorista 
Doc. Origem.........: MIT044- Alteração na Grade do CDM
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Inclui botão no browse principal.
=====================================================================================
*/

User Function OM040BRW
Local aRot := {}
           
AAdd( aRot, { 'Conhecimento', "MsDocument('DA4',DA4->(RecNo()),4)", 0, 4 } )
AAdd( aRot, { 'Log Conhecimento',"U_MGFINT66('DA4')", 0, 2 } )  

Return aRot