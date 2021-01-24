#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)
//-------------------------------------------------------------------
/*/{Protheus.doc} MGFEST36

@author Gustavo Ananias Afonso - TOTVS Campinas
@since
/*/
//-------------------------------------------------------------------
/*
user function MGFEST36()
	Local aAreaATU 		:= GetArea()
	Local aAreaSD1 		:= SD1->(GetArea())
	Local cF1Doc 		:= SF1->F1_DOC
	Local cF1Serie	 	:= SF1->F1_SERIE
	Local cF1Fornece	:= SF1->F1_FORNECE
	Local cF1Loja		:= SF1->F1_LOJA
	local aTes			:= {}

	SD1->(dbSetOrder(1))
	SD1->(dbGoTop())
	if SD1->(DbSeek(xFilial("SD1") + cF1Doc + cF1Serie + cF1Fornece + cF1Loja))
		Do While SD1->(!Eof()) .And. cF1Doc == SD1->D1_DOC .And. cF1Serie == SD1->D1_SERIE .And. cF1Fornece == SD1->D1_FORNECE .And. cF1Loja == SF1->F1_LOJA
			if !empty(SD1->D1_ZTES)

				aTes := {}
				aTes := getOpXTes()

				RecLock("SD1", .F.)
			    	SD1->D1_TES	:= aTes[1]
			    	SD1->D1_CF	:= aTes[2]
				SD1->(MsUnLock())
			endif
			SD1->(dbSkip())
		EndDo
	endif

	RestArea(aAreaSD1)
	RestArea(aAreaATU)
return
*/
//-------------------------------------------------------------------
// Retorna a TES de acordo com amarracao
//-------------------------------------------------------------------
user function MGFEST36()
	local cRetTpOp	:= ""
	local aRetTes	:= {"", ""}
	local cQrySZ5	:= ""
	local cQrySF4	:= ""
	local cTes		:= ""

	cQrySZ5 += " SELECT Z4_OPERETE"																							+ CRLF
	cQrySZ5 += " FROM "			+ retSQLName("SZ5") + " SZ5"																+ CRLF
	cQrySZ5 += " INNER JOIN "	+ retSQLName("SZ4") + " SZ4"																+ CRLF
	cQrySZ5 += " ON"																										+ CRLF
	cQrySZ5 += "     Z5_LOCAL        =   Z4_LOCAL      AND"																	+ CRLF
	cQrySZ5 += "     Z5_EMPRESA      =   Z4_EMPRESA    AND"																	+ CRLF
	cQrySZ5 += "     Z5_UNIDADE      =   Z4_UNIDADE    AND"																	+ CRLF
	cQrySZ5 += "     Z5_LOCDEST      =   Z4_LOCDEST    AND"																	+ CRLF
	cQrySZ5 += "     SZ4.D_E_L_E_T_  <>  '*'"																				+ CRLF
	cQrySZ5 += " INNER JOIN "	+ retSQLName("SF1") + " SF1"																+ CRLF
	cQrySZ5 += " ON"																										+ CRLF
	cQrySZ5 += "     SZ5.Z5_NUMNFEN  =   ( F1_FILIAL || F1_DOC || F1_SERIE || F1_FORNECE || F1_LOJA || F1_TIPO ) AND"		+ CRLF
	cQrySZ5 += "     SF1.D_E_L_E_T_  <>  '*'"																				+ CRLF
	cQrySZ5 += " WHERE"																										+ CRLF
	cQrySZ5 += " ( F1_FILIAL || F1_DOC || F1_SERIE || F1_FORNECE || F1_LOJA || F1_TIPO )"									+ CRLF
	cQrySZ5 += " 	= "																										+ CRLF
	cQrySZ5 += " '" + SF1->( F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA + F1_TIPO ) + "' AND"						+ CRLF
	cQrySZ5 += " SZ5.D_E_L_E_T_  <>  '*'" + CRLF

	tcQuery changeQuery(cQrySZ5) New Alias "QRYSZ5"

	if !QRYSZ5->(EOF())
		cRetTpOp := QRYSZ5->Z4_OPERETE
	 	//MaTesInt(1,		Alltrim(cOperTES)	,PADR(ALLTRIM(ZZH->ZZH_FORNEC),nTamC)	,PADR(ALLTRIM(ZZH->ZZH_LOJA),nTamL)	,"F"					,PADR(ALLTRIM(ZZI->ZZI_PRODUT),nTamP))
		//cTes := MaTesInt(1 , QRYSZ5->Z4_OPEREME	, cA100For	, cLoja	, If(cTipo$"DB","C","F"), SD1->D1_COD	, "D1_TES")
		/*
		cTes := MaTesInt(1 , QRYSZ5->Z4_OPEREME	, cA100For	, cLoja	, If(cTipo$"DB","C","F"), SD1->D1_COD)

		cQrySF4 := " SELECT F4_CODIGO, F4_CF"								+ CRLF
		cQrySF4 += " FROM "	+ retSQLName("SF4") + " SF4"					+ CRLF
		cQrySF4 += " WHERE"													+ CRLF
		cQrySF4 += " SF4.F4_CODIGO	=	'" + cTes + "'"						+ CRLF
		cQrySF4 += " SF4.F4_FILIAL	=	'" + xFilial("SF4") + "' AND"		+ CRLF
		cQrySF4 += " SF4.D_E_L_E_T_	<>  '*'"								+ CRLF

		tcQuery changeQuery(cQrySF4) New Alias "QRYSF4"

		if !QRYSF4->(EOF()) 
			cRetCF := QRYSF4->F4_CF

			aDadosCFO := {}
			Aadd(aDadosCfo,{"OPERNF","E"})
		 	Aadd(aDadosCfo,{"TPCLIFOR",GetAdvFVal("SA1","A1_TIPO",xFilial("SA1")+cA100For+cLoja,1,"")})
		 	Aadd(aDadosCfo,{"UFDEST",GetAdvFVal("SA1","A1_EST",xFilial("SA1")+cA100For+cLoja,1,"")})
			cRetCF := MaFisCfo(,cRetCF,aDadosCfo)

			aRetTes := { QRYSF4->F4_CODIGO, cRetCF }
		endif
		
		QRYSF4->(DBCloseArea())
		*/
	endif

	QRYSZ5->(DBCloseArea())
return cRetTpOp
