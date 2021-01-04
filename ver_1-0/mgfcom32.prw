#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
 
#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM12
Autor....:              TOTVS
Data.....:              06/06/2017
Descricao / Objetivo:   Inicializador do campo de descricao do produto na prenota MATA140 e doc de entrada MATA103
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
user function MGFCOM32(nItem)
	
GdFieldPut( "D1_PRODESC" , GetAdvFVal("SB1", "B1_DESC", xFilial("SB1") + GDFieldGet("D1_COD",nItem) , 1 , "" ) , nItem )

Return