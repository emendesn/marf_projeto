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
User Function MGFEST49()

	Local lRet 	   := .T.
	Local _lEst76  := .F.
	Local _lFilaut := ''
	Local _lEst76  := GetMv("MGF_EST76A")   // Ativa ou n�o execu��o da rotina
	Local _lFilAut := GetMv("MGF_EST76F")  

	cSolicit 	:= SUBSTR(UsrFullName(RETCODUSR()),1,25)
	if CSOLIC <>  cSolicit
		msgalert("[MGFEST49] N�o permitido Excluir S.As de outro Solicitante/Requisitante")
	    lRet := .F.
	endif
	
	If _lEST76	// Tratamento Embalagem		
		if SB1->B1_TIPO == "EM" 
			iF ! cFilAnt $_lFilAut
				IF SCP->CP_ZSTATUS == "07"
					msgalert("[MGFEST49] N�o permitido exclus�o. Esta solicita��o est� em aprova��o pelo gerente Industrial","Exclus�o N�o Permitida")
					lRet := .F.
				endif
			endif
		endif
	endif
Return lRet

