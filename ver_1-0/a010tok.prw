#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: A010TOK
Autor...............: Marcelo Carneiro
Data................: 30/11/2016 
Descricao / Objetivo: Integracao 
Doc. Origem.........: Contrato GAPS - MIT044- Cadastro de Fornecedores
Solicitante.........: Cliente
Uso.................: 
Obs.................: Ponto de Entrada no final do cadastro de Fornecedores
=====================================================================================
*/
                           

User Function A010TOK

Local lRet := .T.

If ALTERA

	SB1->(Dbseek(xFilial("SB1")+M->B1_COD))

EndIf

// valida campos para integracao do Taura
If FindFunction("U_TAC05A010TOK")
	lRet := U_TAC05A010TOK()
Endif		

IF findfunction("U_MGFEST65") 
	lRet := U_MGFEST65()
EndIf

If lRet
	IF findfunction("U_MGFINT38") 
		lRet := U_MGFINT38('SB1','B1')  
	EndIF         
Endif	

// Marca para Integracao com Eletronico 
// 26/02/2020

If lRet
	
	IF findfunction("U_MGFINT75") 
		lRet := U_MGFINT75('SB1','B1')  
	EndIF         
Endif	


Return(lRet)
