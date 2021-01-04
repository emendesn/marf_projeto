#include 'protheus.ch'
#include 'parmtype.ch'


/*
=====================================================================================
Programa.:              EICPPO01
Autor....:              Leo Kume
Data.....:              19/10/2016
Descricao / Objetivo:   Ponto de Entrada para filtrar o despachante logado
Doc. Origem:            Easy Import Control - GAP EIC07
Solicitante:            Cliente
Uso......:              
Obs......:              Ponto de entrada padrao MVC EICPPO01                   
=====================================================================================
*/

user function EICPPO01()

If findfunction("U_MGFEIC01")
	U_MGFEIC01() //Progama para filtrar Purchase Order (P.O) do Despachante logado
Endif
return