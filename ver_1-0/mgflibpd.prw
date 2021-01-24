#Include "protheus.ch"
#Include "TBICONN.CH"
#Include "TopConn.ch"
#Include 'FwMVCDef.ch'

#DEFINE CRLF Chr(13)+Chr(10)

/*
=====================================================================================
Programa............: xMGFLIBPD
Autor...............: Bruno Tamanaka
Data................: 11/01/2019
Descrição / Objetivo: Atualizar os pedidos de vendas com bloqueio de estoque Taura. 
Doc. Origem.........: 
Solicitante.........: Fabiano Pereira
Uso.................: Marfrig
Obs.................: Prepara ambiente para o JOB
=====================================================================================
*/

User Function xMGFLIPD(cEmp,cFil)

	Local lPrepEnv  := ( IsBlind() .or. ( Select( "SM0" ) == 0 ) )
	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	Local cFilJob
	Local lTrue := .T.
	Private aFilLog := {cEmp,cFil}

	If ( lPrepEnv )
		RpcSetType( 3 )
		PREPARE ENVIRONMENT EMPRESA( cEmp ) FILIAL ( cFil ) TABLES "SC5", "SZJ", "SZT", "SZV"

	EndIf

	BEGIN SEQUENCE
		AtuSX6A()
		cFilJob	:= getmv("MGF_LIBPD")//Recebe as filiais que serão processadas

		/*
		GetUserInfoArray()
		Retorna um array multidimensional com as informações de cada um do processos em execução no Protheus 8 Server e/ou TOTVS Application Server. Esta função é um espelho dos dados que aparecem no TOTVS Monitor.

		Sintaxe:
		GetUserInfoArray ( ) --> aRet

		Retorno :
		aRet(array_of_record) 
		Retorna um array multidimensional com os números e dados de cada uma das threads.
		aInfo[x][01] = (C) Nome de usuário
		aInfo[x][02] = (C) Nome da máquina local
		aInfo[x][03] = (N) ID da Thread
		aInfo[x][04] = (C) Servidor (caso esteja usando Balance; caso contrário é vazio)
		aInfo[x][05] = (C) Nome da função que está sendo executada
		aInfo[x][06] = (C) Ambiente(Environment) que está sendo executado
		aInfo[x][07] = (C) Data e hora da conexão
		aInfo[x][08] = (C) Tempo em que a thread está ativa (formato hh:mm:ss)
		aInfo[x][09] = (N) Número de instruções
		aInfo[x][10] = (N) Número de instruções por segundo
		aInfo[x][11] = (C) Observações
		aInfo[x][12] = (N) (*) Memória consumida pelo processo atual, em bytes
		aInfo[x][13] = (C) (**) SID - ID do processo em uso no TOPConnect/TOTVSDBAccess, caso utilizado.
		*/

		aInfo := GetUserInfoArray()

		for nI := 1 to len(aInfo)
			if "MGFLIBPD" $ aInfo[nI][5] .AND. aInfo[nI][3] <> Threadid()
				lTrue := .F.
			endif
		next nI

		If lTrue .and. iif(lPrepEnv,cFil,cFilAnt) $ cFilJob
			Conout('Iniciou Processo: ' + DtoC(Date()) + ' Horas: ' + TIME())

			If ( lPrepEnv )
				MGFLIBPD(cFilJob,lPrepEnv)
			Else
				xMGFLIBPD(cFilJob,lPrepEnv)
			EndIf
			Conout('Terminou Processo: ' + DtoC(Date()) + ' Horas: ' + TIME())
		EndIf

		RECOVER
		Conout('Deu Problema na Execução' + ' Horas: ' + TIME())

	END SEQUENCE

	ErrorBlock( bError )

	If ( lPrepEnv )
		RESET ENVIRONMENT
	EndIF

Return .T.

/*
Monta error Block
*/

Static Function MyError(oError )
	Conout( oError:Description + " Deu Erro" )
	BREAK
Return .T.

/*
=====================================================================================
Programa............: MGFLIBPD
Autor...............: Bruno Tamanaka
Data................: 11/01/2019
Descrição / Objetivo: Atualizar os pedidos de vendas com bloqueio de estoque Taura. 
Doc. Origem.........: 
Solicitante.........: Fabiano Pereira
Uso.................: Marfrig
=====================================================================================
*/

