#Include "Protheus.ch"
#Include "rwmake.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} MGFEEC36
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MGFEEC36()

	Local aArea			:= GetArea()
	Local cPerg			:= PADR("MGFEEC36",10)
	local lPergEEC36	:= .F.
	Private cNumero := ""
	If IsInCallStack("U_MGFEEC19")

		cPerg := Padr(cPerg,Len(SX1->X1_GRUPO))

		dbSelectArea("SX1")
		SX1->(dbSetOrder(1))
		SX1->(DBGoTop())
		If SX1->(DBSeek(cPerg+"01"))

			RecLock("SX1", .F. )
			SX1->X1_CNT01 := ZZC->(ZZC_ORCAME)
			SX1->(MsUnlock())
		Endif

		Pergunte(cPerg, .F. )
		MV_PAR01	:= ZZC->(ZZC_ORCAME)

		lPergEEC36 := Pergunte(cPerg, .T. )
		cNumero := MV_PAR01
	Else
		lPergEEC36 := Pergunte(cPerg, .T. )
		cNumero := MV_PAR01
	EndIf



	if lPergEEC36
		oDlg := MSDialog():New(96, 012, 250, 400, OemToAnsi(OemToAnsi("Integracao com MS-Word")),,,,,,,,, .t. ,,,)
		TGroup():New(08,005,048,190,OemToAnsi(),, , , .t. )
		IW_Say(18,010,OemToAnsi("Impressao de Orçamento"),,,,, )

		SButton():New(56, 130, 1,{|| WordImp()},,)
		SButton():New(56, 160, 2,{|| oDlg:End()},,)

		oDlg:Activate(,,,.T.,, ,)
	endif

	RestArea(aArea)

return




User Function EEC36par()
	local lRet := .T.

	if MV_PAR01 <> ZB8->(ZB8_EXP + ZB8_ANOEXP + ZB8_SUBEXP)
		lRet := .F.
		MV_PAR01 := ZB8->(ZB8_EXP + ZB8_ANOEXP + ZB8_SUBEXP)
		Iif(FindFunction("APMsgAlert"), APMsgAlert("EXP do parâmetro é diferente da posicionada em tela.",), MsgAlert("EXP do parâmetro é diferente da posicionada em tela.",))
	endif
return lRet

