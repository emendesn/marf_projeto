#INCLUDE "protheus.ch"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*
============================================================================================================================
Programa.:              FA070TIT 
Autor....:              Tarcisio Galeano        
Data.....:              03/2018                                                                                                            
Descricao / Objetivo:   Alterar carteira para permitir baixa
Doc. Origem:            Financeiro 
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              PE FINA070
============================================================================================================================
*/ 
user function F070ACONT()
 
LOCAL C_SIT :=SUBSTR(SE1->E1_MOTNEG,1,1)  


SE1->(RecLock("SE1",.F.))
 	SE1->E1_SITUACA  := C_SIT
 	SE1->E1_MOTNEG   := "   "
SE1->(MsUnlock())



return(.T.)

