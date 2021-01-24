#include "protheus.ch"
#include "totvs.ch"

/*
===========================================================================================
Programa.:              EAE100MNU
Autor....:              Flávio Dentello
Data.....:              Nov/2016
Descricao / Objetivo:   Ponto de entrada chamado na Manutencao de Embarques de processos de exportacao
 						para inclusão de botões nas ações relacionadas
Doc. Origem:            EEC07
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/

User Function EAE100MNU()
Local aBotao := {}

	If findfunction("u_EEC07")
		u_EEC07(@aBotao)
	End

	If findfunction("U_EEC15A")
		U_EEC15A(@aBotao)
	End
	If findfunction("U_fAddBTN")
		U_fAddBTN(@aBotao)
	End
	If findfunction("U_EEC18A")
		U_EEC18A(@aBotao)
	End
	If findfunction("U_EEC28A")
		U_EEC28A(@aBotao)
	End

Return(@aBotao)       


