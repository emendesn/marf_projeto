#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TOTVS.CH"
/*/
{Protheus.doc} MGFFATC0
	Ponto de Entrada para valida��o dO pedido de venda.

@description
	Este ponto de entrada ir� validar se o pedido de Venda utiliza Cargas(C5_TPCARGA = 1 - Utiliza).  
	Caso utilize, verificar se existe carga para o pedido (DAI), se n�o encontrar uma carga dever� avisar que n�o pode ser faturado. 
	
@author Marcos Cesar Donizeti Vieira
@since 20/07/2020

@version P12.1.017
@country Brasil
@language Portugu�s

@type Function 
@table 
	SC5 - Cabe�alho do pedido de vendas
	DAI - Itens da carga

@param
@return

@menu
@history 
/*/
User Function MGFFATC0()
	Local _aArea		:= GetArea()
	Local _lRet 		:= .T.
	Local _aRotExc		:= {}	
	Local _lVldCarga	:= .T.
	Local _cTipoOper	:= ""
	Local _cPedTpOper	:= ""

	Private _lIsBlind   :=  IsBlind() .OR. Type("__LocalDriver") == "U"
	
	//--------------| Verifica exist�ncia de par�metros e caso n�o exista cria. |-------------------------
	If !ExisteSx6("MGF_FATC0A")
		CriarSX6("MGF_FATC0A", "C", "Rotinas que n�o passar�o pela valida��o. Ex:GFEA065;MGFINT09"	, 'GFEA065;MGFINT09' )	
	EndIf

	//--------------| Verifica exist�ncia de par�metros e caso n�o exista cria. |-------------------------
	If !ExisteSx6("MGF_FATC0B")
		CriarSX6("MGF_FATC0B", "L", "Valida se utiliza carga (.T./.F.)?"		, '.T.' )	
	EndIf

	//--------------| Verifica exist�ncia de par�metros e caso n�o exista cria. |-------------------------
	If !ExisteSx6("MGF_FATC0C")
		CriarSX6("MGF_FATC0C", "C", "Tipo Operacao que DEVE ser validado no Pedido(Se Pedido utiliza Carga)."	, '|BJ|' )
	EndIf

	If IsInCallStack("U_M460MARK")	// Se for rotina vindo do OMS
		SC5->(DbSetOrder(1))
		SC5->( DbSeek(xFilial("SC5")+SC9->C9_PEDIDO) )
	EndIf

	_cPedTpOper	:= AllTrim(SC5->C5_ZTPOPER)
	_aRotExc 	:= STRTOKARR(SuperGetMV("MGF_FATC0A",.F.,'GFEA065;MGFINT09'),";")
	_lVldCarga 	:= SUPERGETMV("MGF_FATC0B",.F., '.T.' )
	_cTipoOper	:= AllTrim(SUPERGETMV("MGF_FATC0C",.F., '|BJ|'))

	IF _lIsBlind .OR. !_cPedTpOper $ _cTipoOper
		_lVldCarga := .F.		// Se valida pedido que utiliza carga
	EndIF

	//Verifica se as rotinas que n�o devem passar pela valida��o est�o na pilha de chamada. Se estiver, sai da fun��o. 
	For _nCnt := 1 To Len(_aRotExc)
		If IsInCallStack(Alltrim(_aRotExc[_nCnt]))
			_lVldCarga := .F.		// Se valida pedido que utiliza carga
		EndIf
	Next

	If _lVldCarga	// Valida pedido que utiliza carga
		If SC5->C5_TPCARGA = "1"
			DAI->( dbSetOrder(4) )
			IF !DAI->(dbSeek(xFilial("DAI")+SC5->C5_NUM))
				_lRet 	:= .F.
				Help(NIL, NIL,'N�O � POSSIVEL GERAR NOTA FISCAL', NIL, 'N�o existe uma carga cadastrada para o pedido: '+SC5->C5_NUM, 1, 0, NIL, NIL, NIL, NIL, NIL, {'Crie uma carga ou classifique o pedido corretamente.'})
			EndIf
		EndIf
	EndIf

	RestArea(_aArea)	

Return(_lRet)