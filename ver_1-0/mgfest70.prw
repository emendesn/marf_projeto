#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"

/*              
+-----------------------------------------------------------------------+
¦Programa  ¦MGFEST70    ¦ Autor ¦ WAGNER NEVES         ¦ Data ¦20.04.20 ¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦Ponto de Entrada para gerar a aprovação da solicitacao      ¦
¦          ¦ao armazem na tabela de aprovação no momento                ¦
¦          ¦da confirmação da inclusão e alteração - Rotina(mata105)    ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA MARFRIG			                        ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR      ¦ DATA       ¦ MOTIVO DA ALTERACAO                    ¦
+-----------------------------------------------------------------------¦
¦                 ¦            ¦ 				                        ¦
+-----------------------------------------------------------------------+
*/

User Function  MGFEST70()

	Local lRet := .T.
	Local aAreaApr := GetArea()
	Local cQuery   := ""

	Local _cGrupoInd := GetMv("MGF_EPIIND",,"0321")  // Grupo de Produto EPI Individual
	Local _cGrupoCol := GetMv("MGF_EPICOL",,"0322")  // Grupo de Produto EPI Coletivo

	Local aheader := {"Filial","Numero SA","Dt Emissão","Produto","Local","Quantidade","Matricula"}

	Private aGrupos  := {}
	Private lRet     := .T.
	Private nx       := 0
	Private _aCols   := {}
	Private cNomeFun := ''

	If !cFilAnt $GetMv("MGF_EPIFIL") // Verifica se a filial está autorizada ao tratamento de EPI
		Return
	ENDIF

	_cCondApr := "       AND SCP.CP_FILIAL = '"+SCP->CP_FILIAL+"' "
	_cCondApr += "       AND SCP.CP_NUM    = '"+SCP->CP_NUM+"' "
	_cCondApr += "       AND SCP.CP_ZMATFUN <> '      '"

	#IFDEF TOP
		If Select("TSCP") # 0
			TSCP->(dbCloseArea())
		EndIf
		cQuery := "SELECT CP_FILIAL,CP_NUM,CP_ITEM,CP_PRODUTO,B1_GRUPO,CP_UM,CP_QUANT,CP_DATPRF,CP_LOCAL,CP_OBS,CP_CC,CP_EMISSAO,CP_DESCRI,CP_CODSOLI,CP_SOLICIT,CP_QUJE,CP_STATUS,CP_STATSA,CP_VUNIT,CP_USER,CP_ZMATFUN"
		cQuery += " FROM "+RetSQLName("SCP")+" SCP "
		cQuery += " INNER JOIN SB1010 SB1 ON SB1.B1_COD = SCP.CP_PRODUTO"
		cQuery += " WHERE SCP.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' '
		cQuery += _cCondApr
		cQuery += " ORDER BY SCP.CP_FILIAL, SCP.CP_NUM, SCP.CP_ITEM "
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TSCP", .F., .T.)
	#ENDIF
	If TSCP->(EOF())
		TSCP->(DBCloseArea())
		Return
	Endif
	dbSelectArea("TSCP")
	DbGoTop("TSCP")
	cFilFat := TSCP->CP_FILIAL
	cNumSA  := TSCP->CP_NUM
	While ! TSCP->(Eof())
		If Alltrim(TSCP->B1_GRUPO) $ _cGrupoInd .Or. Alltrim(TSCP->B1_GRUPO) $ _cGrupoCol
			Aadd(_aCols,{TSCP->CP_FILIAL , TSCP->CP_NUM , DTOC(STOD(TSCP->CP_EMISSAO)), TSCP->CP_PRODUTO , TSCP->CP_LOCAL , TSCP->CP_QUANT,TSCP->CP_ZMATFUN})
			TSCP->(DbSkip())
		Else
			TSCP->(DbSkip())
			Loop
		EndIf

	EndDo

	If ! Len(_ACOLS) > 0
		RETURN
	EndIf

	U_MGListBox( "Itens da Solicitação ao Armazém" , aHeader , _ACOLS , .T. , 1 )

// Manda para aprovação
	dbSelectArea("TSCP")
	DbGoTop("TSCP")
	While ! TSCP->(Eof())

		If Alltrim(TSCP->B1_GRUPO) $ _cGrupoInd .Or. Alltrim(TSCP->B1_GRUPO) $ _cGrupoCol

			#IFDEF TOP
				If Select("TZG5") # 0
					TZG5->(dbCloseArea())
				EndIf
				cQuery := "SELECT * "
				cQuery += " FROM "+RetSQLName("ZG5")+" ZG5 "
				cQuery += " WHERE ZG5.D_E_L_E_T_ = ' ' "
				cQuery += " AND ZG5.ZG5_FILIAL = '"+TSCP->CP_FILIAL+"' "
				cQuery += " ORDER BY ZG5.ZG5_NIVEL"
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TZG5", .F., .T.)
			#ENDIF

