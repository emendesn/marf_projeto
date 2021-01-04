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

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁGAP TAURA                                                               Ё
//ЁIntegraГЦo PROTHEUS x Taura - Processos Produtivos                      Ё
//ЁVerifica se a Ordem de Producao possui saldo em processo.               Ё
//ЁPadrЦo: informa saldo em processo (req c/ D3_EMISSAO > Зltimo apontam.) Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local lRet := GetMv("MGF_TAP10A",,.T.)

Return lRet