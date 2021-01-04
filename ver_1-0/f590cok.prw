/*
=====================================================================================
Programa.:              F590COK
Autor....:              Atilio Amarilla
Data.....:              22/12/2017
Descricao / Objetivo:   PE acionado na manutencao de bordero - exclusao
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              PE rotina FINA590
=====================================================================================
*/
User Function F590COK()

Local lRet := .T.

//������������������������������������������������������������������������Ŀ
//�GAP 19_20_21 FIDC - Bloqueia exclusao de titulos FIDC de borderos       �
//��������������������������������������������������������������������������
If ExistBlock("MGFFIN70") .And. ParamIXB[1] == "R"
	lRet := U_MGFFIN70()
EndIf

If !lRet
	DisarmTransaction()
EndIf

Return lRet