/*
=====================================================================================
Programa.:              FA060TRF
Autor....:              Atilio Amarilla
Data.....:              22/12/2017
Descricao / Objetivo:   PE acionado na transferencia de titulo - bloqueia titulo FIDC
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              PE rotina FINA060
=====================================================================================
*/
User Function FA060TRF()

Local lRet := .T.

//������������������������������������������������������������������������Ŀ
//�GAP 19_20_21 FIDC - Bloqueia transferencia de titulos FIDC              �
//��������������������������������������������������������������������������
If ExistBlock("MGFFIN70")
	lRet := U_MGFFIN70()
EndIf

Return lRet