Static Function MGFLIBPD(cFilJob,lPrepEnv)

	Local aPC5 := {}
	Local cQuery 	:= ""
	Local cData		:= dtos(Date())
	Local cHorIni	:= Time()
	Local cObserv 	:= ""
	Local cCodint	:= Substr((getmv("MGF_LIBZ2")),1,3)
	Local cCodtpint	:= Substr((getmv("MGF_LIBZ2")),4,3)
	Local cHorOrd
	Local cTempo
	Local cDocori
	Local nRecnoDoc
	Local lLib 		:= .F.
	Local cMsgErro	:= ''
	Local bFunc		:= nil
	Local lBlq		:= .F.
	Local lRet 		:= .F.
	Local cCodRga	:= ""
	Local _nContaReg	:= 0
	Local _aLog := {}
	Private _cTMSSC5 := "SC5_"+__cUserId
	Private _lExec := .F.
	Private _cLog := ""

	Private oMark

	cCodRga := GetMV("MGF_LIBPD1") // regras que entram para efetuar o desbloqueio automatico de estoque
	cCodRga := FormatIn(cCodRga,'/')
	_cLog := ""
	//Seleção dos pedidos a serem atualizados.
	//Melhoria na Query para não pegar registros que não devem dentro das liberações de pedidos pela regra da FAT14
	cQuery := "		SELECT DISTINCT SC5.C5_ZDTEMBA ,SC5.C5_ZDTREEM, SC5.C5_FILIAL AS FILIAL, SC5.C5_NUM AS PEDIDO, ZV_CODRGA as CODREGRA, SC5.R_E_C_N_O_ SC5RECNO "
	cQuery += "		FROM " + RetSqlName("SC5") + " SC5 "
	cQuery += "		INNER JOIN " + RetSqlName("SZJ") + " SZJ ON SZJ.ZJ_COD = SC5.C5_ZTIPPED AND SZJ.ZJ_TAURA = 'S' AND SZJ.D_E_L_E_T_ = ' ' AND ZJ_ESTFT14 = '1' "
	cQuery += "		INNER JOIN " + RetSqlName("SZV") + " SZV ON SZV.ZV_FILIAL = SC5.C5_FILIAL AND SZV.ZV_PEDIDO = SC5.C5_NUM AND SZV.D_E_L_E_T_ = ' ' AND SZV.ZV_CODRGA IN "+cCodRga+" "
	cQuery += "		INNER JOIN " + RetSqlName("SZT") + " SZT ON SZT.ZT_CODIGO = SZV.ZV_CODRGA AND SZT.ZT_TIPOREG = '3' AND SZT.D_E_L_E_T_ = ' ' "
	cQuery += "		WHERE SC5.C5_MSBLQL <> '1' "
	cQuery += "		AND SC5.C5_ZROAD <> 'S' "
	cQuery += "		AND SC5.C5_FECENT >= '" + cData + "' "
	cQuery += "		AND SC5.C5_FILIAL = '" + cFilJob + "' "	
	cQuery += "		AND SC5.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND SC5.C5_ZBLQRGA = 'B' "
	cQuery += " 	AND SZV.ZV_CODAPR = ' ' " 
	cQuery += " 	AND SC5.C5_NUM IN (SELECT SC6.C6_NUM from " + RetSqlName("SC6") + " SC6 "
	cQuery += " 	INNER JOIN " + RetSqlName("SF4") + " SF4 ON F4_FILIAL = '" + xFilial('SF4') + "' AND SF4.D_E_L_E_T_ = ' ' AND F4_CODIGO = C6_TES AND F4_ESTOQUE = 'S' "
	cQuery += " 	WHERE 1=1 AND SC6.D_E_L_E_T_ = ' ' AND "
	cQuery += " 	SC5.C5_FILIAL = SC6.C6_FILIAL AND "
	cQuery += " 	SC5.C5_NUM = SC6.C6_NUM AND "
	cQuery += " 	SC5.C5_CLIENTE = SC6.C6_CLI AND " 
	cQuery += " 	SC5.C5_LOJAENT = SC6.C6_LOJA AND "
	cQuery += " 	SC5.C5_ZBLQRGA = 'B') "
	cQuery += "		ORDER BY SC5.C5_ZDTEMBA ,SC5.C5_ZDTREEM,SC5.C5_NUM "

	If Select("LIBC5") > 0
		LIBC5->(DbClosearea())
	Endif

	TcQuery cQuery New Alias "LIBC5"
	DbSelectArea("LIBC5")
	LIBC5->(DbGoTop())

	While LIBC5->(!Eof())
		_nContaReg++
		AADD(aPc5,{Alltrim(LIBC5->FILIAL),Alltrim(LIBC5->PEDIDO),LIBC5->SC5RECNO,LIBC5->CODREGRA})
		DBSelectArea("LIBC5")
		LIBC5->(DbSkip())
	EndDo

	aadd(_aLog,{"FILIAL","PEDIDO","ITEM","COD. PRODUTO","DESCR. PRODUTO","QUANT PED","SLD. PROTHEUS","STATUS"})

	For nT := 1 To Len(aPC5)
		cObserv := ""
		dbSelectArea('SZT')
		SZT->(dbSetOrder(1))//ZT_FILIAL+ZT_CODIGO

		DbSelectArea('SC5')
		SC5->(dbSetOrder(1))//C5_FILIAL+C5_NUM

		DbSelectArea('SC6')
		SC6->(dbSetOrder(1))//C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO

		If (SZT->(dbSeek(xFilial('SZT') + aPc5[nT][4] ))) //Posiciona na Regra
			If SZT->ZT_MSBLQL <> '1'//Verifica se Regra não esta Bloqueada
				If SC5->(DbSeek(aPc5[nT][1]+aPc5[nT][2])) .and. SA1->(DbSeek(xFilial('SA1') + SC5->(C5_CLIENTE + C5_LOJACLI)))//Posiciona no Pedido e no Cliente 
					If SZT->ZT_TIPO == '3'//Produto
						If SC6->(DbSeek(xFilial('SC6') + SC5->C5_NUM)) .and. SB1->(DbSeek(xFilial('SB1') + SC6->(C6_PRODUTO)))//Posiciona no primeiro item do pedido 
							While SC6->(!Eof()) .and. SC6->(C6_FILIAL + C6_NUM) == xFilial('SC6') + SC5->C5_NUM //faz a verredura de todos os itens do pedido
								aRetSaldo := { 0 , 0 }
								aRetSaldo := getSalProt(SC6->C6_PRODUTO,  aPc5[nT][2], aPc5[nT][1], .F., SC6->C6_ZDTMIN, SC6->C6_ZDTMAX, .T. )
								Conout("[MGFLIBPD] - Analizado Pedido:"+SC6->C6_NUM+" Item: "+SC6->C6_ITEM+" Produto: "+Alltrim(SC6->C6_PRODUTO)+" Qtd Pedido: "+Transform(SC6->C6_QTDVEN,"@E 999,999,999.9999"))
								aadd(_aLog,{SC6->C6_FILIAL,SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_DESCRI,TRANSFORM(SC6->C6_QTDVEN,"@E 999,999,999,999.999"),TRANSFORM(aRetSaldo[1],"@E 999,999,999,999.999"),iif(aRetSaldo[1] >= ( SC6->C6_QTDVEN - SC6->C6_QTDENT ),"ITEM LIBERADO ","ITEM BLOQUEADO")})
								if aRetSaldo[1] >= ( SC6->C6_QTDVEN - SC6->C6_QTDENT )
									lRet := u_xMF10LbRj(SC6->C6_NUM,SC6->C6_ITEM,aPc5[nT][4],"ZZZZZ1",.T.)
								Else
									cMsgErro := 'A Funcao da regra: ' + aPc5[nT][4] + ', não esta retornando um valor logico. favor verificar'
								EndIf							
								SC6->(DbSkip())
							EndDo
						Else
							cMsgErro := 'Não Foi encontrado o itens para o Pedido: ' + aPc5[nT][2]
						EndIf
					Else
						cMsgErro := 'Não Foi encontrado o Pedido: ' + aPc5[nT][2]
					EndIf
				Else
					cMsgErro := 'Regra: ' + aPc5[nT][4] + ' encontra-se Bloqueada'
				EndIf
			Else
				cMsgErro := 'Não Foi encontrado a Regra de Bloqueio: ' + aPc5[nT][4]
			EndIf

			If !Empty(cMsgErro)
				cObserv += Alltrim(cMsgErro)
			EndIF

			//Adiciona no historico do pedido
			If !Empty(cObserv)
				U_MGFHIS99(aPc5[nT][1],aPc5[nT][2],"[MGFLIBPD] - "+cObserv,.T.)
			EndIf

			//Adiciona no historico do pedido
			//			If !Empty(_cLog)
			//				U_MGFHIS99(aPc5[nT][1],aPc5[nT][2],"[MGFLIBPD] - "+_cLog,.T.)
			//			EndIf

		EndIf

		Conout(_cLog)
		If lRet

			//lLib := !(U_xMF10ExiB(aPc5[nT][1],alltrim(aPc5[nT][2])))
			// a função acima chama essa parte abaixo do programa mas para termos controle de mensagens
			// copiei o trecho para acrescentar as mensagens de log.
			If !Empty(alltrim(aPc5[nT][2]))
				dbSelectArea('SC5')
				SC5->(dbSetOrder(1))
				If SC5->(dbSeek(xFilial('SC5',aPc5[nT][1]) + alltrim(aPc5[nT][2])))
					//					If SC5->C5_ZCONWS == 'S' //Verifica se ja fez a consulta do Webservice
					dbSelectArea('SZV')
					SZV->(dbSetOrder(1))////ZV_FILIAL, ZV_PEDIDO, ZV_ITEMPED, ZV_CODRGA
					If SZV->(DbSeek(xFilial('SZV',aPc5[nT][1]) + alltrim(aPc5[nT][2])))
						While SZV->(!Eof()).and. ( SZV->(ZV_FILIAL + ZV_PEDIDO ) == xFilial('SZV',aPc5[nT][1]) + alltrim(aPc5[nT][2] ))
							If Empty(SZV->ZV_DTAPR)
								lLib := .F.
								Exit
							EndIf
							SZV->(dbSkip())
						EndDo
					EndIf
					//					Else
					//						lLib := .F.
					//					EndIf
				Else
					lLib := .F.
				EndIf
			EndIf

			// o trecho abaixo é após a efetiva análise se o pedido todo não tem nenhum tipo de bloqueio
			dbSelectArea('SC5')
			SC5->(dbSetOrder(1))//C5_FILIAL + C5_NUM
			If SC5->(dbSeek(aPc5[nT][1] + aPc5[nT][2]))
				RECLOCK("SC5",.F.)
				If lLib //Liberação 
					lEnv := SC5->C5_ZBLQRGA <> 'L'
					SC5->C5_ZBLQRGA := 'L'
					cObserv := "Liberado com sucesso filial:"+aPc5[nT][1]+" pedido:"+aPc5[nT][2] + CRLF
					aadd(_aLog,{SC5->C5_FILIAL,SC5->C5_NUM,"","","","","","PEDIDO LIBERADO"})
					Conout(cObserv)
				Else
					lEnv := SC5->C5_ZBLQRGA <> 'B'
					SC5->C5_ZBLQRGA := 'B'
					aadd(_aLog,{SC5->C5_FILIAL,SC5->C5_NUM,"","","","","","PEDIDO AINDA BLOQUEADO"})
					cObserv := "Bloqueado ainda filial:"+aPc5[nT][1]+" pedido:"+aPc5[nT][2] + CRLF
					Conout(cObserv)
				EndIf

				SC5->C5_ZLIBENV := 'S'
				SC5->C5_ZTAUREE := 'S'
				SC5->C5_ZCONRGA	:= 'S'	
				If FieldPos("C5_ZLIBPD") > 0
					SC5->C5_ZLIBPD := SC5->C5_ZLIBPD + 1 
				EndIf
				SC5->(MSUNLOCK())
			Endif

		Else
			aadd(_aLog,{SC5->C5_FILIAL,SC5->C5_NUM,"","","","","","PEDIDO AINDA BLOQUEADO"})
		EndIf

		//Adiciona no historico do pedido
		U_MGFHIS99(aPc5[nT][1],aPc5[nT][2],"[MGFLIBPD] - "+cObserv,.F.)
		//Preenche as variaveis para o log de execução 
		cHorOrd		:= Time()
		cTempo		:= ElapTime(cHorIni,cHorOrd)
		cDocori 	:= alltrim(SC5->C5_FILIAL) + alltrim(SC5->C5_NUM)
		nRecnoDoc   := SC5->(Recno())

		//Chama a função de log
		U_MGFMONITOR(SC5->C5_FILIAL,"1"/*cStatus*/,cCodint,cCodtpint,cObserv,cDocori,cTempo,''/*cErro*/,nRecnoDoc,''/*cHTTP*/,.F./*lJob*/,aFilLog/*aFil*/)

	Next nT

	_cLog := ""
	For xlog := 1 To Len(_aLog)
		_cLog += _aLog[xlog][1]+";"+_aLog[xlog][2]+";"+_aLog[xlog][3]+";"+_aLog[xlog][4]+";"+_aLog[xlog][5]+";"+_aLog[xlog][6]+";"+_aLog[xlog][7]+";"+_aLog[xlog][8]+ CRLF
	Next xLog
	cHorOrd		:= Time()
	cTempo		:= ElapTime(cHorIni,cHorOrd)
	_cLog += "========================================"
	_cLog += "Tempo Total de Processamento: "+cTempo
	_cLog += "========================================"
	Conout(_cLog)
	_cLog := ""

