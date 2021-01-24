#include "protheus.ch"

/*
============================================================================================
Programa.:              MT125LOK
Autor....:              Mauricio Gresele
Data.....:              Agosto/2017 
Descricao / Objetivo:   
Doc. Origem:            Marfrig
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Ponto de Entrada para validar a linha do contrato de parceria
=============================================================================================
*/
User Function MT125LOK()

Local lRet := .T. 

If Findfunction("U_MGFEST33")
	 lRet := U_MGFEST33()                                                                  
Endif

If Findfunction("U_MGFCOM79")
	 lRet := U_MGFCOM79()                                                                  
Endif



Return(lRet)