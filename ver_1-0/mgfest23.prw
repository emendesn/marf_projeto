/*
=====================================================================================
Programa.:              MGFEST23
Autor....:              Atilio Amarilla
Data.....:              25/01/2017
Descricao / Objetivo:   Chamado por PE MT140CPO. Inclusão de campos no aCols da Pré-Nota
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
User Function MGFEST23(aRet)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GAP MGFPER03 - Automação de Vendas e Transferências                     ³
//³               Inclui campo D1_ZTES na geração de Pré-Nota              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If FunName() == "MGFEST17"
	If SD1->( FieldPos( "D1_ZTES" ) ) > 0
		aAdd( aRet , "D1_ZTES"		)
	EndIf
	aAdd( aRet , "D1_IDENTB6"	)
EndIf

Return aRet