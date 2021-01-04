/*
=====================================================================================
Programa.:              MGFGCT14
Autor....:              Atilio Amarilla
Data.....:              03/10/2017
Descricao / Objetivo:   Inclusao de campos na consulta de contratos, F3.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              Chamado por PE CN120CMP, rotina CNTA120.
=====================================================================================
*/
User Function MGFGCT14()

Local aArea	:= SX3->( GetArea() )
//������������������������������������������������������������������������Ŀ
//�GAP 75_82 - Incluir campo para nome de fornecedor na consulta F3        �
//��������������������������������������������������������������������������
SX3->( MsSeek("CN9_ZNOME") )

AAdd(ParamIXB[1],x3Titulo())
Aadd(ParamIXB[2],{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})

SX3->( RestArea( aArea ) )

Return ParamIXB