#Include 'Protheus.ch'

/*
==========================================================================================
Programa.:              EECAC100
Autor....:              Leonardo Kume
Data.....:              Nov/2016
Descricao / Objetivo:   Ponto de entrada para adicionar botão nas ações relacionadas do 
						cadastro do cliente
Doc. Origem:            EEC03
Solicitante:            Cliente
Uso........:            Marfrig
Historico..:            Em 06/07/20 RVBJ - Ajustei para padrao Marfrig
==========================================================================================
*/
User Function EECAC100()

If Findfunction("U_MGFEEC2A")
	U_MGFEEC2A()
Endif

If Findfunction("U_EEC83ADIAN")
	U_EEC83ADIAN()                                                                  
Endif

Return

