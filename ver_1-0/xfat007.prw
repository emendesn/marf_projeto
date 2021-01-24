#include "protheus.ch"

#define CRLF Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ XFat007  º Autor ³Totvs               º Data ³   26/09/10  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para validar geracao de nota fiscal com operacao    º±±
±±º          ³ triangular ou venda para entrega futura.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Motorola										  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/         
User Function XFat007()

Local _aArea := GetArea()
Local _aAreaSC6 := SC6->(GetArea())
Local _cQ := ""
Local _lAchouVenda := .F.
Local _lAchouSimples := .F.
Local _aPedidos := {}
Local _lRet := .T.
Local _cPedVenda := ""
Local _cPedSimples := ""
//Local _cItem := ""
Local _aStrucSC9 := SC9->(dbStruct())
Local _cAliasTrb := GetNextAlias()
Local _nQtdLibVen := 0
Local _nQtdLibSim := 0
Local _cProduto := ""
Local _aPedVen := {}
Local _nQtdLib := 0
Local _nCnt := 0
Local _nQtdEntRem := 0

// carrega perguntas de filtragem da markbrowse
Pergunte("MT461A",.F.)

// busca pedidos marcados para faturamento, do tipo operacao triangular
_cQ := "SELECT SC9.*,C5_XPEDVEN,C5_XPEDSRE "
_cQ += "FROM "+RetSqlName("SC9")+" SC9, "+RetSqlName("SC5")+" SC5 "
_cQ += "WHERE C9_FILIAL = '"+xFilial("SC9")+"' "
_cQ += "AND C5_FILIAL = '"+xFilial("SC5")+"' "
If IsInCallStack("U_M460MARK")
	If ParamIxb[2] // C9_OK invertido
		_cQ += "AND C9_OK <> '"+ParamIxb[1]+"' "
	Elseif !ParamIxb[2] // nao invertido
		_cQ += "AND C9_OK = '"+ParamIxb[1]+"' "
	Endif	
Else
	If ThisInv() // C9_OK invertido
		_cQ += "AND C9_OK <> '"+ThisMark()+"' "
	Elseif !ThisInv() // nao invertido
		_cQ += "AND C9_OK = '"+ThisMark()+"' "
	Endif	
Endif	
_cQ += "AND (C5_XPEDVEN <> '"+Space(Len(SC5->C5_XPEDVEN))+"' "
_cQ += "OR C5_XPEDSRE <> '"+Space(Len(SC5->C5_XPEDSRE))+"' ) "
_cQ += "AND C9_FILIAL = C5_FILIAL "
_cQ += "AND C9_PEDIDO = C5_NUM "
_cQ += "AND C9_BLEST <> '10' "
_cQ += "AND C9_BLCRED <> '10' "
_cQ += "AND C9_NFISCAL = '"+Space(Len(SC9->C9_NFISCAL))+"' "
_cQ += "AND C5_XTPVEND = '2' " // somente pedido de operacao triangular deve ter esta regra
If (mv_par03 == 1 )
	_cQ += "AND C9_PEDIDO >= '"+mv_par05+"' "
	_cQ += "AND C9_PEDIDO <= '"+mv_par06+"' "
	_cQ += "AND C9_CLIENTE >= '"+mv_par07+"' "
	_cQ += "AND C9_CLIENTE <= '"+mv_par08+"' "
	_cQ += "AND C9_LOJA >= '"+mv_par09+"' "
	_cQ += "AND C9_LOJA <= '"+mv_par10+"' "
	_cQ += "AND C9_DATALIB >= '"+Dtos(mv_par11)+"' "
	_cQ += "AND C9_DATALIB <= '"+Dtos(mv_par12)+"' "			
Endif	
_cQ += "AND SC9.D_E_L_E_T_ = ' ' "
_cQ += "AND SC5.D_E_L_E_T_ = ' ' " 
_cQ += "ORDER BY C9_FILIAL,C9_PEDIDO,C9_PRODUTO "
//_cQ += "ORDER BY C9_FILIAL,C9_PEDIDO,C9_ITEM "

// retorna perguntas da rotina
Pergunte("MT460A",.F.)

_cQ := ChangeQuery(_cQ)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQ),_cAliasTrb,.F.,.T.)

aEval(_aStrucSC9,{|e| If(e[2] != "C", TCSetField(_cAliasTrb, e[1], e[2],e[3],e[4]),Nil)})

dbGotop()
// monta matriz com todos os pedidos , colocando o numero do pedido de venda e do simples remessa
While !Eof()
	aAdd(_aPedidos,{(_cAliasTrb)->C9_PEDIDO,;
					(_cAliasTrb)->C5_XPEDVEN,;
					(_cAliasTrb)->C5_XPEDSRE,;
					(_cAliasTrb)->C9_PRODUTO})