// Consulta funcionario para buscar o nome
			cHeadRet	   := ""
			cUrlFun	   := GetMv("MGF_EPIURL",,"http://spdwvapl203:1685/epi/api/consulta/mapa?matricula=")
			aHeadOut   := {}
			nTimeOut   := 12
			aadd( aHeadOut, 'Content-Type: application/json')
			conout('Thread ' + strzero(threadid(),6) +  ' - [MGFEST60]] - Verifica informações Mapa de Risco')
			cUrl		:= cUrlFun+Alltrim(TSCP->CP_ZMATFUN)+"&codEquipSupr="+Alltrim(TSCP->CP_PRODUTO)
			cTimeIni 	:= time()
			xPostRet 	:= httpQuote( cUrl/*<cUrl>*/, "GET" /*<cMethod>*/, /*[cGETParms]*/, /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )
			cTimeFin	:= time()
			cTimeProc	:= elapTime( cTimeIni, cTimeFin )
			nStatuHttp	:= 0
			nStatuHttp	:= httpGetStatus()
			conout(" [MGFEST70] * * * * * Status da integracao * * * * *")
			conout(" [MGFEST70] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase ) )
			conout(" [MGFEST70] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase ) )
			conout(" [MGFEST70] Tempo de Processamento.......: " + cTimeProc )
			conout(" [MGFEST70] URL..........................: " + cURL)
			conout(" [MGFEST70] HTTP Method..................: " + "GET" )
			conout(" [MGFEST70] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
			conout(" [MGFEST70] Retorno......................: " + allTrim( xPostRet ) )
			conout(" [MGFEST70] * * * * * * * * * * * * * * * * * * * * ")
			oFuncionario := nil
			if fwJsonDeserialize( xPostRet, @oFuncionario)
				If Len(oFuncionario) > 0
					cNomeFun := Alltrim(oFuncionario[1]:nome)
				else
					cNomeFun := "Não encontrado"
				endif
			EndIf

			// Fim da Consulta - Manda para aprovação
			DbSelectArea("TZG5")
			DbGoTop("TZG5")
			While ! TZG5->(Eof())
				DbSelectArea("ZG6")
				ZG6->(Reclock("ZG6",.T.))
				ZG6->ZG6_FILIAL 	:= xFilial("ZG6")
				ZG6->ZG6_NUM		:= TSCP->CP_NUM
				ZG6->ZG6_ITEM   	:= TSCP->CP_ITEM
				ZG6->ZG6_PRODUTO	:= TSCP->CP_PRODUTO
				ZG6->ZG6_DESCRI   	:= TSCP->CP_DESCRI
				ZG6->ZG6_UM	   		:= TSCP->CP_UM
				ZG6->ZG6_LOCAL		:= TSCP->CP_LOCAL
				ZG6->ZG6_QUANT  	:= TSCP->CP_QUANT
				ZG6->ZG6_QUJE		:= TSCP->CP_QUJE
				ZG6->ZG6_DTEMIS		:= STOD(TSCP->CP_EMISSAO)
				ZG6->ZG6_DATPRF		:= STOD(TSCP->CP_DATPRF)
				ZG6->ZG6_OBS	    := TSCP->CP_OBS
				ZG6->ZG6_CC			:= TSCP->CP_CC
				ZG6->ZG6_ZMATFU  	:= TSCP->CP_ZMATFUN
				ZG6->ZG6_NOMFUN		:= cNomefun
				ZG6->ZG6_VUNIT      := TSCP->CP_VUNIT
				ZG6->ZG6_CODSOL		:= TSCP->CP_CODSOLI
				ZG6->ZG6_SOLICI  	:= TSCP->CP_SOLICIT
				ZG6->ZG6_STATUS		:= TSCP->CP_STATUS
				ZG6->ZG6_STATSA		:= TSCP->CP_STATSA

				ZG6->ZG6_USUAPR		:= ALLTRIM(TZG5->ZG5_USUAPR)
				ZG6->ZG6_NOMAPR		:= Alltrim(UsrRetname(ALLTRIM(TZG5->ZG5_USUAPR))) //ALLTRIM(TZG5->ZG5_NOMAPR)
				ZG6->ZG6_NIVEL		:= TZG5->ZG5_NIVEL

				ZG6->ZG6_DTGERA		:= DDATABASE
				ZG6->ZG6_HRGERA		:= TIME()

				ZG6->(MsUnlock())

				DbSelectArea("TZG5")

				TZG5->(DbSkip())

			EndDo

			TZG5->(DBCLOSEAREA())

		EndIf

		TSCP->(DbSkip())

	EndDo

	TSCP->(DBCLOSEAREA())

Return lRet
