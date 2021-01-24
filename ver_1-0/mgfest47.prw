#include "totvs.ch"
#include "protheus.ch"

/*
==========================================================================================================
Programa.:              MT105SCR
Autor....:              Tarcisio Galeano         
Data.....:              11/2018 
Descricao / Objetivo:   Tratamento solicit. armazem                        
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
==========================================================================================================
*/
User Function MGFEST47()

lRet 		:= .T.


If Inclui                              
	cSolic 	:= SUBSTR(UsrFullName(RETCODUSR()),1,25)
Endif

If Altera                              
	cSolicit 	:= SUBSTR(UsrFullName(RETCODUSR()),1,25)

	if CSOLIC <>  cSolicit
		msgalert("Não permitido Alterar S.As de outro Solicitante/Requisitante")
	    lRet := .F.
	endif
Endif


Return lRet


