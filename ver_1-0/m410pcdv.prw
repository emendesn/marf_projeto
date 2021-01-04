/*
=====================================================================================
Programa.:              M410PCDV
Autor....:              Atilio Amarilla
Data.....:              11/04/2018
Descricao / Objetivo:   PE acionado na montagem do aCols na Devolucao de Compras.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              PE rotina MATA410. A410Devol.
=====================================================================================
*/
User Function M410PCDV()

//������������������������������������������������������������������������Ŀ
//�Verificacao de C6_PRCVEN na montagem do aCols			   �
//��������������������������������������������������������������������������
If ExistBlock("MGFFAT72")
	U_MGFFAT72()
EndIf

Return