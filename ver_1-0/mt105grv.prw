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
User Function MT105GRV()

If Findfunction("U_MGFEST50")
	 lRet := U_MGFEST50()                                                                  
Endif

Return(lRet) 