//					(_cAliasTrb)->C9_ITEM})					
	dbSkip()
Enddo	

// checa se nos itens marcados ( que tem op. triangular ) estao todos os pedidos que devem ser faturados
If Len(_aPedidos) > 0

	// para uso da operacao triangular, nao pode ser gerado mais de um pedido por nota fiscal. Somente valida se estiver na geracao da nota
	If IsInCallStack("U_M460MARK")
		If mv_par11 = 1
			_lRet := .F.
			ApMsgAlert("Para pedidos com operação triangular não pode ser gerado mais de um pedido por nota fiscal. Verifique os parâmetros.","Stop")
		Endif	
	Endif	
    
	// se estiver validando o estorno dos itens, somente deixa continuar se estiver com a opcao de marcados, e nao de posicionados,
	// para nao ter o risco de excluir somente um dos pedidos e o outro ( simples remessa ) ficar liberado.
	If IsInCallStack("U_XFAT010")
		If mv_par02 = 1 // posicionado
			_lRet := .F.
			ApMsgAlert("Para pedidos com operação triangular, o estorno somente pode ser feito com a opção de parâmetro 'Marcados'. Verifique os parâmetros.","Stop")
		Endif	
	Endif	
	
	If _lRet
		For _nCnt := 1 To Len(_aPedidos)
			_lAchouVenda := .F.
			_lAchouSimples := .F.
			_cPedVenda := IIf(Empty(_aPedidos[_nCnt][2]),_aPedidos[_nCnt][1],_aPedidos[_nCnt][2])
			_cPedSimples := IIf(Empty(_aPedidos[_nCnt][3]),_aPedidos[_nCnt][1],_aPedidos[_nCnt][3])
//			_cItem := _aPedidos[_nCnt][4]
			_cProduto := _aPedidos[_nCnt][4]			
			_nQtdLibVen := 0
			_nQtdLibSim := 0
						
			dbSelectArea(_cAliasTrb)
			dbGotop()
			While !Eof()
				If (_cAliasTrb)->C9_PEDIDO $ _cPedVenda+"/"+_cPedSimples
					// avalia pedido de venda
					If Empty((_cAliasTrb)->C5_XPEDVEN)
//						If (_cAliasTrb)->C9_PEDIDO = _cPedVenda .and. (_cAliasTrb)->C9_ITEM = _cItem
						If (_cAliasTrb)->C9_PEDIDO = _cPedVenda .and. (_cAliasTrb)->C9_PRODUTO = _cProduto
							_lAchouVenda := .T.
							_nQtdLibVen += (_cAliasTrb)->C9_QTDLIB
						Endif
					Elseif Empty((_cAliasTrb)->C5_XPEDSRE) // avalia pedido de simples remessa
//						If (_cAliasTrb)->C9_PEDIDO = _cPedSimples .and. (_cAliasTrb)->C9_ITEM = _cItem
						If (_cAliasTrb)->C9_PEDIDO = _cPedSimples .and. (_cAliasTrb)->C9_PRODUTO = _cProduto
							_lAchouSimples := .T.
							_nQtdLibSim += (_cAliasTrb)->C9_QTDLIB
						Endif
					Endif	
				Endif	
				//If _lAchouVenda .and. _lAchouSimples .and. _nQtdLibVen = _nQtdLibSim
				//	Exit
				//Endif	
				dbSkip()
			Enddo
			If !_lAchouVenda .or. !_lAchouSimples	 
				_lRet := .F.
				If !_lAchouVenda
					APMsgAlert("Falta marcar pedido de venda número: "+_cPedVenda+", produto: "+_cProduto+", para operação triangular, verifique.","Stop")
				Elseif !_lAchouSimples	
					APMsgAlert("Falta marcar pedido de simples remessa número: "+_cPedSimples+", produto: "+_cProduto+", para operação triangular, verifique.","Stop")
				Endif	
				Exit
			Endif
			If _lRet .and. _nQtdLibVen != _nQtdLibSim
				_lRet := .F.
				APMsgAlert("Quantidades liberadas entre os pedidos de venda e de simples remessa número: "+_cPedVenda+"/"+_cPedSimples+", produto: "+_cProduto+" estão divergentes, para operação triangular, verifique.","Stop")
			Endif	
		Next _nCnt		
	Endif	
Endif	

(_cAliasTrb)->(dbCloseArea())

