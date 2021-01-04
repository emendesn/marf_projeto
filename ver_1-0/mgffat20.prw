#include 'protheus.ch'
#include 'parmtype.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFFAT20
Autor....:              Gustavo Ananias Afonso
Data.....:              24/10/2016
Descricao / Objetivo:   Apos a alteracao do produto atualiza status de instegracao para SFA se for elegivel
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
user function MGFFAT20()

	if SB1->B1_XSFA == "S"
		recLock("SB1", .F.)
			SB1->B1_XINTEGR := "P"
		SB1->(msUnLock())
	endif
	
return