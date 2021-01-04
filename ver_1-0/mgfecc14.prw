#Include "Protheus.ch"
#Include "TbiConn.ch"
#Include "Ap5Mail.ch"
#Include "RptDef.ch"
#Include "FwPrintSetup.ch"

/*/{Protheus.doc} MGFECC14
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MGFECC14()

	Local cStartPath 	:= "C:\TEMP"
	Local cPerg			:= "MGFECC14"
	Local lRet			:= .F.
	Local cAliasQry  	:= GetNextAlias()
	Local aSRD, cMemo, nX
	Local nCol	:= 35
	Local nLin := 0
	Local nLin3
	Local nLint := 0
	Local nI
	Local nY
	Local nX
	Local lAlt := .F.
	Local aRet := ""
	Local aRetorno := ""
	Local aRetorno2 := ""
	Local aRetorno3 := ""
	Local aRetorno4 := ""
	Local nCont := 0
	Local cUltdoc := ""
	Local aDados	:= {}



	Private  oFon14NI	 	:= TFont():New("Times New Roman",,14,, .T. ,,,,, .T. , .T. )
	Private  oFont14N	 	:= TFont():New("Times New Roman",,14,, .T. ,,,,, .F. , .F. )
	Private  oFont7N	 	:= TFont():New("Times New Roman",,07,, .T. ,,,,, .F. , .F. )
	Private  oFont5N	 	:= TFont():New("Times New Roman",,05,, .T. ,,,,, .F. , .F. )
	Private  oFont10	 	:= TFont():New("Times New Roman",,10,, .F. ,,,,, .F. , .F. )
	Private  oFont10N	 	:= TFont():New("Times New Roman",,10,, .T. ,,,,, .F. , .F. )
	Private  oFont12NI		:= TFont():New("Times New Roman",,12,, .T. ,,,,, .T. , .T. )
	Private oND


	aDados := DADOS()

	If aDados[1]
		If IsInCallStack("U_MGFEEC24")

			cPerg := Padr(cPerg,Len(SX1->X1_GRUPO))

			dbSelectArea("SX1")
			SX1->(dbSetOrder(1))

			If SX1->(MsSeek(cPerg+"01"))

				RecLock("SX1", .F. )
				SX1->X1_CNT01 := ZB8->(ZB8_EXP + ZB8_ANOEXP + ZB8_SUBEXP)
				SX1->(MsUnlock())
			Endif
			Pergunte(cPerg, .F. )
			MV_PAR01 := ZB8->(ZB8_EXP + ZB8_ANOEXP + ZB8_SUBEXP)
		Else
			If !Pergunte(cPerg, .T. )
				Return nil
			EndIf
		EndIf



		oND:=FWMSPrinter():New("Shipping Instructions",6, .F. ,cStartPath,,,@oND,,,,, .T. )
		oND:SetResolution(72)
		oND:SetPortrait()
		oND:SetPaperSize(9)
		oND:SetMargin(60,60,60,60)
		oND:GetViewPdf()

		lRet := oND:Canceled()

		oND:Cancel()




		nLin := 20
		nLin2 := 20

		oND:Startpage()
		NDCab(@nLin,nLin2,aDados)


		oND:Preview()

	EndIf
Return

Static Function NDCab(nLin, nLin2,aDados)

	Local nX
	Local aRetorno := {}
	Local aRetorno2 := {0}
	Local aRetorno4 := {0}
	Local cIdioma := ""
	Local nLin2 := 0
	Local nEmbarq := MV_PAR01

	nLin2 := nLin + 20

	aRetorno  := aClone(aDados[2])
	aRetorno2 := aClone(aDados[3])
	aRetorno4 := aClone(aDados[4])
	cIdioma	  := aDados[5]




	dBselectArea("ZB8")
	ZB8->(dbSetOrder(3))
	If ZB8->(dbSeek(xFilial("ZB8") + nEmbarq))

		aRetorno3	:= {}
		nLinBcos := 0
		nLinBcos := MLCount(ZB8->ZB8_ZBANCO, 100)

		For nXi:= 1 To nLinBcos
			cTxtLinha := ""
			cTxtLinha := MemoLine( ZB8->ZB8_ZBANCO, 100, nXi)
			If ! Empty(cTxtLinha)
				aadd( aRetorno3, cTxtLinha )
			EndIf
		next


		oND:Box(nLin, 020, nLin2, 0290)
		oND:Box(nLin, 0290, nLin2, 0560)
		nLin +=20
		nLin2 +=20
		oND:Box(nLin, 020, nLin2, 0290)
		oND:Box(nLin, 0290, nLin2, 0560)

		nLin += 2
		oND:Say(nLin-5, 025, "FROM:",oFont14N)
		oND:Say(nLin-5, 075, ALLTRIM(UsrFullName(RetCodUsr())),oFont14N)
		oND:Say(nLin-5, 295, "DEPTO:",oFont14N)
		oND:Say(nLin-5, 355, "EXPORTAÇÃO",oFont14N)

		nLin+=20
		oND:Say(nLin-5, 025, "ENVIADO POR E-MAIL",oFont14N)
		oND:Say(nLin-5, 295, "DATA:",oFont14N)

		oND:Say(nLin-5, 340, DTOC(dDatabase),oFont14N)


		nLin+=28
		oND:Say(nLin, 170, "RE: SHIPPING INSTRUCTIONS / DOCUMENTS DISTRIBUTION",oFont10N)

		QuebraPag(0,@nLin,0)

		nLin+=20
		dBselectArea("SYQ")
		SYQ->(dbSetOrder(1))
		If SYQ->(dbSeek(xFilial("SYQ")+ZB8->ZB8_VIA))
			oND:Say(nLin, 180, "EMBARQUE VIA:",oFont10N)
			oND:Say(nLin, 250, SYQ->YQ_DESCR,oFont10N)
		EndIf
		oND:Say(nLin, 300, "DESTINO:",oFont10N)
		dBselectArea("SY9")
		SYR->(dbSetOrder(4))
		If SYR->(dbSeek(xFilial("SYR")+ZB8->ZB8_DEST))

		EndIf
		If SYA->(dbSeek(xFilial("SYA")+SYR->YR_PAIS_DE))
			oND:Say(nLin, 340,  ALLTRIM(SYR->YR_CID_DES)+ " - " + SYA->YA_DESCR)
		EndIf
		nLin+=20

		oND:Say(nLin, 180, ZB8->ZB8_EXP+"/"+ZB8->ZB8_ANOEXP+"-"+ZB8->ZB8_SUBEXP,oFont10N)
		IF ZB8->ZB8_INTERM == "1"
			oND:Say(nLin, 240, "EXPORTADOR:",oFont10N)
			oND:Say(nLin, 320, ZB8->ZB8_IMPODE,oFont10N)
			nLin += 10
			oND:Say(nLin, 240, "CLIENTE:",oFont10N)
			oND:Say(nLin, 320, GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+ZB8->ZB8_CLIENT+ZB8->ZB8_CLLOJA,1,""),oFont10N)
		Else
			oND:Say(nLin, 280, "CLIENTE:",oFont10N)
			oND:Say(nLin, 320, ZB8->ZB8_IMPODE,oFont10N)
		EndiF
		nLin += 40

		If ALLTRIM(ZB8->ZB8_CONDPA) $ GetMv("MV_ZCDBCO",,"001")

			oND:Say(nLin, 020, "1) JOGO DO BANCO (CARTA REMESSA + PROTOCOLO):",oFont10N)
		Else
			oND:Say(nLin, 020, "1) JOGO DO CLIENTE (CARTA REMESSA + PROTOCOLO):",oFont10N)
		EndIf

		nLin += 20
		oND:Say(nLin, 040, "Sales Terms:",oFont10)
		oND:Say(nLin, 090, ZB8->ZB8_INCOTE,oFont10)
		nLin += 20
		oND:Say(nLin, 040, "Payment Terms:",oFont10)
		oND:Say(nLin, 100, ZB8->ZB8_CONDPA,oFont10)

		nLin += 20
		nLin2 := nLin + 25
		nLin3 := nLin + 15
		QuebraPag(0,@nLin,@nLin3)

		oND:Box(nLin, 020, nLin2, 0290)
		oND:Say(nLin3, 120, "DOCUMENTOS",oFont10N)
		oND:Box(nLin, 0290, nLin2, 0440)
		oND:Say(nLin3, 345, "ORIGINAL",oFont10N)
		oND:Box(nLin, 440, nLin2, 0560)
		oND:Say(nLin3, 490, "COPIA",oFont10N)


		dBselectArea("SZZ")
		SZZ->(dbSetOrder(1))
		SZZ->(dbGoTop())

		ZZJ->(dbSetOrder(2))
		ZZJ->(dbGoTop())
		ZZJ->(dbSeek(xFilial("ZZJ") + ALLTRIM(ZB8->ZB8_EXP+ZB8->ZB8_ANOEXP+ZB8->ZB8_SUBEXP)))
		While !ZZJ->(Eof()) .and.  xfilial("ZZJ")+ALLTRIM(ZB8->ZB8_EXP+ZB8->ZB8_ANOEXP+ZB8->ZB8_SUBEXP) == ALLTRIM(ZZJ->ZZJ_FILIAL+ZZJ->ZZJ_PEDIDO)

			If SZZ->(dbSeek(xFilial("SZZ") + ZZJ->ZZJ_CODDOC))
				If SZZ->ZZ_TIPO == "D"



					nLin += 20
					nLin2 := nLin + 25
					nLin3 := nLin + 15

					oND:Box(nLin, 020, nLin2, 0290,)
					oND:Say(nLin3, 030, ALLTRIM(SZZ->ZZ_DESCR),oFont10)

					oND:Box(nLin, 0290, nLin2, 0440,)
					oND:Say(nLin3, 365, ALLTRIM(STR(ZZJ->ZZJ_QTDORI)),oFont10)
					oND:Box(nLin, 440, nLin2, 0560,)
					oND:Say(nLin3, 500, ALLTRIM(STR(ZZJ->ZZJ_QTDCOP)),oFont10)


					QuebraPag(0,@nLin,@nLin3)

				EndIf
			EndIf

			ZZJ->(dbSkip())
		Enddo

		nLin += 040
		nLin2 += 040
		nLin3 := nLin - 3
		nLint := nLin + nLin3

		QuebraPag(@nLint,@nLin,@nLin3)

		oND:Say(nLin, 020, "2) NOME DO PRODUTO EM INGLÊS",oFont10N)

		nLin += 040
		nLin2 += 040
		nLin3 := nLin - 3
		nLint := nLin + nLin3

		QuebraPag(@nLint,@nLin,@nLin3)

		For nCnt := 1 To Len(aRetorno)

			oND:Say(nLin, 020,aRetorno[nCnt],oFont10N)
			nLin += 020
			nLin2 += 020
			nLin3 := nLin - 3
			nLint := nLin + nLin3

			QuebraPag(@nLint,@nLin,@nLin3)

		Next



		nLin += 040
		nLin2 += 040
		nLin3 := nLin - 3
		nLint := nLin + nLin3

		QuebraPag(@nLint,@nLin,@nLin3)

		oND:Say(nLin, 020, "3) INFORMAÇÕES COMPLEMENTARES",oFont10N)


		nLin += 040
		nLin2 += 040
		nLin3 := nLin - 3
		nLint := nLin + nLin3

		QuebraPag(@nLint,@nLin,@nLin3)

		For nCnt := 1 To Len(aRetorno4)

			oND:Say(nLin, 020,aRetorno4[nCnt],oFont10N)
			nLin += 020
			nLin2 += 020
			nLin3 := nLin - 3
			nLint := nLin + nLin3

			QuebraPag(@nLint,@nLin,@nLin3)
		Next
		nLint := nLin + nLin3

		QuebraPag(@nLint,@nLin,@nLin3)

		nLin += 040
		nLin2 += 040
		nLin3 := nLin - 3
		nLint := nLin + nLin3

		QuebraPag(@nLint,@nLin,@nLin3)




		nLin += 040
		nLin2 += 040
		nLin3 := nLin - 3
		nLint := nLin + nLin3

		QuebraPag(@nLint,@nLin,@nLin3)

		oND:Say(nLin, 020, "4) FAVOR MENCIONAR NÚMERO DA FATURA NO R.E. E VICE E VERSA",oFont10N)
		nLint := nLin + nLin3

		QuebraPag(@nLint,@nLin,@nLin3)

		nLin += 040
		nLin2 += 040
		nLin3 := nLin - 3
		nLint := nLin + nLin3

		QuebraPag(@nLint,@nLin,@nLin3)

		oND:Say(nLin, 020, '5) IMEDIATAMENTE APÓS A SAÍDA DO NAVIO, GENTILEZA ENVIAR "DETALHES EMBARQUE" + CÓPIA DE TODOS OS DOCUMENTOS',oFont10N)
		oND:Say(nLin+=10, 020, "POR E-MAIL. (CARTA BORDERÔ COM NÚMERO DO COURIER, R.E. E DEMAIS DOCUMENTOS CONFERIDOS E CORRETOS).",oFont10N)

		nLin += 040
		nLin2 += 040
		nLin3 := nLin - 3
		nLint := nLin + nLin3

		QuebraPag(@nLint,@nLin,@nLin3)


		oND:Say(nLin, 020, "6) IMPORTADOR NA INVOICE:",oFont10N)
		dBselectArea("SA1")
		SA1->(dbSetOrder(1))
		If SA1->(dbSeek(xFilial("SA1") + ZB8->ZB8_IMPORT + ZB8->ZB8_IMLOJA))
			oND:Say(nLin, 150, SA1->A1_NOME,oFont10N)
			oND:Say(nLin+=10, 150, SA1->A1_END,oFont10N)
			dBselectArea("SA1")
			SA1->(dbSetOrder(1))
			If SYA->(dbSeek(xFilial("SYA") + SA1->A1_PAIS))
				oND:Say(nLin+=10, 150, iIf(!Empty(alltrim(SYA->YA_PAIS_I)),SYA->YA_PAIS_I,SYA->YA_DESCR) ,oFont10N)
			EndIf
		EndIf

		nLint := nLin + nLin3
		nLin += 040
		nLin2 += 040
		nLin3 := nLin - 3

		QuebraPag(@nLint,@nLin,@nLin3)

		dBselectArea("SA1")
		SA1->(dbSetOrder(1))
		If SA1->(dbSeek(xFilial("SA1") + ZB8->ZB8_CONSIG))
			oND:Say(nLin, 020, "7) CONSIGNEE B/L:",oFont10N)
			oND:Say(nLin, 150, SA1->A1_NOME,oFont10N)
			oND:Say(nLin+=10, 150, SA1->A1_END,oFont10N)
			If SYA->(dbSeek(xFilial("SYA") + SA1->A1_PAIS))
				oND:Say(nLin+=10, 150, iIf(!Empty(alltrim(SYA->YA_PAIS_I)),SYA->YA_PAIS_I,SYA->YA_DESCR),oFont10N)
			EndIf
		EndIf

		nLin += 040
		nLin2 += 040
		nLin3 := nLin - 3
		nLint := nLin + nLin3

		QuebraPag(@nLint,@nLin,@nLin3)








		dBselectArea("SA1")
		SA1->(dbSetOrder(1))
		If SA1->(dbSeek(xFilial("SA1") + ZB8->ZB8_ZNOTIF+ZB8->ZB8_ZLJNOT))


			oND:Say(nLin, 020, "8) NOTIFY PARTY:",oFont10N)
			oND:Say(nLin, 150, ALLTRIM(SA1->A1_NOME),oFont10N)
			oND:Say(nLin+=10, 150, ALLTRIM(SA1->A1_END),oFont10N)
			If SYA->(dbSeek(xFilial("SYA") + SA1->A1_PAIS))
				oND:Say(nLin+=10, 150, iIf(!Empty(alltrim(SYA->YA_PAIS_I)),SYA->YA_PAIS_I,SYA->YA_DESCR),oFont10N)
			EndIf

			nLin += 040
			nLin2 += 040
			nLin3 := nLin - 3
			nLint := nLin + nLin3

			QuebraPag(@nLint,@nLin,@nLin3)

		EndIf


		oND:Say(nLin, 020, "9) B/L DEVERÁ MOSTRAR:",oFont10N)

		nLin += 040
		nLin2 += 040
		nLin3 := nLin - 3
		nLint := nLin + nLin3

		QuebraPag(@nLint,@nLin,@nLin3)

		For nCnt := 1 To Len(aRetorno2)

			oND:Say(nLin, 020,aRetorno2[nCnt],oFont10N)
			nLin += 020
			nLin2 += 020
			nLin3 := nLin - 3
			nLint := nLin + nLin3

			QuebraPag(@nLint,@nLin,@nLin3)
		Next
		nLint := nLin + nLin3

		QuebraPag(@nLint,@nLin,@nLin3)

		nLin += 040
		nLin2 += 040
		nLin3 := nLin - 3
		nLint := nLin + nLin3

		QuebraPag(@nLint,@nLin,@nLin3)


		oND:Say(nLin, 020, "10) CERTIFICADO SANITÁRIO VALIDO PARA:"+ space(5) + cIdioma,oFont10N)

		nLin += 040
		nLin2 += 040
		nLin3 := nLin - 3
		nLint := nLin + nLin3

		QuebraPag(@nLint,@nLin,@nLin3)

		If ZB8->ZB8_ZIMSAN <> " "
			oND:Say(nLin, 020, "11) HEALT CERTIFICATE EM NOME DE:",oFont10N)
			dBselectArea("SA1")
			SA1->(dbSetOrder(1))





			If SA1->(dbSeek(xFilial("SA1") + ZB8->ZB8_ZIMSAN))

				oND:Say(nLin, 180, SA1->A1_NOME,oFont10N)
				oND:Say(nLin+=10, 180, SA1->A1_END,oFont10N)
				dBselectArea("SYA")
				SYA->(dbSetOrder(1))
				If SYA->(dbSeek(xFilial("SYA") + SA1->A1_PAIS))
					oND:Say(nLin+=10, 180,iIf(!Empty(alltrim(SYA->YA_PAIS_I)),SYA->YA_PAIS_I,SYA->YA_DESCR),oFont10N)
				EndIf

			EndIf
		EndIf
		nLin += 040
		nLin2 += 040
		nLin3 := nLin - 3
		nLint := nLin + nLin3

		QuebraPag(@nLint,@nLin,@nLin3)
		oND:Say(nLin, 020, iif(ZB8->ZB8_ZIMSAN <> " ","12)","11)")+" BANCO NO EXTERIOR:",oFont10N)

		nLin += 020
		nLin2 += 020
		nLin3 := nLin - 3
		nLint := nLin + nLin3

		For nCnt := 1 To Len(aRetorno3)

			oND:Say(nLin, 020,aRetorno3[nCnt],oFont10N)
			nLin += 020
			nLin2 += 020
			nLin3 := nLin - 3
			nLint := nLin + nLin3
			QuebraPag(@nLint,@nLin,@nLin3)
		Next


		nLin += 040
		nLin2 += 040
		nLin3 := nLin - 3
		nLint := nLin + nLin3
		QuebraPag(@nLint,@nLin,@nLin3)

		oND:Say(nLin, 020, "NOTAS",oFont10N)
		oND:Say(nLin+=010, 020, "1) FAVOR PROVISIONAR NO R.E. CONDIÇÃO DE PAGAMENTO EM 90 DIAS DATA B/L.",oFont10)
		oND:Say(nLin+=010, 020, "2) PROVISIONAR COMISSÃO MÁXIMA PERMITIDA NO R.E. COM MODALIDADE A REMETER.",oFont10)



		oND:Say(nLin, 110, "",oFont10)

		nLin += 040
		nLin2 += 040
		nLin3 := nLin - 3
		nLint := nLin + nLin3

		QuebraPag(@nLint,@nLin,@nLin3)

		oND:Say(nLin, 070, "ATENÇÃO: Favor constar em sua carta remessa/Borderô enviada ao banqueiro cobrador no exterior que todas as",oFont10N)
		oND:Say(nLin+=10, 090, "despesas bancárias no exterior devem ser cobradas do importador e são por conta do mesmo.",oFont10N)


		nLin += 040
		nLin2 += 040
		nLin3 := nLin - 3
		nLint := nLin + nLin3
		QuebraPag(@nLint,@nLin,@nLin3)

		oND:Say(nLin, 020, "QUALQUER DÚVIDA, FAVOR ENTRAR EM CONTATO.",oFont10N)
		oND:Say(nLin+=12, 020, "ATENCIOSAMENTE,",oFont10N)
		oND:Say(nLin+=12, 020,  ALLTRIM(UsrFullName(RetCodUsr())),oFont10N)
		oND:Say(nLin+=12, 020, "DEPARTAMENTO DE EXPORTAÇÃO,",oFont10N)

		oND:EndPage()
	Else
		Iif(FindFunction("APMsgAlert"), APMsgAlert("Certificado não encontrado",), MsgAlert("Certificado não encontrado",))
	EndIf

Return



Static Function DESPROD()

	Local cDescr   := Space(120)
	Local cDescrb  := Space(120)
	Local cDescrbl := Space(120)
	Local cDescr2  := Space(120)
	Local cDescr3  := Space(120)
	Local cDescr4  := Space(120)
	Local cNomebco := Space(120)
	Local cEndbco  := Space(120)
	Local cZipcode := Space(120)
	Local cCid     := Space(120)
	Local cPais    := Space(120)
	Local oMemo	   := Space(120)
	Local cTexto1  := ""
	Local aRet := {}
	Local aRetMemo := {}
	Local Odlg
	Local cDescrC := ""
	Private lOk,lCancel


	oDlg = TDialog():New( 180, 180, 400, 700, "NOME DOS PRODUTOS EM INGLÊS",,,.F.,,,,,,.T.,,,,, )

	oTmultiget1 := tmultiget():new( 01, 01, {| u | if ( pCount() > 0, cTexto1 := u, cTexto1)}, oDlg, 260 , 92, , , , , , .T. )
	oTButton := TButton():New( 100, 205, "&OK",oDlg	,{|| lOk:= .T. , oDlg:End() },40,10,,, .F. , .T. , .F. ,, .F. ,,, .F.  )

	oDlg:Activate( oDlg:bLClicked, oDlg:bMoved, oDlg:bPainted,.T.,,,, oDlg:bRClicked, )


	aRetMemo := {}
	nCount := 0

	aRetMemo := StrToKArr(ALLTRIM(cTexto1),Chr(13)+Chr(10))















	AADD (aRet, {cTexto1, cDescrb, cDescrbl, cDescr2, cDescr3, cDescr4, cNomebco, cEndbco, cZipcode, cCid, cPais, aClone(aRetMemo) })

Return aRetMemo





Static Function DESBL()

	Local cDescr   := Space(120)
	Local cDescrb  := Space(120)
	Local cDescrbl := Space(120)
	Local cDescr2  := Space(120)
	Local cDescr3  := Space(120)
	Local cDescr4  := Space(120)
	Local cNomebco := Space(120)
	Local cEndbco  := Space(120)
	Local cZipcode := Space(120)
	Local cCid     := Space(120)
	Local cPais    := Space(120)
	Local oMemo	   := Space(120)
	Local cTexto2  := ""
	Local aRet := {}
	Local Odlg
	Local cDescrC := ""
	Local aRetMemo2 := {}
	Private lOk,lCancel


	oDlg = TDialog():New( 180, 180, 400, 700, "B/L DEVERÁ MOSTRAR",,,.F.,,,,,,.T.,,,,, )

	oTmultiget1 := tmultiget():new( 01, 01, {| u | if ( pCount() > 0, cTexto2 := u, cTexto2)}, oDlg, 260 , 92, , , , , , .T. )
	oTButton := TButton():New( 100, 205, "&OK",oDlg	,{|| lOk:= .T. , oDlg:End() },40,10,,, .F. , .T. , .F. ,, .F. ,,, .F.  )

	oDlg:Activate( oDlg:bLClicked, oDlg:bMoved, oDlg:bPainted,.T.,,,, oDlg:bRClicked, )


	aRetMemo2 := {}
	nCount := 0

	aRetMemo2 := StrToKArr(ALLTRIM(cTexto2),Chr(13)+Chr(10))















	AADD (aRet, {cTexto2, cDescrb, cDescrbl, cDescr2, cDescr3, cDescr4, cNomebco, cEndbco, cZipcode, cCid, cPais, aClone(aRetMemo2) })

Return aRetMemo2


Static Function INFCOMPL()

	Local cDescr   := Space(120)
	Local cDescrb  := Space(120)
	Local cDescrbl := Space(120)
	Local cDescr2  := Space(120)
	Local cDescr3  := Space(120)
	Local cDescr4  := Space(120)
	Local cNomebco := Space(120)
	Local cEndbco  := Space(120)
	Local cZipcode := Space(120)
	Local cCid     := Space(120)
	Local cPais    := Space(120)
	Local oMemo	   := Space(120)
	Local cTexto2  := ""
	Local aRet := {}
	Local Odlg
	Local cDescrC := ""
	Local aRetMemo2 := {}
	Private lOk,lCancel


	oDlg = TDialog():New( 180, 180, 400, 700, "INFORMAÇÕES COMPLEMENTARES",,,.F.,,,,,,.T.,,,,, )

	oTmultiget1 := tmultiget():new( 01, 01, {| u | if ( pCount() > 0, cTexto2 := u, cTexto2)}, oDlg, 260 , 92, , , , , , .T. )
	oTButton := TButton():New( 100, 205, "&OK",oDlg	,{|| lOk:= .T. , oDlg:End() },40,10,,, .F. , .T. , .F. ,, .F. ,,, .F.  )

	oDlg:Activate( oDlg:bLClicked, oDlg:bMoved, oDlg:bPainted,.T.,,,, oDlg:bRClicked, )


	aRetMemo2 := {}
	nCount := 0

	aRetMemo2 := StrToKArr(ALLTRIM(cTexto2),Chr(13)+Chr(10))















	AADD (aRet, {cTexto2, cDescrb, cDescrbl, cDescr2, cDescr3, cDescr4, cNomebco, cEndbco, cZipcode, cCid, cPais, aClone(aRetMemo2) })

Return aRetMemo2




Static Function IDIOMA()

	Local 	cIdioma  := Space(120)
	Local	Odlg
	Local 	cIdio := ""
	Private lOk,lCancel


	oDlg = TDialog():New( 180, 180, 350, 500, "Informa Idioma na instrução de embarque",,,.F.,,,,,,.T.,,,,, )

	TGet():New( 25, 58, { | u | If( PCount() == 0, cIdioma, cIdioma := u ) },oDlg, 90, 10, "@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cIdioma",,,, )
	TSay():New( 26, 08,{||  "Cert.Válido para:"},oDlg,,,.F.,.F.,.F.,.T.,,, 50, 10,.F.,.F.,.F.,.F.,.F.,.F. )


	oTButton := TButton():New( 70, 120, "&OK",oDlg			,{|| lOk:= .T.     , oDlg:End() }	,40,10,,, .F. , .T. , .F. ,, .F. ,,, .F.  )

	oDlg:Activate( oDlg:bLClicked, oDlg:bMoved, oDlg:bPainted,.T.,,,, oDlg:bRClicked, )



Return cIdioma




User Function EEC07(aButtons)
	aadd(aButtons,{"Impressão Documentos Exportação","U_MGFECC14",0,4})
	aadd(aButtons,{"Ajustes de Documentos","U_MGFEEC20",0,4})
Return aButtons


Static Function QuebraPag(nLint,nLin,nLin3)

	If nLint > 1500

		oND:StartPage()
		nLin := 40
		nLin3 := 40
	EndIf

Return


Static Function DADOS()

	Local cTexto1  := ""
	Local cTexto2  := ""
	Local cTexto3  := ""
	Local cIdioma  := Space(255)
	Local aRet := { .f. }
	Local oDlg
	Local cDescrC := ""
	Local aRetMemo1 := {}
	Local aRetMemo2 := {}
	Local aRetMemo3 := {}
	Local  oFont := TFont():New("Courier new",,-16, .T. )
	Local oSay1, oSay2, oSay3, oSay4, oTmultiget1, oTmultiget2, oTmultiget3, oTButton
	Local lOk := .f.
	Local lCancel := .f.


	oDlg = TDialog():New( 180, 180, 750, 1100, "DADOS PARA SHIPPING INSTRUCTIONS",,,.F.,,,,,,.T.,,,,, )


	oSay1:= TSay():New(5,10,{||"NOME DOS PRODUTOS EM INGLÊS"},oDlg,,oFont,,,, .T. ,128,16777215,200,20)
	oTmultiget1 := tmultiget():new( 15, 10, {| u | if ( pCount() > 0, cTexto1 := u, cTexto1)}, oDlg, 200 , 100, , , , , , .T. )
	oSay2:= TSay():New(5,250,{||"B/L DEVERÁ MOSTRAR"},oDlg,,oFont,,,, .T. ,128,16777215,200,20)
	oTmultiget2 := tmultiget():new( 15,250 , {| u | if ( pCount() > 0, cTexto2 := u, cTexto2)}, oDlg, 200 , 100, , , , , , .T. )
	oSay3:= TSay():New(120,10,{||"INFORMAÇÕES COMPLEMENTARES"},oDlg,,oFont,,,, .T. ,128,16777215,200,20)
	oTmultiget3 := tmultiget():new( 130, 10, {| u | if ( pCount() > 0, cTexto3 := u, cTexto3)}, oDlg, 200 , 100, , , , , , .T. )
	oSay4:= TSay():New(120,250,{||"Cert.Válido para:"},oDlg,,oFont,,,, .T. ,128,16777215,200,20)

	oGet1 := TGet():New( 130, 250, { | u | If( PCount() == 0, cIdioma, cIdioma := u ) },oDlg, 200, 010, "!@",, 0, 16777215,, .F. ,, .T. ,, .F. ,, .F. , .F. ,, .F. , .F.  ,,"cIdioma",,,, .f.   )

	oTButton := TButton():New( 270, 400, "&OK",oDlg	,{|| xClose(@lOk,@oDlg) },40,10,,, .F. , .T. , .F. ,, .F. ,,, .F.  )

	oDlg:Activate( oDlg:bLClicked, oDlg:bMoved, oDlg:bPainted,.T.,,,, oDlg:bRClicked, )


	aRetMemo2 := {}
	nCount := 0

	aRetMemo1 := StrToKArr(ALLTRIM(cTexto1),Chr(13)+Chr(10))
	aRetMemo2 := StrToKArr(ALLTRIM(cTexto2),Chr(13)+Chr(10))
	aRetMemo3 := StrToKArr(ALLTRIM(cTexto3),Chr(13)+Chr(10))

	aRet :=  {lOk, aClone(aRetMemo1), aClone(aRetMemo2), aClone(aRetMemo3), cIdioma }

Return aRet

Static Function xClose(lOk,oDlg)
	lOk := .t.
	oDlg:End()
Return