Return

// Rotina de Menu de Usuario

Static Function xMGFLIBPD(cFilJob,lPrepEnv)

	Local aPC5 := {}
	Local cQuery 	:= ""
	Local cData		:= dtos(Date())
	Local cHorIni	:= Time()
	Local cObserv 	:= ""
	Local cCodint	:= Substr((getmv("MGF_LIBZ2")),1,3)
	Local cCodtpint	:= Substr((getmv("MGF_LIBZ2")),4,3)
	Local cHorOrd
	Local cTempo
	Local cDocori
	Local nRecnoDoc
	Local lLib 		:= .T.
	Local cMsgErro	:= ''
	Local bFunc		:= nil
	Local lBlq		:= .F.
	Local lRet 		:= .F.
	Local cCodRga	:= ""
	Local _nContaReg	:= 0

	Private aCores	:={} 
	Private _cTMSSC5 := "SC5_"+__cUserId
	Private _lExec := .F.
	Private _cLog := ""
	Private cMarca    := GetMark()
	Private aRotina   := {}
	Private aCampos   := {}    

	cCodRga := GetMV("MGF_LIBPD1") // regras que entram para efetuar o desbloqueio automatico de estoque
	cCodRga := FormatIn(cCodRga,'/')

	//Seleção dos pedidos a serem atualizados.
	//Melhoria na Query para não pegar registros que não devem dentro das liberações de pedidos pela regra da FAT14
	cQuery := "		SELECT DISTINCT SC5.C5_ZDTEMBA ,SC5.C5_ZDTREEM, SC5.C5_FILIAL AS FILIAL, SC5.C5_NUM AS PEDIDO, ZV_CODRGA as CODREGRA, SC5.R_E_C_N_O_ SC5RECNO "
	cQuery += "		FROM " + RetSqlName("SC5") + " SC5 "
	cQuery += "		INNER JOIN " + RetSqlName("SZJ") + " SZJ ON SZJ.ZJ_COD = SC5.C5_ZTIPPED AND SZJ.ZJ_TAURA = 'S' AND SZJ.D_E_L_E_T_ = ' ' AND ZJ_ESTFT14 = '1' "
	cQuery += "		INNER JOIN " + RetSqlName("SZV") + " SZV ON SZV.ZV_FILIAL = SC5.C5_FILIAL AND SZV.ZV_PEDIDO = SC5.C5_NUM AND SZV.D_E_L_E_T_ = ' ' AND SZV.ZV_CODRGA IN "+cCodRga+" "
	cQuery += "		INNER JOIN " + RetSqlName("SZT") + " SZT ON SZT.ZT_CODIGO = SZV.ZV_CODRGA AND SZT.ZT_TIPOREG = '3' AND SZT.D_E_L_E_T_ = ' ' "
	cQuery += "		WHERE SC5.C5_MSBLQL <> '1' "
	cQuery += "		AND SC5.C5_ZROAD <> 'S' "
	cQuery += "		AND SC5.C5_FECENT >= '" + cData + "' "
	cQuery += "		AND SC5.C5_FILIAL = '" + cFilJob + "' "	
	cQuery += "		AND SC5.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND SC5.C5_ZBLQRGA = 'B' "
	cQuery += " 	AND SZV.ZV_CODAPR = ' ' " 
	cQuery += " 	AND SC5.C5_NUM IN (SELECT SC6.C6_NUM from " + RetSqlName("SC6") + " SC6 "
	cQuery += " 	INNER JOIN " + RetSqlName("SF4") + " SF4 ON F4_FILIAL = '" + xFilial('SF4') + "' AND SF4.D_E_L_E_T_ = ' ' AND F4_CODIGO = C6_TES AND F4_ESTOQUE = 'S' "
	cQuery += " 	WHERE 1=1 AND SC6.D_E_L_E_T_ = ' ' AND "
	cQuery += " 	SC5.C5_FILIAL = SC6.C6_FILIAL AND "
	cQuery += " 	SC5.C5_NUM = SC6.C6_NUM AND "
	cQuery += " 	SC5.C5_CLIENTE = SC6.C6_CLI AND " 
	cQuery += " 	SC5.C5_LOJAENT = SC6.C6_LOJA AND "
	cQuery += " 	SC5.C5_ZBLQRGA = 'B') "
	cQuery += "		ORDER BY SC5.C5_ZDTEMBA ,SC5.C5_ZDTREEM,SC5.C5_NUM "

	If Select("LIBC5") > 0
		LIBC5->(DbClosearea())
	Endif

	TcQuery cQuery New Alias "LIBC5"
	DbSelectArea("LIBC5")
	LIBC5->(DbGoTop())

	While LIBC5->(!Eof())
		_nContaReg++
		AADD(aPc5,{Alltrim(LIBC5->FILIAL),Alltrim(LIBC5->PEDIDO),LIBC5->SC5RECNO,LIBC5->CODREGRA})
		DBSelectArea("LIBC5")
		LIBC5->(DbSkip())
	EndDo

	// montando tela com os pedidos selecionados
	_aStru := {}
	aTam   := {}
	aadd(_aStru,{"TA_MARK"     , "C", 02, 0}) //PARA O MARKBROWSE
	aadd(_aStru,{"TA_STATUS"   , "C", 01, 0}) //PARA O STATUS
	aTam := TamSX3("C5_FILIAL")
	aadd(_aStru,{"TA_FILIAL", aTam[3],aTam[1],aTam[2]}) //FILIAL
	aTam := TamSX3("C5_NUM")
	aadd(_aStru,{"TA_PEDIDO"  , aTam[3],aTam[1],aTam[2]}) //NUMERO PEDIDO
	aadd(_aStru,{"TA_RECNO"  , "N"    ,     10,      0}) //Recno
	aTam := TamSX3("ZV_CODRGA")
	aadd(_aStru,{"TA_REGRA"  , aTam[3],aTam[1],aTam[2]}) //Codigo Regra
	aadd(_aStru,{"TA_LOG"  , "M", 10 ,0}) //Log

	_cArq1 := CriaTrab(_aStru, .T.)
	dbUseArea(.T., ,_cArq1, _cTMSSC5, .F., .F.)

	For nT := 1 To Len(aPC5)
		Reclock(_cTMSSC5,.T.)
		(_cTMSSC5)->TA_MARK 	:= cMarca
		(_cTMSSC5)->TA_STATUS 	:= '3'
		(_cTMSSC5)->TA_FILIAL   := aPc5[nT][1]
		(_cTMSSC5)->TA_PEDIDO   := aPc5[nT][2]
		(_cTMSSC5)->TA_RECNO   	:= aPc5[nT][3]
		(_cTMSSC5)->TA_REGRA   	:= aPc5[nT][4]
		(_cTMSSC5)->TA_LOG   	:= ""
		(_cTMSSC5)->(MsUnLock())
	Next nT

	aRotina := {{"Confirma		 ", "U_EXECRCM", 0, 4},;
	{"Marcar Todos	 ", "U_MARKCM ", 0, 4},;
	{"Desmarcar Todos", "U_DESMACM", 0, 4},;
	{"Inverter Todos ", "U_MARKACM", 0, 4}}


	AADD(aCampos,{"TA_FILIAL"  	, "", "Filial" 		, ""}) //Filial
	AADD(aCampos,{"TA_PEDIDO"  	, "", "Num. Pedido" , ""}) //Pedido
	AADD(aCampos,{"TA_RECNO"	, "", "ID Pedido"	, ""}) //Recno SC5
	AADD(aCampos,{"TA_REGRA"	, "", "Cod. Regra"	, ""}) //Cod. Regra Bloqueio
	AADD(aCampos,{"TA_LOG"		, "", "Log Processamento"	, ""}) //Log de Processamento

	aCores := 	{	{"TA_STATUS=='1'",'ENABLE'},;
	{"TA_STATUS=='3'",'DISABLE'}}

	DbSelectArea(_cTMSSC5)
	dbGoTop()

	MarkBrow(_cTMSSC5  ,"TA_MARK" , .F.        ,aCampos   ,   ,cMarca    ,'U_MARKACM()',         ,           ,           ,'U_MARK()',{||U_DESMACM()},               ,          ,aCores)
	//	MarkBrow([ cAlias ] [ cCampo ] [ cCpo ]     [ aCampo ] [ lInvert ] [ cMarca ] [ cCtrlM ]    [ uPar8 ] [ cExpIni ] [ cExpFim ] [ cAval ]  [ bParBloco ]   [ cExprFilTop ] [ uPar14 ] [ aColors ] [ uPar16 ] [ uPar17 ] [ uPar18 ] [ lShowAmb ] )
	If _lExec
		dbSelectArea(_cTMSSC5)
		(_cTMSSC5)->(dbGoTop())
		While !Eof()
			If !Empty((_cTMSSC5)->TA_MARK)

				cObserv := ""
				dbSelectArea('SZT')
				SZT->(dbSetOrder(1))//ZT_FILIAL+ZT_CODIGO

				DbSelectArea('SC5')
				SC5->(dbSetOrder(1))//C5_FILIAL+C5_NUM

				DbSelectArea('SB1')
				SB1->(dbSetOrder(1))//B1_FILIAL, B1_COD

				DbSelectArea('SC6')
				SC6->(dbSetOrder(1))//C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO
				If Empty(_cLog)
					_cLog := "|  ITEM   | COD. PRODUTO         | DESCR. PRODUTO                                                                                 | QUANT PED            | SLD. PROTHEUS       |  STATUS   |"+ CRLF
				EndIf
				If (SZT->(dbSeek(xFilial('SZT') + (_cTMSSC5)->TA_REGRA ))) //Posiciona na Regra
					If SZT->ZT_MSBLQL <> '1'//Verifica se Regra não esta Bloqueada
						If SC5->(DbSeek((_cTMSSC5)->TA_FILIAL+(_cTMSSC5)->TA_PEDIDO)) .and. SA1->(DbSeek(xFilial('SA1') + SC5->(C5_CLIENTE + C5_LOJACLI)))//Posiciona no Pedido e no Cliente 
							If SZT->ZT_TIPO == '3'//Produto
								If SC6->(DbSeek(SC5->C5_FILIAL + SC5->C5_NUM)) .and. SB1->(DbSeek(xFilial('SB1') + SC6->(C6_PRODUTO)))//Posiciona no primeiro item do pedido 
									While SC6->(!Eof()) .and. SC6->(C6_FILIAL + C6_NUM) == SC5->C5_FILIAL + SC5->C5_NUM //faz a verredura de todos os itens do pedido
										aRetSaldo := { 0 , 0 }
										// ultimo parametro informa se é para ser utilizada a verificação apenas de pedidos que estejam liberados na consulta de estoque desprezando os bloqueados.
										aRetSaldo := getSalProt( SC6->C6_PRODUTO, (_cTMSSC5)->TA_PEDIDO,(_cTMSSC5)->TA_FILIAL, .F., SC6->C6_ZDTMIN, SC6->C6_ZDTMAX, .T. )
										Conout("[MGFLIBPD] - Analizado Pedido:"+SC6->C6_NUM+" Item: "+SC6->C6_ITEM+" Produto: "+Alltrim(SC6->C6_PRODUTO)+" Qtd Pedido: "+Transform(SC6->C6_QTDVEN,"@E 999,999,999.9999"))
										_cLog += "|   " + SC6->C6_ITEM + "   | " + SC6->C6_PRODUTO + " | " + SC6->C6_DESCRI + " | " + TRANSFORM(SC6->C6_QTDVEN,"@E 999,999,999,999.999") + "  | " + TRANSFORM(aRetSaldo[1],"@E 999,999,999,999.999") + "  | " + iif(aRetSaldo[1] >= ( SC6->C6_QTDVEN - SC6->C6_QTDENT ),"LIBERADO ","BLOQUEADO") + " |" + CRLF
										if aRetSaldo[1] >= ( SC6->C6_QTDVEN - SC6->C6_QTDENT ) //1.499 >= 1.000 ok 
											lRet := u_xMF10LbRj(SC6->C6_NUM,SC6->C6_ITEM,(_cTMSSC5)->TA_REGRA,"ZZZZZ1",.T.)
										Else
											cMsgErro := 'A Funcao da regra: ' + (_cTMSSC5)->TA_REGRA + ', não esta retornando um valor logico. favor verificar'
										EndIf							
										SC6->(DbSkip())
									EndDo
								Else
									cMsgErro := 'Não Foi encontrado o itens para o Pedido: ' + (_cTMSSC5)->TA_PEDIDO
								EndIf
							Else
								cMsgErro := 'Não Foi encontrado o Pedido: ' + (_cTMSSC5)->TA_PEDIDO
							EndIf
						Else
							cMsgErro := 'Regra: ' + (_cTMSSC5)->TA_REGRA + ' encontra-se Bloqueada'
						EndIf
					Else
						cMsgErro := 'Não Foi encontrado a Regra de Bloqueio: ' + (_cTMSSC5)->TA_REGRA
					EndIf

					If !Empty(cMsgErro)
						cObserv += Alltrim(cMsgErro)
					EndIF

					//Adiciona no historico do pedido
					If !Empty(cObserv)
						U_MGFHIS99((_cTMSSC5)->TA_FILIAL,(_cTMSSC5)->TA_PEDIDO,"[MGFLIBPD] - "+cObserv,.F.)
					EndIf
				EndIf

				If lRet
					//lLib := !(U_xMF10ExiB(aPc5[nT][1],alltrim(aPc5[nT][2])))
					// a função acima chama essa parte abaixo do programa mas para termos controle de mensagens
					// copiei o trecho para acrescentar as mensagens de log.
					If !Empty(alltrim((_cTMSSC5)->TA_PEDIDO))
						dbSelectArea('SC5')
						SC5->(dbSetOrder(1))
						If SC5->(dbSeek(xFilial('SC5',(_cTMSSC5)->TA_FILIAL) + alltrim((_cTMSSC5)->TA_PEDIDO)))
							//							If SC5->C5_ZCONWS == 'S' //Verifica se ja fez a consulta do Webservice
							dbSelectArea('SZV')
							SZV->(dbSetOrder(1))////ZV_FILIAL, ZV_PEDIDO, ZV_ITEMPED, ZV_CODRGA
							If SZV->(DbSeek(xFilial('SZV',(_cTMSSC5)->TA_FILIAL) + alltrim((_cTMSSC5)->TA_PEDIDO)))
								While SZV->(!Eof()).and. ( SZV->(ZV_FILIAL + ZV_PEDIDO ) == xFilial('SZV',(_cTMSSC5)->TA_FILIAL) + alltrim((_cTMSSC5)->TA_PEDIDO ))
									If Empty(SZV->ZV_DTAPR)
										lLib := .F.
										Exit
									EndIf
									SZV->(dbSkip())
								EndDo
							EndIf
							//							Else
							//								lLib := .F.
							//							EndIf
						Else
							lLib := .F.
						EndIf
					EndIf

					// o trecho abaixo é após a efetiva análise se o pedido todo não tem nenhum tipo de bloqueio
					dbSelectArea('SC5')
					SC5->(dbSetOrder(1))//C5_FILIAL + C5_NUM
					If SC5->(dbSeek((_cTMSSC5)->TA_FILIAL+(_cTMSSC5)->TA_PEDIDO))
						RECLOCK("SC5",.F.)
						If lLib //Liberação 
							lEnv := SC5->C5_ZBLQRGA <> 'L'
							SC5->C5_ZBLQRGA := 'L'
							cObserv := "Liberado com sucesso filial:"+(_cTMSSC5)->TA_FILIAL+" pedido:"+(_cTMSSC5)->TA_PEDIDO + CRLF
						Else
							lEnv := SC5->C5_ZBLQRGA <> 'B'
							SC5->C5_ZBLQRGA := 'B'
							cObserv := "Bloqueado ainda filial:"+(_cTMSSC5)->TA_FILIAL+" pedido:"+(_cTMSSC5)->TA_PEDIDO + CRLF
						EndIf

						SC5->C5_ZLIBENV := 'S'
						SC5->C5_ZTAUREE := 'S'
						SC5->C5_ZCONRGA	:= 'S'	
						If FieldPos("C5_ZLIBPD") > 0
							SC5->C5_ZLIBPD := SC5->C5_ZLIBPD + 1 
						EndIf
						SC5->(MSUNLOCK())
					Endif

					If lLib
						Conout("Pedido Nº:"+(_cTMSSC5)->TA_PEDIDO+" liberado pela regra de estoque apenas.")
					Else
						Conout("Pedido Nº:"+(_cTMSSC5)->TA_PEDIDO+" não liberado pela regra do estoque.")
					EndIf
				Else
					Conout("Pedido Nº:"+(_cTMSSC5)->TA_PEDIDO+" não liberado pela regra do estoque.")
				EndIf

				//Adiciona no historico do pedido
				U_MGFHIS99((_cTMSSC5)->TA_FILIAL,(_cTMSSC5)->TA_PEDIDO,"[MGFLIBPD] - "+Alltrim(cObserv),.F.)
				//Preenche as variaveis para o log de execução 
				cHorOrd		:= Time()
				cTempo		:= ElapTime(cHorIni,cHorOrd)
				cDocori 	:= alltrim((_cTMSSC5)->TA_FILIAL) + alltrim((_cTMSSC5)->TA_PEDIDO)
				nRecnoDoc   := SC5->(Recno())

				//Chama a função de log
				U_MGFMONITOR((_cTMSSC5)->TA_FILIAL,"1"/*cStatus*/,cCodint,cCodtpint,Alltrim(cObserv),cDocori,cTempo,''/*cErro*/,nRecnoDoc,''/*cHTTP*/,.F./*lJob*/,aFilLog/*aFil*/)

			EndIf
			dbSelectArea(_cTMSSC5)
			(_cTMSSC5)->(DbSkip())
		EndDo
	EndIf
	//MarkBRefresh()				// atualiza o browse
	(_cTMSSC5)->(dbCloseArea())
	// Mostra Log
	fShowLog(_cLog)
	// apaga a tabela temporário
	MsErase(_cArq1+GetDBExtension(),,"DBFCDX")

