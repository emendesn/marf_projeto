#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'COLORS.CH'

#define CRLF chr(13) + chr(10)             
/*
{Protheus.doc} MGF06R34
@description 
RITM0054762 Relátorio Títulos sem comprovantes
@author Paulo da Mata
@Type Relatório
@since 21/08/2020
@version P12.1.17
*/
User Function MGF06R34

	Local nControle := 0
	Private cPerg  := "MGF06R34"
	
	If Pergunte( cPerg , .T. )
		FWMSGRUN( , {|oproc| nControle := MGF06R34P(oproc, .T., .F.) }, "Aguarde!" , 'Gerando os dados para impressão...' )
	Endif
	
Return .T.

Static Function MGF06R34P(oproc)
	
	Local cQuery 	:= ""
	Local cCodFilia := ""
	Local cArqPsq   := SuperGetMV('MGF_ARQFIN',,"\\stofs01\CNAB\Finnet_Comprovante\MARFRIG\")
	Local cPdf01    := ""
	Local cPdf02    := ""
	Local aSelFil   := {}

	Private aReg := {}

	AdmSelecFil("", 0 ,.F.,@aSelFil,"",.F.)

	If Empty(aSelFil)
	   Return
	Endif
	
	cCodFilia := U_Array_In(aSelFil)

	cQuery := "SELECT * FROM "+CRLF
	cQuery += "( "+CRLF
	cQuery += "SELECT DISTINCT "+CRLF
	cQuery += "SUBSTR(SE2.E2_FILIAL,1,2) EMPR, "+CRLF
	cQuery += "	SUBSTR(SE2.E2_FILIAL,5) ORIG, "+CRLF
	cQuery += "	SE2.E2_NUM NF, "+CRLF
	cQuery += "	CASE  "+CRLF
	cQuery += "		WHEN SA2.A2_TIPO = 'F' THEN SUBSTR(SA2.A2_CGC,1,3)||'.'||SUBSTR(SA2.A2_CGC,4,3)||'.'||SUBSTR(SA2.A2_CGC,7,3)||'-'||SUBSTR(SA2.A2_CGC,10,2) "+CRLF
	cQuery += "		WHEN SA2.A2_TIPO = 'J' THEN SUBSTR(SA2.A2_CGC,1,2)||'.'||SUBSTR(SA2.A2_CGC,3,3)||'.'||SUBSTR(SA2.A2_CGC,6,3)||'/'||SUBSTR(SA2.A2_CGC,9,4)||'-'||SUBSTR(SA2.A2_CGC,13,2) "+CRLF
	cQuery += "	ELSE SA2.A2_CGC	END CNPJCPF, "+CRLF
	cQuery += "	SA2.A2_NOME RAZAO, "+CRLF
	cQuery += " SE2.E2_VALLIQ VLRLIQ, "+CRLF
	cQuery += " TO_CHAR(TO_DATE(SE2.E2_BAIXA,'YYYYMMDD'),'DD/MM/YYYY') DTPAG, "+CRLF
	cQuery += "	SE5.E5_BANCO BCO, "+CRLF
	cQuery += "	SE5.E5_AGENCIA AG, "+CRLF
	cQuery += "	SE5.E5_CONTA CTA, "+CRLF
	cQuery += "	SED.ED_DESCRIC TPDSP, "+CRLF
	cQuery += "	SE2.E2_BAIXA, "+CRLF
	cQuery += "	SE2.E2_IDCNAB IDCNAB, "+CRLF
	cQuery += "	SE2.E2_ZNPORTA ZNPORT, "+CRLF
	cQuery += "	SE5.E5_MOTBX MOTBX, "+CRLF
	cQuery += "	SE5.E5_DTDISPO, "+CRLF
	cQuery += "	SE5.E5_SEQ, "+CRLF
	cQuery += "	MAX(SE5.E5_SEQ) OVER (PARTITION BY SUBSTR(SE2.E2_FILIAL,1,2),SUBSTR(SE2.E2_FILIAL,5), "+CRLF
	cQuery += "	                      NVL(RTRIM(LTRIM(SE2.E2_ZNPORTA)),'-'), SE2.E2_NUM) MAX_SEQ "+CRLF
	cQuery += "FROM "+RetSqlName("SE2")+" SE2, "+RetSqlName("SA2")+" SA2, "+RetSqlName("SED")+" SED, "+RetSqlName("SE5")+" SE5 "+CRLF
	cQuery += "WHERE "+CRLF
	cQuery += "SE2.E2_FORNECE  = SA2.A2_COD     AND "+CRLF
	cQuery += "SE2.E2_LOJA     = SA2.A2_LOJA    AND "+CRLF
	cQuery += "SED.ED_CODIGO   = SE2.E2_NATUREZ AND "+CRLF
	cQuery += "SE2.E2_FORNECE  = SE5.E5_CLIFOR  AND "+CRLF
	cQuery += "SE2.E2_LOJA     = SE5.E5_LOJA    AND "+CRLF
	cQuery += "SE2.E2_NUM      = SE5.E5_NUMERO  AND "+CRLF
	cQuery += "SE2.E2_FILIAL   = SE5.E5_FILIAL  AND "+CRLF
	cQuery += "SE2.E2_PARCELA  = SE5.E5_PARCELA AND "+CRLF
	cQuery += "SE2.E2_PREFIXO  = SE5.E5_PREFIXO AND "+CRLF
	cQuery += "SE5.D_E_L_E_T_ = ' '    AND "+CRLF
	cQuery += "SED.D_E_L_E_T_ = ' '    AND "+CRLF
	cQuery += "SE2.D_E_L_E_T_ = ' '    AND "+CRLF
	cQuery += "SA2.D_E_L_E_T_ = ' '    AND "+CRLF
	cQuery += "E2_FILIAL IN "+cCodFilia+" AND "+CRLF
	cQuery += "E2_BAIXA BETWEEN '"+DtoS(Mv_Par01)+"' AND '"+DtoS(Mv_Par02)+"' AND "+CRLF	
	cQuery += "SE2.E2_FATPREF <> 'FAT' AND "+CRLF
	cQuery += "SE5.E5_MOTBX   <> ' '   AND "+CRLF
	cQuery += "SE5.E5_TIPODOC = 'VL'   AND "+CRLF
	cQuery += "SE5.E5_SITUACA = ' '    AND "+CRLF
	cQuery += "SE2.E2_VALLIQ  > 0      AND "+CRLF
	cQuery += "SE2.E2_ZNPORTA <> ' '       "+CRLF
	cQuery += "ORDER BY SE2.E2_BAIXA) "+CRLF
	cQuery += "WHERE E5_SEQ = MAX_SEQ"+CRLF

	If Select("QRY") > 0
		QRY->(dbCloseArea())
	EndIf

	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.F.)
	
	dbSelectArea("QRY")    
	QRY->(dbGoTop())

	While QRY->(!Eof())

		cPdf01 := AllTrim(cArqPsq)+AllTrim(QRY->IDCNAB)+"*.PDF"
		cPdf02 := AllTrim(cArqPsq)+AllTrim(QRY->ZNPORT)+".PDF"

		// Se tiver os comprovantes, não é para aparecer no relatorio
		If !File(cPdf02)
			If !File(cPdf01) .Or. Empty(AllTrim(QRY->IDCNAB))
				AADD(aReg,{	QRY->EMPR,QRY->ORIG,QRY->ZNPORT,AllTrim(QRY->NF),AllTrim(QRY->CNPJCPF),;
							AllTrim(QRY->RAZAO),QRY->VLRLIQ,QRY->DTPAG,QRY->BCO,AllTrim(QRY->AG),;
							AllTrim(QRY->CTA),AllTrim(QRY->TPDSP),QRY->MOTBX,QRY->IDCNAB})
			EndIf
		EndIf
		
		QRY->(dbSkip())

	EndDo
	
	If !Empty(aReg)
		oReport := RelR0634()
		oReport:PrintDialog()
	Else
		ApMsgAlert(OemToAnsi("Não existem dados a serem exibidos"),OemToAnsi("ATENÇÃO"))
	EndIf
	
