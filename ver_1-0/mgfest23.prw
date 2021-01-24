/*
=====================================================================================
Programa.:              MGFEST23
Autor....:              Atilio Amarilla
Data.....:              25/01/2017
Descricao / Objetivo:   Chamado por PE MT140CPO. Inclus�o de campos no aCols da Pr�-Nota
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
User Function MGFEST23(aRet)

//������������������������������������������������������������������������Ŀ
//�GAP MGFPER03 - Automa��o de Vendas e Transfer�ncias                     �
//�               Inclui campo D1_ZTES na gera��o de Pr�-Nota              �
//��������������������������������������������������������������������������
If FunName() == "MGFEST17"
	If SD1->( FieldPos( "D1_ZTES" ) ) > 0
		aAdd( aRet , "D1_ZTES"		)
	EndIf
	aAdd( aRet , "D1_IDENTB6"	)
EndIf

Return aRet