// busca pedidos marcados para faturamento, do tipo operacao venda futura
If _lRet
	_aPedidos := {}
	// carrega perguntas de filtragem da markbrowse
	Pergunte("MT461A",.F.)

	_cQ := "SELECT SC9.*,C5_XPEDVEN,C5_XPEDSRE "
	_cQ += "FROM "+RetSqlName("SC9")+" SC9, "+RetSqlName("SC5")+" SC5 "
	_cQ += "WHERE C9_FILIAL = '"+xFilial("SC9")+"' "
	_cQ += "AND C5_FILIAL = '"+xFilial("SC5")+"' "
	If IsInCallStack("U_M460MARK")
		If ParamIxb[2] // C9_OK invertido
			_cQ += "AND C9_OK <> '"+ParamIxb[1]+"' "
		Elseif !ParamIxb[2] // nao invertido
			_cQ += "AND C9_OK = '"+ParamIxb[1]+"' "
		Endif	
	Else
		If ThisInv() // C9_OK invertido
			_cQ += "AND C9_OK <> '"+ThisMark()+"' "
		Elseif !ThisInv() // nao invertido
			_cQ += "AND C9_OK = '"+ThisMark()+"' "
		Endif	
	Endif	
	_cQ += "AND (C5_XPEDVEN <> '"+Space(Len(SC5->C5_XPEDVEN))+"' "
	_cQ += "OR C5_XPEDSRE <> '"+Space(Len(SC5->C5_XPEDSRE))+"' ) "
	_cQ += "AND C9_FILIAL = C5_FILIAL "
	_cQ += "AND C9_PEDIDO = C5_NUM "
	_cQ += "AND C9_BLEST <> '10' "
	_cQ += "AND C9_BLCRED <> '10' "
	_cQ += "AND C9_NFISCAL = '"+Space(Len(SC9->C9_NFISCAL))+"' "
	_cQ += "AND C5_XTPVEND = '1' "
	If (mv_par03 == 1 )
		_cQ += "AND C9_PEDIDO >= '"+mv_par05+"' "
		_cQ += "AND C9_PEDIDO <= '"+mv_par06+"' "
		_cQ += "AND C9_CLIENTE >= '"+mv_par07+"' "
		_cQ += "AND C9_CLIENTE <= '"+mv_par08+"' "
		_cQ += "AND C9_LOJA >= '"+mv_par09+"' "
		_cQ += "AND C9_LOJA <= '"+mv_par10+"' "
		_cQ += "AND C9_DATALIB >= '"+Dtos(mv_par11)+"' "
		_cQ += "AND C9_DATALIB <= '"+Dtos(mv_par12)+"' "			
	Endif	
	_cQ += "AND SC9.D_E_L_E_T_ = ' ' "
	_cQ += "AND SC5.D_E_L_E_T_ = ' ' " 
	_cQ += "ORDER BY C9_FILIAL,C9_PEDIDO,C9_PRODUTO "

	// retorna perguntas da rotina
	Pergunte("MT460A",.F.)
	
	_cQ := ChangeQuery(_cQ)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQ),_cAliasTrb,.F.,.T.)
	
	aEval(_aStrucSC9,{|e| If(e[2] != "C", TCSetField(_cAliasTrb, e[1], e[2],e[3],e[4]),Nil)})
	
	dbGotop()
	// monta matriz com todos os pedidos , colocando o numero do pedido de venda e do simples remessa
	While !Eof()
		aAdd(_aPedidos,{(_cAliasTrb)->C9_PEDIDO,;
						(_cAliasTrb)->C5_XPEDVEN,;
						(_cAliasTrb)->C5_XPEDSRE,;
						(_cAliasTrb)->C9_ITEM,;
						(_cAliasTrb)->C9_PRODUTO,;
						(_cAliasTrb)->C9_QTDLIB})
		dbSkip()
	Enddo	
    
    // ordena por numero de pedido
	aSort(_aPedidos,,,{|x,y| x[1]<y[1]})
	
	// se for o pedido de venda, apenas mostra o numero do pedido de simples remessa, se for o pedido de simples remessa,
	// checa se a quantidade a ser faturada jah foi entregue no pedido de venda correspondente
	If Len(_aPedidos) > 0
		For _nCnt := 1 To Len(_aPedidos)
			// mostra mensagem para pedido de venda
			If !Empty(_aPedidos[_nCnt][3])
				If aScan(_aPedVen,_aPedidos[_nCnt][1]) = 0
					aAdd(_aPedVen,_aPedidos[_nCnt][1])
					APMsgInfo("Existe o pedido de simples remessa número: "+_aPedidos[_nCnt][3]+" associado a este pedido de venda.")
				Endif
			Endif	
			
			// valida quantidade entregue, para o pedido de cobranca
			If !Empty(_aPedidos[_nCnt][2])
				
				dbSelectArea("SC6")
				dbSetOrder(1)
				// SC6 posicionado no pedido de simples remessa
				If dbSeek(xFilial("SC6")+_aPedidos[_nCnt][1]+_aPedidos[_nCnt][4]+_aPedidos[_nCnt][5])
					_nQtdLib := U_Fat004QLibVen(SC6->(Recno()),.F.,.T.)
					_nQtdEntRem := SC6->C6_QTDENT // busca quantidade jah entregue deste item
					// SC6 posicionado no pedido de cobranca
					If dbSeek(xFilial("SC6")+_aPedidos[_nCnt][2]+_aPedidos[_nCnt][4]+_aPedidos[_nCnt][5])
						If _nQtdLib+_nQtdEntRem > SC6->C6_QTDENT
							_lRet := .F.
							APMsgAlert("Item/produto: "+_aPedidos[_nCnt][4]+"/"+_aPedidos[_nCnt][5]+", do pedido de simples remessa número: "+_aPedidos[_nCnt][1]+;
							", com quantidade liberada+entregue: "+Alltrim(Transform(_nQtdLib+_nQtdEntRem,PesqPict("SC9","C9_QTDLIB")))+", maior que a quantidade "+;
							"já entregue: "+Alltrim(Transform(SC6->C6_QTDENT,PesqPict("SC6","C6_QTDENT")))+", para o pedido de venda de cobrança correspondente, "+;
							"número: "+_aPedidos[_nCnt][2]+"."+CRLF+;
							"Favor faturar este Item/produto no pedido de venda antes.","Stop")
							Exit
						Endif
					Endif
				Endif	
			Endif			
		Next _nCnt		
	Endif	
	
	(_cAliasTrb)->(dbCloseArea())	