Static Function WordImp()

	Local aAreaSM0 := SM0->(GetArea())
	Local WOrcamento, WTrader, WTrading, WContact, WDate, WRevised, WBuyer, WBuyerEnd, WBuyerCidade, WBuyerPais, WBuyerPais, WFamilia, WTipoProduto
	Local WSalesTerm, WPaymentTerms, WMoeda, WTipoVenda, WTipoTransporte, wTipoEmbarque, WTipoPagto, WEmbarque, WVenda, WProdutoEstoque, WGenset, WTemp
	Local WAprovaEtiqueta, WWeekDe, WWeekAte, WNotas, WPortoOrigem, WPortoDestino, WTransit, WShippingMarks, WBooking, WControle, WInspecao, WPaletizado
	Local WQualEmpresa, WArmador, WFrete, WMoeda2, WValor,WQtdContainer, WTotalPV, WImportador, WInvoice, WSanitario, WConsignee, WNotify, WBanco, WNotes
	Local WSeller, WCompany, WAddressCompany, WZipCode, WPlaceCompany, WMarca, WObservacao,WSArmador, WNArmador
	Local nTotQuant 	:= 0
	Local nTot			:= 0
	Local lRet			:= .t.
	Local nQtdCont 		:= 1


	Local aDot			:= {GetMV("MGF_EEC361",,"Orcamento.dot")}

	Local WItens := {}

	Local nK
	Local cDir			:= "C:\DOT\" +  Alltrim(GetEnvServer())
	Local cPathDot		:= cDir + "\" + aDot[1]
	Private	hWord

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

	If ExistDir(cDir)
		If !FILE(cDir+'\'+aDot[1])
			If FILE("\system\"+aDot[1])
				If !__CopyFile("\system\"+aDot[1],cDir+'\'+aDot[1])
					Iif(FindFunction("APMsgStop"), APMsgStop("Não foi possível copiar o arquivo."+Chr(13)+Chr(10)+" Favor contatar o administrador do sistema.",), MsgStop("Não foi possível copiar o arquivo."+Chr(13)+Chr(10)+" Favor contatar o administrador do sistema.",))
					lRet := .f.
				EndIf
			Else
				Iif(FindFunction("APMsgStop"), APMsgStop("Arquivo não encontrado no Servidor."+Chr(13)+Chr(10)+" Favor contatar o administrador do sistema.",), MsgStop("Arquivo não encontrado no Servidor."+Chr(13)+Chr(10)+" Favor contatar o administrador do sistema.",))
				lRet := .f.
			EndIF
		EndIF
	Else
		Iif(FindFunction("APMsgStop"), APMsgStop("Não foi possível criar pasta."+Chr(13)+Chr(10)+" Favor contatar o administrador do sistema.",), MsgStop("Não foi possível criar pasta."+Chr(13)+Chr(10)+" Favor contatar o administrador do sistema.",))
		lRet := .f.
	EndIF

	oDlg	:End()


	If lRet

		OpenSM0()
		DbSelectArea("SM0")
		SM0->(DbSetOrder(1))
		SM0->(DbSeek(cEmpAnt+cFilAnt))
		DbSelectArea("EE2")
		EE2->(DbSetOrder(1))
		DbSelectArea("ZZC")
		ZZC->(DbSetOrder(1))
		lRet := ZZC->(DbSeek(xFilial("ZZC")+cNumero))
		DbSelectArea("ZZD")
		ZZD->(DbSetOrder(1))
		lRet := lRet .and.  ZZD->(DbSeek(xFilial("ZZD")+cNumero))


		If lRet
			WOrcamento		:= ZZC->ZZC_ORCAME
			WTrader			:= GetAdvFVal("SA3","A3_NOME",xFilial("SA3")+ZZC->ZZC_ZTRADE,1,"")
			WTrading		:= GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+ZZC->ZZC_ZTRADI+ZZC->ZZC_ZLJTRA,1,"")
			WContact		:= ZZC->ZZC_ZCONT
			WDate			:= DTOC(ZZC->ZZC_DTPROC)
			WRevised		:= DTOC(ZZC->ZZC_ZREVIS)
			WBuyer			:= ZZC->ZZC_ZBUYER + " - "+ GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+ZZC->ZZC_ZBUYER+ZZC->ZZC_ZBUYLJ,1,"")
			WBuyerEnd  		:= Alltrim(GetAdvFVal("SA1","A1_END",xFilial("SA1")+ZZC->ZZC_ZBUYER+ZZC->ZZC_ZBUYLJ,1,""))
			WBuyerEnd  		+= " - " + Alltrim(GetAdvFVal("SA1","A1_COMPLEM",xFilial("SA1")+ZZC->ZZC_ZBUYER+ZZC->ZZC_ZBUYLJ,1,""))
			WBuyerCidade  	:= GetAdvFVal("SA1","A1_MUN",xFilial("SA1")+ZZC->ZZC_ZBUYER+ZZC->ZZC_ZBUYLJ,1,"")
			WBuyerCidade  	:= Iif(Alltrim(WBuyerCidade) <> "EX",WBuyerCidade,"")
			WBuyerPais  	:= GetAdvFVal("SA1","A1_PAIS",xFilial("SA1")+ZZC->ZZC_ZBUYER+ZZC->ZZC_ZBUYLJ,1,"")
			WBuyerPais  	:= GetAdvFVal("SYA","YA_PAIS_I",xFilial("SYA")+WBuyerPais,1,WBuyerPais)
			WBuyerPais  	:= Iif(Empty(Alltrim(WBuyerPais)),GetAdvFVal("SYA","YA_DESCR",xFilial("SYA")+WBuyerPais,1,""),WBuyerPais)

			WFamilia    	:= GetAdvFVal("EEH","EEH_NOME",xFilial("EEH")+ZZC->(ZZC_IDIOMA+ZZC_ZFAMIL),1,"")
			WTipoProduto  	:= GetAdvFVal("SYC","YC_NOME",xFilial("SYC")+ZZC->ZZC_ZTPROD,1,"")
			WSalesTerm    	:= ZZC->ZZC_INCOTE
			WTemp    			:= Alltrim(ZZC->ZZC_ZTEMPE) + IIF( AT("ºC", ZZC->ZZC_ZTEMPE) > 0  .Or. AT("DRY", ZZC->ZZC_ZTEMPE) > 0 , "" , "ºC" ) 

			EE2->(DbSeek(XFILIAL("EE2")+"2*"+ZZC->(ZZC_IDIOMA+ZZC_CONDPA+STR(ZZC_DIASPA,AVSX3("ZZC_DIASPA",3)))  ))

			If Alltrim(EE2->EE2_COD) == ZZC->ZZC_CONDPA+Str(ZZC->ZZC_DIASPA,3)
				WPaymentTerms		:= iIf(!Empty(Alltrim(MSMM(EE2->EE2_TEXTO,50))),MSMM(EE2->EE2_TEXTO,50),MSMM(SY6->Y6_DESC_P,50))
			Else
				WPaymentTerms		:= iIf(!Empty(Alltrim(MSMM(SY6->Y6_DESC_I,50))),MSMM(SY6->Y6_DESC_I,50),MSMM(SY6->Y6_DESC_P,50))
			EndIf

			WMoeda		  	:= ZZC->ZZC_MOEDA
			WTipoVenda  	:= iif(ZZC->ZZC_ZTPVEN=="1","DIRETA",iif(ZZC->ZZC_ZTPVEN=="2","EQUIPARADA",""))
			WTipoTransporte := GetAdvFVal("SYQ","YQ_DESCR",xFilial("SYQ")+ZZC->ZZC_VIA,1,"")
			wTipoEmbarque   := GetAdvFVal("EYG","EYG_DESCON",xFilial("EYG")+ZZC->ZZC_ZCONTA,1,"")
			WTipoPagto		:= iif(ZZC->ZZC_FRPPCC=="CC","COLLECT",iif(ZZC->ZZC_FRPPCC=="PP","PREPAID",""))
			WEmbarque  		:= iif(ZZC->ZZC_ZEDCLI=="1","POR SEMANA",iif(ZZC->ZZC_ZEDCLI=="2","POR QUINZENA",iif(ZZC->ZZC_ZEDCLI=="3","POR MÊS","")))
			WVenda    		:= iif(ZZC->ZZC_ZHILTO=="1","HILTON","NÃO HILTON")
			WProdutoEstoque	:= iif(ZZC->ZZC_ZESTVE=="1","SIM","NÃO")
			WGenset			:= iif(ZZC->ZZC_ZGENSE=="1","SIM","NÃO")
			WAprovaEtiqueta	:= iif(ZZC->ZZC_ZETIQU=="1","SIM","NÃO")
			WWeekDe  		:= ZZC->ZZC_ZWEEKD
			WWeekAte  		:= ZZC->ZZC_ZWEEKA
			WNotas  		:= ZZC->ZZC_ZOBSWE

			WPortoOrigem	:= GetAdvFVal("SY9","Y9_DESCR",xFilial("SY9")+ZZC->ZZC_ORIGEM,2,"")
			WPortoOrigem	+= " - " + GetAdvFVal("SYA","YA_PAIS_I",xFilial("SYA")+GetAdvFVal("SY9","Y9_PAIS",xFilial("SY9")+ZZC->ZZC_ORIGEM,2,""),1,"")
			WPortoDestino	:= GetAdvFVal("SY9","Y9_DESCR",xFilial("SY9")+ZZC->ZZC_DEST,2,"")
			WPortoDestino	+= " - " + GetAdvFVal("SYA","YA_PAIS_I",xFilial("SYA")+GetAdvFVal("SY9","Y9_PAIS",xFilial("SY9")+ZZC->ZZC_DEST,2,""),1,"")
			WTransit		:= GetAdvFVal("SYA","YA_DESCR",xFilial("SYA")+ZZC->ZZC_ZCINTE,1,"")

			WShippingMarks	:= ZZC->ZZC_MARCAC
			WBooking  		:= iif(ZZC->ZZC_ZBOOKI=="1","CLIENTE",iif(ZZC->ZZC_ZBOOKI=="2","MARFRIG",iif(ZZC->ZZC_ZBOOKI=="3","MARFRIG O/B WESTON","")))
			WControle		:= iif(ZZC->ZZC_ZQUALI=="1","SIM",iif(ZZC->ZZC_ZQUALI=="2","NÃO",""))
			WInspecao		:= iif(ZZC->ZZC_ZINSPE=="1","SIM",iif(ZZC->ZZC_ZINSPE=="2","NÃO",""))
			WPaletizado		:= iif(ZZC->ZZC_ZCARGA=="1","SIM",iif(ZZC->ZZC_ZCARGA=="2","NÃO",""))
			WQualEmpresa	:= IIF(WInspecao == "SIM",GetAdvFVal("SY5","Y5_NOME",xFilial("SY5")+ZZC->ZZC_ZEMPIN,1,""),"")
			WArmador		:= GetAdvFVal("SY5","Y5_NOME",xFilial("SY5")+ZZC->ZZC_ZARMAD,1,"")
			WSArmador		:= IIF(!Empty(Alltrim(ZZC->ZZC_ZOBSPR)),"Obs.Log INTL:","")
			WNArmador		:= IIF(!Empty(Alltrim(ZZC->ZZC_ZOBSPR)),ZZC->ZZC_ZOBSPR,ZZC->ZZC_ZOBSPR)
			WFrete    		:= ""
			WMoeda2    		:= ZZC->ZZC_ZMOEFR + "/" + iif(ZZC->ZZC_ZTPFRE=="1","TON",iif(ZZC->ZZC_ZTPFRE=="2","FCL",""))
			WValor    		:= 0

			WQtdContainer	:= ZZC->ZZC_ZQTDCO

			WImportador  	:= GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+ZZC->ZZC_ZIMPNF+ZZC->ZZC_ZIMPLJ,1,"")
			WInvoice	  	:= GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+ZZC->ZZC_ZIMPIN+ZZC->ZZC_ZINVLJ,1,"")
			WSanitario    	:= GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+ZZC->ZZC_ZIMSAN+ZZC->ZZC_ZLJSAN,1,"")

			WConsignee   	:= GetAdvFVal("SA1","A1_NOME",XFILIAL("SA1")+ZZC->ZZC_CONSIG+ZZC->ZZC_COLOJA,1,"")
			WNotify		   	:= GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+ZZC->ZZC_ZNOTIF+ZZC->ZZC_ZLJNOT,1,"")
			WBanco		   	:= ZZC->ZZC_ZBANCO

			WNotes		   	:= ZZC->ZZC_ZOBSND


			WSeller				:= SM0->M0_NOMECOM
			WCompany			:= WSeller
			WAddressCompany		:= allTrim(SM0->M0_ENDENT)
			WZipCode			:= +SM0->M0_CEPENT
			WPlaceCompany		:= " - "+ALLTRIM(SM0->M0_CIDENT)+" - "+ALLTRIM(SM0->M0_ESTENT)
			WObservacao  		:= ""
			WUM					:= ZZD->ZZD_UNIDAD


			While !ZZD->(EOF()) .AND.  ALLTRIM(ZZC->(ZZC_ORCAME)) == ALLTRIM(ZZD->(ZZD_ORCAME)) .AND.  ZZC->ZZC_FILIAL == ZZD->ZZD_FILIAL
				lRet := SB1->(DbSeek(xFilial("SB1")+ ZZD->ZZD_COD_I))
				WMarca := GetAdvFVal("ZZU","ZZU_DESCRI",xFilial("ZZU")+ ZZD->ZZD_ZCMARC,1,"")
				If lRet
					cAPreco := iif(Empty(Alltrim(ZZD->ZZD_Z2UM)),ZZD->ZZD_ZPRECO,ZZD->ZZD_ZPR2UM)
					cAQtd	:= IIF(Empty(Alltrim(ZZD->ZZD_Z2UM)),ZZD->ZZD_SLDINI,ZZD->ZZD_ZQT2UM)

					EE2->(DBGoTop())
					cDescProd := ""
					if EE2->( DBSeek( xFilial("EE2") + "3*" + ZZC->ZZC_IDIOMA + ZZD->ZZD_COD_I ) )
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


					aAdd(WItens,{ZZD->ZZD_COD_I, cDescProd, ZZD->ZZD_ZVLDPR,WMarca,ZZD->ZZD_UNIDAD,IIF(ZZD->ZZD_ZHILTO=="1","HILTON","NÃO HILTON"), cAQtd*nQtdCont,cAPreco,cAQtd*cAPreco*nQtdCont, "KIT"})

				EndIf
				ZZD->(DbSkip())
			ENDDO


			hWord	:= OLE_CreateLink()
			OLE_NewFile(hWord, cPathDot )
			OLE_SetProperty( hWord, "206", .T.  )


			OLE_SetDocumentVar(hWord, "WOrcamento"		,WOrcamento			)
			OLE_SetDocumentVar(hWord, "WTrader"			,WTrader			)
			OLE_SetDocumentVar(hWord, "WTrading"		,WTrading		    )
			OLE_SetDocumentVar(hWord, "WContact"		,WContact		    )
			OLE_SetDocumentVar(hWord, "WDate"			,WDate			    )
			OLE_SetDocumentVar(hWord, "WRevised"		,WRevised		    )
			OLE_SetDocumentVar(hWord, "WBuyer"			,WBuyer				)
			OLE_SetDocumentVar(hWord, "WBuyerEnd"		,WBuyerEnd  		)
			OLE_SetDocumentVar(hWord, "WBuyerCidade"	,WBuyerCidade  		)
			OLE_SetDocumentVar(hWord, "WBuyerPais"		,WBuyerPais  	    )
			OLE_SetDocumentVar(hWord, "WFamilia"		,WFamilia    	    )
			OLE_SetDocumentVar(hWord, 'WTemp'			,WTemp    	    )
			OLE_SetDocumentVar(hWord, "WTipoProduto"	,WTipoProduto  		)
			OLE_SetDocumentVar(hWord, "WSalesTerm"		,WSalesTerm    		)
			OLE_SetDocumentVar(hWord, "WPaymentTerms"	,WPaymentTerms  	)
			OLE_SetDocumentVar(hWord, "WMoeda"			,WMoeda		  		)
			OLE_SetDocumentVar(hWord, "WTipoVenda"		,WTipoVenda  	    )
			OLE_SetDocumentVar(hWord, "WTipoTransporte"	,WTipoTransporte   	)
			OLE_SetDocumentVar(hWord, "wTipoEmbarque"	,wTipoEmbarque     	)
			OLE_SetDocumentVar(hWord, "WTipoPagto"		,WTipoPagto			)
			OLE_SetDocumentVar(hWord, "WEmbarque"		,WEmbarque  		)
			OLE_SetDocumentVar(hWord, "WVenda"			,WVenda    			)
			OLE_SetDocumentVar(hWord, "WProdutoEstoque"	,WProdutoEstoque	)
			OLE_SetDocumentVar(hWord, "WGenset"			,WGenset			)
			OLE_SetDocumentVar(hWord, "WAprovaEtiqueta"	,WAprovaEtiqueta	)
			OLE_SetDocumentVar(hWord, "WWeekDe"			,WWeekDe  		    )
			OLE_SetDocumentVar(hWord, "WWeekAte"		,WWeekAte	  		)
			OLE_SetDocumentVar(hWord, "WNotas"			,WNotas  		    )
			OLE_SetDocumentVar(hWord, "WPortoOrigem"	,WPortoOrigem	    )
			OLE_SetDocumentVar(hWord, "WPortoDestino"	,WPortoDestino	    )
			OLE_SetDocumentVar(hWord, "WTransit"		,WTransit		    )
			OLE_SetDocumentVar(hWord, "WShippingMarks"	,WShippingMarks		)
			OLE_SetDocumentVar(hWord, "WBooking"		,WBooking 	 		)
			OLE_SetDocumentVar(hWord, "WControle"		,WControle		    )
			OLE_SetDocumentVar(hWord, "WInspecao"		,WInspecao		    )
			OLE_SetDocumentVar(hWord, "WPaletizado"		,WPaletizado		)
			OLE_SetDocumentVar(hWord, "WQualEmpresa"	,WQualEmpresa	    )
			OLE_SetDocumentVar(hWord, "WArmador"		,WArmador		    )
			OLE_SetDocumentVar(hWord, "WFrete"			,WFrete 	   		)
			OLE_SetDocumentVar(hWord, "WMoeda2"			,WMoeda2    		)
			OLE_SetDocumentVar(hWord, "WValor"			,WValor    			)
			OLE_SetDocumentVar(hWord, "WQtdContainer"	,WQtdContainer	    )
			OLE_SetDocumentVar(hWord, "WImportador"		,WImportador  	    )
			OLE_SetDocumentVar(hWord, "WInvoice"		,WInvoice	  	    )
			OLE_SetDocumentVar(hWord, "WSanitario"		,WSanitario 	   	)
			OLE_SetDocumentVar(hWord, "WConsignee"		,WConsignee   	    )
			OLE_SetDocumentVar(hWord, "WNotify"			,WNotify		   	)
			OLE_SetDocumentVar(hWord, "WBanco"			,WBanco			   	)
			OLE_SetDocumentVar(hWord, "WNotes"			,WNotes			   	)
			OLE_SetDocumentVar(hWord, "WSeller"			,WSeller			)
			OLE_SetDocumentVar(hWord, "WCompany"		,WCompany		    )
			OLE_SetDocumentVar(hWord, "WAddressCompany"	,WAddressCompany	)
			OLE_SetDocumentVar(hWord, "WZipCode"		,WZipCode		    )
			OLE_SetDocumentVar(hWord, "WPlaceCompany"	,WPlaceCompany	    )
			OLE_SetDocumentVar(hWord, "WObservacao"		,WObservacao	    )
			OLE_SetDocumentVar(hWord, "WSArmador"		,WSArmador	    	)
			OLE_SetDocumentVar(hWord, "WNArmador"		,WNArmador	    	)
			OLE_SetDocumentVar(hWord, "WUM"				,WUM	   			)


			OLE_SetDocumentVar(hWord, "Prt_nroitens",str(Len(WItens)))



			for nK := 1 to Len(WItens)
				OLE_SetDocumentVar(hWord,"WCode"+AllTrim(Str(nK)),WItens[nK][1])
				OLE_SetDocumentVar(hWord,"WDescription"+AllTrim(Str(nK)),WItens[nK][2])
				OLE_SetDocumentVar(hWord,"WValidade"+AllTrim(Str(nK)),WItens[nK][3])
				OLE_SetDocumentVar(hWord,"WBrand"+AllTrim(Str(nK)),WItens[nK][4])
				OLE_SetDocumentVar(hWord,"WUnidade"+AllTrim(Str(nK)),WItens[nK][5])
				OLE_SetDocumentVar(hWord,"WTipo"+AllTrim(Str(nK)),WItens[nK][6])
				OLE_SetDocumentVar(hWord,"WQuantity"+AllTrim(Str(nK)), Transform(WItens[nK][7],"@E 999,999,999.99"))
				OLE_SetDocumentVar(hWord,"WPrice"+AllTrim(Str(nK)), Transform(WItens[nK][8],"@E 999,999,999.99"))
				OLE_SetDocumentVar(hWord,"WTotal"+AllTrim(Str(nK)), Transform(WItens[nK][9],"@E 999,999,999.99"))
				OLE_SetDocumentVar(hWord,"WKit"+AllTrim(Str(nK)), WItens[nK][10])

				nTotQuant += WItens[nK][7]
				nTot	+= WItens[nK][9]
			next
			WTotalPV  := nTotQuant * WQtdContainer
			OLE_SetDocumentVar(hWord, "WTotalPV"		,Transform(WTotalPV,"@E 999,999,999.99") 	 		)

			OLE_ExecuteMacro(hWord,"tabitens")

			OLE_SetDocumentVar(hWord, "WQuantity", Transform(nTotQuant,"@E 999,999,999.99"))
			OLE_SetDocumentVar(hWord, "WTotal", Transform(nTot,"@E 999,999,999.99"))


			OLE_UpdateFields(hWord)






			If Iif(FindFunction("APMsgYesNo"), APMsgYesNo("Fecha o Word e Corta o Link ?",), (cMsgYesNo:="MsgYesNo", &cMsgYesNo.("Fecha o Word e Corta o Link ?",)))
				OLE_CloseFile( hWord )
				OLE_CloseLink( hWord )
			Endif


		Else
			Iif(FindFunction("APMsgStop"), APMsgStop("Orçamento não encontrada",), MsgStop("Orçamento não encontrada",))
		EndIf
	EndIf

	SM0->(RestArea(aAreaSM0))
Return()

Static Function GetContainers()

	Local cAliasZB8 := GetNextAlias()










	__execSql(cAliasZB8," SELECT SUM(ZB8.ZB8_ZQTDCO) TOTAL FROM  "+RetSqlName('ZB8')+" ZB8 WHERE ZB8.D_E_L_E_T_ = ' ' AND ZB8_FILIAL =  '" +xFilial('ZB8')+"'  AND ZB8_EXP =  "+___SQLGetValue(ZB8->ZB8_EXP)+" AND ZB8_ANOEXP =  "+___SQLGetValue(ZB8->ZB8_ANOEXP),{},.F.)



Return (cAliasZB8)->TOTAL


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

	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQrySysCom), "QRYSYSCOMP" , .F. , .T. )

	if !QRYSYSCOMP->(EOF())
		cRetSM0 := &("QRYSYSCOMP->" + cFieldSM0)
	endif

	QRYSYSCOMP->(DBCloseArea())
return cRetSM0
