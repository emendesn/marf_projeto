#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"
             
/*
============================================================================================
Programa.:              MT116AGR 
Autor....:              Flavio Dentello         
Data.....:              12/06/2018 
Descricao / Objetivo:   Grava dados do CTB32
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=============================================================================================
*/ 
User Function MT116AGR 
 
If Isincallstack('GFEA065')
	If Findfunction("U_xGFE0654")
		U_xGFE0654()                                                                  
	Endif
EndIf

Return 