Return

Static Function AtuSX6A()

	If SX6->(!DbSeek(xFilial()+"MGF_LIBPD1"))
		RecLock("SX6",.T.)
		SX6->X6_FIL    := ""
		SX6->X6_VAR    := "MGF_LIBPD1"
		SX6->X6_TIPO   := "C"
		SX6->X6_DESCRIC:= "Cod. de Regras que usaremos para liberação de estoque"
		SX6->X6_DESC1  := ""
		//12345678901234567890123456789012345678901234567890
		SX6->X6_CONTEUD:= "000011/"
		SX6->X6_PROPRI := "U"
		SX6->X6_PYME   := "S"
		MsUnlock()
	Endif



	If SX6->(!DbSeek(xFilial()+"MGF_LIBZ2 "))
		_nSZ2 := U_GETSZ2()
		_nSZ3 := U_GETSZ3(strzero(_nSZ2,3))
		RecLock("SX6",.T.)
		SX6->X6_FIL    := ""
		SX6->X6_VAR    := "MGF_LIBZ2"
		SX6->X6_TIPO   := "C"
		SX6->X6_DESCRIC:= "Cod. de Integração Lib.Pedido Venda Automatico"
		SX6->X6_DESC1  := ""
		//12345678901234567890123456789012345678901234567890
		SX6->X6_CONTEUD:= strzero(_nSZ2,3)+strzero(_nSZ3,3)
		SX6->X6_PROPRI := "U"
		SX6->X6_PYME   := "S"
		MsUnlock()
	Endif

