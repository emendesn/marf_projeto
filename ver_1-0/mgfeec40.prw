#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*/{Protheus.doc} MGFEEC40
//TODO Relatório de Follow Up
@author leonardo.kume
@since 29/12/2017
@version 6

@type function
/*/
User Function MGFEEC40()

	Local cStartPath 	:= 'C:\TEMP'
	Local cPart
	Local cFiltro   := ""
	Local cAliasZZJ := GetNextAlias()
	Local cRespon	:= ""
	Local dDeadLine	:= STOD("19910101")

	Private  oFon14NI	 	:= TFont():New("Times New Roman",,14,,.T.,,,,,.T.,.T.)  //Fonte Times New Roman 14 Negrito Italico
	Private  oFont14N	 	:= TFont():New("Times New Roman",,14,,.T.,,,,,.F.,.F.)  //Fonte Times New Roman 14 Negrito
	Private  oFont07	 	:= TFont():New("Times New Roman",,07,,.F.,,,,,.F.,.F.)  //Fonte Times New Roman 07 Negrito
	Private  oFont5N	 	:= TFont():New("Times New Roman",,05,,.T.,,,,,.F.,.F.)  //Fonte Times New Roman 07 Negrito
	Private  oFont10	 	:= TFont():New("Times New Roman",,10,,.F.,,,,,.F.,.F.)  //Fonte Times New Roman 12
	Private  oFont10N	 	:= TFont():New("Times New Roman",,10,,.T.,,,,,.F.,.F.)  //Fonte Times New Roman 12 Negrito
	Private  oFont10NI		:= TFont():New("Times New Roman",,10,,.T.,,,,,.T.,.T.)  //Fonte Times New Roman 12 Negrito Italico
	Private oND
	Private nLin	:= 40
	Private nLin2 	:= 40
	Private nI		:= 0

	lRet 	:= Pergunte("MGFEEC17",.T.)
	If lRet
		_cQuery := MontaQuery()
		
	
		//%DEFINE O ALIAS PARA A QUERY E VERIFICAR SE O ALIAS ESTA EM USO
		If Select(cAliasZZJ) > 0
			DbSelectArea(cAliasZZJ)
			DbCloseArea()
		EndIf
	
		//%CRIAR O ALIAS EXECUTANDO A QUERY
		DbUseArea(.T.,'TOPCONN',TCGENQRY(,,_cQuery),cAliasZZJ,.F.,.T.)
	
		//Iniciando Variavel FWMSPRINTER
		oND:=FWMSPrinter():New("FOLLOW UP EXPS",IMP_PDF,.F.,cStartPath,.T.,,@oND,,,,,.T.)
		oND:SetResolution(72)
		oND:SetPortrait()
		oND:SetPaperSize(DMPAPER_A4)
		oND:SetMargin(60,60,60,60)
		oND:GetViewPdf()
	
		nI++
		//IMPRIME CABEÇALHO
		ImpCabec(nI) 
	
	
		While !(cAliasZZJ)->(Eof())
	
			If cRespon != (cAliasZZJ)->ZZJ_RESPON
				QuebraPag(nLin)
				cRespon := (cAliasZZJ)->ZZJ_RESPON
				oND:Say(nLin, 025, "Usuário: "+UsrRetName((cAliasZZJ)->ZZJ_RESPON),oFont10N)
				nLin += 30
			EndIf
	
			If dDeadLine != STOD((cAliasZZJ)->ZZJ_PRVCON)
				QuebraPag(nLin)
				dDeadLine := STOD((cAliasZZJ)->ZZJ_PRVCON)
				oND:Say(nLin, 100, "DeadLine: "+DTOC(STOD((cAliasZZJ)->ZZJ_PRVCON)),oFont10N)
				oND:Say(nLin, 250, "Usuário: "+UsrRetName((cAliasZZJ)->ZZJ_RESPON),oFont10N)
				nLin += 20
			EndIf
			QuebraPag(nLin)
			oND:Say(nLin, 025, (cAliasZZJ)->ZZJ_PEDIDO,oFont10)
			oND:Say(nLin, 80, (cAliasZZJ)->ZB8_IMPODE,oFont10)
			oND:Say(nLin, 250, GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+(cAliasZZJ)->(ZB8_ZTRADI+ZB8_ZLJTRA),1,""),oFont10)
			oND:Say(nLin, 420, (cAliasZZJ)->ZZ_DESCR,oFont10)
			nLin += 20
	
			(cAliasZZJ)->(Dbskip())
	
			If !(cAliasZZJ)->(Eof()) 
				If dDeadLine != STOD((cAliasZZJ)->ZZJ_PRVCON)
					oND:Line(nLin,100,nLin,560)
					nLin += 20
				EndIf
			Else
				oND:Line(nLin,100,nLin,560)
				nLin += 20
			EndIf
		EndDo
	
	
		(cAliasZZJ)->(DbCloseArea())
	
		oND:Preview()
	EndIf
Return

Static Function ImpCabec(nI)

	nLin	:= 40
	nLin2	:= 40


	oND:StartPage()

	oND:Box(nLin-10, 020, nLin+45, 0560) // From

	oND:Say(nLin+5, 025, 'RELATÓRIO DE FOLLOW UP DAS EXPS',oFon14NI)

	nLin2 +=30
	oND:Say(nLin2, 025, 'PERIODO',oFont10N)
	oND:Say(nLin2, 100, 'DE '+DTOC(MV_PAR01)+' A '+DTOC(MV_PAR02) + " Ordenado por Usuario, DeadLine e EXP",oFont10)
	//		oND:Say(052, 340, DTOC(ZB8->ZB8_DTPROC),oFont14N)
	oND:Say(nLin, 470, "PAG:  "+STRZERO(nI,4),oFont10)
	nLin +=15
	oND:Say(nLin, 470, "DATA: "+DTOC(dDatabase),oFont10)
	nLin +=15
	oND:Say(nLin, 470, "HORA: "+Time(),oFont10)
	nLin += 30

	oND:Say(nLin, 025, 'EXP',oFont10N)
	oND:Say(nLin, 80, 'IMPORTADOR',oFont10N)
	oND:Say(nLin, 250, 'TRADING',oFont10N)
	oND:Say(nLin, 420, 'ETAPA A CONCLUIR',oFont10N)

	oND:Line(nLin+5, 025, nLin+5,560)

	nLin += 20

	nLin2 := nLin

	QuebraPag(nLin)

Return

Static Function QuebraPag(nLint)
	If nLint > 800
		oND:EndPage()
		nLin := 40
		nLin2 := 40
		nI++
		ImpCabec(nI)
	EndIf
Return

Static Function MontaQuery()
	Local _cQuery := ""

	_cQuery := "  SELECT ZZJ_PEDIDO,ZZJ_CODDOC, ZZJ_PEDIDO, ZZ_DESCR,ZZJ_FINALI, ZB8_IMPODE, ZZJ_NECESS, "
	_cQuery += " ZZJ_QTDIAS,ZZJ_DTBASE,ZZJ_PRVCON,ZZJ_CONCLU,ZZJ_RESPON, ZB8.ZB8_ZTRADI, ZB8.ZB8_ZLJTRA	 "	
	_cQuery += " FROM "+RetSqlName("ZZJ")+" ZZJ "
	_cQuery += " INNER JOIN "+RetSqlName("ZB8")+" ZB8 "
	_cQuery += " ON  	ZB8.ZB8_FILIAL = '"+xFilial("ZB8")+"' AND "
	_cQuery += " 		ZB8.D_E_L_E_T_ = ' ' AND "
	_cQuery += " 		TRIM(CONCAT(ZB8.ZB8_EXP,CONCAT(ZB8.ZB8_ANOEXP,ZB8_SUBEXP))) = TRIM(ZZJ.ZZJ_PEDIDO)  "
	_cQuery += " INNER JOIN "+RetSqlName("SZZ")+" SZZ "
	_cQuery += " ON  SZZ.ZZ_FILIAL = '"+xFilial("SZZ")+"' AND "
	_cQuery += " 		SZZ.D_E_L_E_T_ = ' ' AND "
	_cQuery += " 	SZZ.ZZ_CODDOC = ZZJ.ZZJ_CODDOC  "
	_cQuery += " WHERE 	ZZJ.D_E_L_E_T_ = ' ' AND "
	_cQuery += " 		ZZJ.ZZJ_FILIAL = '"+xFilial("ZZJ")+"' AND
	If !Empty(alltrim(MV_PAR05))
		_cQuery += " 		ZZJ.ZZJ_PEDIDO = '"+MV_PAR05+"' AND "
	EndIf
	If !Empty(alltrim(MV_PAR04))
		_cQuery += " 		ZZJ.ZZJ_RESPON = '"+MV_PAR04+"' AND "
	EndIf
	_cQuery += " 		ZZJ.ZZJ_FINALI IN ("+iif(MV_PAR03==2,"'N'","'S','N'")+") AND "
	//Se filtrar finalizados considerar todos os com data menor que "até data", senão também considerar o parâmetro "de data"
	If MV_PAR03 == 1
		_cQuery += " 		ZZJ.ZZJ_PRVCON >= '"+DTOS(MV_PAR01)+"' AND "
	EndIf
	_cQuery += " 		ZZJ.ZZJ_PRVCON <= '"+DTOS(MV_PAR02)+"' AND "
	_cQuery += " 		SZZ.ZZ_MSBLQL = '2' "
	_cQuery += " ORDER BY ZZJ.ZZJ_RESPON,ZZJ.ZZJ_PRVCON,ZZJ.ZZJ_PEDIDO, ZZJ.ZZJ_CODDOC
	_cQuery := ChangeQuery(_cQuery) 


Return _cQuery


