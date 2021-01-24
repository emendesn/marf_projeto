/*
=====================================================================================
Programa.:              F590COK
Autor....:              Atilio Amarilla
Data.....:              22/12/2017
Descricao / Objetivo:   PE acionado na manutenção de bordero - exclusão
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              PE rotina FINA590
=====================================================================================
*/
User Function F590COK()

Local lRet := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GAP 19_20_21 FIDC - Bloqueia exclusão de títulos FIDC de borderos       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("MGFFIN70") .And. ParamIXB[1] == "R"
	lRet := U_MGFFIN70()
EndIf

If !lRet
	DisarmTransaction()
EndIf

Return lRet