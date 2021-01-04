#include 'protheus.ch'
#include "rwmake.ch"
#include "topconn.ch"

/*/{Protheus.doc} MGFEEC37
//Programa para geração de Proforma Invoice - Pedido de Exportacao
@author gresele
@since Out/2017
@version 1

@type function
/*/
user function MGFEEC37()

	Local aArea			:= GetArea()
	Local cPerg			:= "MGFEEC37"
	local lPergEEC37	:= .F.
	Private cNumero := ""
	If IsInCallStack("EECAP100")

		cPerg := Padr(cPerg,Len(SX1->X1_GRUPO))

		//dbSelectArea("SX1")
		//SX1->(dbSetOrder(1))
		//SX1->(DBGoTop())
		Pergunte(cPerg,.F.)
		//MV_PAR01	:= EE7->EE7_PEDIDO
		mv_par01 := SetMVPar(cPerg,"01",EE7->EE7_PEDIDO)
        /*
		If SX1->(DBSeek(cPerg+"01"))
			//Acerto o parametro com a database
			RecLock("SX1",.F.)
			SX1->X1_CNT01 := EE7->EE7_PEDIDO
			SX1->(MsUnlock())
		Endif
        */
		lPergEEC37 := Pergunte(cPerg,.T.)
		cNumero := MV_PAR01
	Else
		lPergEEC37 := Pergunte(cPerg,.T.)
		cNumero := MV_PAR01
	EndIf

	if lPergEEC37
		@ 96,012 TO 250,400 DIALOG oDlg TITLE OemToAnsi("Integracao com MS-Word")
		@ 08,005 TO 048,190
		@ 18,010 SAY OemToAnsi("Impressao de Proforma Invoice" )

		@ 56,130 BMPBUTTON TYPE 1 ACTION WordImp()
		@ 56,160 BMPBUTTON TYPE 2 ACTION Close(oDlg)

		ACTIVATE DIALOG oDlg CENTERED
	endif

	RestArea(aArea)

return


Static Function SetMVPar(cPerg,cOrdem,xValor)

SX1->(dbSetOrder(1))  // X1_GRUPO, X1_ORDEM
If SX1->(dbSeek(cPerg+cOrdem,.F.))
	SX1->(Reclock("SX1",.F.))
//	SX1->X1_CNT01 := Str(xValor,nTamanho)
	SX1->X1_CNT01 := xValor
	//SX1->X1_PRESEL := xValor
	SX1->(MsUnlock())
EndIf

SetMVValue(cPerg,"MV_PAR"+cOrdem,xValor)
&("MV_PAR"+cOrdem) := xValor

Return(xValor)


//----------------------------------------
// Valida se parametro do usuario é igual ao posicionado no grid
//----------------------------------------
user function eec37par()
	local lRet := .T.

	if MV_PAR01 <> EE7->EE7_PEDIDO
		lRet := .F.
		MV_PAR01 := EE7->EE7_PEDIDO
		msgAlert("Pedido de Exportação do parâmetro é diferente do posicionado em tela.")
	endif
return lRet

