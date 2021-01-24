/*
=====================================================================================
Programa.:              MGFCOM41
Autor....:              Atilio Amarilla
Data.....:              09/10/2017
Descricao / Objetivo:   Mostrar Dados de Solicitante e Comprador na aprovação de compras
Doc. Origem:
Solicitante:            Cliente
Uso......:              Marfrig - GAP COM084
Obs......:              
=====================================================================================
*/
User Function MGFCOM41(cOpc)
	
	Local cRet := ""
	/*
	=====================================================================================
	GAP COM084 - Mostrar Dados de Solicitante e Comprador na aprovação de compras
	=====================================================================================
	*/
	If cOpc == "1"
		If SCR->CR_TIPO == "SC"
			cRet := GetAdvFVal("SC1","C1_USER",xFilial("SC1")+Subs(SCR->CR_NUM,1,TamSX3("C1_NUM")[1]),1,Space(TamSX3("CR_ZCODSOL")[1]))
		Else
			cRet := Space(TamSX3("CR_ZCODSOL")[1])
		EndIf
	ElseIf cOpc == "2"
		If SCR->CR_TIPO == "SC"
			cRet := UsrRetName(GetAdvFVal("SC1","C1_USER",xFilial("SC1")+Subs(SCR->CR_NUM,1,TamSX3("C1_NUM")[1]),1,Space(TamSX3("CR_ZNOMSOL")[1])))
		Else
			cRet := Space(TamSX3("CR_ZNOMSOL")[1])
		EndIf
	ElseIf cOpc == "3"
		If SCR->CR_TIPO == "SC"
			cRet := GetAdvFVal("SC1","C1_CODCOMP",xFilial("SC1")+Subs(SCR->CR_NUM,1,TamSX3("C1_NUM")[1]),1,Space(TamSX3("CR_ZCODCOM")[1]))
		ElseIf SCR->CR_TIPO == "PC"
			cRet := GetAdvFVal("SC7","C7_USER",xFilial("SC7")+Subs(SCR->CR_NUM,1,TamSX3("C7_NUM")[1]),1,Space(TamSX3("CR_ZCODCOM")[1]))
		Else
			cRet := Space(TamSX3("CR_ZCODCOM")[1])
		EndIf
	ElseIf cOpc == "4"
		If SCR->CR_TIPO == "SC"
			cRet := GetAdvFVal("SY1","Y1_NOME",xFilial("SY1")+GetAdvFVal("SC1","C1_CODCOMP",xFilial("SC1")+Subs(SCR->CR_NUM,1,TamSX3("C1_NUM")[1]),1,Space(TamSX3("CR_ZCODCOM")[1])),1,Space(TamSX3("CR_ZCODCOM")[1]))
		ElseIf SCR->CR_TIPO == "PC"
			cRet := UsrRetName(GetAdvFVal("SC7","C7_USER",xFilial("SC7")+Subs(SCR->CR_NUM,1,TamSX3("C7_NUM")[1]),1,Space(TamSX3("CR_ZCODCOM")[1])))
		Else
			cRet := Space(TamSX3("CR_ZCODCOM")[1])
		EndIf
	EndIf		

Return cRet
