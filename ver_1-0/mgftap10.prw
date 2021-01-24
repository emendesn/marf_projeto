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

//������������������������������������������������������������������������Ŀ
//�GAP TAURA                                                               �
//�Integra��o PROTHEUS x Taura - Processos Produtivos                      �
//�Verifica se a Ordem de Producao possui saldo em processo.               �
//�Padr�o: informa saldo em processo (req c/ D3_EMISSAO > �ltimo apontam.) �
//��������������������������������������������������������������������������
Local lRet := GetMv("MGF_TAP10A",,.T.)

Return lRet