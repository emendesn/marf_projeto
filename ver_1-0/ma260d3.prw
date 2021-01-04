/*
=====================================================================================
Programa.:              MA260D3
Autor....:              Atilio Amarilla
Data.....:              24/11/2016
Descricao / Objetivo:   PE chamado apos gravacao da transferencia (MATA260)
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
User Function MA260D3()

//������������������������������������������������������������������������Ŀ
//�GAP TAURA                                                               �
//�Integracao PROTHEUS x Taura - Processos Produtivos                      �
//�Envio de quantidade transferida ao armazem produtivo                    �
//��������������������������������������������������������������������������
If ExistBlock("MGFTAP11")
	U_MGFTAP11()
EndIf

Return