#include "protheus.ch"

/*
=====================================================================================
Programa.:              MT103MSD
Autor....:              Totvs
Data.....:              Fev/2018 
Descricao / Objetivo:   Compras
Doc. Origem:            Compras
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Ponto de entrada para excluir a amarracao com os conhecimentos, no estorno da classificacao da nota de entrada
=====================================================================================
*/                                                            '
// este ponto de entrada nao estah sendo utilizado para a finalidade que ele foi criado ( de atualizar os conhecimentos relacionados a nota ),
// mas como ele somente eh executado no estorno da classificacao da nota de entrada,
// estah sendo utilizado para um tratamento no controle da aprovacao de documentos ( SCR ).
User Function MT103MSD()

Local lRet := .T.

// excluir bloqueio por divergencia de valor total da NFE
IF FindFunction("U_MGFCOM74")
	U_MGFCOM74()
EndIF

Return(lRet)