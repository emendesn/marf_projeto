#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "APWEBSRV.CH"
#include 'DIRECTRY.CH'

/*/{Protheus.doc} MGFEST76
    Faz check no sistema TAURA no plano de produção, se a quantidade solicitada na SA está dentro do permitido
	e manda para aprovação caso a quantidade nao esteja de acordo
    @type  Function
    @author Wagner Neves
    @since 26/05/2020
    @version version 12.17
    @Centro de Custo que deve ser considerado - conforme documentação 
    		Abate          - 1003
			Carregamento   - 1027
			Desossa        - 1011
			Miúdos         - 1004
			Porcionados    - 1013
	@RTASK0011152
/*/

User Function MGFEST76()

	local cIdInteg		:= " "	
	local cURLUse		:= ""
	local cHTTPMetho	:= ""
	local cJson			:= ""
	local nStatuHttp	:= 0
	local aHeadStr		:= {}
	local cHeaderRet	:= ""
	local nTimeOut		:= 120
	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""
	local cHttpRet		:= ""
	local lBlock		:= .F.
	local lBlockIten	:= .F.
	local cStaLog		:= ""
	local cErroLog		:= ""
	local nI			:= 0
	local cHeadHttp		:= ""
	local nX 			:= 0
	// Definição do parametro MGF_EST76A
	_lEst76  := GetMv("MGF_EST76A")   // Ativa ou não execução da rotina
	If ! _lEST76
		Return
	Endif
	cURLInteg	:= AllTrim(SuperGetMv("MGF_EST76C",,"http://integracoes.marfrig.com.br:1699/processo-pcp/api/v1/consulta/qtd-programada"))
	cCodInteg	:= Alltrim(SuperGetMv("MGF_EST76D",,"012"))
	cCodTpInt	:= AllTrim(Supergetmv("MGF_EST76E",,"001"))
	_cCusto     := Alltrim(SuperGetMv("MGF_EST76B",,"'1003','1027','1011','1004','1013'"))   // Centros de Custo que devem ser considerados no processo
	U_MFCONOUT("[MGFEST76] Selecionando requisições EMBALAGENS dentro do periodo desejado...")
	fQrySCP1() // Seleciona as SAs que estão sendo inseridas nesse momento
	If QRYSCP1->(EOF())
		U_MFCONOUT("[MGFEST76] Não foram localizadas requisições !")
		Return
	Endif
	_lFilAutorizada := SuperGetMv( "MGF_EST76F" , ,"010003")   // Filial autorizada a executar essa rotina
	If ! cFilAnt $_lFilAutorizada
		Return
	EndIf
	cURLUse := cURLInteg
	QRYSCP1->(DBGOTOP())
	_ntot := 0
	do while !(QrysCP1->(EOF()))
		_ntot++
		QrySCP1->( Dbskip() )
	enddo
	_nni := 1
	nCountSCP1	:= 0
	nTotalSCP1	:= 0
	Count to nTotalSCP1
	QRYSCP1->(DBGoTop())
	aRequisicao			:= {}
	While !QRYSCP1->(EOF())
		_cFilial	:= Alltrim(QRYSCP1->CP_FILIAL)
		_cInsumo	:= Alltrim(QRYSCP1->CP_PRODUTO)
