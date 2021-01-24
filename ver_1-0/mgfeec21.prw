#include 'protheus.ch'
#include "rwmake.ch"
#include "topconn.ch"

/*/{Protheus.doc} MGFEEC21
//Programa para geração de Proforma Invoice
@author leonardo.kume
@since 31/05/2017
@version 6

@type function
/*/
user function MGFEEC21()

	Local aArea			:= GetArea()
	Local cPerg			:= PADR("MGFEEC21",10)
	local lPergEEC21	:= .F.
	Private cNumero := ""
	If IsInCallStack("U_MGFEEC24")

		cPerg := Padr(cPerg,Len(SX1->X1_GRUPO))

		dbSelectArea("SX1")
		SX1->(dbSetOrder(1))
		SX1->(DBGoTop())
		If SX1->(DBSeek(cPerg+"01"))
			//Acerto o parametro com a database
			RecLock("SX1",.F.)
			SX1->X1_CNT01 := ZB8->(ZB8_EXP + ZB8_ANOEXP + ZB8_SUBEXP)
			SX1->(MsUnlock())
		Endif
		Pergunte(cPerg,.F.)
		MV_PAR01	:= ZB8->(ZB8_EXP + ZB8_ANOEXP + ZB8_SUBEXP)

		//If SX1->(MsSeek(cPerg+"01"))

		lPergEEC21 := Pergunte(cPerg,.T.)
		cNumero := MV_PAR01
	Else
		lPergEEC21 := Pergunte(cPerg,.T.)
		cNumero := MV_PAR01
	EndIf

	if lPergEEC21
		@ 96,012 TO 250,400 DIALOG oDlg TITLE OemToAnsi("Integracao com MS-Word")
		@ 08,005 TO 048,190
		@ 18,010 SAY OemToAnsi("Impressao de Proforma Invoice" )

		@ 56,130 BMPBUTTON TYPE 1 ACTION WordImp()
		@ 56,160 BMPBUTTON TYPE 2 ACTION Close(oDlg)

		ACTIVATE DIALOG oDlg CENTERED
	endif

	RestArea(aArea)

return

//----------------------------------------
// Valida se parametro do usuario é igual ao posicionado no grid
//----------------------------------------
user function eec21par()
	local lRet := .T.

	if MV_PAR01 <> ZB8->(ZB8_EXP + ZB8_ANOEXP + ZB8_SUBEXP)
		lRet := .F.
		MV_PAR01 := ZB8->(ZB8_EXP + ZB8_ANOEXP + ZB8_SUBEXP)
		msgAlert("EXP do parâmetro é diferente da posicionada em tela.")
	endif
return lRet

