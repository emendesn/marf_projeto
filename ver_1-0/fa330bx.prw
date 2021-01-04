#include "protheus.ch"

/*
=====================================================================================
Programa.:              MGFFIN84
Autor....:              Totvs
Data.....:              Marco/2018
Descricao / Objetivo:   Funcao chamada pelo ponto de entrada F330SE5
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
User Function FA330BX()

If FindFunction("U_MGFFIN84")
	U_MGFFIN84()
Endif	

If FindFunction("U_MGFFINX5")
	U_MGFFINX5()
Endif	
	
Return
 	  