#include "totvs.ch"
#include "protheus.ch"

/*
==========================================================================================================
Programa.:              MT105FIM
Autor....:              Wagner Neves
Data.....:              05/2020
Descricao / Objetivo:   Tratamento solicit. armazem                        
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
==========================================================================================================
*/
User Function MT105FIM()

If Findfunction("U_MGFEST70")
	 lRet := U_MGFEST70()                                                             
Endif

Return(lRet) 