/*
=====================================================================================
Programa.:              F590COK
Autor....:              Atilio Amarilla
Data.....:              22/12/2017
Descricao / Objetivo:   PE acionado na manuten��o de bordero - exclus�o
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              PE rotina FINA590
=====================================================================================
*/
User Function F590COK()

Local lRet := .T.

//������������������������������������������������������������������������Ŀ
//�GAP 19_20_21 FIDC - Bloqueia exclus�o de t�tulos FIDC de borderos       �
//��������������������������������������������������������������������������
If ExistBlock("MGFFIN70") .And. ParamIXB[1] == "R"
	lRet := U_MGFFIN70()
EndIf

If !lRet
	DisarmTransaction()
EndIf

Return lRet