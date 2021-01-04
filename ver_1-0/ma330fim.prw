#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
/*
==========================================================================================================
Programa.:              MA330FIM
Autor....:              Tarcisio Galeano         
Data.....:              09/11/2018 
Descricao / Objetivo:   Sinalizar o termino do processamento de custo                        
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
==========================================================================================================
*/
User Function MA330FIM()

Local lRet := .T.

If FindFunction("U_MGFEST54")
	lRet := U_MGFEST54()
Endif	

Return(lRet)