/*
=====================================================================================
Programa.:              A103CLAS
Autor....:              Atilio Amarilla
Data.....:              26/01/2017
Descricao / Objetivo:   PE para manipulação de aCols na classificação da Pré-Nota
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
User Function A103CLAS()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GAP MGFPER03 - Automação de Vendas e Transferências                     ³
//³               Copia conteúdo de D1_ZTES p/ D1_TES no aCols             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("MGFEST25") //.And. FunName() == "MGFEST17"
	U_MGFEST25()
EndIf

Return