/*
=====================================================================================
Programa.:              A103CLAS
Autor....:              Atilio Amarilla
Data.....:              26/01/2017
Descricao / Objetivo:   PE para manipula��o de aCols na classifica��o da Pr�-Nota
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
User Function A103CLAS()

//������������������������������������������������������������������������Ŀ
//�GAP MGFPER03 - Automa��o de Vendas e Transfer�ncias                     �
//�               Copia conte�do de D1_ZTES p/ D1_TES no aCols             �
//��������������������������������������������������������������������������
If ExistBlock("MGFEST25") //.And. FunName() == "MGFEST17"
	U_MGFEST25()
EndIf

Return