//		_cUnidade   := Alltrim(QRYSCP1->B1_UM)
		_cNum		:= Alltrim(QRYSCP1->CP_NUM)
		_cItem		:= Alltrim(QRYSCP1->CP_ITEM)
		_dDataUtil	:= left( fwTimeStamp( 3 , sToD( QRYSCP1->CP_ZDTUTIL ) ) , 10 ) + "T"+time()
		_cRecno		:= QRYSCP1->recno

		oJsonRequis						:= JsonObject():new()
		oJsonRequis["id"] 				:= _cNum+_cItem
		oJsonRequis["idEmpresa"] 		:= _cFilial
		oJsonRequis["idProduto"] 		:= _cInsumo
		//oJsonRequis["unidadeMedida"] 	:= _cUnidade
		oJsonRequis["dataUtilizacao"] 	:= _dDataUtil
		oJSonRequis["recno"]			:= _cRecno

		aadd( aRequisicao , oJsonRequis )

		QRYSCP1->(DBSKIP())

	EndDo
	freeObj( oJsonRequis )
	cJson 		:= ""
	cJson 		:= fwJsonSerialize( aRequisicao , .T. , .T. )
	cHTTPMetho	:= "POST"
	cHeaderRet	:= ""
	cHttpRet	:= ""	
	cIdInteg	:= fwUUIDv4( .T. )

	aHeadStr	:= {}
	aadd( aHeadStr , 'Content-Type: application/json'							)
	aadd( aHeadStr , 'origem-criacao: ' + 'MATA105-Solicitacao Armazem'			)
	aadd( aHeadStr , 'origem-alteracao: protheus'								)
	aadd( aHeadStr , 'x-marfrig-client-id: ' /*+ cIDMgf*/						)
	aadd( aHeadStr , 'x-correlation-id: ' + cIdInteg							)

	cTimeIni	:= time()
	cHttpRet	:= httpQuote( cURLUse /*<cUrl>*/, cHTTPMetho /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
	cTimeFin	:= time()
	cTimeProc	:= elapTime( cTimeIni , cTimeFin )
	nStatuHttp	:= 0
	nStatuHttp	:= httpGetStatus()

	conout(" [MGFEST76] * * * * * Status da integracao * * * * *"									)
	conout(" [MGFEST76] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )		)
	conout(" [MGFEST76] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )		)
	conout(" [MGFEST76] Tempo de Processamento.......: " + cTimeProc 								)
	conout(" [MGFEST76] URL..........................: " + cURLUse 									)
	conout(" [MGFEST76] HTTP Method..................: " + cHTTPMetho								)
	conout(" [MGFEST76] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 			)
	conout(" [MGFEST76] Envio Headers................: " + varInfo( "aHeadStr" , aHeadStr ) 		)
	conout(" [MGFEST76] Envio Body...................: " + cJson 									)
	conout(" [MGFEST76] Retorno......................: " + cHttpRet 								)
	conout(" [MGFEST76] * * * * * * * * * * * * * * * * * * * * "									)

	if nStatuHttp >= 200 .and. nStatuHttp <= 299	
		oRequisicao := Nil
		fwJsonDeserialize(cHTTPRET, @oRequisicao)
		cStaLog 	:= "1"	// Sucesso
	else
		cStaLog		:= "2"	// Erro
		cErroLog	:= cHttpRet
	endif

	cHeadHttp := ""

	for nI := 1 to len( aHeadStr )
		cHeadHttp += aHeadStr[ nI ]
	next

	for nI := 1 to len( aRequisicao )
		//GRAVAR LOG
		U_MGFMONITOR(																													 ;
			cFilAnt																			/* Filial */									,;
			cStaLog																			/* Status - 1-Suceso / 2-Erro*/					,;
			cCodInteg																		/* Integração */								,;
			cCodTpInt																		/* Tipo de integração */						,;
			iif( empty( cErroLog ) , "Processamento realizado com sucesso!" , cErroLog )	/*cErro*/										,;
			" "																				/*cDocori*/										,;
			cTimeProc																		/* Tempo de processamento */					,;
			aRequisicao[ nI ]:toJson()														/* JSON */										,;
			aRequisicao[ nI ]["recno"]														/* RECNO do registro */							,;
			cValToChar( nStatuHttp )														/* Status HTTP Retornado */						,;
			.F.																				/* Se precisar preparar ambiente enviar .T. */	,;
			{}																				/* Filial para preparar ambiente */				,;
			cIdInteg																		/* UUID */	     								,;
			iif( type( cHttpRet ) <> "U", cHttpRet, " ")									/* JSON de RETORNO */							,;
			"A"																				/*cTipWsInt*/									,;
			" "																				/*cJsonCB Z1_JSONCB*/							,;
			" "																				/*cJsonRB Z1_JSONRB*/							,;
			sTod("    /  /  ")																/*dDTCallb Z1_DTCALLB*/							,;
			" "																				/*cHoraCall Z1_HRCALLB*/						,;
			" "																				/*cCallBac Z1_CALLBAC*/							,;
			cURLUse																			/*cLinkEnv Z1_LINKENV*/							,;
			" "																				/*cLinkRec Z1_LINKREC*/							,;
			cIdInteg																		/*cHeaderID		Z1_HEADEID*/					,;
			cHeadHttp																		/*cHeadeHttp	Z1_HEADER*/						)
	next

	If cStalog == "1" // Envio com sucesso

		cStalog := "2" //Deixa como erro até achar conteúdo válido na resposta
		_nQtdProgr := 0 //Soma para considerar mais de uma resposta válida

		For Nx := 1 To Len(oRequisicao)

			If type("oRequisicao["+ALLTRIM(STR(nX))+"]:id") == 'C' .and. type("oRequisicao["+ALLTRIM(STR(nX))+"]:dataUtilizacao") == "C"

				_cNumero  	 := Subs(oRequisicao[nX]:id,1,6)
				_cItem    	 := Subs(oRequisicao[nX]:id,7,2)
				_cFilial  	 := oRequisicao[nX]:idempresa 
				_cProd	 	 := oRequisicao[nX]:idProduto
				_dDataUtil	 := oRequisicao[nX]:dataUtilizacao
				_dDataUtil	 := Subs(_dDataUtil,1,4)+subs(_dDataUtil,6,2)+subs(_dDataUtil,9,2)
				_nQtdProgr	 += oRequisicao[nX]:qtdprogramada
				_cDescProd	 := POSICIONE("SB1",1,XFILIAL("SB1")+_cProd,"B1_DESC")
				nNumSemana 	 := Subs(RetSem(STOD(_dDataUtil)),8,2)
				dDtInicio    := ctod("  /  /  ")
				dDtFim	     := ctod("  /  /  ")
				_nQtdeScpc   := 0
				_nQtdPedAber := 0
				_nQtdReqAber := 0
				_cExclusao 	 := .F.
				cStalog := "1" // achou conteúdo válido então marca que a resposta está ok 
			
			Else

				//Resposta inválida será desconsiderada
				Loop

			Endif

			dPerSem()
			
			fQryScp2() //Seleciona requisições em aberto no período

			If ! QRYSCP2->(EOF())
				_nQtdReqAber :=  QRYSCP2->QTDADE
			Endif

			_nQtdeScpc :=  ( _nQtdReqAber )

			If _nQtdeScpc  > _nQtdProgr  // Quantidade das requisições do periodo menor que o total da programação
		
				_nAprova := "N"
				If MsgYesNo("A soma das requisições de embalagem do produto "+Alltrim(_cProd)+"-"+Alltrim(_cDescProd)+" item "+_cItem+" ref. ao período "+DTOC(dDtInicio)+" Até "+DTOC(dDtFim)+" incluindo esta solicitação, excedem a quantidade programada desse produto . Esse item deverá ser submetida a aprovação da Gerencia Industrial.","Deseja submeter essa requisição de embalagem para aprovação da Gerência Industrial  ?")
					_nAprova := "S"
					fGrvAprova()  // Gera registro para aprovação
				EndIf

				If _nAprova == "N"
					If MsgYesNo("Prezado usuário, você escolheu não submeter a requisição "+_cNumero+"-"+_cItem+" de embalagem para aprovação. Caso a mesma não seja excluída, esse item mesmo assim seguirá para aprovação.","Deseja excluir o item da requisição de embalagem ? ")
						//Deletando a solicitação
						cUpdTbe	:= ""
						cUpdTbe := "UPDATE " + RetSqlName("SCP")				+ CRLF
						cUpdTbe += "	SET"									+ CRLF
						cUpdTbe += " 		D_E_L_E_T_ = '*'"					+ CRLF 
						cUpdTbe += " WHERE"										+ CRLF
						cUpdTbe += " 	CP_FILIAL = '"+_cFilial+ "' AND" 		+ CRLF
						cUpdTbe += " 	CP_NUM  = '"+_cNumero+ "' AND" 			+ CRLF
						cUpdTbe += "    CP_ITEM = '"+_cItem+"'"   				+ CRLF
						if tcSQLExec( cUpdTbe) < 0
							conout( "Não foi possível executar UPDATE." + CRLF + tcSqlError() )
						endif
						MsgInfo("Requisição "+_cNumero+" Item "+_cItem+" de embalagem foi excluida","Exclusão Requisição embalagem ")
						_cExclusao := .t.
					Else
						_nAprova := "S"
						fGrvAprova()  // Gera registro para aprovação
					EndIf
				EndIf
				If ! _cExclusao .And. _nAprova = "S"
					cUpdTbl	:= ""
					cUpdTbl := "UPDATE " + RetSqlName("SCP")				+ CRLF
					cUpdTbl += "	SET"									+ CRLF
					cUpdTbl += " 		CP_ZSTATUS	=	'07'"				+ CRLF   // 09 em aprovação
					cUpdTbl += " WHERE"										+ CRLF
					cUpdTbl += " 	CP_FILIAL = '"+_cFilial+ "' AND" 		+ CRLF
					cUpdTbl += " 	CP_NUM  = '"+_cNumero+ "' AND" 			+ CRLF
					cUpdTbl += "    CP_ITEM = '"+_cItem+"'"   				+ CRLF
					if tcSQLExec( cUpdTbl ) < 0
						conout( "Não foi possível executar UPDATE." + CRLF + tcSqlError() )
					endif
				EndIf
			else
				_cNumero  	 := Subs(oRequisicao[nX]:id,1,6)
				_cItem    	 := Subs(oRequisicao[nX]:id,7,2)
				cUpdTbl	:= ""
				cUpdTbl := "UPDATE " + RetSqlName("SCP")				+ CRLF
				cUpdTbl += "	SET"									+ CRLF
				cUpdTbl += " 		CP_ZSTATUS	=	'06'"				+ CRLF  // Aprovado
				cUpdTbl += " WHERE"										+ CRLF
				cUpdTbl += " 	CP_FILIAL = '"+_cFilial+ "' AND" 		+ CRLF
				cUpdTbl += " 	CP_NUM  = '"+_cNumero+ "' AND" 			+ CRLF
				cUpdTbl += "    CP_ITEM = '"+_cItem+"'"   				+ CRLF
				if tcSQLExec( cUpdTbl ) < 0
					conout( "Não foi possível executar UPDATE." + CRLF + tcSqlError() )
				endif
			EndIf
		Next

		lRet := .t.
	Endif
	
	If cStalog == "2"   // Erro na transmissao. Deleta a SA
		// exclui SA na SCP
		cUpdTbe	:= ""
		cUpdTbe := "UPDATE " + RetSqlName("SCP")				+ CRLF
		cUpdTbe += "	SET"									+ CRLF
		cUpdTbe += " 		D_E_L_E_T_ = '*'"					+ CRLF 
		cUpdTbe += " WHERE"										+ CRLF
		cUpdTbe += " 	CP_FILIAL = '"+_cFilial+ "' AND" 		+ CRLF
		cUpdTbe += " 	CP_NUM  = '"+_cNum+ "' AND" 			+ CRLF
		if tcSQLExec( cUpdTbe) < 0
			conout( "Não foi possível excluir requisição." + CRLF + tcSqlError() )
		endif
		MsgInfo("Requisição "+_cNum+" de embalagem foi excluida, pois não conseguiu transmitir ao TAURA para liberação.","Exclusão Requisição embalagem ")
		_cExclusao := .t.
		lRet := .f.
	EndIf

Return lRet

Static function fQrySCP1()
	If Select("QRYSCP1") # 0
		QRYSCP1->(dbCloseArea())
	EndIf
	cQryScp1 := ' '
	cQryScp1 := + CRLF + "SELECT"
	cQryScp1 += + CRLF + " CP_FILIAL,CP_NUM,CP_ITEM,CP_EMISSAO,CP_PRODUTO,CP_EMISSAO,CP_DATPRF,CP_OBS,CP_CC,CP_VUNIT,CP_CODSOLI,CP_SOLICIT,CP_STATUS,CP_STATSA,B1_DESC,B1_TIPO,B1_UM,CP_ZDTUTIL,CP_QUANT,CP_QUJE,CP_LOCAL,SCP.R_E_C_N_O_ RECNO"
	cQryScp1 += + CRLF + " FROM "	+ RetSQLName("SCP") + " SCP"
	cQryScp1 += + CRLF + " INNER JOIN "+RetSQLName("SB1") + " SB1 ON B1_COD=CP_PRODUTO"
	cQryScp1 += + CRLF + " WHERE "
	cQryScp1 += + CRLF + " SCP.CP_FILIAL='"+xFilial("SCP")+"'"
	cQryScp1 += + CRLF + " 	  AND SCP.CP_NUM='"+SCP->CP_NUM+"'"
	cQryScp1 += + CRLF + "    AND SB1.B1_TIPO='EM'"
	cQryScp1 += + CRLF + "    AND SCP.CP_QUJE < SCP.CP_QUANT"
	cQryScp1 += + CRLF + "    AND SCP.CP_CC IN ("+_cCusto+") "
	cQryScp1 += + CRLF + "    AND SCP.CP_ZSTATUS IN ('  ','06','09')"
	cQryScp1 += + CRLF + "    AND SCP.D_E_L_E_T_ = ' ' "
	cQryScp1 += + CRLF + "    AND SB1.D_E_L_E_T_ = ' ' "
	cQryScp1 += + CRLF + " ORDER BY CP_PRODUTO,CP_ZDTUTIL"
	tcQuery cQryScp1 New Alias "QRYSCP1"
Return

Static function fQrySCP2()
	If Select("QRYSCP2") # 0
		QRYSCP2->(dbCloseArea())
	EndIf
	cQryScp2 := + CRLF + "SELECT DISTINCT CP_PRODUTO,SUM(CP_QUANT) QTDADE "
	cQryScp2 += + CRLF + " FROM "	+ RetSQLName("SCP") + " SCP"
	cQryScp2 += + CRLF + " INNER JOIN "+RetSQLName("SB1") + " SB1 ON B1_COD=CP_PRODUTO"
	cQryScp2 += + CRLF + " WHERE "
	cQryScp2 += + CRLF + " SCP.CP_FILIAL='"+xFilial("SCP")+"'"
	cQryScp2 += + CRLF + " 	  AND SCP.CP_PRODUTO='"+_cProd+"'"
	cQryScp2 += + CRLF + "    AND SCP.CP_ZDTUTIL BETWEEN '"+DTOS(dDtInicio)+"' AND '"+DTOS(dDtFim)+"'"
	//cQryScp2 += + CRLF + "    AND SCP.CP_PREREQU=' ' AND SCP.CP_STATUS<> 'E' "
	cQryScp2 += + CRLF + "    AND SCP.CP_QUJE < SCP.CP_QUANT"
	//cQryScp2 += + CRLF + "    AND SCP.CP_ZSTATUS IN ('  ','06','08')"
	cQryScp2 += + CRLF + "    AND SCP.D_E_L_E_T_ = ' ' "
	cQryScp2 += + CRLF + "    AND SB1.D_E_L_E_T_ = ' ' "
	cQryScp2 += + CRLF + " GROUP BY CP_PRODUTO"
	tcQuery cQryScp2 New Alias "QRYSCP2"
Return

Static Function dPerSem()

IF DOW(STOD(_dDataUtil)) = 1
	dDtInicio := STOD(_dDataUtil) -6
	dDtFim 	  := STOD(_dDataUtil) +0 
ELSEIF DOW(STOD(_dDataUtil)) = 2
	dDtInicio := STOD(_dDataUtil) -0
	dDtFim 	  := STOD(_dDataUtil) +6
ELSEIF DOW(STOD(_dDataUtil)) = 3
	dDtInicio := STOD(_dDataUtil) -1
	dDtFim 	  := STOD(_dDataUtil) +5
ELSEIF DOW(STOD(_dDataUtil)) = 4
	dDtInicio := STOD(_dDataUtil) -2
	dDtFim 	  := STOD(_dDataUtil) +4
ELSEIF DOW(STOD(_dDataUtil)) = 5
	dDtInicio := STOD(_dDataUtil) -3
	dDtFim 	  := STOD(_dDataUtil) +3
ELSEIF DOW(STOD(_dDataUtil)) = 6
	dDtInicio := STOD(_dDataUtil) -4
	dDtFim 	  := STOD(_dDataUtil) +2
ELSEIF DOW(STOD(_dDataUtil)) = 7
	dDtInicio := STOD(_dDataUtil) -5
	dDtFim 	  := STOD(_dDataUtil) +1
ENDIF
RETURN(dDtInicio,dDtFim)
/*Segunda-feira	-	2
Terça-feira		-	3
Quarta-feira	-	4
Quinta-feira	-	5
Sexta-feira		-	6
Sábado			-	7
Domingo			-	1*/

Static Function fGrvAprova() // Consulta Cadastro Aprovadores
	If Select("TZGB") # 0
		TZGB->(dbCloseArea())
	EndIf
	cQryAprv := "SELECT * "
	cQryAprv += " FROM "+RetSQLName("ZGB")+" ZGB "
	cQryAprv += " WHERE ZGB.D_E_L_E_T_ = ' ' "
	cQryAprv += " AND ZGB.ZGB_FILIAL = '"+_cFilial+"' "
	cQryAprv += " ORDER BY ZGB.ZGB_NIVEL"
	tcQuery cQryAprv New Alias "TZGB"

	If Select("QRYSCP3") # 0
		QRYSCP3->(dbCloseArea())
	EndIf
	cQryScp3 := ' '
	cQryScp3 := + CRLF + "SELECT * "
	cQryScp3 += + CRLF + " FROM "	+ RetSQLName("SCP") + " SCP"
	cQryScp3 += + CRLF + " INNER JOIN "+RetSQLName("SB1") + " SB1 ON B1_COD=CP_PRODUTO"
	cQryScp3 += + CRLF + " WHERE "
	cQryScp3 += + CRLF + "     SCP.CP_FILIAL='"+_cFilial+"'"
	cQryScp3 += + CRLF + " AND SCP.CP_NUM='"+_cNumero+"'"
	cQryScp3 += + CRLF + " AND SCP.CP_ITEM='"+_cItem+"'"
	cQryScp3 += + CRLF + " AND SCP.D_E_L_E_T_ = ' ' "
	cQryScp3 += + CRLF + " AND SB1.D_E_L_E_T_ = ' ' "
	tcQuery cQryScp3 New Alias "QRYSCP3"
	
	DbSelectArea("TZGB")
	DbGoTop("TZGB")
	While ! TZGB->(Eof())
		DbSelectArea("ZGC")
		ZGC->(Reclock("ZGC",.T.))
		ZGC->ZGC_FILIAL 	:= xFilial("ZGC")
		ZGC->ZGC_NUM		:= QRYSCP3->CP_NUM
		ZGC->ZGC_ITEM   	:= QRYSCP3->CP_ITEM
		ZGC->ZGC_PRODUTO	:= QRYSCP3->CP_PRODUTO
		ZGC->ZGC_DESCRI   	:= QRYSCP3->B1_DESC
		ZGC->ZGC_UM	   		:= QRYSCP3->B1_UM
		ZGC->ZGC_LOCAL		:= QRYSCP3->CP_LOCAL
		ZGC->ZGC_QUANT  	:= QRYSCP3->CP_QUANT
		ZGC->ZGC_QUJE		:= QRYSCP3->CP_QUJE
		ZGC->ZGC_DTEMIS		:= STOD(QRYSCP3->CP_EMISSAO)
		ZGC->ZGC_DATPRF		:= STOD(QRYSCP3->CP_DATPRF)
		ZGC->ZGC_ZDTUTI     := STOD(QRYSCP3->CP_ZDTUTIL)
		ZGC->ZGC_OBS	    := "Motivo: Qtdade total das requisições entre: "+DTOC(dDtInicio)+" e "+DTOC(dDtFim)+"--> "+alltrim(STR(_nQtdeScpc,12,2))+" - "+"Qtdade programação Taura mesmo período "+alltrim(STR(_nQtdProgr,12,2))
		ZGC->ZGC_CC			:= QRYSCP3->CP_CC
		ZGC->ZGC_ZDESCC		:= POSICIONE("CTT",1,XFILIAL("CTT")+QRYSCP3->CP_CC,"CTT_DESC01")
		ZGC->ZGC_VUNIT      := QRYSCP3->CP_VUNIT
		ZGC->ZGC_CODSOL		:= QRYSCP3->CP_CODSOLI
		ZGC->ZGC_SOLICI  	:= QRYSCP3->CP_SOLICIT
		ZGC->ZGC_STATUS		:= "7" //QRYSCP3->CP_STATUS
		ZGC->ZGC_STATSA		:= QRYSCP3->CP_STATSA
		ZGC->ZGC_USUAPR		:= ALLTRIM(TZGB->ZGB_USUAPR)
		ZGC->ZGC_NOMAPR		:= ALLTRIM(TZGB->ZGB_NOMAPR)
		ZGC->ZGC_NIVEL		:= TZGB->ZGB_NIVEL
		ZGC->ZGC_DTGERA		:= DDATABASE
		ZGC->ZGC_HRGERA		:= TIME()
		ZGC->(MsUnlock())
		DbSelectArea("TZGB")
		TZGB->(DbSkip())
	EndDo
	TZGB->(DBCLOSEAREA())
Return
