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
User Function A105DELOK()

If Findfunction("U_MGFEST49")
	 lRet := U_MGFEST49()                                                                  
Endif

Return(lRet) 