Static Function WordImp()

	Local aAreaSM0 := SM0->(GetArea())
	Local WNumOrc, WRef, WTo, WDate, WRevised, WAttention, WNotes, WSeller, WNameBuyer, WAddressBuyer, WCountryPort, WCountryBuyer, WMerchandise
	Local WShippingMarks, WSalesTerms, WPaymentTerms, WBank, WWeek, WVia, WCarrier, WAgency, WPlaceOfCharge, WPlaceOfDischarge, WIsIT , WIT, WAgent
	Local WComission, WCompany, WAddressCompany, WZipCode, WPlaceCompany, WHasObs, WObservation, cAPreco,cAQtd
	Local nTotQuant 	:= 0
	Local nTot			:= 0
	Local lRet			:= .t.
	Local nQtdCont 		:= 1
	Local lIndustria 	:= MV_PAR02 == 1
	Local lIncoterm 	:= MV_PAR03 == 1

	Local WItens := {}

	Local nK
	Local cPathDot		:= "C:\DOT\"+iif(lIncoterm,"ProformainvoiceOff.dot","ProformaInvoiceV3.dot")
	Local lHilton := MV_PAR04 == 1
	Local cAliasEE8 := GetNextAlias()
	Local cExp := ""
	Local cAnoExp := ""
	Local cSubExp := ""
	Local cPedido := ""
	Local cProduto := ""
	Local lFis45 := .F.
	Local cUserWord := GetMv("MGF_PROFWO")
	Local aDot			:= {GetMv("MGF_EEC211",,"ProformaInvoice.dot"),GetMv("MGF_EEC212",,"ProformaInvoiceV3.dot"),GetMv("MGF_EEC213",,"ProformainvoiceOff.dot")}
	//Empresa01, Empresa02, EmpresaOffshore

	Local cPicture	:= "@E 999,999,999.99"

	Private	hWord

	If cEmpAnt == "01"
		cPathDot		:= "C:\DOT\"+iif(lIncoterm,aDot[3],aDot[1])
	EndIf

	If !ExistDir("C:\DOT")
		If  !MakeDir("C:\DOT") == 0
			lRet := .f.
		EndIf
	EndIF
	If ExistDir("C:\DOT")
		If cEmpAnt == "01"
			If !FILE("C:\DOT\"+aDot[1])
				If FILE("\system\"+aDot[1])
					If !__CopyFile("\system\ProformaInvoice.dot","C:\DOT\"+aDot[1])
						MsgStop("Não foi possíveçl copiar o arquivo."+CRLF+" Favor contatar o administrador do sistema.")
						lRet := .f.
					EndIf
				Else
					MsgStop("Arquivo não encontrado no Servidor."+CRLF+" Favor contatar o administrador do sistema.")
					lRet := .f.
				EndIF
			EndIF
		Else
			If !FILE("C:\DOT\"+aDot[2])
				If FILE("\system\"+aDot[2])
					If !__CopyFile("\system\"+aDot[2],"C:\DOT\"+aDot[2])
						MsgStop("Não foi possível copiar o arquivo."+CRLF+" Favor contatar o administrador do sistema.")
						lRet := .f.
					EndIf
				Else
					MsgStop("Arquivo não encontrado no Servidor."+CRLF+" Favor contatar o administrador do sistema.")
					lRet := .f.
				EndIF
			EndIF
		EndIF
		If !FILE("C:\DOT\"+aDot[3])
			If FILE("\system\"+aDot[3])
				If !__CopyFile("\system\"+aDot[3],"C:\DOT\"+aDot[3])
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
		DbSelectArea("EE7")
		EE7->(dbSetOrder(1))
		DbSelectArea("EE8")
		EE8->(dbSetOrder(1))
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
		DbSelectArea("ZZS")
		ZZS->(DbSetOrder(1))
		DbSelectArea("EE2")
		EE2->(DbSetOrder(1))
		lRet := EE7->(DbSeek(xFilial("EE7")+cNumero))
		cExp := EE7->EE7_ZEXP
		cAnoExp := EE7->EE7_ZANOEX
		cSubExp := EE7->EE7_ZSUBEX
		If lHilton .and. Empty(cExp) .and. Empty(cAnoExp)
			MsgStop("Campo com número da 'EXP' não preenchido para este Pedido."+CRLF+;
			"Escolha impressão com parâmetro 'Hilton' = Nâo.")

			Return()
		Endif

		cPicture := iif(EE7->EE7_INTERM == "1","@E 999,999,999.999999",cPicture)

		//lRet := lRet .and. EE8->(DbSeek(xFilial("EE8")+cNumero))
		lRet := lRet .and. AliasEE8(cAliasEE8,lHilton,cExp,cAnoExp,cSubExp)

		nQtdCont 	:= GetContainers()
		If Empty(nQtdCont)
			nQtdCont := 1
		Endif

		If lRet
			EE8->(dbGoto((cAliasEE8)->EE8_RECNO))
			If lIncoterm .AND. EE7->EE7_INTERM == "1"
				SA1->(DbSeek(xFilial("SA1")+EE7->(EE7_CLIENT+EE7_CLLOJA)))
			Else
				SA1->(DbSeek(xFilial("SA1")+EE7->(EE7_IMPORT+EE7_IMLOJA)))
			EndIf
			If lIncoterm
				SA2->(DbSeek(xFilial("SA2")+EE7->(EE7_EXPORT+EE7_EXLOJA)))
			EndIf
			//			EE3->(DbSeek(xFilial("EE3")+"I"+ZB8->(PADR(ZB8_IMPORT,15)+ZB8_IMLOJA)))
			//SB1->(DbSeek(xFilial("SB1")+ ZB9->ZB9_COD_I))
			SYC->(DbSeek(xFilial("SYC")+ EE7->EE7_IDIOMA+alltrim(EE7->EE7_ZTPROD)))
			//			EEH->(DbSeek(xFilial("EEH")+ SYC->(YC_IDIOMA+YC_COD_RL) ) )
			//			SYJ->(DbSeek(xFilial("SYJ")+ ZB8->ZB8_INCOTE))
			//			SA6->(DbSeek(xFilial("SA6")+ SA1->A1_BCO1))
			SYQ->(DbSeek(xFilial("SYQ")+ EE7->EE7_VIA))
			SY5->(DbSeek(xFilial("SY5")+ EE7->EE7_ZARMAD))
			SY6->(DbSeek(xFilial("SY6")+ EE7->EE7_CONDPA))
			If lIncoterm
				EE2->(DbSeek(XFILIAL("EE2")+"2*"+EE7->(EE7_IDIOMA+EE7_COND2+STR(EE7_DIAS2,AVSX3("EE7_DIAS2",3)))  ))
			Else
				EE2->(DbSeek(XFILIAL("EE2")+"2*"+EE7->(EE7_IDIOMA+EE7_CONDPA+STR(EE7_DIASPA,AVSX3("EE7_DIASPA",3)))  ))
			EndIf
		EndIF

		If lRet
			WNumOrc 			:= EE7->EE7_PEDIDO
			WRef				:= EE7->EE7_REFIMP //ZB8->ZB8_ZREFER //CAMPO NOVO
			WTo					:= SA1->A1_NOME
			WDate				:= DTOC(EE7->EE7_DTPROC)
			WRevised			:= DTOC(EE7->EE7_ZREVIS) //CAMPO NOVO
			WAttention			:= IIF(lIncoterm,EE7->EE7_ZREFE2,EE7->EE7_ZCONT)
			WNotes				:= EE7->EE7_ZNOTES //CAMPO NOVO
			// ALTERACAO
			WSeller				:= Iif(lIncoterm,SA2->A2_NOME,SM0->M0_NOMECOM)
			//			WSeller				:= getSeller(lIncoterm, "M0_NOMECOM")
			//OLE_SetDocumentVar(hWord, 'WSeller', WSeller) //FILIAL DA ZB8 -> Se lIncoterm .T. -> 900001

			If !Empty(Alltrim(EE7->EE7_CONSIG)) .AND. !lIncoterm .AND. !EE7->EE7_INTERM == "1" //CASO TENHA CONSIGNATARIO PEGAR DADOS DELE
				lRet := SA1->(DbSeek(xFilial("SA1")+EE7->(EE7_CONSIG+EE7_COLOJA)))
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
			WMerchandise		:= iif(alltrim(SYC->YC_COD) == alltrim(EE7->EE7_ZTPROD),SYC->YC_NOME,"")
			WShippingMarks		:= MSMM(EE7->EE7_CODMAR,50) //EE7->EE7_MARCAC // VOLTAR CAMPO PARA VISUAL
			WSalesTerms			:= iif(lIncoterm,EE7->EE7_INCO2,EE7->EE7_INCOTE)
			WPaymentTerms		:= iIf(EE2->(Found()) .and. !Empty(Alltrim(MSMM(EE2->EE2_TEXTO,50))),MSMM(EE2->EE2_TEXTO,50),MSMM(SY6->Y6_DESC_P,50))
			WBank				:= iif(EE7->EE7_INTERM == "1" .AND. !lIncoterm,"",EE7->EE7_ZBANCO)
			WWeek				:= EE7->EE7_ZOBSWE  //CAMPO NOVO
			WVia				:= SYQ->YQ_DESCR
			WCarrier			:= EE7->EE7_ZNTRAN //CAMPO NOVO
			WAgency				:= iif(alltrim(SY5->Y5_COD) == alltrim(EE7->EE7_ZARMAD),SY5->Y5_NOME,"")//CAMPO NOVO
			lRet := SY9->(DbSeek(xFilial("SY9")+ EE7->EE7_ORIGEM))
			WPlaceOfCharge		:= SY9->Y9_DESCR
			lRet := SY9->(DbSeek(xFilial("SY9")+ EE7->EE7_DEST))
			WPlaceOfDischarge	:= GetAdvFVal("SYA","YA_PAIS_I",xFilial("SYA")+EE7->EE7_PAISET,1,"")
			WPlaceOfDischarge	:= Iif(Empty(WPlaceOfDischarge),GetAdvFVal("SYA","YA_DESCR",xFilial("SYA")+EE7->EE7_PAISET,1,""),WPlaceOfDischarge)
			WPlaceOfDischarge	:= SY9->Y9_DESCR  + " - "+ WPlaceOfDischarge
			WIsIT				:= iif(!Empty(EE7->EE7_ZINTER),"I/T:","")
			WIT					:= EE7->EE7_ZINTER//CAMPO NOVO
			SY5->(DbSeek(xFilial("SY5")+ EE7->EE7_ZAGENT))
			WAgent				:= iif(alltrim(SY5->Y5_COD) == alltrim(EE7->EE7_ZAGENT),SY5->Y5_NOME,"")
			WComission			:= Alltrim(Transform(EE7->EE7_VALCOM,"@E 999,999,999.99"))+iif(EE7->EE7_TIPCVL=="1"," %",iif(EE7->EE7_TIPCVL=="2"," % por item",""))
			WCompany			:= WSeller
			//WAddressCompany		:=
			WAddressCompany		:= iif(lIncoterm, allTrim(SA2->A2_END), allTrim(SM0->M0_ENDENT))
			WZipCode			:= iif(lIncoterm,""," - CEP "+SM0->M0_CEPENT)
			WPlaceCompany		:= " - "+iif(lIncoterm,iIf(ALLTRIM(SA2->A2_EST)<> "EX",allTrim(SA2->A2_MUN)+" - "+ALLTRIM(SA2->A2_EST),"UNITED KINGDOM - ENGLAND"),ALLTRIM(SM0->M0_CIDENT)+" - "+ALLTRIM(SM0->M0_ESTENT))
			WHasObs				:= iIf(lIndustria,"Obs:","") //Somente tem observação na industria
			WObservation		:=  iIf(lIndustria,EE7->EE7_ZOBSND,"")
			WCurrency			:= EE7->EE7_MOEDA

			EE2->(DbSeek(XFILIAL("EE2")+"8*"+EE7->EE7_IDIOMA+IIF(Empty(Alltrim(EE8->EE8_Z2UM)),EE8->EE8_UNIDAD,EE8->EE8_Z2UM) ) )
			WUnit				:= IIf(EE2->(Found()),EE2->EE2_DESCMA,"")

			While !(cAliasEE8)->(EOF()) //.AND. ALLTRIM(ZB8->(ZB8_EXP + ZB8_ANOEXP + ZB8_SUBEXP)) == ALLTRIM(ZB9->(ZB9_EXP + ZB9_ANOEXP + ZB9_SUBEXP))
				EE8->(dbGoto((cAliasEE8)->EE8_RECNO))
				cPedido := EE8->EE8_PEDIDO
				cProduto := EE8->EE8_COD_I
				lFis45 := !Empty(EE8->EE8_ZQTDSI)
				lRet := SB1->(DbSeek(xFilial("SB1")+ EE8->EE8_COD_I))
				lRet := lRet .and. ZZU->(DbSeek(xFilial("ZZU")+ SB1->B1_ZMARCA))
				If lRet
					cAPreco := iif(lIncoterm,EE8->EE8_PRENEG,iif(Empty(Alltrim(EE8->EE8_Z2UM)),EE8->EE8_PRECO,/*ZB9->ZB9_ZPR2UM*/EE8->EE8_ZPRECO))
					cAQtd	:= IIF(Empty(Alltrim(EE8->EE8_Z2UM)),EE8->EE8_SLDINI,/*ZB9->ZB9_ZQT2UM*/EE8->EE8_SLDINI)

					EE2->(DBGoTop())
					cDescProd := ""
					if EE2->( DBSeek( xFilial("EE2") + "3*" + EE7->EE7_IDIOMA + EE8->EE8_COD_I ) )
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

					aAdd(WItens,{EE8->EE8_COD_I, cDescProd, ZZU->ZZU_DESCRI,cAQtd*nQtdCont,cAPreco,cAQtd*cAPreco*nQtdCont})
				EndIf
				(cAliasEE8)->(DbSkip())
				EE8->(dbGoto((cAliasEE8)->EE8_RECNO))
				// tratamento para o GAP FIS45, onde ocorre a duplicacao do produto para um TES diferente
				If lRet .and. lFis45 .and. cPedido == EE8->EE8_PEDIDO .and. cProduto == EE8->EE8_COD_I .and. EE8->EE8_ZGERSI == "S"
					cAQtd += IIF(Empty(Alltrim(EE8->EE8_Z2UM)),EE8->EE8_SLDINI,/*ZB9->ZB9_ZQT2UM*/EE8->EE8_SLDINI)
					WItens[Len(WItens)][4] := cAQtd*nQtdCont
					WItens[Len(WItens)][6] := cAQtd*cAPreco*nQtdCont
					(cAliasEE8)->(DbSkip())
					EE8->(dbGoto((cAliasEE8)->EE8_RECNO))
				Endif
			ENDDO

			//Conecta ao word
			hWord	:= OLE_CreateLink()
			OLE_NewFile(hWord, cPathDot )
			If !__cUserId $ cUserWord
				OLE_SetProperty( hWord, "206", .F. ) //206 -OLEWDVISIBLE
			Else
				OLE_SetProperty( hWord, "206", .T. ) //206 -OLEWDVISIBLE
			Endif

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

			If !__cUserId $ cUserWord
				If !ExistDir("C:\TEMP")
					MakeDir("C:\TEMP")
				Endif
				OLE_SaveAsFile( hWord, "C:\TEMP\Proformainvoice_"+Alltrim(cNumero)+".pdf",'','',.F. , 17 ) // 17 - PDF
				OLE_CloseFile( hWord )
				OLE_CloseLink( hWord )
				ShellExecute( "Open", "Proformainvoice_"+Alltrim(cNumero)+".pdf", " ", "C:\TEMP\", 3 )
			Else
				If MsgYesNo("Fecha o Word e Corta o Link ?")
					OLE_CloseFile( hWord )
					OLE_CloseLink( hWord )
				Endif
			Endif
		Else
			MsgStop("Pedido de Exportação não encontrado.")
		EndIf
	EndIf

	SM0->(RestArea(aAreaSM0))

	If Select(cAliasEE8) > 0
		(cAliasEE8)->(dbCloseArea())
	Endif

Return()

Static Function GetContainers()

	Local cAliasEE7 := GetNextAlias()

	BeginSQL Alias cAliasEE7

	SELECT SUM(EE7.EE7_ZQTDCO) TOTAL
	FROM %table:EE7% EE7
	WHERE EE7.D_E_L_E_T_ = ' '
	AND EE7_FILIAL = %xFilial:EE7%
	AND EE7_PEDIDO = %Exp:EE7->EE7_PEDIDO%

	EndSQL

Return (cAliasEE7)->TOTAL

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


Static Function AliasEE8(cAliasEE8,lHilton,cExp,cAnoExp,cSubExp)

Local cQ := ""
Local lRet := .F.

cQ := "SELECT EE8.R_E_C_N_O_ EE8_RECNO "
cQ += "FROM "+RetSqlName("EE8")+" EE8 "
If lHilton
	cQ += "INNER JOIN "+RetSqlName("EE7")+" EE7 "
	cQ += "ON EE7_FILIAL = EE8_FILIAL "
	cQ += "AND EE7_PEDIDO = EE8_PEDIDO "
	cQ += "AND EE7.D_E_L_E_T_ = ' ' "
	cQ += "AND EE7_ZEXP = '"+cExp+"' "
	cQ += "AND EE7_ZANOEX = '"+cAnoExp+"' "
	cQ += "AND EE7_ZSUBEX = '"+cSubExp+"' "
Endif
cQ += "WHERE "
cQ += "EE8.D_E_L_E_T_ = ' ' "
cQ += "AND EE8_FILIAL = '"+EE7->EE7_FILIAL+"' "
If !lHilton
	cQ += "AND EE8_PEDIDO = '"+cNumero+"' "
	//cQ += "ORDER BY EE8_FILIAL,EE8_PEDIDO,EE8_SEQUEN "
	cQ += "ORDER BY EE8_FILIAL,EE8_PEDIDO,EE8_COD_I,EE8_SEQUEN " // obs: deixar nesta ordem para atender ao GAP FIS45
Else
	cQ += "ORDER BY EE8_FILIAL,EE8_PEDIDO,EE8_COD_I,EE8_SEQUEN "
Endif

cQ := ChangeQuery(cQ)
dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasEE8,.T.,.T.)

If (cAliasEE8)->(!Eof())
	lRet := .T.
Endif

Return(lRet)

