#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"

/*              
+-----------------------------------------------------------------------+
�Programa  �MGFEST60    � Autor � WAGNER NEVES         � Data �20.04.20 �
+----------+------------------------------------------------------------�
�Descri��o �O objetivo deste fonte e a valida��o da linha da solicitacao�
�		   �ao arrmazem quando o produto pertencer ao grupo de EPI      �
�		   �e quando a matricula estiver preenchido						|
+----------+------------------------------------------------------------�
� Uso      � ESPECIFICO PARA MARFRIG			                        �
+-----------------------------------------------------------------------�
�           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            �
+-----------------------------------------------------------------------�
�PROGRAMADOR      � DATA       � MOTIVO DA ALTERACAO                    �
+-----------------------------------------------------------------------�
�                 �            � 				                        �
+-----------------------------------------------------------------------+
*/

User Function  MGFEST60()

	Local nPosItem	  := aScan(aHeader,{|x| AllTrim(x[2]) == 'CP_ITEM'})
	Local nPosProd	  := aScan(aHeader,{|x| AllTrim(x[2]) == 'CP_PRODUTO'})
	Local nPosLocal	  := aScan(aHeader,{|x| AllTrim(x[2]) == 'CP_LOCAL'})
	Local nPosQtde	  := aScan(aHeader,{|x| AllTrim(x[2]) == 'CP_QUANT'})
	Local nPosMatFun  := aScan(aHeader,{|x| AllTrim(x[2]) == 'CP_ZMATFUN'})
	Local nPosStatus  := aScan(aHeader,{|x| AllTrim(x[2]) == 'CP_ZSTATUS'})

	Local nPosNome    := aScan(aHeader,{|x| AllTrim(x[2]) == 'CP_ZSTATUS'})

	Local cItem       := aCols[n][nPosItem]
	Local cProduto    := aCols[n][nPosProd]
	Local cArmazem    := aCols[n][nPosLocal]
	Local nQtdLib	  := aCols[n][nPosQtde]
	Local cMatFunc    := aCols[n][nPosMatFun]
	Local cStatusEpi  := aCols[n][nPosStatus]

	Local nQtdEstoq  := POSICIONE('SB2',1,xFilial('SCP')+cProduto+cArmazem,'SB2->B2_QATU')
	Local nQtdReserv := POSICIONE('SB2',1,xFilial('SCP')+cProduto+cArmazem,'SB2->B2_RESERVA')
	Local nSaldoDisp := nQtdEstoq - nQtdReserv
	Local _cGrupoInd := GetMv("MGF_EPIIND",,"0321")  // Grupo de Produto EPI Individual
	Local _cGrupoCol := GetMv("MGF_EPICOL",,"0322")  // Grupo de Produto EPI Coletivo

	Local nI := 1
	Local nLinha := 0
	Public lRet := .T.

	If cFilAnt $GetMv("MGF_EPIFIL") // Verifica se a filial est� autorizada ao tratamento de EPI

		If ! Inclui .And. cStatusEpi <> "00"
			Help(NIL, NIL, "Requisi��o em aprova��o", NIL, "Documento pendente de aprova��o. N�o pode ser alterado.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Contate seu superior"})
			lRet := .F.
			Return(lRet)
		EndIf

		If ! EMPTY(cMatFunc)
			_cTemMat := .T.
			// Verifica se o grupo do produto informado � de EPI INDIVIDUAL
			If ! Alltrim(SB1->B1_GRUPO) $ _cGrupoInd
				Help(NIL, NIL, "Grupo Indevido", NIL, "Este Item n�o Pertence ao Grupo de Produtos de Entrega Individual de EPI. Caso necessite requisitar o item, por favor, entrar em contato com o setor do SESMT", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Produto deve pertencer ao grupo "+_cGrupoInd})
				lRet := .F.
				Return(lRet)
			EndIf

			// Verifica se ja existe produto informado na SA
			nLinha := n
			For nI := 1 To Len(Acols)
				If !GdDeleted( NI )
					If nI <> nLInha .And. aCols[nI][nPosProd] = aCols[n][nPosProd]
						Help(NIL, NIL, "Produto j� existe", NIL, "O item j� consta nesta requisi��o, caso necess�rio, realizar a manuten��o na inclus�o j� existente no item "+cValToChar(nI), 1, 0, NIL, NIL, NIL, NIL, NIL, {"REalizar a manuten��o no produto j� existente."})
						lRet := .F.
						Return(lRet)
					EndIf
				EndIf
			NEXT

			// Verifica Saldo em Estoque
			If(nQtdLib > nSaldoDisp)
				Help(NIL, NIL, "Saldo Insuficiente em estoque", NIL, "Estoque indispon�vel para o item solicitado. O Saldo em estoque desse produto � de : "+cValToChar(nSaldoDisp)+" itens,";
					+" no Armaz�m "+cArmazem, 1, 0, NIL, NIL, NIL, NIL, NIL, {"Verificar saldo do produto (Saldo Atual - Reserva)" })
				lRet := .F.
				Return(lRet)
			EndIf

			fValidFun(cMatFunc,cProduto,nQtdLib)

		Else // Matricula em branco

			// Verifica se o grupo do produto informado � de EPI INDIVIDUAL
			If Alltrim(SB1->B1_GRUPO) $ _cGrupoInd
				If SB1->B1_ZENTEPI = '2' .Or. Empty(SB1->B1_ZENTEPI)//N�o entrega coletiva
					Help(NIL, NIL, "Grupo Indevido", NIL, "Este item pertence ao grupo de Equipamentos de Prote��o Individual e somente poder� ser requisitado com a inclus�o da Matr�cula do Funcion�rio a ser atendido!", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Produto deve pertencer ao grupo "+_cGrupoInd})
					lRet := .F.
					Return(lRet)
				EndIf
			EndIf

			If Alltrim(SB1->B1_GRUPO) $ _cGrupoCol
				If SB1->B1_ZENTEPI = '2' //N�o entrega coletiva
					Help(NIL, NIL, "Grupo Indevido", NIL, "Este item pertence ao grupo de Equipamentos de Prote��o Coletiva mas no cadastro de produtos est� configurado como N�O sendo de uso coletivo.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Produto precisa ser configurado"+_cGrupoInd})
					lRet := .F.
					Return(lRet)
				EndIf
			EndIf
		EndIf
	EndIf
	
Return(lRet)


Static Function fValidFun(cMatFunc,cProduto,nQtdLib)
	Local cHeadRet	   := ""
	Local cUrlFun	   := GetMv("MGF_EPIURL",,"http://spdwvapl203:1685/epi/api/consulta/mapa?matricula=")
	Local aHeadOut	   := {}
	Local nTimeOut	   := 120
	Local _cUnidade    := ''
	Local _cMatricula  := ''
	Local _cProduto    := ''
	Local _nQuantEpi   := 0

	aadd( aHeadOut, 'Content-Type: application/json')
	conout('Thread ' + strzero(threadid(),6) +  ' - [MGFEST60]] - Verifica informa��es Mapa de Risco')
	cUrl		:= cUrlFun+Alltrim(cMatFunc)+"&codEquipSupr="+Alltrim(cProduto)
	cTimeIni 	:= time()
	xPostRet 	:= httpQuote( cUrl/*<cUrl>*/, "GET" /*<cMethod>*/, /*[cGETParms]*/, /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )
	cTimeFin	:= time()
	cTimeProc	:= elapTime( cTimeIni, cTimeFin )
	nStatuHttp	:= 0
	nStatuHttp	:= httpGetStatus()
	conout(" [MGFEST60] * * * * * Status da integracao * * * * *")
	conout(" [MGFEST60] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase ) )
	conout(" [MGFEST60] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase ) )
	conout(" [MGFEST60] Tempo de Processamento.......: " + cTimeProc )
	conout(" [MGFEST60] URL..........................: " + cURL)
	conout(" [MGFEST60] HTTP Method..................: " + "GET" )
	conout(" [MGFEST60] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
	conout(" [MGFEST60] Retorno......................: " + allTrim( xPostRet ) )
	conout(" [MGFEST60] * * * * * * * * * * * * * * * * * * * * ")
	oFuncionario := nil
	if fwJsonDeserialize( xPostRet, @oFuncionario)
		If Len(oFuncionario) > 0
			_cUnidade    := Alltrim(oFuncionario[1]:codunidade)
			_cMatricula  := Alltrim(Str(oFuncionario[1]:matricula))
			_cProduto    := Alltrim(oFuncionario[1]:codEquipSupr)
			_nquantEpi	 := oFuncionario[1]:qtdeDefinido
		Else
			Help(NIL, NIL, "Mapa de Risco", NIL, "Este item n�o pertence ao Mapa de Risco do funcion�rio. Caso necessite requisitar o item, por favor, entrar em contato com o setor do SESMT", 1, 0, NIL, NIL, NIL, NIL, NIL, {"O produto informado deve pertencer ao Mapa de Risco do funcion�rio."})
			lRet := .f.
			Return(lRet)
		EndIf
		If cFilAnt == _cUnidade
			lRet := .t.
		Else
			Help(NIL, NIL, "Filial Incorreta", NIL, "Filial n�o est� de acordo.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique a filial."})
			lRet := .f.
		EndIf
		If cMatFunc == _cMatricula
			lRet := .t.
		Else
			Help(NIL, NIL, "Matr�cula", NIL, "Matricula n�o est� de acordo com o cadastro de funcion�rios", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique a matr�cula do funcion�rio"})
			lRet := .f.
		EndIf
		If _cProduto == Alltrim(cProduto)
			lRet := .t.
		Else
			Help(NIL, NIL, "Mapa de Risco - Produto", NIL, "Produto n�o faz parte do mapa de risco do funcion�rio", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique o produto."})
			lRet := .f.
		EndIf
		If nQtdLib <= _nQuantEpi
			lRet := .t.
		Else
			Help(NIL, NIL, "Quantidade", NIL, "A quantidade solicitada excede o valor parametrizado para o Mapa de Risco do Funcion�rio.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique a quantidade solicitada."})
			lRet := .f.
		EndIf
	Else
		Help(NIL, NIL, "Mapa de Risco", NIL, "N�o foi poss�vel realizar a consulta no Mapa de Risco do Funcion�rio.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique com o Adm do sistema."})
		lRet := .f.
	EndIf
Return(lRet)