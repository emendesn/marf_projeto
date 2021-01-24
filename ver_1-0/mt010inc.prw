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
user function MT010INC()

//Garante que o produto continua posicionado
_npos := SB1->(Recno())

// na copia de produto, zera alguns campos do produto de origem
If findfunction("U_MGFEST43")
	U_MGFEST43()
Endif

SB1->(Dbgoto(_npos))

// valida campos para integracao do Taura
If FindFunction("U_TAC05MT010INC")
	U_TAC05MT010INC()
Endif

SB1->(Dbgoto(_npos))

If findfunction("U_MGFFAT19")
	U_MGFFAT19()
Endif


SB1->(Dbgoto(_npos))

//Essa função deve ser chamada antes das funções de grade de aprovação.
If findFunction("U_MGFFIS40")
		U_MGFFIS40(3) //1: Fornecedor / 2:Cliente / 3:Produto
EndIf

SB1->(Dbgoto(_npos))

IF findfunction("U_MGFINT39")
	U_MGFINT39(2,'SB1','B1_MSBLQL')
EndIF

SB1->(Dbgoto(_npos))

return

