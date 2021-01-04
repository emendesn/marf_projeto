#include 'protheus.ch'
#include "rwmake.ch"

/*/{Protheus.doc} MGFEEC28
//TODO Programa para gerar a Packing List
@author leonardo.kume
@since 31/05/2017
@version 6

@type function
/*/
user function MGFEEC28()

Local aArea 	 := GetArea()
Local cPerg      := "MGFEEC28"
Local nPallet    := 0
Private cNumero	 := EEC->(EEC_PREEMB)
Private c_Filtro := "%EEC.EEC_STATUS <> '*'%"


If Pergunte(cPerg,.t.)
	nPallet := MV_PAR01
	WordImp(nPallet)
EndIf


//@ 96,012 TO 250,400 DIALOG oDlg TITLE OemToAnsi("Integracao com MS-Word")
//@ 08,005 TO 048,190
//@ 12,010 SAY OemToAnsi("Caso tenha peso de Pallet, digite abaixo:")
//@ 22,010 MSGET nPallet     SIZE  90,10 OF oDlg PIXEL PICTURE '999,999.999999'

//@ 56,130 BMPBUTTON TYPE 1 ACTION WordImp()
//@ 56,160 BMPBUTTON TYPE 2 ACTION Close(oDlg)

//ACTIVATE DIALOG oDlg CENTERED

RestArea(aArea)

return

Static Function WordImp(nPallet)

Local WNumOrc, WEXP, WRef, WDate, WImporter, WImportAddress, WImpCity, WCountryPort, WImpCountry, WPlaceOfShipment
Local WPlaceOfDischarge, WStuffingDate, WContainer, WSeal, WProductionDate
Local WCompany, WAddressCompany, WZipCode, WPlaceCompany, WDescrType
Local WUnit,WUnit2
Local nTQuantity 	:= 0
Local nTNetWeight 	:= 0
Local nTGrossWeight	:= 0
Local nTBundles		:= 0
Local lRet			:= .t.
Local cAliasZZR 	:= GetNextAlias()
Local cAliasEE8		:= GetNextAlias()
Local cAliasEE9		:= GetNextAlias()
Local cProduto 		:= ""
Local nProduto 		:= 0
Local cDescProd 	:= ""
Local lBundles		:= .f.

Local WItens := {}
Local aPedidos := {}

Local cNumPed 	:= ""
Local cTipoPed 	:= ""
Local lSemTaura	:= .f.
Local cArquivo		:= iif(Substr(cFilAnt,2,1)=='1',GetMV("MGF_EEC471",,"PackingList2.dot"),GetMV("MGF_EEC472",,"PackingList2.dot"))
Local cPicture		:= iif(Substr(cFilAnt,2,1)=='1',"@E 999,999,999.999","@E 999,999,999.999999")
Local cBundles		:= iif(Substr(cFilAnt,2,1)=='1',GetMV("MGF_EEC473",,"PackingListBundles01.dot"),GetMV("MGF_EEC474",,"PackingListBundles02.dot"))
Local lPDF		 	:= ! RetCodUsr() $ GetMv("MGF_PROFWO",,"")

Local WItens := {}

Local nK		:= 0
Local cPathDot	:= "C:\DOT\"+cArquivo
Private	hWord	:= nil

If !ExistDir("C:\DOT")
	If  !MakeDir("C:\DOT") == 0
		lRet := .f.
	EndIf
EndIF
If !ExistDir("C:\DOT\PDF")
	If  !MakeDir("C:\DOT\PDF") == 0
		lRet := .f.
	EndIf
