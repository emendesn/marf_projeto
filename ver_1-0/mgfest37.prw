#include "protheus.ch"

/*
============================================================================================
Programa.:              MGFEST37
Autor....:              Tarcisio Galeano
Data.....:              Março/2018 
Descricao / Objetivo:   
Doc. Origem:            Marfrig
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Gatilho para não permitir movimentação de estoque com datas futuras 
=============================================================================================
*/
User Function MGFEST37()

LRET :=""
// MOV INT SIMPLES
IF FunName() == "MATA240"
	lRet:= M->D3_EMISSAO <=DDATABASE 
ENDIF
// MOV INT MULTIPLA e BAIXA SOLICIT ARMAZEM
IF FUNNAME() == "MATA241" .or. FUNNAME() == "MGFEST28"
	lRet:= DA241DATA<=DDATABASE 
ENDIF
// TRANSF SIMPLES
IF FUNNAME() == "MATA260"
	lRet:=	DEMIS260 <=DDATABASE 
ENDIF
// TRANSF MULTIPLA
IF FUNNAME() == "MATA261"
	lRet:=	DA261DATA <=DDATABASE 
endif

Return(lRet)