/*
=====================================================================================
Programa.:              MA261D3
Autor....:              Atilio Amarilla
Data.....:              24/11/2016
Descricao / Objetivo:   PE chamado ap�s grava��o da transfer�ncia mod.2 (MATA261)
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
User Function MA261D3()

//������������������������������������������������������������������������Ŀ
//�GAP TAURA                                                               �
//�Integra��o PROTHEUS x Taura - Processos Produtivos                      �
//�Envio de quantidade transferida ao armaz�m produtivo                    �
//��������������������������������������������������������������������������
If ExistBlock("MGFTAP11")
	U_MGFTAP11()
EndIf

Return