EndIF
If ExistDir("C:\DOT")
	If !FILE("C:\DOT\"+cArquivo)
		If FILE("\system\"+cArquivo)
			If !__CopyFile("\system\"+cArquivo,"C:\DOT\"+cArquivo)
				MsgStop("Não foi possível copiar o arquivo."+CRLF+" Favor contatar o administrador do sistema.")
				lRet := .f.
			EndIf
		Else
			MsgStop("Arquivo não encontrado no Servidor."+CRLF+" Favor contatar o administrador do sistema.")
			lRet := .f.
		EndIF
	EndIF
	If !FILE("C:\DOT\"+cBundles)
		If FILE("\system\"+cBundles)
			If !__CopyFile("\system\"+cBundles,"C:\DOT\"+cBundles)
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

//Close(oDlg)

If lRet
	//Alimentando valores para atualizar o documento Word
	OpenSM0()
	DbSelectArea("EEC")
	EEC->(DbSetOrder(1))
	DbSelectArea("EE9")
	EE9->(DbSetOrder(2))
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	DbSelectArea("EX9")
	EX9->(DbSetOrder(1))
	DbSelectArea("SB1")
	SYQ->(DbSetOrder(1))
	DbSelectArea("SY9")
	SY9->(DbSetOrder(2))
	DbSelectArea("ZZR")
	ZZR->(DbSetOrder(1))
	DbSelectArea("EEG")
	EEG->(DbSetOrder(1))
	DbSelectArea("EEH")
	EEH->(DbSetOrder(1))
	DbSelectArea("SYC")
	SYC->(DbSetOrder(4))
	lRet := EEC->(DbSeek(xFilial("EEC")+cNumero))
	lRet := lRet .and. EE9->(DbSeek(xFilial("EE9")+cNumero))


	cNumPed 	:= GetAdvFVal("EE7","EE7_PEDFAT",xFilial("EE7")+EEC->EEC_PEDREF,1,"")
	cTipoPed 	:= GetAdvFVal("EE7","EE7_ZTIPPE",xFilial("EE7")+EEC->EEC_PEDREF,1,"")
	cTipoPed 	:= GetAdvFVal("SZJ","ZJ_TAURA",xFilial("SZJ")+cTipoPed,1,"")
	lSemTaura	:= cTipoPed == "N"

	If lSemTaura
		DbSelectArea("ZDW")
		ZDW->(DbSetOrder(1))
		ZDW->(Dbseek(xFilial("ZDW")+cNumPed))
		DbSelectArea("ZDX")
		ZDX->(DbSetOrder(1))
		ZDX->(Dbseek(xFilial("ZDX")+cNumPed))
	EndIf

	If lRet
		If MV_PAR02 == 1 .AND. EEC->EEC_INTERM == '1'
			SA1->(DbSeek(xFilial("SA1")+EEC->(EEC_CLIENT+EEC_CLLOJA)))
		Else
			SA1->(DbSeek(xFilial("SA1")+EEC->(EEC_IMPORT+EEC_IMLOJA)))
		EndIf
		EX9->(DbSeek(xFilial("EX9")+cNumero))
		SYQ->(DbSeek(xFilial("SYQ")+ EEC->EEC_VIA))
	EndIF

	If lRet
		WEXP	 			:= EEC->(Alltrim(EEC_ZEXP) + '/' + EEC_ZANOEX + IIF(!Empty(EEC_ZSUBEX),"-" + EEC_ZSUBEX ,"" ))
		WRef				:= EEC->EEC_REFIMP
		WDate				:= STR(DAY(dDatabase),2,0) + " " + Substr(cMonth(dDatabase),1,3) + " " + STR(Year(dDatabase),4,0)
		WImporter  			:= SA1->A1_NOME
		WImportAddress  	:= SA1->A1_END
		WImpCity  			:= IIF("EXTERIOR"$Alltrim(SA1->A1_MUN),"",Alltrim(SA1->A1_MUN))
		WCountryPort		:= GetAdvFVal("SYA","YA_DESCR",xFilial("SYA")+SA1->A1_PAIS,1,"")
		WImpCountry  		:= GetAdvFVal("SYA","YA_PAIS_I",xFilial("SYA")+SA1->A1_PAIS,1,"")
		WImpCountry  		:= iIf(!Empty(Alltrim(WImpCountry  )),WImpCountry ,WCountryPort)

		lRet := SY9->(DbSeek(xFilial("SY9")+ EEC->EEC_ORIGEM))
		WPlaceOfShipment  		:= Alltrim(SY9->Y9_DESCR) + ', '
		WPlaceOfShipment		+= GetAdvFVal("SYA","YA_NOIDIOM",xFilial("SYA")+SY9->Y9_PAIS,1,"")
		lRet := SY9->(DbSeek(xFilial("SY9")+ EEC->EEC_DEST))
		WPlaceOfDischarge		:= Alltrim(SY9->Y9_DESCR) + ', '
		WPlaceOfDischarge		+= GetAdvFVal("SYA","YA_NOIDIOM",xFilial("SYA")+SY9->Y9_PAIS,1,"")

		WVia				:= SYQ->YQ_DESCR

		EE2->(DbSeek(XFILIAL("EE2")+"6*"+EEC->EEC_IDIOMA+EE9->EE9_EMBAL1 ) )
		WUnit				:= MSMM(EE2->EE2_TEXTO,50)
		EE2->(DbSeek(XFILIAL("EE2")+"8*"+EEC->EEC_IDIOMA+EE9->EE9_UNIDAD  ) )
		WUnit2				:= "KG"//IIF(!Empty(Alltrim(WUnit2)),WUnit2,EE9->EE9_UNIDAD)

		WDescrType := ""
		SYC->(DbSeek(xFilial("SYC")+ EEC->EEC_VIA))

		If SYC->(DbSeek(xFilial("SYC")+EEC->EEC_IDIOMA+EEC->EEC_ZTPROD))
			WDescrType	+= SYC->YC_NOME + CRLF
		EndIf

		WDescrType -= CRLF

		If Alltrim(EEC->EEC_ZTPROD) == "04"
			lBundles := .t.
		EndIf

		aPedidos := EEC28B(EEC->EEC_ZEXP,EEC->EEC_ZSUBEX,EEC->EEC_ZANOEX)

		For nK := 1 to Len(aPedidos)
			If !lSemTaura
				If ZZR->(DbSeek(XFILIAL("ZZR")+PADR(aPedidos[nK],20)  ) )

					WStuffingDate  		:= STR(DAY(ZZR->ZZR_DTESTU),2,0) + " " + Substr(cMonth(ZZR->ZZR_DTESTU),1,3) + " " + STR(Year(ZZR->ZZR_DTESTU),4,0)
					While !ZZR->(EOF()) .AND. ALLTRIM(ZZR->(ZZR_PEDIDO)) == ALLTRIM(aPedidos[nK]) .AND. ZZR->ZZR_FILIAL == xFilial("ZZR")
						cProduto	:= GetAdvFVal("SC6","C6_PRODUTO",xFilial("SC6")+ZZR->(PADR(ZZR_PEDIDO,6)+PADR(ZZR_ITEM,2)) ,1,"" )
						nProduto	:= aScan(WItens,{|x| Alltrim(x[1]) == Alltrim(cProduto)})
						lRet 		:= SB1->(DbSeek(xFilial("SB1")+ cProduto ))

						cDescProd := ""
						if EE2->( DBSeek( xFilial("EE2") + "3*" + EEC->EEC_IDIOMA + cProduto ) )
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
						If lRet
							If nProduto > 0
								WItens[nProduto][3]	+= ZZR->ZZR_TOTCAI
								WItens[nProduto][4]	+= ZZR->ZZR_PESOL
								WItens[nProduto][5]	+= ZZR->ZZR_PESOB
							Else
								aAdd(WItens,{cProduto,cDescProd,ZZR->ZZR_TOTCAI,ZZR->ZZR_PESOL,ZZR->ZZR_PESOB, ZZR->ZZR_ITEM })
							EndIf
						EndIf
						ZZR->(DbSkip())
					EndDo

					if lBundles
						EEC28D(EEC->EEC_ZEXP,EEC->EEC_ZANOEX,EEC->EEC_ZSUBEX,cAliasEE8)

						While !(cAliasEE8)->(EOF())
							nI := AScan(wItens, {|x| Alltrim(x[1]) == Alltrim((cAliasEE8)->EE8_COD_I)})
							If nI > 0
								aAdd(wItens[nI],(cAliasEE8)->EE8_SLDINI)
							EndIf
							(cAliasEE8)->(DbSkip())
						EndDo
					EndIf
				EndIf
			Else
				If ZDW->(DbSeek(XFILIAL("ZDW")+PADR(aPedidos[nK],20)  ) )

					WStuffingDate  		:= STR(DAY(ZDW->ZDW_DTESTU),2,0) + " " + Substr(cMonth(ZDW->ZDW_DTESTU),1,3) + " " + STR(Year(ZDW->ZDW_DTESTU),4,0)
					While !ZDW->(EOF()) .AND. ALLTRIM(ZDW->(ZDW_PEDIDO)) == ALLTRIM(aPedidos[nK]) .AND. ZDW->ZDW_FILIAL == xFilial("ZDW")
						cProduto	:= GetAdvFVal("SC6","C6_PRODUTO",xFilial("SC6")+ZDW->(PADR(ZDW_PEDIDO,6)+PADR(ZDW_ITEM,2)) ,1,"" )
						nProduto	:= aScan(WItens,{|x| Alltrim(x[1]) == Alltrim(cProduto)})
						lRet 		:= SB1->(DbSeek(xFilial("SB1")+ cProduto ))
						cDescProd := ""
						if EE2->( DBSeek( xFilial("EE2") + "3*" + EEC->EEC_IDIOMA + cProduto ) )
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
						If lRet
							If nProduto > 0
								WItens[nProduto][3]	+= ZDW->ZDW_TOTCAI
								WItens[nProduto][4]	+= ZDW->ZDW_PSLQUN
								WItens[nProduto][5]	+= ZDW->ZDW_PSBRUN
							Else
								aAdd(WItens,{cProduto,cDescProd,ZDW->ZDW_TOTCAI,ZDW->ZDW_PSLQUN,ZDW->ZDW_PSBRUN})
							EndIf
						EndIf
						ZDW->(DbSkip())
					EndDo
				EndIf
			EndIf
		Next nK
		If Len(wItens) == 0 .or. (Len(wItens) > 0 .and. WItens[1][4] == 0)
			wItens := {}
			If Empty(WStuffingDate)

				WStuffingDate  		:= STR(DAY(EX9->EX9_DTPREV),2,0) + " " + Substr(cMonth(EX9->EX9_DTPREV),1,3) + " " + STR(Year(EX9->EX9_DTPREV),4,0)
				MsgAlert("Dados de Data de estufagem e Itens não atualizados com o Taura, virá a informação do Embarque")
			Else
				MsgAlert("Dados de Itens não atualizados com o Taura, virá a informação do Embarque")
			EndIf

			EEC28C(EEC->EEC_ZEXP,EEC->EEC_ZANOEX,EEC->EEC_ZSUBEX,cAliasEE9)

			While !(cAliasEE9)->(EOF())
				lRet := SB1->(DbSeek(xFilial("SB1")+ (cAliasEE9)->EE9_COD_I))
				nProduto	:= aScan(WItens,{|x| Alltrim(x[1]) == Alltrim((cAliasEE9)->EE9_COD_I)})
				cDescProd := ""
				if EE2->( DBSeek( xFilial("EE2") + "3*" + (cAliasEE9)->EEC_IDIOMA + (cAliasEE9)->EE9_COD_I ) )
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
				If lRet
					If nProduto > 0
						WItens[nProduto][3]	+= (cAliasEE9)->EE9_QTDEM1
						WItens[nProduto][4]	+= (cAliasEE9)->EE9_PSLQTO
						WItens[nProduto][5]	+= (cAliasEE9)->EE9_PSBRTO
					Else
						aAdd(WItens,{(cAliasEE9)->EE9_COD_I,cDescProd,(cAliasEE9)->EE9_QTDEM1,(cAliasEE9)->EE9_PSLQTO,(cAliasEE9)->EE9_PSBRTO})
					EndIf
				EndIf
				(cAliasEE9)->(DbSkip())
			EndDo

			(cAliasEE9)->(DbCloseArea())
		EndIf
		If nPallet > 0
			aAdd(WItens,{"","PALLET",0,0,nPallet})
		EndIf

		If lSemTaura
			DbSelectArea("ZDW")
			ZDW->(DbSetOrder(1))
			ZDW->(Dbseek(xFilial("ZDW")+cNumPed))
			DbSelectArea("ZDX")
			ZDX->(DbSetOrder(1))
			ZDX->(Dbseek(xFilial("ZDX")+cNumPed))
		EndIf

		WContainer  		:= IIf( lSemTaura, ZDW->ZDW_CONTNR ,EX9->EX9_CONTNR)
		WSeal  				:= IIf( lSemTaura, ZDW->ZDW_LACRE1 ,EX9->EX9_LACRE )
		WSeal  				+= IIF( lSemTaura, IIF(!Empty(Alltrim(ZDW->ZDW_LACRE2)),CRLF+ZDW->ZDW_LACRE2,""),EX9->EX9_ZLACRE )
		cNumPed				:= GetAdvFVal("EE7","EE7_PEDFAT",xFilial("EE7")+EEC->EEC_PEDREF,1,"")

		BeginSql Alias cAliasZZR
			SELECT MIN(ZZR_PERDE) PERDE, MAX(ZZR_PERATE) PERATE
			FROM %table:ZZR%
			WHERE 	ZZR_PEDIDO = %Exp:cNumPed% AND
			ZZR_FILIAL = %xFilial:ZZR% AND
			%notDel%
		EndSql

		If lSemTaura
			If !ZDX->(Eof())
				WProductionDate  	:= "From "+ STR(DAY(ZDX->ZDX_PERDE),2,0) + " " + Substr(cMonth(ZDX->ZDX_PERDE),1,3) + " " + STR(Year(ZDX->ZDX_PERDE),4,0)
				WProductionDate  	+= " to " + STR(DAY(ZDX->ZDX_PERATE),2,0) + " " + Substr(cMonth(ZDX->ZDX_PERATE),1,3) + " " + STR(Year(ZDX->ZDX_PERATE),4,0)
			EndIf
		Else
			If !(cAliasZZR)->(Eof())
				WProductionDate  	:= "From "+ STR(DAY(STOD((cAliasZZR)->PERDE)),2,0) + " " + Substr(cMonth(STOD((cAliasZZR)->PERDE)),1,3) + " " + STR(Year(STOD((cAliasZZR)->PERDE)),4,0)
				WProductionDate  	+= " to "+ STR(DAY(STOD((cAliasZZR)->PERATE)),2,0) + " " + Substr(cMonth(STOD((cAliasZZR)->PERATE)),1,3) + " " + STR(Year(STOD((cAliasZZR)->PERATE)),4,0)
			EndIf
		EndIf

		WCompany			:= SM0->M0_NOMECOM
		WAddressCompany		:= SM0->M0_ENDENT
		WZipCode			:= SM0->M0_CEPENT
		WPlaceCompany		:= ALLTRIM(SM0->M0_CIDENT)+" - "+ALLTRIM(SM0->M0_ESTENT)

		If lBundles
			cPathDot	:= "C:\DOT\"+cBundles
		EndIf

		//Conecta ao word
		hWord	:= OLE_CreateLink()
		OLE_NewFile(hWord, cPathDot )
		If lPdf
			OLE_SetProperty( hWord, "206", .F. ) //206 -OLEWDVISIBLE
		EndIf

		//Montagem das variaveis do cabecalho
		OLE_SetDocumentVar(hWord, 'WNumOrc'				,WNumOrc			)
		OLE_SetDocumentVar(hWord, 'WEXP'                ,WEXP               )
		OLE_SetDocumentVar(hWord, 'WRef'                ,WRef               )
		OLE_SetDocumentVar(hWord, 'WDate'               ,WDate              )
		OLE_SetDocumentVar(hWord, 'WImporter'           ,WImporter          )
		OLE_SetDocumentVar(hWord, 'WImportAddress'      ,WImportAddress     )
		OLE_SetDocumentVar(hWord, 'WImpCity'            ,WImpCity           )
		OLE_SetDocumentVar(hWord, 'WCountryPort'        ,WCountryPort       )
		OLE_SetDocumentVar(hWord, 'WImpCountry'         ,WImpCountry        )
		OLE_SetDocumentVar(hWord, 'WPlaceOfShipment'    ,WPlaceOfShipment   )
		OLE_SetDocumentVar(hWord, 'WPlaceOfDischarge'   ,WPlaceOfDischarge  )
		OLE_SetDocumentVar(hWord, 'WVia'   				,WVia  				)
		OLE_SetDocumentVar(hWord, 'WStuffingDate'       ,WStuffingDate      )
		OLE_SetDocumentVar(hWord, 'WContainer'          ,WContainer         )
		OLE_SetDocumentVar(hWord, 'WSeal'               ,WSeal              )
		OLE_SetDocumentVar(hWord, 'WProductionDate'     ,WProductionDate    )
		OLE_SetDocumentVar(hWord, 'WUnit'     			,WUnit     			)
		OLE_SetDocumentVar(hWord, 'WUnit2'     			,WUnit2     		)
		OLE_SetDocumentVar(hWord, 'WCompany'			,WCompany			)
		OLE_SetDocumentVar(hWord, 'WAddressCompany'		,WAddressCompany	)
		OLE_SetDocumentVar(hWord, 'WZipCode'			,WZipCode			)
		OLE_SetDocumentVar(hWord, 'WPlaceCompany'		,WPlaceCompany		)

		OLE_SetDocumentVar(hWord, 'WDescrType'			,WDescrType			)

		OLE_SetDocumentVar(hWord, 'Prt_nroitens',str(Len(WItens)))

		//Montagem das variaveis dos itens. No documento word estas variaveis serao criadas //dinamicamente da seguinte forma:
		//prt_cod1, prt_cod2 ... prt_cod10
		for nK := 1 to Len(WItens)
			OLE_SetDocumentVar(hWord,"WCode"+AllTrim(Str(nK)),WItens[nK][1])
			OLE_SetDocumentVar(hWord,"WDescription"+AllTrim(Str(nK)),WItens[nK][2])
			OLE_SetDocumentVar(hWord,"WQuantity"+AllTrim(Str(nK)), Transform(WItens[nK][3],"@E 999,999,999"))
			If lBundles
				If Len(WItens[nK]) >= 7
					OLE_SetDocumentVar(hWord,"WBundles"+AllTrim(Str(nK)), Transform(WItens[nK][7],"@E 999,999,999"))
				Else
					OLE_SetDocumentVar(hWord,"WBundles"+AllTrim(Str(nK)), "")
				Endif
			EndIf
			OLE_SetDocumentVar(hWord,"WNetWeight"+AllTrim(Str(nK)), Transform(WItens[nK][4],cPicture))
			OLE_SetDocumentVar(hWord,"WGrossWeight"+AllTrim(Str(nK)), Transform(WItens[nK][5],cPicture))

			nTQuantity 		+= WItens[nK][3]
			nTNetWeight 	+= WItens[nK][4]
			nTGrossWeight	+= WItens[nK][5]
			If lBundles
				If Len(WItens[nK]) >= 7
					nTBundles		+= WItens[nK][7]
				Endif
			EndIf
		next

		OLE_ExecuteMacro(hWord,"tabitens")

		OLE_SetDocumentVar(hWord, 'WTQuantity', Transform(nTQuantity,"@E 999,999,999"))
		OLE_SetDocumentVar(hWord, 'WTNetWeight', Transform(nTNetWeight,cPicture))
		OLE_SetDocumentVar(hWord, 'WTGrossWeight', Transform(nTGrossWeight,cPicture))
		If lBundles
			OLE_SetDocumentVar(hWord, 'WTBundles', Transform(nTBundles,cPicture))
		EndIf

		OLE_UpdateFields(hWord)	// Atualizando as variaveis do documento do Word

		If lPDF
			OLE_SaveAsFile( hWord, "C:\DOT\PDF\Pack"+StrTran(WEXP,"/","")+".pdf",'','',.F. , 17 ) // 17 - PDF
			OLE_CloseFile( hWord )
			OLE_CloseLink( hWord )
			ShellExecute( "Open", "Pack"+StrTran(WEXP,"/","")+".pdf", " ", "C:\DOT\PDF\", 3 )
		Else
			If MsgYesNo("Fecha o Word e Corta o Link ?")
				OLE_CloseFile( hWord )
				OLE_CloseLink( hWord )
			Endif
		EndIf
	Else
		MsgStop("Embarque não encontrado")
	EndIf
EndIf
Return()

/*/{Protheus.doc} EEC28A
//TODO Inclusão de item no menu
@author leonardo.kume
@since 05/06/2018
@version 6

@type function
/*/
User Function EEC28A(aButtons)

aadd(aButtons,{"Packing List Marfrig","U_MGFEEC28",0,1,0})

Return aButtons

/*/{Protheus.doc} EEC28B
//TODO Programa para trazer pedidos EE7
@author leonardo.kume
@since 05/06/2018
@version 6

@type function
/*/
Static Function EEC28B(cEXP, cSubEX, cAnoEX)

Local aPedidos 	:= {}
Local cAliasEE7	:= GetNextAlias()


// INNER JOIN %Table:EE9% EE9
// ON	EE9.%notDel% AND
// 	EE9.EE9_PREEMB = EEC.EEC_PREEMB AND
// 	EE9.EE9_FILIAL = EEC.EEC_FILIAL

BeginSql Alias cAliasEE7

	SELECT EE7.EE7_PEDFAT
	FROM %Table:EEC% EEC
	INNER JOIN %Table:EE7% EE7
	ON 	EE7.%notDel% AND
		EE7.EE7_PEDIDO = EEC.EEC_PEDREF 
	WHERE
		EEC.%notDel% AND
		EEC.EEC_ZEXP = %Exp:cEXP% AND
		EEC.EEC_ZANOEX = %Exp:cAnoEX% AND
		EEC.EEC_ZSUBEX = %Exp:cSubEX% AND
		%Exp:c_Filtro%
	GROUP BY EE7.EE7_PEDFAT

EndSql

While !(cAliasEE7)->(Eof())

	aAdd(aPedidos,(cAliasEE7)->EE7_PEDFAT)
	(cAliasEE7)->(DbSkip())
EndDo

(cAliasEE7)->(DbCloseArea())

Return aPedidos

/*/{Protheus.doc} EEC28C
//TODO Programa para trazer produtos EE9
@author leonardo.kume
@since 05/06/2018
@version 6

@type function
/*/
Static Function EEC28C(cEXP,cAnoEX,cSubEX,cAliasEE9)

if MV_PAR02 = "1"

BeginSql Alias cAliasEE9

	SELECT  EE9.EE9_SEQUEN, EE9.EE9_COD_I,EE9.EE9_QTDEM1,EE9.EE9_PSLQTO,EE9.EE9_PSBRTO,EEC.EEC_IDIOMA
	FROM %Table:EEC% EEC
	INNER JOIN %Table:EE9% EE9
	ON 	EE9.%notDel% AND
		EE9.EE9_PEDIDO = EEC.EEC_PEDREF AND
		EEC.EEC_FILIAL = '900001'
	WHERE
		EEC.%notDel% AND
		EEC.EEC_ZEXP = %Exp:cEXP% AND
		EEC.EEC_ZANOEX = %Exp:cAnoEX% AND
		EEC.EEC_ZSUBEX = %Exp:cSubEX% AND
		%Exp:c_Filtro%

EndSql

Else //Se não for offshore, considerar os dados das filiais diferentes de offshore

BeginSql Alias cAliasEE9

	SELECT  EE9.EE9_SEQUEN, EE9.EE9_COD_I,EE9.EE9_QTDEM1,EE9.EE9_PSLQTO,EE9.EE9_PSBRTO,EEC.EEC_IDIOMA
	FROM %Table:EEC% EEC
	INNER JOIN %Table:EE9% EE9
	ON 	EE9.%notDel% AND
		EE9.EE9_PEDIDO = EEC.EEC_PEDREF AND
		EEC.EEC_FILIAL <> '900001'
	WHERE
		EEC.%notDel% AND
		EEC.EEC_ZEXP = %Exp:cEXP% AND
		EEC.EEC_ZANOEX = %Exp:cAnoEX% AND
		EEC.EEC_ZSUBEX = %Exp:cSubEX% AND
		%Exp:c_Filtro%

EndSql


endif

Return cAliasEE9
/*/{Protheus.doc} EEC28D
//TODO Programa para trazer produtos EE8
@author leonardo.kume
@since 05/06/2018
@version 6

@type function
/*/
Static Function EEC28D(cEXP,cAnoEX,cSubEX,cAliasEE8)

BeginSql Alias cAliasEE8

	SELECT  EE8.EE8_SEQUEN, EE8.EE8_COD_I,SUM(EE8.EE8_SLDINI) EE8_SLDINI
	FROM %Table:EE7% EE7
	INNER JOIN %Table:EE8% EE8
	ON 	EE8.%notDel% AND
		EE8.EE8_PEDIDO = EE7.EE7_PEDIDO AND
		EE8.EE8_FILIAL = EE7.EE7_FILIAL
	WHERE
		EE7.%notDel% AND
		EE7.EE7_FILIAL = %xFilial:EE7% AND
		EE7.EE7_ZEXP = %Exp:cEXP% AND
		EE7.EE7_ZANOEX = %Exp:cAnoEX% AND
		EE7.EE7_ZSUBEX = %Exp:cSubEX%
	GROUP BY EE8.EE8_SEQUEN, EE8.EE8_COD_I

EndSql

Return cAliasEE8
