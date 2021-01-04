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
User Function MGFEST48()

lRet := .T.
nOpcap := PARAMIXB


If Altera                              
	cSolicit 	:= SUBSTR(UsrFullName(RETCODUSR()),1,25)

	if CSOLIC <>  cSolicit
		msgalert("Nao permitido Alterar S.As de outro Solicitante/Requisitante")
	    lRet := .F.
	endif
Endif



Return lRet

