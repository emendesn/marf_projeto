#include "protheus.ch"

/*
==========================================================================================
Programa.:              MT100AG
Autor....:              Totvs
Data.....:              Jun/2018
Descricao / Objetivo:   Ponto de entrada para gravacao complementar no documento de entrada
Pedido Exportacao
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
==========================================================================================
*/
User Function MT100AG()

If FindFunction("U_MGFCOM86")
	U_MGFCOM86()
Endif	

Return()