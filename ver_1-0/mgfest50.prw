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
Uso......:              Marfrig
==========================================================================================================
*/
User Function MGFEST50()

lRet := .T.
nOpcap := PARAMIXB

if inclui
	RecLock("SCP",.F.)
		SCP->CP_SOLICIT := CSOLIC
	SCP->(MsUnLock())            
endif


Return lRet