Return

User Function fMkBrwL()
	Local cTitulo := "Legenda"
	Local aLegenda:= {}

	aAdd(aLegenda, {"BR_VERMELHO" ,"BLOQUEADO TOTAL"})
	aAdd(aLegenda, {"BR_VERDE"   ,"LIBERADO TOTAL"    })

	BrwLegenda("Legenda do Browse",cTitulo,aLegenda)

Return

User Function EXEMGLB()

	_lExec := .T.

	//	CloseBrowse()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fShowLog  ³ Autor ³ Felipe Nathan Welter  ³ Data ³ 09/09/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Apresentacao do log de processo/erro em tela                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³1.cTxtLog - texto de log para apresentacao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³NGPimsCst                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fShowLog(cTxtLog)

	Local cPrograma := Substr(ProcName(1),1,Len(ProcName(1)))
	Local cMask := "Arquivos Texto (*.TXT) |*.txt|"
	Local oFont, oDlg
	Local aLog := Array(1)

	Local cArq   := cPrograma + "_" + SM0->M0_CODIGO + SM0->M0_CODFIL + "_" + Dtos(Date()) + "_" + StrTran(Time(),":","") + ".LOG"
	Local __cFileLog := MemoWrite(cArq,cTxtLog)

	lSched := If(Type("lSched")<>"L",.F.,lSched)

	If !lSched .And. !Empty(cArq)
		cTxtLog := MemoRead(AllTrim(cArq))
		aLog[1] := {cTxtLog}
		DEFINE FONT oFont NAME "Courier New" SIZE 5,0
		DEFINE MSDIALOG oDlg TITLE "Log de Processo" From 3,0 to 340,817 COLOR CLR_BLACK,CLR_WHITE PIXEL
		@ 5,5 GET oMemo  VAR cTxtLog MEMO SIZE 500,145 OF oDlg PIXEL
		oMemo:bRClicked := {||AllwaysTrue()}
		oMemo:oFont := oFont
		oMemo:lReadOnly := .T.

		DEFINE SBUTTON FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL
		DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,OemToAnsi("Salvar Como...")),If(cFile="",.t.,MemoWrite(cFile,cTxtLog)),oDlg:End()) ENABLE OF oDlg PIXEL
		DEFINE SBUTTON  FROM 153,115 TYPE 6 ACTION fLogPrint(aLog,cPrograma) ENABLE OF oDlg PIXEL
		ACTIVATE MSDIALOG oDlg CENTERED
	EndIf

