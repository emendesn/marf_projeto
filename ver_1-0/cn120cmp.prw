/*
=====================================================================================
Programa.:              CN120CMP
Autor....:              Atilio Amarilla
Data.....:              03/10/2017
Descricao / Objetivo:   PE acionado na consulta de contratos, F3.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              PE rotina CNTA120.
=====================================================================================
*/
User Function CN120CMP()

Local aRet	:= ""
//������������������������������������������������������������������������Ŀ
//�GAP 75_82 - Incluir campo para nome de fornecedor na consulta F3        �
//��������������������������������������������������������������������������
If ExistBlock("MGFGCT14")
	aRet := U_MGFGCT14()
EndIf

Return aRet