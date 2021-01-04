#Include 'Protheus.ch'
/*
=====================================================================================
Programa............: MGFFAT17
Autor...............: Joni Lima
Data................: 17/10/2016
Descricao / Objetivo: Utilizado no Ponto de Entrada MT410INC
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza o Processamento das regras.
=====================================================================================
*/
User Function MGFFAT17(cPedido)

	Local aArea			:= GetArea()
	Local cCodPedLib   	:= SuperGetMV("MGF_FAT16F",.F.,'TP|EX|TI|DV|RB|MI|IM|TE')  //Codigos da especie de pedido que nao passar�o por aprovacao
	Local lLiberado		:= SC5->C5_ZTIPPED $ cCodPedLib  //Tem que ficar .T. para passar direto 
	Local lRet 			:= !Empty(cPedido) //.AND. SC5->C5_TIPOCLI <> "X" //.T.
	Local lHor24 		:= .F.

	Default cPedido := ''

	If IsInCallStack("EECFATCP") .OR. !Empty(alltrim(SC5->C5_PEDEXP)) .OR. IsInCallStack("U_MGFEEC24")
		// inserido em 09/02/18 por Gresele
		If !SC5->C5_ZBLQRGA == 'L'
			SC5->(RecLock('SC5',.F.))
			SC5->C5_ZBLQRGA := 'L'
			SC5->C5_ZLIBENV := 'S' 
			SC5->C5_ZTAUREE := 'S'
			SC5->(MsunLock())
		Endif	
		Return .T.
	EndIf
	
	// rotina de importacao de ordem de embarque
	If IsInCallStack("GravarCarga") .or. IsInCallStack("U_GravarCarga") .or. IsInCallStack("INCPEDFAT")
		Return(.T.)
	Endif	

	// rotina de exclusao de nota de saida, desfaz fis45
	If (IsInCallStack("MATA521") .or. IsInCallStack("MATA521A") .or. IsInCallStack("MATA521B")) 
		Return(.T.)
	Endif	
	
	// Rotina de Pr� pedido onde rodado via startjob
	IF isBlind() .AND. IsInCallStack("U_xFAT87PED") 	    
		Return(.T.)
	Endif	
	
		xDelSZV(cPedido)

	If lLiberado
		SC5->(RecLock('SC5',.F.))
		SC5->C5_ZBLQRGA := 'L'
		SC5->C5_ZLIBENV := 'S' // alterado em 30/11/17 por Gresele, para forcar o envio destes pedidos para o Taura, pois na tabela SZJ ( tipos de pedido Marfrig ) eh que tem a regra se os pedidos devem ser enviados ou nao para o Taura ou keyconsult
		SC5->C5_ZTAUREE := 'S'
		SC5->(MsunLock())
	ElseIf lRet
		//Verifica se existiu notas nas ultimas 24 horas
		lHor24 := U_xMF16N24H()

		//Sempre apos inclusao ou inclusao/alteracao sera inciado como bloqueado o Registro
		SC5->(RecLock('SC5',.F.))
		SC5->C5_ZBLQRGA := 'B'

		If !(lHor24) 
			SC5->C5_ZCONFIS := 'S' //Consulta Fiscal
		Else
			SC5->C5_ZCONFIS := 'N'
			SC5->C5_ZCONWS  := 'S'
		EndIf

		SC5->(MsunLock())

		If !(lHor24) .AND. !(lLiberado)
			U_xMF10CdBlq(cPedido,'01','000096') //Bloqueio Aguardando Consulta Receita Federal
			U_xMF10CdBlq(cPedido,'01','000097') //Bloqueio Aguardando Consulta Sintegra
			U_xMF10CdBlq(cPedido,'01','000098') //Bloqueio Aguardando Consulta Suframa
		EndIf

		//Chama nova thread
		//StartJob("u_xMF10JAllR",GetEnvServer(),.F.,cPedido,/*aRegra*/,cEmpAnt,cFilAnt,cModulo)

		if isBlind() 
			u_xMF10AllRg(cPedido, nil )
		else
			fwMsgRun(, { || u_xMF10AllRg(cPedido, nil ) }, "Processando FAT14", "Aguarde. Processando regras de bloqueio..." )
		endif
	EndIf
	
	// se for pedido sfa, liberado e sem nenhuma regra de bloqueio gerada, forca reenvio off line, pois alguns pedidos nao estao sendo enviados como liberados para o taura, 
	// estao sendo enviados como bloqueados, provavelmente apos a liberacao, nao estao caindo em nenhum trecho do fonte que altera os campos para reenvio off line
	//If !Empty(SC5->C5_XIDSFA)
		If SC5->C5_ZBLQRGA == 'L'
			If PVSemRegra(SC5->C5_NUM)
				SC5->(RecLock('SC5',.F.))
				SC5->C5_ZLIBENV := 'S'
				SC5->C5_ZTAUREE := 'S'
				SC5->(MsunLock())
			Endif	
		Endif
	//Endif
			
	RestArea(aArea)

