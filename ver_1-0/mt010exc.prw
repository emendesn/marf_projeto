#include 'protheus.ch'
#include 'parmtype.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MT010INC
Autor....:              Gustavo Ananias Afonso
Data.....:              24/10/2016
Descricao / Objetivo:   
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              http://tdn.totvs.com/pages/releaseview.action?pageId=6087685
=====================================================================================
*/
user function MT010EXC()

// envia fornecedor para Taura
If FindFunction("U_TAC05EXCMT010")
	U_TAC05EXCMT010()
Endif		

	If findfunction("U_MGFFAT19")
		U_MGFFAT19()
	Endif

return
