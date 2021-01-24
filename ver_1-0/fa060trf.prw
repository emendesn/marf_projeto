/*
=====================================================================================
Programa.:              FA060TRF
Autor....:              Atilio Amarilla
Data.....:              22/12/2017
Descricao / Objetivo:   PE acionado na transfer�ncia de t�tulo - bloqueia t�tulo FIDC
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              PE rotina FINA060
=====================================================================================
*/
User Function FA060TRF()

Local lRet := .T.

//������������������������������������������������������������������������Ŀ
//�GAP 19_20_21 FIDC - Bloqueia transfer�ncia de t�tulos FIDC              �
//��������������������������������������������������������������������������
If ExistBlock("MGFFIN70")
	lRet := U_MGFFIN70()
EndIf

Return lRet