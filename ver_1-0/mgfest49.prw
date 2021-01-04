#include "totvs.ch"
#include "protheus.ch"

/*
==========================================================================================================
Programa.:              MT105GRV
Autor....:              Tarcisio Galeano         
Data.....:              11/2018 
Descricao / Objetivo:   Tratamento solicit. armazem                        
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
==========================================================================================================
*/
User Function MGFEST49()

lRet := .T.

	cSolicit 	:= SUBSTR(UsrFullName(RETCODUSR()),1,25)

	if CSOLIC <>  cSolicit
		msgalert("Nao permitido Excluir S.As de outro Solicitante/Requisitante")
	    lRet := .F.
	endif

Return lRet

