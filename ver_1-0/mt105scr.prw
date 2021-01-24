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
User Function MT105SCR(nOpcx)

If Findfunction("U_MGFEST47")
	 lRet := U_MGFEST47()                                                                  
Endif

Return(lRet)




