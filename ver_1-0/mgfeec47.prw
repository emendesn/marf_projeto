#include 'protheus.ch'
#include "rwmake.ch"

/*
=====================================================================================
Programa............: MGFEEC47
Autor...............: leonardo.kume 
Data................: 31/05/2017
Descrição / Objetivo: Programa para gerar a Packing List na EXP
=====================================================================================
*/
user function MGFEEC47()

	Local aArea 	:= GetArea()
	Local cPerg 	:= "MGFEEC28"
	Local nPallet	:= 0
	Private cFilVen := ZB8->(ZB8_FILVEN)
	Private cNumero := ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP)

	If Pergunte(cPerg,.t.)
		nPallet := MV_PAR01
		fwmsgrun(,{|| MGFEEC47E(nPallet)},"Exportando packing list...","Aguarde...")
	EndIf

	RestArea(aArea)

return

/*
=====================================================================================
Programa............: MGFEEC47E
Autor...............: leonardo.kume 
Data................: 31/05/2017
Descrição / Objetivo: Executa impressão e exporta pdf
=====================================================================================
*/
Static Function MGFEEC47E(nPallet)

	Local WNumOrc, WEXP, WRef, WDate, WImporter, WImportAddress, WImpCity, WCountryPort, WImpCountry, WPlaceOfShipment
	Local WPlaceOfDischarge, WStuffingDate, WContainer, WSeal, WProductionDate
	Local WCompany, WAddressCompany, WZipCode, WPlaceCompany, WDescrType
	Local WUnit,WUnit2
	Local nTQuantity 	:= 0
	Local nTNetWeight 	:= 0
	Local nTGrossWeight	:= 0
	Local lRet			:= .t.
	Local cAliasZZR 	:= GetNextAlias()
	Local cProduto 	:= ""
	Local nProduto 	:= 0
	Local cDescProd 	:= ""
	Local lBundles		:= .f.

	Local WItens := {}

	Local cNumPed 	:= ""
	Local cTipoPed 	:= ""
	Local lSemTaura	:= .f.
	Local cFilVen	:= ""
	Local cArquivo		:= iif(Substr(cFilAnt,2,1)=='1',GetMV("MGF_EEC471",,"PackingList2.dot"),GetMV("MGF_EEC472",,"PackingList2.dot"))
	Local cBundles		:= iif(Substr(cFilAnt,2,1)=='1',GetMV("MGF_EEC473",,"PackingListBundles01.dot"),GetMV("MGF_EEC474",,"PackingListBundles02.dot"))
	Local cPicture		:= iif(Substr(cFilAnt,2,1)=='1',"@E 999,999,999.999","@E 999,999,999.999999")
	Local lPDF		 	:= ! RetCodUsr() $ GetMv("MGF_PROFWO",,"")

	Local WItens := {}

	Local nK			:= 0
	Local cPathDot		:= "C:\DOT\"+cArquivo
	Private	hWord		:= nil

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

	If lRet
		//Alimentando valores para atualizar o documento Word
		OpenSM0()
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
		DbSelectArea("ZB8")
		ZB8->(DbSetOrder(3))
		lRet := ZB8->(DbSeek(xFilial("ZB8")+cNumero))
		DbSelectArea("ZB9")
		ZB9->(DbSetOrder(2))
		lRet := lRet .and. ZB9->(DbSeek(xFilial("ZB9")+cNumero))

		cNumPed 	:= ZB8->ZB8_PEDFAT
		cTipoPed 	:= ZB8->ZB8_ZTIPPE
		cTipoPed 	:= GetAdvFVal("SZJ","ZJ_TAURA",xFilial("SZJ")+cTipoPed,1,"")
		lSemTaura	:= cTipoPed == "N"
		cFilVen		:= ZB8->ZB8_FILVEN

		If lSemTaura
			DbSelectArea("ZDW")
			ZDW->(DbSetOrder(1))
			ZDW->(Dbseek(xFilial("ZDW")+cNumPed))
			DbSelectArea("ZDX")
			ZDX->(DbSetOrder(1))
			ZDX->(Dbseek(xFilial("ZDX")+cNumPed))
		EndIf

		If lRet
			If MV_PAR02 == 1 .AND. ZB8->ZB8_INTERM == '1'
				SA1->(DbSeek(xFilial("SA1")+ZB8->(ZB8_CLIENT+ZB8_CLLOJA)))
			Else
				SA1->(DbSeek(xFilial("SA1")+ZB8->(ZB8_IMPORT+ZB8_IMLOJA)))
			EndIf
			EX9->(DbSeek(cFilVen+cNumero)) //ATENÇÃO NÃO TERÁ EX9
			SYQ->(DbSeek(xFilial("SYQ")+ZB8->ZB8_VIA))
		EndIF


		If lRet
			WEXP	 			:= ZB8->(ZB8_EXP +"/"+ ZB8_ANOEXP + IIF(!Empty(ZB8_SUBEXP),"-" + ZB8_SUBEXP ,"" ))
			WRef				:= ZB8->ZB8_REFIMP
			WDate				:= STR(DAY(dDatabase),2,0) + " " + Substr(cMonth(dDatabase),1,3) + " " + STR(Year(dDatabase),4,0)
			WImporter  			:= SA1->A1_NOME
			WImportAddress  	:= SA1->A1_END
			WImpCity  			:= IIF("EXTERIOR"$Alltrim(SA1->A1_MUN),"",Alltrim(SA1->A1_MUN))
			WCountryPort		:= GetAdvFVal("SYA","YA_DESCR",xFilial("SYA")+SA1->A1_PAIS,1,"")
			WImpCountry  		:= GetAdvFVal("SYA","YA_PAIS_I",xFilial("SYA")+SA1->A1_PAIS,1,"")
			WImpCountry  		:= iIf(!Empty(Alltrim(WImpCountry)),WImpCountry ,WCountryPort)

			lRet := SY9->(DbSeek(xFilial("SY9")+ ZB8->ZB8_ORIGEM))
			WPlaceOfShipment  		:= Alltrim(SY9->Y9_DESCR) + ', '
			WPlaceOfShipment		+= GetAdvFVal("SYA","YA_PAIS_I",xFilial("SYA")+SY9->Y9_PAIS,1,"")
			lRet := SY9->(DbSeek(xFilial("SY9")+ ZB8->ZB8_DEST))
			WPlaceOfDischarge		:= Alltrim(SY9->Y9_DESCR) + ', '
			WPlaceOfDischarge		+= GetAdvFVal("SYA","YA_PAIS_I",xFilial("SYA")+SY9->Y9_PAIS,1,"")

			WVia				:= SYQ->YQ_DESCR

			EE2->(DbSeek(xFilial("EE2")+"6*"+ZB8->ZB8_IDIOMA+ZB9->ZB9_EMBAL1 ) )
			WUnit				:= MSMM(EE2->EE2_TEXTO,50)
			EE2->(DbSeek(xFilial("EE2")+"8*"+ZB8->ZB8_IDIOMA+ZB9->ZB9_UNIDAD  ) )
			WUnit2				:= "KG"


			WDescrType := ""
			SYC->(DbSeek(xFilial("SYC")+ EEC->EEC_VIA))

			If SYC->(DbSeek(xFilial("SYC")+EEC->EEC_IDIOMA+EEC->EEC_ZTPROD ) )
				WDescrType	+= SYC->YC_NOME + CRLF
			EndIf
	
			If ZZR->(DbSeek(cFilVen+PADR(cNumPed,20)  ) )

				If DAY(ZZR->ZZR_DTESTU) > 0
					WStuffingDate  		:= STR(DAY(ZZR->ZZR_DTESTU),2,0) + " " + Substr(cMonth(ZZR->ZZR_DTESTU),1,3) + " " + STR(Year(ZZR->ZZR_DTESTU),4,0)
				EndIf

				While !ZZR->(EOF()) .AND. ALLTRIM(ZZR->(ZZR_PEDIDO)) == ALLTRIM(cNumPed) .AND. ZZR->ZZR_FILIAL == cFilVen
					cProduto	:= GetAdvFVal("SC6","C6_PRODUTO",cFilVen+ZZR->(PADR(ZZR_PEDIDO,6)+PADR(ZZR_ITEM,2)) )
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

						//Valida status da EEC para não trazer nf com embarque cancelado
						SC5->(Dbsetorder(1)) //C5_FILIAL+C5_NUM
						If SC5->(Dbseek(ZZR->ZZR_FILIAL+ZZR->ZZR_PEDIDO))

							EEC->(Dbsetorder(1)) //EEC_FILIAL + EEC_PREEMB
							If EEC->(Dbseek(SC5->C5_FILIAL+SC5->C5_PEDEXP))

								If EEC->EEC_STATUS != "*" //Embarque cancelado

									If nProduto > 0

										WItens[nProduto][3]	+= ZZR->ZZR_TOTCAI
										WItens[nProduto][4]	+= ZZR->ZZR_PESOL
										WItens[nProduto][5]	+= ZZR->ZZR_PESOB
									Else
										aAdd(WItens,{cProduto,cDescProd,ZZR->ZZR_TOTCAI,ZZR->ZZR_PESOL,ZZR->ZZR_PESOB})
									EndIf
								EndIf
							Endif
						Endif
					Endif

					ZZR->(DbSkip())
				EndDo
			ElseIf ZDW->(DbSeek(cFilVen+PADR(cNumPed,20)  ) )

				If DAY(ZDW->ZDW_DTESTU) > 0
					WStuffingDate  		:= STR(DAY(ZDW->ZDW_DTESTU),2,0) + " " + Substr(cMonth(ZDW->ZDW_DTESTU),1,3) + " " + STR(Year(ZDW->ZDW_DTESTU),4,0)
				EndIf
				While !ZDW->(EOF()) .AND. ALLTRIM(ZDW->(ZDW_PEDIDO)) == ALLTRIM(cNumPed) .AND. ZDW->ZDW_FILIAL == cFilVen
					cProduto	:= GetAdvFVal("SC6","C6_PRODUTO",cFilVen+ZDW->(PADR(ZDW_PEDIDO,6)+PADR(ZDW_ITEM,2)) )
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

						//Valida status da EEC para não trazer nf com embarque cancelado
						SC5->(Dbsetorder(1)) //C5_FILIAL+C5_NUM
						If SC5->(Dbseek(ZDW->ZDW_FILIAL+ZDW->ZDW_PEDIDO))

							EEC->(Dbsetorder(1)) //EEC_FILIAL + EEC_PREEMB
							If EEC->(Dbseek(SC5->C5_FILIAL+SC5->C5_PEDEXP))

								If EEC->EEC_STATUS != "*" //Embarque cancelado

									If nProduto > 0
										WItens[nProduto][3]	+= ZDW->ZDW_TOTCAI
										WItens[nProduto][4]	+= ZDW->ZDW_PSLQUN
										WItens[nProduto][5]	+= ZDW->ZDW_PSBRUN
									Else
										aAdd(WItens,{cProduto,cDescProd,ZDW->ZDW_TOTCAI,ZDW->ZDW_PSLQUN,ZDW->ZDW_PSBRUN})
									EndIf
								EndIf
							Endif
						Endif
						
					Endif
					ZDW->(DbSkip())
				EndDo
			EndIf
			If Len(wItens) == 0 .or. (Len(wItens) > 0 .and. WItens[1][4] == 0)
				wItens := {}

				If Empty(WStuffingDate)

					If DAY(EX9->EX9_DTPREV) > 0
						WStuffingDate  		:= STR(DAY(EX9->EX9_DTPREV),2,0) + " " + Substr(cMonth(EX9->EX9_DTPREV),1,3) + " " + STR(Year(EX9->EX9_DTPREV),4,0)
					EndIf
					MsgAlert("Dados de Data de estufagem e Itens não atualizados com o Taura, virá a informação da EXP")
				Else
					MsgAlert("Dados de Itens não atualizados com o Taura, virá a informação da EXP")
				EndIf
				While !ZB9->(EOF()) .AND. ALLTRIM(ZB9->(ZB9_EXP+ZB9_ANOEXP+ZB9_SUBEXP)) == ALLTRIM(ZB8->(ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP))
					lRet := SB1->(DbSeek(xFilial("SB1")+ ZB9->ZB9_COD_I))
					nProduto	:= aScan(WItens,{|x| Alltrim(x[1]) == Alltrim(ZB9->ZB9_COD_I)})
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
					If lRet
						If nProduto > 0
							WItens[nProduto][3]	+= ZB9->ZB9_QTDEM1
							WItens[nProduto][4]	+= ZB9->ZB9_PSLQTO
							WItens[nProduto][5]	+= ZB9->ZB9_PSBRTO
						Else
							aAdd(WItens,{ZB9->ZB9_COD_I,cDescProd,ZB9->ZB9_QTDEM1,ZB9->ZB9_PSLQTO,ZB9->ZB9_PSBRTO})
						EndIf
					EndIf
					ZB9->(DbSkip())
				EndDo
			EndIf
			If nPallet > 0
				aAdd(WItens,{"","PALLET",0,0,nPallet})
			EndIf

			If lSemTaura
				DbSelectArea("ZDW")
				ZDW->(DbSetOrder(1))
				ZDW->(Dbseek(ZB8->ZB8_FILVEN+ZB8->ZB8_PEDFAT))
				DbSelectArea("ZDX")
				ZDX->(DbSetOrder(1))
				ZDX->(Dbseek(ZB8->ZB8_FILVEN+ZB8->ZB8_PEDFAT))
			EndIf

			WContainer  		:= IIf( lSemTaura, ZDW->ZDW_CONTNR ,EX9->EX9_CONTNR)
			WSeal  				:= IIf( lSemTaura, ZDW->ZDW_LACRE1 ,EX9->EX9_LACRE )
			WSeal  				+= IIF( lSemTaura, IIF(!Empty(Alltrim(ZDW->ZDW_LACRE2)),CRLF+ZDW->ZDW_LACRE2,""),EX9->EX9_ZLACRE )
			cNumPed				:= GetAdvFVal("EE7","EE7_PEDFAT",xFilial("EE7")+EEC->EEC_PEDREF,1,"")

			BeginSql Alias cAliasZZR
				SELECT MIN(ZZR_PERDE) PERDE, MAX(ZZR_PERATE) PERATE
				FROM %table:ZZR%
				WHERE 	ZZR_PEDIDO = %Exp:cNumPed% AND
						ZZR_FILIAL = %Exp:cFilVen% AND
						%notDel%
			EndSql

			If lSemTaura
				If !ZDX->(Eof()) .and. (DAY(STOD(ZDX->ZDX_PERDE)) > 0 .or. DAY(STOD(ZDX->ZDX_PERATE)) > 0 )
					WProductionDate  	:= "From "+ STR(DAY(ZDX->ZDX_PERDE),2,0) + " " + Substr(cMonth(ZDX->ZDX_PERDE),1,3) + " " + STR(Year(ZDX->ZDX_PERDE),4,0)
					WProductionDate  	+= " to " + STR(DAY(ZDX->ZDX_PERATE),2,0) + " " + Substr(cMonth(ZDX->ZDX_PERATE),1,3) + " " + STR(Year(ZDX->ZDX_PERATE),4,0)
				EndIf
			Else
				If !(cAliasZZR)->(Eof()) .and. (DAY(STOD((cAliasZZR)->PERDE)) > 0 .or. DAY(STOD((cAliasZZR)->PERATE)) > 0 )
					WProductionDate  	:= "From "+ STR(DAY(STOD((cAliasZZR)->PERDE)),2,0) + " " + Substr(cMonth(STOD((cAliasZZR)->PERDE)),1,3) + " " + STR(Year(STOD((cAliasZZR)->PERDE)),4,0)
					WProductionDate  	+= " to "+ STR(DAY(STOD((cAliasZZR)->PERATE)),2,0) + " " + Substr(cMonth(STOD((cAliasZZR)->PERATE)),1,3) + " " + STR(Year(STOD((cAliasZZR)->PERATE)),4,0)
				EndIf
			EndIf

			WCompany			:= SM0->M0_NOMECOM
			WAddressCompany		:= SM0->M0_ENDENT
			WZipCode			:= SM0->M0_CEPENT
			WPlaceCompany		:= ALLTRIM(SM0->M0_CIDENT)+" - "+ALLTRIM(SM0->M0_ESTENT)

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
					nTBundles		+= WItens[nK][7]
				EndIf
			next nK

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
			Endif
		Else
			MsgStop("Embarque não encontrado")
		EndIf
	EndIf
Return()


User Function EEC47A(aButtons)

	aadd(aButtons,{"Packing List Marfrig","U_MGFEEC47",0,1,0})

Return aButtons
