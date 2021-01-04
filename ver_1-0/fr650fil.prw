/*
=====================================================================================
Programa.:              FR650FIL
Autor....:              Paulo Fernandes
Data.....:              12/05/2018
Descricao / Objetivo:   PE acionado no relatorio de arquivo CNAB. Busca ID CNAB 
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              PE rotina FINR650
=====================================================================================
*/
User Function FR650FIL()
Local lRet		:= .T.

//������������������������������������������������������������������������Ŀ
//�GAP CNAB - Se existe ID CNAB importado (E1_ZIDCNAB), busca E1_IDCNAB    �
//��������������������������������������������������������������������������
If MV_PAR07 == 1
	If ExistBlock("MGFFIN89")
		lRet:=U_MGFFIN89()
	EndIf
Endif	

Return(lRet)