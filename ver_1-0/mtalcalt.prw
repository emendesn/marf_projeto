#include "protheus.ch"

/*
=====================================================================================
Programa.:              MTALCALT
Autor....:              Totvs
Data.....:              Fev/2018 
Descricao / Objetivo:   Compras
Doc. Origem:            Compras
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Ponto de Entrada para gravacao complementar na inclusao do documento de bloqueio do SCR
=====================================================================================
*/
User Function MTALCALT()

IF FindFunction("U_MGFCOM76")
	U_MGFCOM76()
EndIF

Return()