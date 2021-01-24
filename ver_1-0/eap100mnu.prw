#include "protheus.ch"

/*
===========================================================================================
Programa.:              EAP100MNU
Autor....:              Leonardo Kume
Data.....:              Out/2016
Descricao / Objetivo:   Ponto de entrada chamado no Pedido de Exportação
para inclusão de botões nas ações relacionadas
Doc. Origem:            EEC03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/

User Function EAP100MNU() 

	Local aBotao := {}

	If findfunction("U_EEC15A")
		U_EEC15A(@aBotao)
	End


Return(aBotao)