Return

Static Function RelR0634

	Local oReport
	Local oImp

	oReport := TReport():New("MGF06R34","Relatório Titulos Sem Comprovantes","MGF06R34", {|oReport| PrintReport(oReport)},"Relatório Titulos Sem Comprovantes")

	oReport:SetLandScape(.T.)
	oImp := TRSection():New(oReport,"Relatório Titulos Sem Comprovantes","MGF06R34",{"QRY"})

	TRCell():New(oImp,"EMPR"	,"QRY","Empr."	  , 							,02					  	,.F.,)
	TRCell():New(oImp,"ORIG"    ,"QRY","Orig."	  , 							,02					    ,.F.,)
	TRCell():New(oImp,"ZNPORT"	,"QRY","Id.Port." ,PesqPict('SE2',"E2_ZNPORTA") ,TamSx3("E2_ZNPORTA")[1],.F.,)
	TRCell():New(oImp,"NF" 		,"QRY","N.F."	  ,PesqPict('SE2',"E2_NUM")	    ,TamSx3("E2_NUM")[1]	,.F.,)
	TRCell():New(oImp,"CNPJCPF" ,"QRY","CNPJ"	  , 							,18					  	,.F.,)
	TRCell():New(oImp,"RAZAO"	,"QRY","Forn."    ,PesqPict('SA2',"A2_NOME")	,TamSx3("A2_NOME")[1]	,.F.,)
	TRCell():New(oImp,"VLRLIQ"  ,"QRY","Vlr. Liq.",PesqPict('SE2',"E2_VALLIQ")	,TamSx3("E2_VALLIQ")[1] ,.F.,)
	TRCell():New(oImp,"DTPAG"	,"QRY","Dt. Pgt." ,   							,10						,.F.,)
	TRCell():New(oImp,"BCO"    	,"QRY","Bco."  	  ,PesqPict('SE2',"E5_BANCO")	,TamSx3("E5_BANCO")[1]	,.F.,)
	TRCell():New(oImp,"AG"    	,"QRY","Ag. "     ,PesqPict('SE2',"E5_AGENCIA") ,TamSx3("E5_AGENCIA")[1],.F.,)
	TRCell():New(oImp,"CTA"	   	,"QRY","Cta."  	  ,PesqPict('SE2',"E5_CONTA")	,TamSx3("E5_CONTA")[1]	,.F.,)
	TRCell():New(oImp,"TPDSP"	,"QRY","Desp."    ,PesqPict('SE2',"ED_DESCRIC") ,TamSx3("ED_DESCRIC")[1],.F.,)
	TRCell():New(oImp,"MOTBX" 	,"QRY","Mot." 	  ,PesqPict('SE2',"E5_MOTBX")	,TamSx3("E5_MOTBX")[1]	,.F.,)
	TRCell():New(oImp,"IDCNAB" 	,"QRY","IDCNAB"   ,PesqPict('SE2',"E2_IDCNAB")	,TamSx3("E2_IDCNAB")[1]	,.F.,)

