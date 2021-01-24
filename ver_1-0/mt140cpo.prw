/*
=====================================================================================
Programa.:              MT140CPO
Autor....:              Atilio Amarilla
Data.....:              25/01/2017
Descricao / Objetivo:   PE para inclus�o de campos no array aCols da Pr�-Nota
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
User Function MT140CPO()

Local aRet := {}

//������������������������������������������������������������������������Ŀ
//�GAP MGFPER03 - Automa��o de Vendas e Transfer�ncias                     �
//�               Inclui campo D1_ZTES na gera��o de Pr�-Nota              �
//��������������������������������������������������������������������������
If ExistBlock("MGFEST23") .And. FunName() == "MGFEST17"
	U_MGFEST23(@aRet)
EndIf

If findfunction("U_MGFCRM11")
	U_MGFCRM11(@aRet)
Endif

If FindFunction("U_COM65Limpa")
	U_COM65Limpa()
Endif	

Return aRet