Return Nil

//Funções antigas mantidas para retrocompatibilidade com fontes que fazem callstatic:
// MGFFAT16, MGFFAT68, MGFLIBPD, MGFWSC27, MGFWSC33
//------------------------------------------------------
// Retorna saldo do Produto apos consulta com Taura - Pedido deve estar posicionado
// [1] = Saldo (Taura - Protheus)
// [2] = Peso Medio
//------------------------------------------------------
static function getSalProt( cB1Cod, cC5Num, cStockFil, lJobStock, dDtMin, dDtMax, _BlqEst )
	local cQueryProt	:= ""
	local nRetProt		:= 0
	local nRetProt2		:= 0
	local aArea			:= getArea()
	local aAreaSZJ		:= SZJ->(getArea())
	local aAreaSA1		:= SA1->(getArea())
	local aAreaSB1		:= SB1->(getArea())

	local aRet			:= {}
	local aRet2			:= {}
	local nSalProt		:= 0
	local nSalProt2		:= 0
	local nPesoMedio	:= 0
	local aRetStock		:= { 0 , 0 }

	local lRet			:= .F.
	local lFefo			:= .F.

	local nMGFDTMIN		:= 0
	local nMGFDTMAX		:= 0

	local dDataMin		:= CTOD("  /  /  ")
	local dDataMax		:= CTOD("  /  /  ")

	local nDtMin		:= superGetMv("MGF_DTMIN", , 0 )
	local nDtMax		:= superGetMv("MGF_DTMAX", , 0 )

	local nDtMinPr		:= superGetMv( "MGF_MINPR", , 0 )
	local nDtMaxPr		:= superGetMv( "MGF_MAXPR", , 0 )

	default lJobStock	:= .F.
	default cC5Num		:= space(06)
	default cStockFil	:= cFilAnt

	default dDtMin		:= CTOD("  /  /  ")
	default dDtMax		:= CTOD("  /  /  ")
	default _BlqEst		:= .F.

	if !empty( dDtMin )
		dDataMin := dDtMin
	endif

	if !empty( dDtMax )
		dDataMax := dDtMax
	endif

	if !empty( dDataMin ) .and. !empty( dDataMax )
		lFefo := .T.
	endif

	if lJobStock
		if QRYSB2->ZJ_FEFO <> 'S'
			// Para o tipo VE as datas nao importam na consulta ao Taura, mas na conta para debitar Pedidos do Protheus sim
			dDataMin := CTOD("  /  /  ")
			dDataMax := CTOD("  /  /  ")
		elseif QRYSB2->ZJ_FEFO == 'S'
			dDataMin := dDataBase + QRYSB2->ZJ_MINIMO
			dDataMax := dDataBase + QRYSB2->ZJ_MAXIMO
		endif
	endif

	if lJobStock
		if QRYSB2->ZJ_FEFO <> 'S'
			U_MGFTAE21( @aRet, cStockFil, QRYSB2->idproduto, .F., dDataMin, dDataMax )
		else
			// Se NAO houver saldo no VE outros tipos recebem o saldo do VE (zerado ou negativo)
			// Se HOUVER saldo no VE consulta novamente o saldo nos outros tipos

			U_MGFTAE21( @aRet, cStockFil, QRYSB2->idproduto, .F., dDataMin, dDataMax )

			nRetProt := getSaldoPv( QRYSB2->idproduto, cStockFil, cC5Num, "", "", _BlqEst )
			nSalProt := ( aRet[01] - nRetProt )

			aRet2 := {0}
			U_MGFTAE21( @aRet2, cStockFil, QRYSB2->idproduto, .T., dDataMin, dDataMax )

			nRetProt2 := getSaldoPv( QRYSB2->idproduto, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
			nSalProt2 := ( aRet2[01] - nRetProt2 )

			if nSalProt2 > nSalProt
				// Se FF ou PR forem maiores do que o VE, respeitara os valores do VE
				dDataMin := CTOD("  /  /  ")
				dDataMax := CTOD("  /  /  ")
			else
				aRet := {}
				aRet := aClone( aRet2 )
			endif
		endif
	else
		DBSelectArea('SZJ')
		SZJ->(DBSetOrder(1))
		SZJ->(DBSeek(xFilial('SZJ') + SC5->C5_ZTIPPED))

		if SZJ->ZJ_FEFO <> 'S'
			if !empty( dDataMin ) .and. !empty( dDataMax )
				U_MGFTAE21( @aRet, cStockFil, cB1Cod, .T., dDataMin, dDataMax )

				nRetProt := 0
				nRetProt := getSaldoPv( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
				nSalProt := 0
				nSalProt := ( aRet[01] - nRetProt )

				// CASO TENHA PARAMETRIZADO DATA, DEVERA VERIFICAR COM VE SEM DATA
				aRet2 := {0}
				U_MGFTAE21( @aRet2, cStockFil, cB1Cod, .F., dDataMin, dDataMax )

				nRetProt2 := getSaldoPv( cB1Cod, cStockFil, cC5Num, "", "", _BlqEst )
				nSalProt2 := ( aRet2[01] - nRetProt2 )

				// SE - 'VE com Data' for maior que 'VE sem Data' - Considera SEM DATA
				//if nSalProt2 > nSalProt
				if nSalProt > nSalProt2
					aRet := {}
					aRet := aClone( aRet2 )

					dDataMin := CTOD("  /  /  ")
					dDataMax := CTOD("  /  /  ")
				endif

			else
				U_MGFTAE21( @aRet, cStockFil, cB1Cod, .F., dDataMin, dDataMax )
			endif
		else
			// Se NAO houver saldo no VE outros tipos recebem o saldo do VE (zerado ou negativo)
			// Se HOUVER saldo no VE consulta novamente o saldo nos outros tipos
			U_MGFTAE21( @aRet, cStockFil, cB1Cod, .F., dDataMin, dDataMax )

			nRetProt := getSaldoPv( cB1Cod, cStockFil, cC5Num, "", "", _BlqEst )
			nSalProt := ( aRet[01] - nRetProt )

			aRet2 := {0}
			U_MGFTAE21( @aRet2, cStockFil, cB1Cod, .T., dDataMin, dDataMax )

			nRetProt2 := getSaldoPv( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
			nSalProt2 := ( aRet2[01] - nRetProt2 )

			if nSalProt2 > nSalProt
				// Se FF ou PR forem maiores do que o VE, respeitara os valores do VE
				dDataMin := CTOD("  /  /  ")
				dDataMax := CTOD("  /  /  ")
			else
				aRet := {}
				aRet := aClone( aRet2 )
			endif
		endif
	endif

	if aRet[2] > 0
		nPesoMedio := ( aRet[1] / aRet[2] )
	endif

	nRetProt := 0
	nSalProt := 0
	Conout("Parametros enviado para a função getSaldoPv: "+cB1Cod +"," + cStockFil + "," + cC5Num )
	nRetProt := getSaldoPv( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
	nSalProt := ( aRet[01] - nRetProt )
	qTaura   := aRet[01]
	restArea(aAreaSB1)
	restArea(aAreaSA1)
	restArea(aAreaSZJ)
	restArea(aArea)

	aRetStock := { nSalProt, nPesoMedio }
	Conout("[MGFWSC05] - Resuldado da funcao getSalProt: Saldo: "+ Alltrim(Transform(nSalProt,"@E 999,999,999.9999")) + " Peso Medio: "+ Alltrim(Transform(nPesoMedio,"@E 999,999,999.9999")) )
return aRetStock


//------------------------------------------------------------
// Retorna o saldo de Pedidos
//------------------------------------------------------------
static function getSaldoPv( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )

	local nSaldoPV		:= 0
	local cQueryProt	:= ""
	local cQryPv		:= getNextAlias()

	Conout("Parametros recebido na função getSaldoPv: "+cB1Cod +"," + cStockFil + "," + cC5Num )

	// a query abaixo para trazer o saldo que o Protheus tem de pedidos, por produto
	// desconsidera o pedido que está sendo manipulado no momento ou analisado
	// mas considera todos os pedidos que estão com bloqueio seja de estoque o não no sistema
	// gerando erro. Criado um parametro no final para informar se deve ou não descosiderar
	// pedidos com bloqueio de estoque.

	cQueryProt  := "SELECT SUM(C6_QTDVEN) - SUM(C6_QTDENT) AS SALDO"
	cQueryProt  += " FROM " +	RetSqlName("SC6") + " C6 "
	cQueryProt +=  " INNER JOIN " + RetSqlName("SA1") + " A1 ON C6.C6_CLI		=	A1.A1_COD AND C6.C6_LOJA		=	A1.A1_LOJA AND A1.D_E_L_E_T_	<>	'*' "
	cQueryProt +=  " INNER JOIN " + RetSqlName("SF4") + " F4 ON C6_TES			=	F4_CODIGO AND F4.D_E_L_E_T_	<>	'*' "
	cQueryProt +=  " INNER JOIN " + RetSqlName("SC5") + " C5 ON C6.C6_FILIAL = C5.C5_FILIAL AND C6.C6_NUM = C5.C5_NUM AND C5.D_E_L_E_T_ = ' ' "

	cQueryProt  += " WHERE"
	cQueryProt  += "	    C6.D_E_L_E_T_	<>	'*'"
	cQueryProt	+= "	AND F4.F4_ESTOQUE	=	'S'"
	cQueryProt  += "	AND C6_PRODUTO		=	'" + cB1Cod		+ "'"
	cQueryProt  += "	AND C6_FILIAL		=	'" + cStockFil	+ "'"
	cQueryProt  += "  	AND C6_NOTA			=	'         '"
	cQueryProt  += "  	AND C6_BLQ			<>	'R'"

	if !empty( cC5Num )
		cQueryProt  += "  AND C6_NUM <> '" + cC5Num + "'"
	endif

	if !empty( dDataMin ) .and. !empty( dDataMax )
		cQueryProt  += " AND"
		cQueryProt  += "     ("
		cQueryProt  += "         C6.C6_ZDTMIN BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
		cQueryProt  += "         OR"
		cQueryProt  += "         C6.C6_ZDTMAX BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
		cQueryProt  += "     )"
	endif

	Conout("[MGFWSC05] - Roda Query funcao getSaldoPv: "+ cQueryProt )
	tcQuery cQueryProt New Alias (cQryPv)

	if !(cQryPv)->(EOF())
		nSaldoPV := (cQryPv)->SALDO
	endif

	If Select(cQryPv) > 0
		(cQryPv)->(DBCloseArea())
	EndIf
	Conout("[MGFWSC05] - Resuldado da Query funcao getSaldoPv saldo pvs: "+ Transform(nSaldoPV,"@E 999,999,999.9999") )

	// agora processo o saldo de pedidos que estão com bloqueio de estoque
	// e desconto essa quantidade na quantidade de pedido que a query anterior trouxe pois havia contemplado
	// erroneamente todos os pedidos mesmos os que estão com bloqueio de estoque

	if _BlqEst
		cQueryProt  := "SELECT SUM(C6_QTDVEN) - SUM(C6_QTDENT) AS SALDO"
		cQueryProt  += " FROM " +	RetSqlName("SC6") + " C6 "
		cQueryProt +=  " INNER JOIN " + RetSqlName("SA1") + " A1 ON C6.C6_CLI		=	A1.A1_COD AND C6.C6_LOJA		=	A1.A1_LOJA AND A1.D_E_L_E_T_	<>	'*' "
		cQueryProt +=  " INNER JOIN " + RetSqlName("SF4") + " F4 ON C6_TES			=	F4_CODIGO AND F4.D_E_L_E_T_	<>	'*' "
		cQueryProt +=  " INNER JOIN " + RetSqlName("SC5") + " C5 ON C6.C6_FILIAL = C5.C5_FILIAL AND C6.C6_NUM = C5.C5_NUM AND C5.D_E_L_E_T_ = ' ' "
		cQueryProt +=  " INNER JOIN " + RetSqlName("SZV") + " SZV ON SZV.ZV_FILIAL = C5.C5_FILIAL AND SZV.ZV_PEDIDO = C5.C5_NUM AND SZV.D_E_L_E_T_ = ' ' AND SZV.ZV_CODRGA IN ('000011') AND SZV.ZV_ITEMPED = C6.C6_ITEM "
		cQueryProt  += " WHERE"
		cQueryProt  += "	    C6.D_E_L_E_T_	<>	'*'"
		cQueryProt	+= "	AND F4.F4_ESTOQUE	=	'S'"
		cQueryProt  += "	AND C6_PRODUTO		=	'" + cB1Cod		+ "'"
		cQueryProt  += "	AND C6_FILIAL		=	'" + cStockFil	+ "'"
		cQueryProt  += "  	AND C6_NOTA			=	'         '"
		cQueryProt  += "  	AND C6_BLQ			<>	'R'"
		cQueryProt  += "  	AND C5.C5_ZBLQRGA = 'B' "
		cQueryProt  += "  	AND SZV.ZV_CODAPR = ' ' "
		if !empty( cC5Num )
			cQueryProt  += "  AND C6_NUM <> '" + cC5Num + "'"
		endif

		if !empty( dDataMin ) .and. !empty( dDataMax )
			cQueryProt  += " AND"
			cQueryProt  += "     ("
			cQueryProt  += "         C6.C6_ZDTMIN BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
			cQueryProt  += "         OR"
			cQueryProt  += "         C6.C6_ZDTMAX BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
			cQueryProt  += "     )"
		endif

		Conout("[MGFWSC05] - Roda Query funcao getSaldoPv: "+ cQueryProt )
		tcQuery cQueryProt New Alias (cQryPv)

		if !(cQryPv)->(EOF())
			nSaldoPV := nSaldoPV - (cQryPv)->SALDO
		endif

		If Select(cQryPv) > 0
			(cQryPv)->(DBCloseArea())
		EndIf
		Conout("[MGFWSC05] - Resuldado da Query funcao getSaldoPv - saldos bloqueados: "+ Transform(nSaldoPV,"@E 999,999,999.9999") )
	ENDIF

return nSaldoPV