Static Function WordImp()

	Local aAreaSM0 := SM0->(GetArea())
	Local WNumOrc, WRef, WTo, WDate, WRevised, WAttention, WNotes, WSeller, WNameBuyer, WAddressBuyer, WCountryPort, WCountryBuyer, WMerchandise, WTemp
	Local WShippingMarks, WSalesTerms, WPaymentTerms, WBank, WWeek, WVia, WCarrier, WAgency, WPlaceOfCharge, WPlaceOfDischarge, WIsIT , WIT, WAgent
	Local WComission, WCompany, WAddressCompany, WZipCode, WPlaceCompany, WHasObs, WObservation, cAPreco,cAQtd
	Local nTotQuant 	:= 0
	Local nTot			:= 0
	Local lRet			:= .t.
	Local nQtdCont 		:= 1
	Local lIndustria 	:= MV_PAR02 == 1
	Local lIncoterm 	:= MV_PAR03 == 1
	Local lPDF		 	:= ! RetCodUsr() $ GetMv("MGF_PROFWO",,"")
	Local aDot			:= {GetMv("MGF_EEC211",,"ProformaInvoice.dot"),GetMv("MGF_EEC212",,"ProformaInvoiceV3.dot"),GetMv("MGF_EEC213",,"ProformainvoiceOff.dot")}
	//Empresa01, Empresa02, EmpresaOffshore

	Local WItens := {}
	Local cPicture	:= "@E 999,999,999.999999"

	Local nK
	Local cDir			:= "C:\DOT\" +  Alltrim(GetEnvServer())
	Local cPathDot		:= cDir + "\" + iif(lIncoterm,aDot[3],aDot[2])
	Private	hWord
	
	If cEmpAnt == "01"
		cPathDot		:= cDir + "\" + iif(lIncoterm,aDot[3],aDot[1])
	EndIf

	If !ExistDir("C:\DOT")  
		If  !MakeDir("C:\DOT") == 0
			lRet := .f.
		EndIf
	EndIF

	If !ExistDir(cDir)  
		If  !MakeDir(cDir) == 0
			lRet := .f.
		EndIf
	EndIF

	If !ExistDir("C:\DOT\PDF")
		If  !MakeDir("C:\DOT\PDF") == 0
			lRet := .f.
		EndIf
	EndIF
	If ExistDir(cDir)
		If cEmpAnt == "01"
			If !FILE(cDir + "\"+aDot[1])
				If FILE("\system\"+aDot[1])
					If !__CopyFile("\system\"+aDot[1],cDir + "\"+aDot[1])
						MsgStop("Não foi possível copiar o arquivo."+CRLF+" Favor contatar o administrador do sistema.")
						lRet := .f.
					EndIf
				Else
					MsgStop("Arquivo não encontrado no Servidor."+CRLF+" Favor contatar o administrador do sistema.")
					lRet := .f.
				EndIF
			EndIF
		Else
			If !FILE(cDir + "\"+aDot[2])
				If FILE("\system\"+aDot[2])
					If !__CopyFile("\system\"+aDot[2],cDir + "\"+aDot[2])
						MsgStop("Não foi possível copiar o arquivo."+CRLF+" Favor contatar o administrador do sistema.")
						lRet := .f.
					EndIf
				Else
					MsgStop("Arquivo não encontrado no Servidor."+CRLF+" Favor contatar o administrador do sistema.")
					lRet := .f.
				EndIF
			EndIF
		EndIF
		If !FILE(cDir + "\"+aDot[3])
			If FILE("\system\"+aDot[3])
				If !__CopyFile("\system\"+aDot[3],cDir + "\"+aDot[3])
					MsgStop("Não foi possível copiar o arquivo."+CRLF+" Favor contatar o administrador do sistema.")
					lRet := .f.
				EndIf
			Else
				MsgStop("Arquivo não encontrado no Servidor."+CRLF+" Favor contatar o administrador do sistema.")
				lRet := .f.
			EndIF
		EndIF
	Else
		MsgStop("Não foi possível criar pasta."+CRLF+" Favor contatar o administrador do sistema.")
		lRet := .f.
	EndIF

	Close(oDlg)


	If lRet
		//Alimentando valores para atualizar o documento Word
		OpenSM0()
		DbSelectArea("SM0")
		SM0->(DbSetOrder(1))
		SM0->(DbSeek(cEmpAnt+cFilAnt))
		DbSelectArea("ZB8")
		ZB8->(DbSetOrder(3))
		DbSelectArea("ZB9")
		ZB9->(DbSetOrder(2))
		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		DbSelectArea("EE3")
		EE3->(DbSetOrder(1))
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		DbSelectArea("SYC")
		SYC->(DbSetOrder(4))
		//		DbSelectArea("EEH")
		//		EEH->(DbSetOrder(1))
		//		DbSelectArea("SYJ")
		//		SYJ->(DbSetOrder(1))
		DbSelectArea("SY5")
		SY5->(DbSetOrder(1))
		DbSelectArea("SY6")
		SY6->(DbSetOrder(1))
		DbSelectArea("SA6")
		//		SA6->(DbSetOrder(1))
		//		DbSelectArea("SYQ")
		SYQ->(DbSetOrder(1))
		DbSelectArea("SY9")
		SY9->(DbSetOrder(2))
		DbSelectArea("SY6")
		SY6->(DbSetOrder(1))
		DbSelectArea("ZZS")
		ZZS->(DbSetOrder(1))
		ZB8->(DBGoTop())
		lRet := ZB8->(DbSeek(xFilial("ZB8")+cNumero))
		ZB9->(DBGoTop())
		lRet := lRet .and. ZB9->(DbSeek(xFilial("ZB8")+cNumero))

		nQtdCont 	:= GetContainers()

		// cPicture := iif(ZB8->ZB8_INTERM == "1","@E 999,999,999.999999",cPicture)

		If lRet
			If Empty(ZB8->ZB8_ZEMPRO)
				RecLock("ZB8",.F.)
				ZB8->ZB8_ZEMPRO := ddatabase
				ZB8->(MsUnlock())
			EndIf


			If lIncoterm .AND. ZB8->ZB8_INTERM == "1"
				SA1->(DbSeek(xFilial("SA1")+ZB8->(ZB8_CLIENT+ZB8_CLLOJA)))
			Else
				SA1->(DbSeek(xFilial("SA1")+ZB8->(ZB8_IMPORT+ZB8_IMLOJA)))
			EndIf
			If lIncoterm
				SA2->(DbSeek(xFilial("SA2")+ZB8->(ZB8_EXPORT+ZB8_EXLOJA)))
			EndIf
			//			EE3->(DbSeek(xFilial("EE3")+"I"+ZB8->(PADR(ZB8_IMPORT,15)+ZB8_IMLOJA)))
			SB1->(DbSeek(xFilial("SB1")+ ZB9->ZB9_COD_I))
			SYC->(DbSeek(xFilial("SYC")+ ZB8->ZB8_IDIOMA+alltrim(ZB8->ZB8_ZTPROD)))
			//			EEH->(DbSeek(xFilial("EEH")+ SYC->(YC_IDIOMA+YC_COD_RL) ) )
			//			SYJ->(DbSeek(xFilial("SYJ")+ ZB8->ZB8_INCOTE))
			//			SA6->(DbSeek(xFilial("SA6")+ SA1->A1_BCO1))
			SYQ->(DbSeek(xFilial("SYQ")+ ZB8->ZB8_VIA))
			SY5->(DbSeek(xFilial("SY5")+ ZB8->ZB8_ZARMAD))
			SY6->(DbSeek(xFilial("SY6")+ ZB8->ZB8_CONDPA))
			If lIncoterm
				EE2->(DbSeek(XFILIAL("EE2")+"2*"+ZB8->(ZB8_IDIOMA+ZB8_COND2+STR(ZB8_DIAS2,AVSX3("ZB8_DIAS2",3)))  ))
			Else
				EE2->(DbSeek(XFILIAL("EE2")+"2*"+ZB8->(ZB8_IDIOMA+ZB8_CONDPA+STR(ZB8_DIASPA,AVSX3("ZB8_DIASPA",3)))  ))
			EndIf
		EndIF

		If lRet
			WNumOrc 			:= ZB8->(ZB8_EXP + '/' + ZB8_ANOEXP + IIF(!EMpty(ZB8_SUBEXP),"-" + ZB8_SUBEXP ,"" ))
			WRef				:= ZB8->ZB8_REFIMP //ZB8->ZB8_ZREFER //CAMPO NOVO
			WTo					:= SA1->A1_NOME
			WDate				:= DTOC(ZB8->ZB8_DTPROC)
			WRevised			:= DTOC(ZB8->ZB8_ZREVIS) //CAMPO NOVO
			WAttention			:= IIF(lIncoterm,ZB8->ZB8_ZREFE2,ZB8->ZB8_ZCONT)
			WNotes				:= ZB8->ZB8_ZNOTES //CAMPO NOVO
			// ALTERACAO
			WSeller				:= Iif(lIncoterm,SA2->A2_NOME,SM0->M0_NOMECOM)
			//			WSeller				:= getSeller(lIncoterm, "M0_NOMECOM")
			//OLE_SetDocumentVar(hWord, 'WSeller', WSeller) //FILIAL DA ZB8 -> Se lIncoterm .T. -> 900001

			If !Empty(Alltrim(ZB8->ZB8_ZBUYER)) .AND. !lIncoterm .AND. !ZB8->ZB8_INTERM == "1" //CASO TENHA CONSIGNATARIO PEGAR DADOS DELE
				lRet := SA1->(DbSeek(xFilial("SA1")+ZB8->(ZB8_ZBUYER+ZB8_ZBUYLJ)))
			EndIf
			//WNameBuyer			:= SA1->A1_NOME
			WNameBuyer			:= SA1->A1_NOME
			//OLE_SetDocumentVar(hWord, 'WNameBuyer', WNameBuyer) // QUANDO NAO lIncoterm -> INFORMAÇÕES DO TO
			// FIM

			WAddressBuyer		:= SA1->A1_END
			//			WCityBuyer			:= Alltrim(SA1->A1_MUN) //+ "/"+SA1->A1_EST
			WCountryPort		:= GetAdvFVal("SYA","YA_DESCR",xFilial("SYA")+SA1->A1_PAIS,1,"")
			WCountryBuyer		:= GetAdvFVal("SYA","YA_PAIS_I",xFilial("SYA")+SA1->A1_PAIS,1,"")
			WCountryBuyer		:= iIf(!Empty(Alltrim(WCountryBuyer)),WCountryBuyer,WCountryPort)
			WTemp				:= Alltrim(ZB8->ZB8_ZTEMPE) + IIF(AT("ºC", ZB8->ZB8_ZTEMPE) > 0 .Or. AT("DRY", ZB8->ZB8_ZTEMPE) > 0 , "" , "ºC" ) 
			WMerchandise		:= iif(alltrim(SYC->YC_COD) == alltrim(ZB8->ZB8_ZTPROD),SYC->YC_NOME,"")
			WShippingMarks		:= ZB8->ZB8_MARCAC // VOLTAR CAMPO PARA VISUAL
			WSalesTerms			:= iif(lIncoterm,ZB8->ZB8_INCO2,ZB8->ZB8_INCOTE)
			If Alltrim(EE2->EE2_COD) == ZB8->ZB8_COND2+Str(ZB8->ZB8_DIAS2,3) .or.  Alltrim(EE2->EE2_COD) == ZB8->ZB8_CONDPA+Str(ZB8->ZB8_DIASPA,3)
				WPaymentTerms		:= iIf(!Empty(Alltrim(MSMM(EE2->EE2_TEXTO,50))),MSMM(EE2->EE2_TEXTO,50),MSMM(SY6->Y6_DESC_P,50))
			Else
				WPaymentTerms		:= MSMM(SY6->Y6_DESC_P,50)
			EndIf
			WBank				:= iif(ZB8->ZB8_INTERM == "1" .AND. !lIncoterm,"",ZB8->ZB8_ZBANCO)
			WWeek				:= ZB8->ZB8_ZOBSWE  //CAMPO NOVO
			WVia				:= SYQ->YQ_DESCR
			WCarrier			:= ZB8->ZB8_ZNTRAN //CAMPO NOVO
			WAgency				:= iif(alltrim(SY5->Y5_COD) == alltrim(ZB8->ZB8_ZARMAD),SY5->Y5_NOME,"")//CAMPO NOVO
			lRet := SY9->(DbSeek(xFilial("SY9")+ ZB8->ZB8_ORIGEM))
			WPlaceOfCharge		:= SY9->Y9_DESCR
			lRet := SY9->(DbSeek(xFilial("SY9")+ ZB8->ZB8_DEST))
			WPlaceOfDischarge	:= GetAdvFVal("SYA","YA_PAIS_I",xFilial("SYA")+ZB8->ZB8_PAISET,1,"")
			WPlaceOfDischarge	:= Iif(Empty(WPlaceOfDischarge),GetAdvFVal("SYA","YA_DESCR",xFilial("SYA")+ZB8->ZB8_PAISET,1,""),WPlaceOfDischarge)
			WPlaceOfDischarge	:= Alltrim(SY9->Y9_DESCR) + " - "+ WPlaceOfDischarge
			WIsIT				:= iif(!Empty(ZB8->ZB8_ZINTER),"I/T:","")
			WIT					:= ZB8->ZB8_ZINTER//CAMPO NOVO
			SY5->(DbSeek(xFilial("SY5")+ ZB8->ZB8_ZAGENT))
			WAgent				:= iif(alltrim(SY5->Y5_COD) == alltrim(ZB8->ZB8_ZAGENT),SY5->Y5_NOME,"")
			WComission			:= Alltrim(Transform(ZB8->ZB8_VALCOM,"@E 999,999,999.99"))+iif(ZB8->ZB8_TIPCVL=="1"," %",iif(ZB8->ZB8_TIPCVL=="2"," % por item",""))
			WCompany			:= WSeller
			//WAddressCompany		:=
			WAddressCompany		:= iif(lIncoterm, allTrim(SA2->A2_END), allTrim(SM0->M0_ENDENT))
			WZipCode			:= iif(lIncoterm,""," - CEP "+SM0->M0_CEPENT)
			WPlaceCompany		:= " - "+iif(lIncoterm,iIf(ALLTRIM(SA2->A2_EST)<> "EX",allTrim(SA2->A2_MUN)+" - "+ALLTRIM(SA2->A2_EST),"UNITED KINGDOM - ENGLAND"),ALLTRIM(SM0->M0_CIDENT)+" - "+ALLTRIM(SM0->M0_ESTENT))
			WHasObs				:= iIf(lIndustria,"Obs:","") //Somente tem observação na industria
			WObservation		:=  iIf(lIndustria,ZB8->ZB8_ZOBSND,"")
			WCurrency			:= ZB8->ZB8_MOEDA



			EE2->(DbSeek(XFILIAL("EE2")+"8*"+ZB8->ZB8_IDIOMA+IIF(Empty(Alltrim(ZB9->ZB9_Z2UM)),ZB9->ZB9_UNIDAD,ZB9->ZB9_Z2UM) ) )
			WUnit				:= EE2->EE2_DESCMA

			While !ZB9->(EOF()) .AND. ALLTRIM(ZB8->(ZB8_EXP + ZB8_ANOEXP + ZB8_SUBEXP)) == ALLTRIM(ZB9->(ZB9_EXP + ZB9_ANOEXP + ZB9_SUBEXP))
				lRet := SB1->(DbSeek(xFilial("SB1")+ ZB9->ZB9_COD_I))
				ZZU->(DbSeek(xFilial("ZZU")+ ZB9->ZB9_ZCMARC))
				If lRet
					cAPreco := iif(lIncoterm,ZB9->ZB9_PRENEG,iif(Empty(Alltrim(ZB9->ZB9_Z2UM)),ZB9->ZB9_PRECO,ZB9->ZB9_ZPR2UM))
					cAQtd	:= IIF(Empty(Alltrim(ZB9->ZB9_Z2UM)),ZB9->ZB9_SLDINI,ZB9->ZB9_ZQT2UM)

					EE2->(DBGoTop())
					cDescProd := ""
					if EE2->( DBSeek( xFilial("EE2") + "3*" + ZB8->ZB8_IDIOMA + ZB9->ZB9_COD_I ) )
						cDescProd := EE2->EE2_TEXTO

						If !Empty(cDescProd)
							DBSelectArea("EE2")
							cDescProd := MSMM(cDescProd,50)
						Else
							cDescProd := SB1->B1_DESC
						EndIf

					else
						cDescProd := SB1->B1_DESC
					endif

					aAdd(WItens,{ZB9->ZB9_COD_I, cDescProd, ZZU->ZZU_DESCRI,cAQtd*nQtdCont,cAPreco,cAQtd*cAPreco*nQtdCont})
				EndIf
				ZB9->(DbSkip())
			ENDDO

			//Conecta ao word
			hWord	:= OLE_CreateLink()
			OLE_NewFile(hWord, cPathDot )
			If lPdf
				OLE_SetProperty( hWord, "206", .F. ) //206 -OLEWDVISIBLE
			EndIf

			//Montagem das variaveis do cabecalho
			OLE_SetDocumentVar(hWord, 'WNumOrc', WNumOrc)
			OLE_SetDocumentVar(hWord, 'WRef', WRef)
			OLE_SetDocumentVar(hWord, 'WTo', WTo)
			OLE_SetDocumentVar(hWord, 'WDate', WDate)
			OLE_SetDocumentVar(hWord, 'WRevised', WRevised)
			OLE_SetDocumentVar(hWord, 'WAttention', WAttention)
			OLE_SetDocumentVar(hWord, 'WNotes', WNotes)
			OLE_SetDocumentVar(hWord, 'WSeller', WSeller) //FILIAL DA ZB8 -> Se lIncoterm .T. -> 900001
			OLE_SetDocumentVar(hWord, 'WNameBuyer', WNameBuyer) // QUANDO NAO lIncoterm -> INFORMAÇÕES DO TO
			OLE_SetDocumentVar(hWord, 'WAddressBuyer', WAddressBuyer)
			//			OLE_SetDocumentVar(hWord, 'WCityBuyer', WCityBuyer)
			OLE_SetDocumentVar(hWord, 'WCountryBuyer', WCountryBuyer)
			OLE_SetDocumentVar(hWord, 'WTemp', WTemp)
			OLE_SetDocumentVar(hWord, 'WMerchandise', WMerchandise)
			OLE_SetDocumentVar(hWord, 'WShippingMarks', WShippingMarks)
			OLE_SetDocumentVar(hWord, 'WSalesTerms', WSalesTerms)
			OLE_SetDocumentVar(hWord, 'WPaymentTerms', WPaymentTerms)
			OLE_SetDocumentVar(hWord, 'WBank', WBank)
			OLE_SetDocumentVar(hWord, 'WWeek', WWeek)
			OLE_SetDocumentVar(hWord, 'WVia', WVia)
			OLE_SetDocumentVar(hWord, 'WCarrier', WCarrier)
			OLE_SetDocumentVar(hWord, 'WAgency', WAgency)
			OLE_SetDocumentVar(hWord, 'WPlaceOfCharge', WPlaceOfCharge)
			OLE_SetDocumentVar(hWord, 'WPlaceOfDischarge', WPlaceOfDischarge)
			OLE_SetDocumentVar(hWord, 'WIsIT', WIsIT)
			OLE_SetDocumentVar(hWord, 'WIT', WIT)
			OLE_SetDocumentVar(hWord, 'WAgent', WAgent)
			OLE_SetDocumentVar(hWord, 'WComission', WComission)
			OLE_SetDocumentVar(hWord, 'WCompany', WCompany)
			OLE_SetDocumentVar(hWord, 'WAddressCompany', WAddressCompany)
			OLE_SetDocumentVar(hWord, 'WZipCode', WZipCode)
			OLE_SetDocumentVar(hWord, 'WPlaceCompany', WPlaceCompany)
			OLE_SetDocumentVar(hWord, 'WHasObs', WHasObs)
			OLE_SetDocumentVar(hWord, 'WObservation', WObservation)
			OLE_SetDocumentVar(hWord, 'WCurrency', WCurrency)
			OLE_SetDocumentVar(hWord, 'WUnit', WUnit)

			OLE_SetDocumentVar(hWord, 'Prt_nroitens',str(Len(WItens)))

			//Montagem das variaveis dos itens. No documento word estas variaveis serao criadas //dinamicamente da seguinte forma:
			//prt_cod1, prt_cod2 ... prt_cod10
			for nK := 1 to Len(WItens)
				OLE_SetDocumentVar(hWord,"WCode"+AllTrim(Str(nK)),WItens[nK][1])
				OLE_SetDocumentVar(hWord,"WDescription"+AllTrim(Str(nK)),WItens[nK][2])
				OLE_SetDocumentVar(hWord,"WBrand"+AllTrim(Str(nK)),WItens[nK][3])
				OLE_SetDocumentVar(hWord,"WQuantity"+AllTrim(Str(nK)), Transform(WItens[nK][4],"@E 999,999,999.999"))
				OLE_SetDocumentVar(hWord,"WPrice"+AllTrim(Str(nK)), Transform(WItens[nK][5],"@E 999,999,999.999999"))
				OLE_SetDocumentVar(hWord,"WTotal"+AllTrim(Str(nK)), Transform(WItens[nK][6],"@E 999,999,999.99"))

				nTotQuant += WItens[nK][4]
				nTot	+= WItens[nK][6]
			next

			OLE_ExecuteMacro(hWord,"tabitens")

			OLE_SetDocumentVar(hWord, 'WQuantity', Transform(nTotQuant,"@E 999,999,999.999"))
			OLE_SetDocumentVar(hWord, 'WTotal', Transform(nTot,"@E 999,999,999.99"))


			OLE_UpdateFields(hWord)	// Atualizando as variaveis do documento do Word
			//			If MsgYesNo("Imprime o Documento ?")
			//				Ole_PrintFile(hWord,"ALL",,,1)
			//			EndIf

			If lPDF
				OLE_SaveAsFile( hWord, "C:\DOT\PDF\Orc"+StrTran(WNumOrc,"/","")+".pdf",'','',.F. , 17 ) // 17 - PDF
				OLE_CloseFile( hWord )
				OLE_CloseLink( hWord )
				ShellExecute( "Open", "Orc"+StrTran(WNumOrc,"/","")+".pdf", " ", "C:\DOT\PDF\", 3 )
			Else
				If MsgYesNo("Fecha o Word e Corta o Link ?")
					OLE_CloseFile( hWord )
					OLE_CloseLink( hWord )
				Endif
			Endif

			U_MGFDT15()

		Else
			MsgStop("EXP não encontrada")
		EndIf
	EndIf

	SM0->(RestArea(aAreaSM0))
Return()

Static Function GetContainers()

	Local cAliasZB8 := GetNextAlias()

	BeginSQL Alias cAliasZB8

		SELECT SUM(ZB8.ZB8_ZQTDCO) TOTAL
		FROM %table:ZB8% ZB8
		WHERE ZB8.D_E_L_E_T_ = ' '
		AND ZB8_FILIAL = %xFilial:ZB8%
		AND ZB8_EXP = %Exp:ZB8->ZB8_EXP%
		AND ZB8_ANOEXP = %Exp:ZB8->ZB8_ANOEXP%

	EndSQL



Return (cAliasZB8)->TOTAL

//-----------------------------------------------------------
static function getSeller(lIncoterm, cFieldSM0)
	local cRetSM0		:= ""
	local cQrySysCom	:= ""
	local cFilSearch	:= ""

	if lIncoterm
		cFilSearch := allTrim(getMv("MV_AVG0024"))
	else
		cFilSearch := cFilAnt
	endif

	cQrySysCom := "SELECT " + cFieldSM0
	cQrySysCom += " FROM SYS_COMPANY SYSCOM"
	cQrySysCom += " WHERE"
	cQrySysCom += "			SYSCOM.M0_CODFIL	=	'" + cFilSearch + "'"
	cQrySysCom += "		AND	SYSCOM.D_E_L_E_T_	<>	'*'"

	TcQuery cQrySysCom New Alias "QRYSYSCOMP"

	if !QRYSYSCOMP->(EOF())
		cRetSM0 := &("QRYSYSCOMP->" + cFieldSM0)
	endif

	QRYSYSCOMP->(DBCloseArea())
return cRetSM0

