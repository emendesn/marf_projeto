#Include "Protheus.ch"
#Include "topconn.ch"
#Include "tbiconn.ch"

/*/{Protheus.doc} MGFC23SH
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MGFC23SH()

	RpcSetType( 3 )
	If (.F. );CallProc( "RpcSetEnv", "01", "010001",,,,, { "SCR","SC1","DBM","SAL","DBL","SAK","SCX","SC7","SE2" } ); Else; RpcSetEnv( "01", "010001",,,,, { "SCR","SC1","DBM","SAL","DBL","SAK","SCX","SC7","SE2" } ); endif
	U_MGFCOM23()
	If (.F. );CallProc( "RpcClearEnv" ); Else; RpcClearEnv( ); endif

Return


User Function MGFCOM23()

	Local aArea	   	 := GetArea()
	Local aAreaSE2	 := SE2->(GetArea())
	Local cxAlias	 := xVerDados()
	Local cxExcAlias := xExcDados()
	Local cCC		 := ""
	Local cNatur 	:= Alltrim(GetMv("MV_ZMF15AD",,"22704|22706|22707|22708|30110|30111|30112|30113"))

	dbSelectArea("SE2")
	SE2->(dbSetOrder(1))


	dbSelectArea("SCR")
	SCR->(dbSetOrder(1))
	(cxExcAlias)->(dbGoTop())
	While (cxExcAlias)->(!EOF())
		cChav := (cxExcAlias)->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA)
		If SCR->(dbSeek(xFilial("SCR",(cxExcAlias)->E2_FILIAL) + "ZC" + PadR(cChav,Len(SCR->CR_NUM))))
			While SCR->(!EOF()) .and.  SCR->(CR_FILIAL + CR_TIPO + CR_NUM) ==  xFilial("SCR",(cxExcAlias)->E2_FILIAL) + "ZC" + PadR(cChav,Len(SCR->CR_NUM))
				RecLock("SCR", .F. )
				SCR->(dbDelete())
				SCR->(MsUnLock())
				SCR->(dbSkip())
			EndDo
		EndIf

		(cxExcAlias)->(dbSkip())
	EndDo

	While (cxAlias)->(!EOF())
		If SE2->(dbSeek((cxAlias)->(E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA)))



			IF (Alltrim(SE2->E2_TIPO) == "PR" .OR.  Alltrim(SE2->E2_TIPO) == "PRE") .and.  !(Alltrim(SE2->E2_NATUREZ) $ cNatur 	)
				RecLock("SE2", .F. )
				SE2->E2_ZCODGRD := "ZZZZZZZZZZ"
				SE2->E2_ZBLQFLG := "S"
				SE2->E2_DATALIB := dDataBase
				SE2->E2_ZIDINTE := "ZZZZZZZZZ"
				SE2->E2_ZIDGRD  := "ZZZZZZZZZ"
				SE2->E2_ZNEXGRD := ""
				SE2->(MsUnlock())

			Else

				If SE2->E2_CCUSTO == Space(Len(SE2->E2_CCUSTO))

					cCC := retCC()
					RecLock("SE2", .F. )
					SE2->E2_CCUSTO := cCC
					SE2->(MsUnlock())
				EndIf


				xGravSCR()
			EndIF
		EndIf
		(cxAlias)->(dbSkip())
	EndDo

	(cxAlias)->(DbClosearea())
	(cxExcAlias)->(DbClosearea())

	RestArea(aAreaSE2)
	RestArea(aArea)

Return


Static Function xVerDados()

	Local aArea 	:= GetArea()
	Local cNextAlias:= GetNextAlias()
	Local cUpd		:= ""
	Local cCod		:= AllTrim(GetMv("MGF_IDGRD"))
	Local aQuery

	PUTMV("MGF_IDGRD", Soma1(cCod))

	cUpd := "UPDATE " + RetSQLName("SE2")  + " SE2 " + Chr(13)+Chr(10)
	cUpd += " SET E2_ZIDGRD = '" + cCod + "' " + Chr(13)+Chr(10)
	cUpd += " WHERE " + Chr(13)+Chr(10)

	cUpd += " SE2.D_E_L_E_T_ <> '*' AND SE2.E2_ZCODGRD = '      ' " + Chr(13)+Chr(10)



	TcSQLExec(cUpd)














	__execSql(cNextAlias," SELECT SE2.E2_FILIAL, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO, SE2.E2_FORNECE, SE2.E2_LOJA FROM  "+RetSqlName('SE2')+" SE2 WHERE SE2.E2_ZIDGRD =  "+___SQLGetValue(CCOD),{},.F.)

	aQuery := GetLastQuery()
	
	

	(cNextAlias)->(DbGoTop())

	RestArea(aArea)

Return (cNextAlias)


Static Function xExcDados()

	Local aArea 	:= GetArea()
	Local cNextAlias:= GetNextAlias()
	Local cUpd		:= ""
	Local cLPUpd	:= ""
	Local cCod		:= AllTrim(GetMv("MGF_IDGRD"))
	Local aQuery

	PUTMV("MGF_IDGRD", Soma1(cCod))

	cUpd := "UPDATE " + RetSQLName("SE2")  + " SE2 " + Chr(13)+Chr(10)
	cUpd += " SET E2_ZIDGRD = '" + cCod + "' " + Chr(13)+Chr(10)
	cUpd += " WHERE " + Chr(13)+Chr(10)

	cUpd += " SE2.D_E_L_E_T_ = '*' AND SE2.E2_ZCODGRD <> '      ' " + Chr(13)+Chr(10)



	TcSQLExec(cUpd)

	cUpd := "UPDATE " + RetSQLName("SE2") + " SE21 " + Chr(13)+Chr(10)
	cUpd += " SET E2_ZIDGRD = '" + cCod + "' " + Chr(13)+Chr(10)
	cUpd += " WHERE " + Chr(13)+Chr(10)
	cUpd += " RTRIM(SE21.E2_PREFIXO || SE21.E2_NUM || SE21.E2_PARCELA || SE21.E2_TIPO|| SE21.E2_FORNECE || SE21.E2_LOJA) IN ( " + Chr(13)+Chr(10)
	cUpd += "                 SELECT RTRIM(CR_NUM) " + Chr(13)+Chr(10)
	cUpd += "                 FROM " + RetSQLName("SCR") + " SCR " + Chr(13)+Chr(10)
	cUpd += "                 WHERE SCR.D_E_L_E_T_ = ' ' and SCR.CR_TIPO = 'ZC' AND " + Chr(13)+Chr(10)
	cUpd += "                 RTRIM(CR_NUM) NOT IN ( " + Chr(13)+Chr(10)
	cUpd += "										SELECT RTRIM(E2_PREFIXO || E2_NUM || E2_PARCELA || E2_TIPO|| E2_FORNECE || E2_LOJA) " + Chr(13)+Chr(10)
	cUpd += "          								FROM " + RetSQLName("SE2") + " SE2 WHERE SE2.D_E_L_E_T_ = ' ' )) "



	TcSQLExec(cUpd)














	__execSql(cNextAlias," SELECT SE2.E2_FILIAL, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO, SE2.E2_FORNECE, SE2.E2_LOJA FROM  "+RetSqlName('SE2')+" SE2 WHERE SE2.E2_ZIDGRD =  "+___SQLGetValue(CCOD),{},.F.)

	aQuery := GetLastQuery()



	cLPUpd := "UPDATE " + RetSQLName("SE2")  + " SE2 " + Chr(13)+Chr(10)
	cLPUpd += " SET E2_ZCODGRD = ' ' " + Chr(13)+Chr(10)
	cLPUpd += " WHERE " + Chr(13)+Chr(10)
	cLPUpd += " SE2.D_E_L_E_T_ = '*' AND SE2.E2_ZIDGRD = '" + cCod + "' " + Chr(13)+Chr(10)



	TcSQLExec(cLPUpd)

	(cNextAlias)->(DbGoTop())

	RestArea(aArea)

Return (cNextAlias)


static function retCC()
	local cRet		:= ""
	local cQrySED	:= ""

	cQrySED := "SELECT ED_CCD " + Chr(13)+Chr(10)
	cQrySED += "FROM " + retSQLName("SED") + " SED " + Chr(13)+Chr(10)
	cQrySED += "WHERE SED.D_E_L_E_T_ = ' ' " + Chr(13)+Chr(10)
	cQrySED += "	AND SED.ED_CODIGO	=	'" + SE2->E2_NATUREZ	+ "' " + Chr(13)+Chr(10)
	cQrySED += "	AND SED.ED_FILIAL	=	'" + xFilial("SED")		+ "' " + Chr(13)+Chr(10)



	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQrySED), "QRYSED" , .F. , .T. )

	if !QRYSED->(EOF())
		cRet := QRYSED->ED_CCD
	endif

	QRYSED->(DBCloseArea())
return cRet



Static Function xGravSCR()

	Local aArea	 := GetArea()
	Local cGrupo := ""
	Local aGrade := {}
	Local cTit	 := ""


	aGrade 	:= xMC22Grd(SE2->E2_CCUSTO,SE2->E2_NATUREZ,SE2->E2_PREFIXO,SE2->E2_ORIGEM)
	cTit	:= SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA)


	If !Empty(aGrade)

		xMC22GSCR(cTit,aGrade)
		RecLock("SE2", .F. )
		SE2->E2_ZNEXGRD := ""
		SE2->E2_ZIDINTE := ""
		SE2->E2_ZBLQFLG := "S"

		SE2->E2_ZCODGRD := aGrade[1]
		SE2->E2_ZVERSAO := aGrade[2]
		SE2->(MsUnlock())
	Else
		RecLock("SE2", .F. )
		SE2->E2_ZBLQFLG := "N"
		SE2->E2_ZNEXGRD := "S"
		SE2->(MsUnlock())
	EndIf

	RestArea(aArea)

Return

Static Function xMC22Grd(cCC,cNaturez,cSE2Pref,cOriegem)

	Local aArea := GetArea()

	Local aRet 		 := {}
	Local cNextAlias := GetNextAlias()

	Local cxFilZAB := xFilial("ZAB",SE2->E2_FILIAL)
	Local aQuery
	Local cPref		:= Alltrim(GetMv("MGF_PREFGR",,"MAN"))
	Local cGrdMan   := Alltrim(GetMv("MGF_GRDMAN",,"C9999"))

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	If Alltrim(UPPER(cOriegem)) = "FINA050" .and.  Alltrim(cSE2Pref) $ cPref













		__execSql(cNextAlias," SELECT ZAB.ZAB_CODIGO, ZAB.ZAB_VERSAO, ZAE.ZAE_NATURE FROM  "+RetSqlName('ZAB')+" ZAB INNER JOIN  "+RetSqlName('ZAE')+" ZAE ON ZAE.D_E_L_E_T_= ' ' AND ZAE.ZAE_FILIAL = ZAB.ZAB_FILIAL AND ZAE.ZAE_CODIGO = ZAB.ZAB_CODIGO AND ZAE.ZAE_VERSAO = ZAB.ZAB_VERSAO AND ZAE.ZAE_NATURE =  "+___SQLGetValue(CNATUREZ)+" WHERE ZAB.D_E_L_E_T_= ' ' AND ZAB.ZAB_FILIAL =  "+___SQLGetValue(CXFILZAB)+" AND ZAB.ZAB_TIPO = 'C' AND ZAB.ZAB_CODIGO =  "+___SQLGetValue(CGRDMAN)+" AND ZAB.ZAB_HOMOLO = 'S'",{},.F.)
	Else













		__execSql(cNextAlias," SELECT ZAB.ZAB_CODIGO, ZAB.ZAB_VERSAO, ZAE.ZAE_NATURE FROM  "+RetSqlName('ZAB')+" ZAB INNER JOIN  "+RetSqlName('ZAE')+" ZAE ON ZAE.D_E_L_E_T_= ' ' AND ZAE.ZAE_FILIAL = ZAB.ZAB_FILIAL AND ZAE.ZAE_CODIGO = ZAB.ZAB_CODIGO AND ZAE.ZAE_VERSAO = ZAB.ZAB_VERSAO AND ZAE.ZAE_NATURE =  "+___SQLGetValue(CNATUREZ)+" WHERE ZAB.D_E_L_E_T_= ' ' AND ZAB.ZAB_FILIAL =  "+___SQLGetValue(CXFILZAB)+" AND ZAB.ZAB_TIPO = 'C' AND ZAB.ZAB_CC =  "+___SQLGetValue(CCC)+" AND ZAB.ZAB_HOMOLO = 'S'",{},.F.)
	EndIf




	(cNextAlias)->(DbGoTop())

	While (cNextAlias)->(!EOF())
		aRet := {(cNextAlias)->ZAB_CODIGO,(cNextAlias)->ZAB_VERSAO,(cNextAlias)->ZAE_NATURE}
		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(dbCloseArea())

	RestArea(aArea)

Return aRet


Static Function xMC22GSCR(cChav,aGrade)

	Local aArea 		:= GetArea()
	Local aAreaSE2		:= SE2->(GetArea())

	Local cNextAlias 	:= GetNextAlias()
	Local nIt			:= 1

	Local cFilSAL		:= xFilial("SAL",SE2->E2_FILIAL)
	Local lLbSeqZC		:= GetMv("MGF_LIBSEQ",, .T. )
	Local aQuery

	Local lIncFlg		:= .T.

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	dbSelectArea("SCR")
	SCR->(dbSetOrder(1))

	If SCR->(dbSeek(xFilial("SCR",SE2->E2_FILIAL) + "ZC" + PadR(cChav,Len(SCR->CR_NUM))))
		lIncFlg := .F.
		While SCR->(!EOF()) .and.  SCR->(CR_FILIAL + CR_TIPO + CR_NUM) ==  xFilial("SCR",SE2->E2_FILIAL) + "ZC" + PadR(cChav,Len(SCR->CR_NUM))
			RecLock("SCR", .F. )
			SCR->(dbDelete())
			SCR->(MsUnLock())
			SCR->(dbSkip())
		EndDo
	EndIf


















	__execSql(cNextAlias," SELECT ZAD_SEQ, ZAD_NIVEL, ZA2_CODUSU, ZAD_VALINI, ZAD_VALFIM FROM  "+RetSqlName('ZAD')+" ZAD INNER JOIN  "+RetSqlName('ZA2')+" ZA2 ON ZA2.D_E_L_E_T_= ' ' AND ZA2_NIVEL = ZAD_NIVEL AND ZA2_EMPFIL =  "+___SQLGetValue(SE2->E2_FILIAL)+" WHERE ZAD.D_E_L_E_T_= ' ' AND ZA2.D_E_L_E_T_= ' ' AND ZA2.ZA2_LOGIN <> ' ' AND ZA2_FILIAL = ZAD_FILIAL AND ZAD_CODIGO =  "+___SQLGetValue(AGRADE[1])+" AND ZAD_VERSAO =  "+___SQLGetValue(AGRADE[2])+" AND ZAD_NATURE =  "+___SQLGetValue(AGRADE[3])+" ORDER BY ZAD_SEQ",{},.F.)

	aQuery := GetLastQuery()









	dbSelectArea(cNextAlias)
	dbGoTop()

	While (cNextAlias)->(!EOF())

		If SE2->E2_VALOR >= (cNextAlias)->ZAD_VALINI .And.  SE2->E2_VALOR <= (cNextAlias)->ZAD_VALFIM
			RecLock("SCR", .T. )

			SCR->CR_FILIAL 	:= xFilial("SCR",SE2->E2_FILIAL)
			SCR->CR_NUM 	:= cChav
			SCR->CR_TIPO 	:= "ZC"
			SCR->CR_USER 	:= (cNextAlias)->ZA2_CODUSU


			SCR->CR_ITGRP 	:= (cNextAlias)->ZAD_SEQ
			SCR->CR_NIVEL 	:= (cNextAlias)->ZAD_SEQ

			If lLbSeqZC
				SCR->CR_STATUS 	:= IIF(nIt == 1,"02","01")
			Else
				SCR->CR_STATUS 	:= "02"
			EndIf

			SCR->CR_EMISSAO	:= dDataBase
			SCR->CR_TOTAL 	:= SE2->E2_VALOR
			SCR->CR_MOEDA 	:= SE2->E2_MOEDA
			SCR->CR_TXMOEDA	:= SE2->E2_TXMOEDA
			SCR->CR_ZCODGRD := aGrade[1]
			SCR->CR_ZVERSAO := aGrade[2]
			SCR->CR_ZNATURE := aGrade[3]
			SCR->CR_ZORIGEM := U_xOrNFF1(SE2->E2_FILIAL,SE2->E2_NUM,SE2->E2_PREFIXO,SE2->E2_FORNECE,SE2->E2_LOJA)

			SCR->CR_ZVENCIM := SE2->E2_VENCTO
			SCR->CR_ZNOMFOR := POSICIONE("SA2",1, xFilial("SA2",SE2->E2_FILIAL) + SE2->E2_FORNECE + SE2->E2_LOJA,"A2_NOME")
			SCR->CR_ZNATDES := POSICIONE("SED",1, xFilial("SED",SE2->E2_FILIAL) + SE2->E2_NATUREZ,"ED_DESCRIC")

			SCR->CR_ZNIVEL := (cNextAlias)->ZAD_NIVEL

			SCR->(MsUnlock())
			nIt ++
		EndIf

		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

	RestArea(aAreaSE2)
	RestArea(aArea)

Return










User Function xOrNFF1(cxFil,cDoc,cSerie,cFornec,cLoja)

	Local aArea 	:= GetArea()
	Local aAreaSF1	:= SF1->(GetArea())
	Local cTipo     := "N"

	Local cRet := ""

	dbSelectArea("SF1")
	SF1->(dbSetOrder(1))

	If SF1->(dbSeek(cxFil + cDoc + cSerie + cFornec + cLoja ))
		cRet := SF1->F1_ORIGEM
	Endif

	RestArea(aAreaSF1)
	RestArea(aArea)

Return cRet