Return lRet

Static function xDelSZV(cPedido)

	Local aArea 	:= GetArea()
	Local aAreaSZV	:= SZV->(GetArea())
	Local cChvSZV := xFilial('SZV') + cPedido

	DbSelectArea('SZV')
	SZV->(dbSetOrder(1))//ZV_FILIAL+ZV_PEDIDO+ZV_ITEMPED+ZV_CODRGA

	If (SZV->(DbSeek(cChvSZV )))
		While SZV->(!EOF()) .and. SZV->(ZV_FILIAL+ZV_PEDIDO) == cChvSZV 
			// Alterado Marcelo Carneiro para nao apagar os bloqueios do Taura.
			IF SZV->ZV_CODRGA <> '000088' .AND. SZV->ZV_CODRGA <> '000089'
				RecLock('SZV',.F.)
				SZV->(dbDelete())
				SZV->(MsUnLock())
			EndIF
			SZV->(DbSkip())
		EndDo
	EndIf

	RestArea(aAreaSZV)
	RestArea(aArea)

	return

	***************************
User function xBlqNFRga(cPedido)

	Local lRet := .T.

	Default cPedido := ''

	If !Empty(cPedido)
		If SC5->C5_ZBLQRGA == "B"
			Alert("Pedido com bloqueio de regra!")
			lRet := .F.
		Endif
	Endif

	Return lRet

	*******************************
User function xBlqMkRga()

	Local _aArea := GetArea()
	Local _cQ := ""
	Local _lRet := .T.
	Local _cAliasTrb := GetNextAlias()

	// carrega perguntas de filtragem da markbrowse
	If IsInCallStack("MATA460A")
		Pergunte("MT461A",.F.)

		// busca pedidos marcados para faturamento, do tipo operacao triangular
		_cQ := "SELECT C5_NUM, C5_ZBLQRGA, C5_ZTPTRAN "
		_cQ += "FROM "+RetSqlName("SC9")+" SC9, "+RetSqlName("SC5")+" SC5 "
		_cQ += "WHERE C9_FILIAL = '"+xFilial("SC9")+"' "
		_cQ += "AND C5_FILIAL = '"+xFilial("SC5")+"' "
		If ParamIxb[2] // C9_OK invertido
			_cQ += "AND C9_OK <> '"+ParamIxb[1]+"' "
		Elseif !ParamIxb[2] // nao invertido
			_cQ += "AND C9_OK = '"+ParamIxb[1]+"' "
		Endif	
		_cQ += "AND C9_FILIAL = C5_FILIAL "
		_cQ += "AND C9_PEDIDO = C5_NUM "
		_cQ += "AND C9_BLEST <> '10' "
		_cQ += "AND C9_BLCRED <> '10' "
		_cQ += "AND C9_NFISCAL = '"+Space(Len(SC9->C9_NFISCAL))+"' "
		_cQ += "AND (C5_ZBLQRGA = 'B' " // somente pedidos liberados pelo FAT14
		_cQ += "OR C5_ZTPTRAN <> ' ') "
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

		// monta matriz com todos os pedidos , colocando o numero do pedido de venda e do simples remessa
		While !Eof()
			_lRet := .F.
			If (_cAliasTrb)->C5_ZBLQRGA == "B"
				APMsgAlert("Pedido "+(_cAliasTrb)->C5_NUM +" com bloqueio de regra!")
			Endif
			If !Empty((_cAliasTrb)->C5_ZTPTRAN)
				APMsgAlert("Pedido "+(_cAliasTrb)->C5_NUM+" foi gerado pela rotina espec�fica de 'Automacao de Vendas.'")
			Endif
			dbSkip()
		Enddo	

		(_cAliasTrb)->(dbCloseArea())
		RestArea(_aArea)
	Endif

Return(_lRet)


// retorna pedidos sem nenhuma regra de bloqueio
Static Function PVSemRegra(cPedido)

Local aArea := {GetArea()}
Local cAliasTrb := GetNextAlias()
Local cQ := ""
Local lRet := .F.

cQ := "SELECT 1 "
cQ += "FROM "+RetSqlName("SZV")+" SZV "
cQ += "WHERE ZV_FILIAL = '"+xFilial("SZV")+"' "
cQ += "AND ZV_PEDIDO = '"+cPedido+"' "
cQ += "AND D_E_L_E_T_ = ' ' "

cQ := ChangeQuery(cQ)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.F.,.T.)

If (cAliasTrb)->(Eof())
	lRet := .T.
Endif

(cAliasTrb)->(dbCloseArea())	

aEval(aArea,{|x| RestArea(x)})

Return(lRet)
