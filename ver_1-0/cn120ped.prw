#include "totvs.ch"
#include "protheus.ch"
#include 'parmtype.ch'
/*
===========================================================================================
Programa.:              CN120PED
Autor....:              Tarcisio Galeano
Data.....:              Dez/2018
Descricao / Objetivo:   P.E. medição gerando pedido de compras - salvar obs
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/

User function CN120PED()
Local lret := "" 

If Findfunction("U_MGFEST58")
	 lRet := U_MGFEST58()                                                                  
Endif

Return lret 
    
