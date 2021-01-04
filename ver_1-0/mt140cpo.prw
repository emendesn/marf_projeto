/*
=====================================================================================
Programa.:              MT140CPO
Autor....:              Atilio Amarilla
Data.....:              25/01/2017
Descricao / Objetivo:   PE para inclusão de campos no array aCols da Pré-Nota
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
User Function MT140CPO()

Local aRet := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GAP MGFPER03 - Automação de Vendas e Transferências                     ³
//³               Inclui campo D1_ZTES na geração de Pré-Nota              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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