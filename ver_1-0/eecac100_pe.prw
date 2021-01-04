#Include 'Protheus.ch'

/*
==========================================================================================
Programa.:              MA030BUT
Autor....:              Leonardo Kume
Data.....:              Nov/2016
Descricao / Objetivo:   Ponto de entrada para adicionar botao nas acoes relacionadas do 
  						cadastro do cliente
Doc. Origem:            EEC03
Solicitante:            Cliente
Uso......:              
==========================================================================================
*/


User Function EECAC100()

Local aBotao := {} 

u_MGFEEC2A(@aBotao)


Return aBotao

