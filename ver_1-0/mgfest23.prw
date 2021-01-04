/*
=====================================================================================
Programa.:              MGFEST23
Autor....:              Atilio Amarilla
Data.....:              25/01/2017
Descricao / Objetivo:   Chamado por PE MT140CPO. Inclusao de campos no aCols da Pre-Nota
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
User Function MGFEST23(aRet)

//������������������������������������������������������������������������Ŀ
//�GAP MGFPER03 - Automacao de Vendas e Transferencias                     �
//�               Inclui campo D1_ZTES na geracao de Pre-Nota              �
//��������������������������������������������������������������������������
If FunName() == "MGFEST17"
	If SD1->( FieldPos( "D1_ZTES" ) ) > 0
		aAdd( aRet , "D1_ZTES"		)
	EndIf
	aAdd( aRet , "D1_IDENTB6"	)
EndIf

Return aRet