Endif	

// se pedido veio do PMS, soh deixa faturar se projeto estiver na fase de execucao
If _lRet
	// carrega perguntas de filtragem da markbrowse
	Pergunte("MT461A",.F.)

	_cQ := "SELECT C9_PEDIDO "
	_cQ += "FROM "+RetSqlName("SC9")+" SC9 "
	_cQ += "WHERE C9_FILIAL = '"+xFilial("SC9")+"' "
	If IsInCallStack("U_M460MARK")
		If ParamIxb[2] // C9_OK invertido
			_cQ += "AND C9_OK <> '"+ParamIxb[1]+"' "
		Elseif !ParamIxb[2] // nao invertido
			_cQ += "AND C9_OK = '"+ParamIxb[1]+"' "
		Endif	
	Else
		If ThisInv() // C9_OK invertido
			_cQ += "AND C9_OK <> '"+ThisMark()+"' "
		Elseif !ThisInv() // nao invertido
			_cQ += "AND C9_OK = '"+ThisMark()+"' "
		Endif	
	Endif	
	_cQ += "AND C9_BLEST <> '10' "
	_cQ += "AND C9_BLCRED <> '10' "
	_cQ += "AND C9_NFISCAL = '"+Space(Len(SC9->C9_NFISCAL))+"' "
	If (mv_par03 == 1 )
		_cQ += "AND C9_PEDIDO >= '"+mv_par05+"' "
		_cQ += "AND C9_PEDIDO <= '"+mv_par06+"' "
		_cQ += "AND C9_CLIENTE >= '"+mv_par07+"' "
		_cQ += "AND C9_CLIENTE <= '"+mv_par08+"' "
		_cQ += "AND C9_LOJA >= '"+mv_par09+"' "
		_cQ += "AND C9_LOJA <= '"+mv_par10+"' "
		_cQ += "AND C9_DATALIB >= '"+Dtos(mv_par11)+"' "
		_cQ += "AND C9_DATALIB <= '"+Dtos(mv_par12)+"' "			
	Endif	
	_cQ += "AND SC9.D_E_L_E_T_ = ' ' "   
	_cQ += "GROUP BY C9_PEDIDO "
	_cQ += "ORDER BY C9_PEDIDO "

	// retorna perguntas da rotina
	Pergunte("MT460A",.F.)
	
	_cQ := ChangeQuery(_cQ)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQ),_cAliasTrb,.F.,.T.)
	
	dbGotop()
	While !Eof()
		_aPms := U_Fat001PedPMS((_cAliasTrb)->C9_PEDIDO)
		If _aPms[1] .and. _aPms[3] != "03"
			_lRet := .F.
			ApMsgAlert("Pedido número: "+(_cAliasTrb)->C9_PEDIDO+", Projeto não está na fase de 'Execução'.")
			Exit
		Endif
		dbSelectArea(_cAliasTrb)
		dbSkip()
	Enddo	

	(_cAliasTrb)->(dbCloseArea())
Endif	
	
RestArea(_aAreaSC6)
RestArea(_aArea)

Return(_lRet)