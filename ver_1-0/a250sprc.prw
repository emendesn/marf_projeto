/*
=====================================================================================
Programa.:              A250SPRC
Autor....:              Atilio Amarilla
Data.....:              30/11/2016
Descricao / Objetivo:   PE Verifica se a Ordem de Producao possui saldo em processo
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
User Function A250SPRC()

Local lRet := NIL
Local aParam	:= ParamIXB
Local cQuery := ""

//������������������������������������������������������������������������Ŀ
//�GAP TAURA                                                               �
//�Integracao PROTHEUS x Taura - Processos Produtivos                      �
//�Verifica se a Ordem de Producao possui saldo em processo.               �
//�Padrao: informa saldo em processo (req c/ D3_EMISSAO > ultimo apontam.) �
//��������������������������������������������������������������������������
If ExistBlock("MGFTAP10") .And. FunName() == "MGFTAP10"
	lRet := U_MGFTAP10()
	//ConOut("IN "+FunName())
	//ConOut(lRet)
EndIf

//ConOut(FunName())
//ConOut(lRet)


Return lRet