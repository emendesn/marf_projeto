/*
=====================================================================================
Programa.:              CN120ESY
Autor....:              Atilio Amarilla
Data.....:              03/10/2017
Descricao / Objetivo:   PE acionado na consulta de contratos, F3.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              PE rotina CNTA120.
=====================================================================================
*/
User Function CN120ESY()

Local cQuery := ParamIXB[1]

//������������������������������������������������������������������������Ŀ
//�GAP 75_82 - Alteracao de query para inclusao de nome de fornecedor      �
//��������������������������������������������������������������������������
If ExistBlock("MGFGCT15")
	cQuery := U_MGFGCT15(cQuery)
EndIf

Return( cQuery )