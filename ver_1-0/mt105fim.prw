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
Observa��o: 			Esse ponto de entrada � executado ap�s a agrava��o dos dados na tabela SCP
==========================================================================================================
*/
User Function MT105FIM()

If Findfunction("U_MGFEST76") //EMABALAGENS
	 lRet := U_MGFEST76()                                                             
Endif

If Findfunction("U_MGFEST70") //EPI
	 lRet := U_MGFEST70()                                                             
Endif

Return(lRet) 