#include "protheus.ch"

/*
=====================================================================================
Programa.:              MT094LEG
Autor....:              Totvs
Data.....:              Fev/2018 
Descricao / Objetivo:   Compras
Doc. Origem:            Compras
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Ponto de Entrada para alterar a legenda da tela de liberacao de documentos
=====================================================================================
*/                                                            '
User Function MT094LEG()

Local aLegenda := Paramixb[1] 

IF FindFunction("U_MGFCOM75")
	aLegenda := U_MGFCOM75()
EndIF

Return(aLegenda)