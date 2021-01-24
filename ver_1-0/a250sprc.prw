/*
=====================================================================================
Programa.:              A250SPRC
Autor....:              Atilio Amarilla
Data.....:              30/11/2016
Descricao / Objetivo:   PE Verifica se a Ordem de Producao possui saldo em processo
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
User Function A250SPRC()

Local lRet := NIL
Local aParam	:= ParamIXB
Local cQuery := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GAP TAURA                                                               ³
//³Integração PROTHEUS x Taura - Processos Produtivos                      ³
//³Verifica se a Ordem de Producao possui saldo em processo.               ³
//³Padrão: informa saldo em processo (req c/ D3_EMISSAO > último apontam.) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("MGFTAP10") .And. FunName() == "MGFTAP10"
	lRet := U_MGFTAP10()
	//ConOut("IN "+FunName())
	//ConOut(lRet)
EndIf

//ConOut(FunName())
//ConOut(lRet)


Return lRet