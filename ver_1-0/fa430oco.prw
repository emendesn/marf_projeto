/*
=====================================================================================
Programa.:              FA430OCO
Autor....:              Atilio Amarilla
Data.....:              26/09/2017
Descricao / Objetivo:   PE acionado no processamento de arquivo CNAB
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              PE rotina FINA430.
=====================================================================================
*/
User Function FA430OCO()

//������������������������������������������������������������������������Ŀ
//�GAP 19_20_21 FIDC - Bloqueio baixa pelo portador para titulo FIDC            �
//��������������������������������������������������������������������������
If ExistBlock("MGFFIN60")
	U_MGFFIN60()
EndIf

Return