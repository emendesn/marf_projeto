/*
=====================================================================================
Programa.:              MGFTAP10
Autor....:              Atilio Amarilla
Data.....:              01/12/2016
Descricao / Objetivo:   Chamado por PE A250SPRC.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              .T. - Permitir encerramento com saldos (requis.) em processo
=====================================================================================
*/
User Function MGFTAP10()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿒AP TAURA                                                               �
//쿔ntegra豫o PROTHEUS x Taura - Processos Produtivos                      �
//쿣erifica se a Ordem de Producao possui saldo em processo.               �
//쿛adr�o: informa saldo em processo (req c/ D3_EMISSAO > �ltimo apontam.) �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Local lRet := GetMv("MGF_TAP10A",,.T.)

Return lRet