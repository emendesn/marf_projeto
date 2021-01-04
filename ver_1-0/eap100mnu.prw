#include "protheus.ch"

/*
===========================================================================================
Programa.:              EAP100MNU
Autor....:              Leonardo Kume
Data.....:              Out/2016
Descricao / Objetivo:   Ponto de entrada chamado no Pedido de Exportacao
para inclusao de botoes nas acoes relacionadas
Doc. Origem:            EEC03
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/

User Function EAP100MNU() 

	Local aBotao := {}

	If findfunction("U_EEC15A")
		U_EEC15A(@aBotao)
	End


Return(aBotao)