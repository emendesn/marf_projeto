/*
=====================================================================================
Programa.:              MA261D3
Autor....:              Atilio Amarilla
Data.....:              24/11/2016
Descricao / Objetivo:   PE chamado após gravação da transferência mod.2 (MATA261)
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
User Function MA261D3()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GAP TAURA                                                               ³
//³Integração PROTHEUS x Taura - Processos Produtivos                      ³
//³Envio de quantidade transferida ao armazém produtivo                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("MGFTAP11")
	U_MGFTAP11()
EndIf

Return