Return oReport

Static Function PrintReport(oReport)

	Local nI := 0

	oReport:SetMeter(LEN(aReg))
	oReport:Section(1):Init()	

	For nI := 1 To LEN(aReg)

		IF oReport:Cancel()
			Exit
		Endif

	    oReport:IncMeter()

		oReport:Section(1):Cell("EMPR"):SetBlock({|| aReg[nI,1] })
		oReport:Section(1):Cell("ORIG"):SetBlock({|| aReg[nI,2] })
		oReport:Section(1):Cell("ZNPORT"):SetBlock({|| aReg[nI,3] })
		oReport:Section(1):Cell("NF"):SetBlock({|| aReg[nI,4] })
		oReport:Section(1):Cell("CNPJCPF"):SetBlock({|| aReg[nI,5] })
		oReport:Section(1):Cell("RAZAO"):SetBlock({|| aReg[nI,6] })
		oReport:Section(1):Cell("VLRLIQ"):SetBlock({|| aReg[nI,7] })
		oReport:Section(1):Cell("DTPAG"):SetBlock({|| aReg[nI,8] })
		oReport:Section(1):Cell("BCO"):SetBlock({|| aReg[nI,9] })
		oReport:Section(1):Cell("AG"):SetBlock({|| aReg[nI,10] })
		oReport:Section(1):Cell("CTA"):SetBlock({|| aReg[nI,11] })
		oReport:Section(1):Cell("TPDSP"):SetBlock({|| aReg[nI,12] })
		oReport:Section(1):Cell("MOTBX"):SetBlock({|| aReg[nI,13] })
		oReport:Section(1):Cell("IDCNAB"):SetBlock({|| aReg[nI,14] })
		oReport:Section(1):PrintLine()
	NEXT
	oReport:Section(1):Finish()

Return oReport
