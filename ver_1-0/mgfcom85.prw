#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#INCLUDE "TOPCONN.CH"

/*
=====================================================================================
Programa............: MGFCOM85()
Autor...............: Tarcisio Galeano
Data................: 26/04/18
17
Descricao / Objetivo: Criacao de autoriza��o de entrega por varias scs
Doc. Origem.........: Compras - COM03
Solicitante.........: Cliente
Uso.................: 
Obs.................: teve como base o MGFCOM28
=====================================================================================
*/


User function MGFCOM85()


	Local bPassou := .F.
	local xfilde := SPACE(06)
	local xfilate := "ZZZZZZ"
	local scde  := SPACE(06)
	local scate := "ZZZZZZ"
	local dtde  := ddatabase
	local dtate := ddatabase

	DEFINE MSDIALOG oDLG2 TITLE "Filtro para Solicitacoes" FROM 000, 000  TO 250, 395 COLORS 0, 16777215 PIXEL
	@ 008, 002 SAY  "Filial de:"    SIZE 028, 009 OF oDLG2 			 COLORS 0, 16777215 PIXEL //alterado Rafael 27/12/2018
	@ 007, 030 MSGET  xfilde     SIZE 50, 010 OF oDLG2 PICTURE "@!" COLORS 0, 16777215 PIXEL
	
	@ 028, 002 SAY  "Filial ate:"    SIZE 028, 009 OF oDLG2 			 COLORS 0, 16777215 PIXEL //alterado Rafael 27/12/2018
	@ 027, 030 MSGET  xfilate     SIZE 50, 010 OF oDLG2 PICTURE "@!" COLORS 0, 16777215 PIXEL
	
	@ 048, 002 SAY  "SC de    :"    SIZE 028, 009 OF oDLG2 			 COLORS 0, 16777215 PIXEL
	@ 047, 030 MSGET  SCDE    SIZE 50, 010 OF oDLG2 PICTURE "@!" COLORS 0, 16777215 PIXEL

	@ 068, 002 SAY  "SC ate   :"    SIZE 028, 009 OF oDLG2 			 COLORS 0, 16777215 PIXEL
	@ 067, 030 MSGET  SCATE     SIZE 50, 010 OF oDLG2 PICTURE "@!" COLORS 0, 16777215 PIXEL

	@ 088, 002 SAY  "Data de  :"    SIZE 028, 009 OF oDLG2 			 COLORS 0, 16777215 PIXEL
	@ 087, 030 MSGET  dtde    SIZE 50, 010 OF oDLG2 COLORS 0, 16777215 PIXEL

	@ 108, 002 SAY  "Data ate :"    SIZE 028, 009 OF oDLG2 			 COLORS 0, 16777215 PIXEL
	@ 107, 030 MSGET  dtATE     SIZE 50, 010 OF oDLG2 COLORS 0, 16777215 PIXEL



	//	oBtn := TButton():New( 021, 145 ,"Confirma"    , oDlg2,{|| oDLG2:End() }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
	oBtn := TButton():New( 108, 145 ,"Confirma"    , oDlg2,{|| bPassou := .T., oDLG2:End() }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )

	ACTIVATE MSDIALOG oDLG2 CENTERED

	if bPassou
		MsAguarde({|| rodasc(xfilde,xfilate,scde,scate,dtde,dtate)},"Verificando geracao de Autorizacao de Entrega, aguarde...")
	endif

Return()

Static Function rodasc(xfilde,xfilate,scde,scate,dtde,dtate)

	Local aArea := {SC7->(GetArea()),SA2->(GetArea()),SM0->(GetArea()),GetArea()}
	Local cQuery  := " "
	Local cQueryn  := " "
	Local cQry    := " "
	Local cNumsol := " "
	Local cAlias1
	Local cAlias2
	Local lRet   := .F.
	Local nQuant := 0
	Local aCab   := {}
	Local aItem  := {}
	Local aItens := {}
	Local nI     := 0
	Local nY     := 0
	Local cNumPC := ""
	Local nSaveSX8 := GetSX8Len()
	Local xRet := .F.
	Local nAliq := 0
	Local nValitem := 0
	Local cChave := ""
	Local aAreaSM0 := SM0->(GetArea())
	Local cFilEnt := ""

	Local aSolProc := {}
	Local nxItem   := 1
	Local cSitTrib := ""
	Local lIcmsZero := .F.
	Local aObs := {}
	Local nCnt := 0           
	Local _cContr := " "
	Local _cItContr := " "

	Local aRateio	:= {}             
	Local cItem :=0
	Local ccont :=0
	Local lRegraOri1 := .F.
	local cMsg:=""
	local lCont:= .t.
	LOCAL cFilSol:="" //RAFAEL 27/12/2018
	//SELECT DAS SCS
	cAlias3	:= GetNextAlias()

	cQuery := " SELECT DISTINCT C1_FILIAL,C1_NUM " 
	cQuery += "	FROM " + RetSqlName("SC1") + " SC1" 
	cQuery += "	LEFT OUTER JOIN " + RetSqlName("SC3") + " SC3" 
	cQuery += "	ON SC3.C3_DATPRF >= '"+dtos(dtde)+"' AND SC3.C3_PRODUTO=SC1.C1_PRODUTO "
	cQuery += "	AND SC3.D_E_L_E_T_<>'*' and C3_QUANT-C3_QUJE >= SC1.C1_QUANT "
	cQuery += "	WHERE SC1.D_E_L_E_T_<>'*' AND SC1.C1_EMISSAO >= '" + dtos(dtde) + "' and SC1.C1_EMISSAO <= '"+dtos(dtate)+"' "
	cQuery += "	AND C1_QUJE=0 AND C1_APROV='L'  AND C1_ZGEAUTE='1'  AND C1_COTACAO=' ' AND C1_NUM >='"+SCDE+"' AND C1_NUM <= '"+SCATE+"' "
	cQuery += " AND SC1.C1_FILIAL >= '" + xfilde + "' and SC1.C1_FILIAL <= '"+xfilate+"' " //ALTERADO RAFAEL 27/12/2018
	//cQuery += "	AND C3_NUM IS NOT NULL " ALTERADO RAFAEL 19/11/2018, RETIRADO OS ELIMINADOS RESIDUO
	cQuery += "	AND SC1.C1_RESIDUO<>'S' AND C3_NUM IS NOT NULL "
	cQuery += "	ORDER BY C1_FILIAL,C1_NUM "
	If Select("TEMP1") > 0
		TEMP1->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TEMP1",.T.,.F.)
	dbSelectArea("TEMP1")    
	TEMP1->(dbGoTop())


	While TEMP1->(!Eof())
		//msgalert("entrou no temp"+TEMP1->C1_NUM)
		cNumsol := TEMP1->C1_NUM
		cFilSol	:= TEMP1->C1_FILIAL //RAFAEL 27/12/2018

		cAlias1	:= GetNextAlias()

		//procura contrato na filial	   
		cQuery := "SELECT C1_NUM,C1_FORNECE,C1_LOJA,C1_PRODUTO,C1_QUANT,C1_FILIAL,C1_ZGEAUTE,C1_PEDIDO,C1_FILENT,C1_ITEM,C1_QUJE,C1_ITEMPED,C1_CC,C1_CLVL,C1_ITEMCTA,C1_ZGEAUTE,C1_DATPRF,"
		cQuery += "	C1_ZWFPC,C1_OBS,C1_LOCAL,C3_NUM,C3_FILIAL,C3_FORNECE,C3_LOJA,C3_PRODUTO,C3_DATPRI,C3_DATPRF,C3_QUANT,C3_QUJE,C3_ITEM,C3_COND,C3_IPI,C3_PRECO,C3_ZTES,C3_FILENT,C3_ZCODCOM,C3_MOEDA, "
		cQuery += "	ZD5_FILIAL,ZD5_FORNEC,ZD5_LOJA,ZD5_PROD,NVL(ZD5_CONTRA,' ') AS ZD5_CONTRA"
		cQuery += " FROM " + RetSqlName("SC1") + " SC1"             
		cQuery += " LEFT OUTER JOIN " + RetSqlName("SC3") + " SC3"
		cQuery += " ON"
		cQuery += "         SC3.C3_PRODUTO  =   SC1.C1_PRODUTO"
		cQuery += "         AND C3_DATPRI <= '" + dtos(dDatabase) + "' "
		cQuery += "         AND C3_DATPRF >= '" + dtos(dDatabase) + "' "
		cQuery += "         AND C3_CONAPRO = 'L' "
		cQuery += "         AND C3_RESIDUO = ' ' "
		cQuery += "         AND SC3.D_E_L_E_T_  <>  '*' "
		cQuery += " LEFT OUTER JOIN " + RetSqlName("ZD5") + " ZD5" 
		cQuery += " ON"
		cQuery += "     SC3.C3_FORNECE  = ZD5.ZD5_FORNEC"
		cQuery += "     AND SC3.C3_LOJA     = ZD5.ZD5_LOJA"
		cQuery += "     AND SC3.C3_NUM  = ZD5.ZD5_CONTRA"
		cQuery += "     AND ZD5_FILENT = SC1.C1_FILENT"
		cQuery += "     AND ZD5.D_E_L_E_T_  <>  '*' "
		cQuery += " WHERE"
		cQuery += " SC1.C1_FILIAL = '" + cFilSol + "' " //RAFAEL 27/12/2018
		cQuery += " AND SC1.C1_NUM  = '" + cNumsol + "' "                  
		cQuery += " AND SC1.C1_QUANT <= (SC3.C3_QUANT - SC3.C3_QUJE) "
		cQuery += " AND C1_PEDIDO = ' ' " 
		cQuery += " AND C1_ZGEAUTE = '1' "
		cQuery += " AND SC1.D_E_L_E_T_  <>  '*'  AND ZD5_FILENT=C1_FILENT "
		cQuery += " ORDER BY SC3.C3_FORNECE,SC1.C1_NUM,C1_ITEM "
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias1, .F., .T.)

		nx :=0
		While (cAlias1)->(!EOF())
			nx := nx+1
			(cAlias1)->(dbSkip())
		EndDo

		//se nao achar procura contrato global
		IF NX = 0


			cAlias1	:= GetNextAlias()

			cQuery := "SELECT C1_NUM,C1_FORNECE,C1_LOJA,C1_PRODUTO,C1_QUANT,C1_FILIAL,C1_ZGEAUTE,C1_PEDIDO,C1_FILENT,C1_ITEM,C1_QUJE,C1_ITEMPED,C1_CC,C1_CLVL,C1_ITEMCTA,C1_ZGEAUTE,C1_DATPRF,"
			cQuery += "	C1_ZWFPC,C1_OBS,C1_LOCAL,C3_NUM,C3_FILIAL,C3_FORNECE,C3_LOJA,C3_PRODUTO,C3_DATPRI,C3_DATPRF,C3_QUANT,C3_QUJE,C3_ITEM,C3_COND,C3_IPI,C3_PRECO,C3_ZTES,C3_FILENT,C3_ZCODCOM,C3_MOEDA, "
			cQuery += "	ZD5_FILIAL,ZD5_FORNEC,ZD5_LOJA,ZD5_PROD,NVL(ZD5_CONTRA,' ') AS ZD5_CONTRA"
			cQuery += " FROM " + RetSqlName("SC1") + " SC1"             
			cQuery += " LEFT OUTER JOIN " + RetSqlName("SC3") + " SC3"
			cQuery += " ON"
			cQuery += "         SC3.C3_PRODUTO  =   SC1.C1_PRODUTO"
			cQuery += "         AND SC3.C3_FILENT   =   ' '"
			cQuery += "         AND C3_DATPRI <= '" + dtos(dDatabase) + "' "
			cQuery += "         AND C3_DATPRF >= '" + dtos(dDatabase) + "' "
			cQuery += "         AND C3_CONAPRO = 'L' "
			cQuery += "         AND C3_RESIDUO = ' ' "
			cQuery += "         AND SC3.D_E_L_E_T_  <>  '*' "
			cQuery += " LEFT OUTER JOIN " + RetSqlName("ZD5") + " ZD5" 
			cQuery += " ON"
			cQuery += "     SC3.C3_FORNECE  = ZD5.ZD5_FORNEC"
			cQuery += "     AND SC3.C3_LOJA     = ZD5.ZD5_LOJA"
			cQuery += "     AND SC3.C3_NUM  = ZD5.ZD5_CONTRA"
			cQuery += "     AND ZD5_FILENT = SC1.C1_FILENT"
			cQuery += "     AND ZD5.D_E_L_E_T_  <>  '*' "
			cQuery += " WHERE"
			cQuery += " SC1.C1_FILIAL = '" + cFilSol + "' " //ALTERADO RAFAEL 27/12/2018
			cQuery += " AND SC1.C1_NUM  = '" + cNumsol + "' "                  
			cQuery += " AND SC1.C1_QUANT <= (SC3.C3_QUANT - SC3.C3_QUJE) "
			cQuery += " AND C1_PEDIDO = ' ' " 
			cQuery += " AND C1_ZGEAUTE = '1' "
			cQuery += " AND SC1.D_E_L_E_T_  <>  '*' "
			cQuery += " ORDER BY SC3.C3_FORNECE,SC1.C1_NUM,C1_ITEM "
			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias1, .F., .T.)

		ENDIF

		(cAlias1)->(dbGoTop())
		While (cAlias1)->(!EOF())
			if alltrim((cAlias1)->C1_CLVL)<>"" //alteracao  Rafael 21/12/2018
				dbselectArea("CTH") 
				DBSETORDER(1)
				IF DBSEEK(XFILIAL("CTH")+(cAlias1)->C1_CLVL)
					IF DATE()> CTH->CTH_DTEXSF
						cMsg += "SC numero "+(cAlias1)->C1_NUM+" nao sera processada pois a Classe de Valor "+chr(13)+chr(10)
						cMsg += (cAlias1)->C1_CLVL+" esta expirada,entrar em contato com a Contabilidade!"+chr(13)+chr(10)		
						(cAlias1)->(dbskip())
						lcont:= .f.
					else
						lCont:= .t.
					endif 
				endif
			else
				lCont:=.t.
			endif	
			if 	lCont	// fim alteracao Rafael 21/12/2018
				Begin Transaction 

					cChave := (cAlias1)->C3_FORNECE
					lConf :=.F.

					//msgalert("aqui"+(cAlias1)->ZD5_CONTRA+" "+(cAlias1)->C3_NUM)
					//Se nao houver filiais no ZD5
					IF alltrim((cAlias1)->ZD5_CONTRA) = "" .and. alltrim((cAlias1)->C3_NUM) <> ""  
						lConf :=.T.
						//msgalert ("Vai gerar pedido pelo contrato da global "+cNumsol)
					ELSE 

						IF alltrim((cAlias1)->C3_NUM) <> "" .AND. alltrim((cAlias1)->ZD5_CONTRA) <> ""   
							lConf :=.T.
							//msgalert ("Vai gerar pedido pelo contrato filial "+cNumsol)
						ELSE
							lConf :=.F.
							//msgalert ("Contrato nao encontrado "+cNumsol)
						ENDIF
					ENDIF 

					//Alterado se nao achar registro no ZD5 mas houver no SC3 vai rodar pelo contraro global. 
					//DbCloseArea("TEMP2")

					If (cAlias1)->(!EOF()) .AND. lConf 

						aItens := {}    
						aCab := {}

						cFilAnt := (cAlias1)->C1_FILIAL
						cNumPC := CriaVar("C7_NUM",.T.)
						While ( GetSX8Len() > nSaveSX8 )
							ConfirmSx8()
						EndDo
						If ( Empty(cNumPC) )
							//cNumPC := GetSxeNum("SC7","C7_NUM")//GetNumSC7(.F.)
							cNumPC := GetSxENum("SC7","C7_NUM","C7_NUM"+(cAlias1)->C1_FILIAL,2)
						EndIf

						NFIL :=""
						NFIL :=(cAlias1)->C1_FILIAL 
						aAdd(aCab,{'C7_FILIAL' ,(cAlias1)->C1_FILIAL,Nil}) //Incluido por Barbi
						aAdd(aCab,{'C7_NUM'    ,cNumPC               ,Nil})
						aAdd(aCab,{'C7_EMISSAO',DDATABASE            ,Nil})
						If !Empty( (cAlias1)->C1_FORNECE )
							aAdd(aCab,{'C7_FORNECE',(cAlias1)->C1_FORNECE,Nil})
							aAdd(aCab,{'C7_LOJA'   ,(cAlias1)->C1_LOJA   ,Nil})
						Else
							aAdd(aCab,{'C7_FORNECE',(cAlias1)->C3_FORNECE,Nil})
							aAdd(aCab,{'C7_LOJA'   ,(cAlias1)->C3_LOJA   ,Nil})    
						EndIf
						aAdd(aCab,{'C7_COND'   ,(cAlias1)->C3_COND   ,Nil})
						aAdd(aCab,{'C7_CONTATO',""		             ,Nil})
						If !Empty( (cAlias1)->C1_FILENT )
							aAdd(aCab,{'C7_FILENT' ,(cAlias1)->C1_FILENT ,Nil})
						EndIf
						aAdd(aCab,{'C7_TPOP'   ,"F"		 		     ,Nil})
						aAdd(aCab,{'C7_MOEDA'   ,(cAlias1)->C3_MOEDA  ,Nil})

						aItens := {}
						aItem  := {}
						ccont  :=0 

						While (cAlias1)->(!EOF())  .AND. cChave == (cAlias1)->C3_FORNECE  //alteracao de MIT
							//--------------------FILIAL ENTREGA-------------------------------------------------------
							if empty((cAlias1)->ZD5_CONTRA)

								//msgalert("num"+(cAlias1)->C3_NUM)
								_cContr := (cAlias1)->C3_NUM
								_cItContr := (cAlias1)->C3_ITEM
							else
								_cContr := PADR((cAlias1)->ZD5_CONTRA,TAMSX3("C3_NUM")[1]) //Padrozina o tamanho do conteudo para o campo C3_NUM
								_cItContr := (cAlias1)->C3_ITEM
							endif

							dbSelectArea("SC3")
							SC3->(dbSetOrder(1))//C3_FILIAL+C3_NUM+C3_ITEM  //(dbSeek(xFilial("SC3")+(cAlias1)->C3_NUM+(cAlias1)->C3_ITEM))
							SC3->(dBGotop())

							//msgalert("contrato"+_cContr+(cAlias1)->C3_ITEM)
							If SC3->(dbSeek(xFilial("SC3")+_cContr+(cAlias1)->C3_ITEM))
								If (SC3->C3_QUANT - SC3->C3_QUJE) >= (cAlias1)->C1_QUANT

									SC1->(dbSetOrder(1))//C3_FILIAL+C3_NUM+C3_ITEM

									//msgalert("filial"+(cAlias1)->C1_FILIAL + (cAlias1)->C1_NUM + (cAlias1)->C1_ITEM)

									If SC1->(dbSeek((cAlias1)->C1_FILIAL + (cAlias1)->C1_NUM + (cAlias1)->C1_ITEM))    //C1_FILIAL+C1_NUM+C1_ITEM

										If aScan(aSolProc,(cAlias1)->(C1_PRODUTO + C1_NUM + C1_ITEM) ) == 0
											AADD(aSolProc, (cAlias1)->(C1_PRODUTO + C1_NUM + C1_ITEM))
										Else
											(cAlias1)->(dbSkip())
											Loop 
										EndIf

										xRet := .T.
										nQuant := SC3->C3_QUJE + (cAlias1)->C1_QUANT

										ccont :=ccont+1

										cItem  := "0000"+AllTrim(trans(ccont,"99"))							
										cItem  := right(cItem,4)

										RecLock("SC3",.F.)
										SC3->C3_QUJE := nQuant
										SC3->(MsUnLock())            

										RecLock("SC1",.F.)
										SC1->C1_QUJE 	:= (cAlias1)->C1_QUANT
										SC1->C1_PEDIDO	:= cNumPC 
										//SC1->C1_ITEMPED := StrZero(nxItem,TamSX3('C1_ITEMPED')[1])
										SC1->C1_ITEMPED := citem
										SC1->(MsUnLock())        

										//cItem  := strZero ( 0 , tamSX3("C7_ITEM")[1] )							
										//cItem  := soma1(cItem)

										//nxItem += 1 

										nValitem := (cAlias1)->C3_PRECO

										aItem := {}

										dBselectArea("SB1")
										SB1->(dbSetOrder(1))//B1_FILIAL+B1_COD

										If SB1->(dbSeek(xFilial("SB1")+(cAlias1)->C1_PRODUTO))
											cSitTrib := ""
											lIcmsZero := .F.
											nAliq := 0

											If !Empty((cAlias1)->C3_ZTES)
												SF4->(dbSetOrder(1))
												If SF4->(dbSeek(xFilial("SF4")+(cAlias1)->C3_ZTES))
													cSitTrib := SF4->F4_SITTRIB
													If cSitTrib $ "30/40/41/50/51/60"
														lIcmsZero := .T.
													Endif
												Endif
											Endif

											lRegraOri1 := .F. // tratamento por item

											If !lIcmsZero // icms nao e zero
												If SB1->B1_ORIGEM $ "1/6" // se for importado
													SA2->(dbSetOrder(1))
													If SA2->(dbSeek(xFilial("SA2")+(cAlias1)->C3_FORNECE+(cAlias1)->C3_LOJA))
														SM0->(dbSetOrder(1))
														cFilEnt := IIf(Empty((cAlias1)->C1_FILENT),cFilAnt,(cAlias1)->C1_FILENT)
														If SM0->(dbSeek(FWGrpCompany()+cFilEnt))
															If SA2->A2_EST != SM0->M0_ESTENT // se estado diferente
																nAliq := ExcFisX(SB1->B1_GRTRIB,SA2->A2_GRPTRIB,SA2->A2_EST,.F.,.T.)
																If Empty(nAliq) // se nao achou regra pela excecao, segue	
																	nAliq := GetMv("MGF_ICMPAD",,0)
																Endif	
																lRegraOri1 := .T.
															Endif
														Endif
													Endif
												Endif				

												If !lRegraOri1
													//If SB1->B1_ORIGEM $ "1/6" .or. SB1->B1_TIPO == "MO" .or. Empty(SB1->B1_ORIGEM)
													If SB1->B1_ORIGEM $ "1/6"
														nAliq := ExcFisX(SB1->B1_GRTRIB,SA2->A2_GRPTRIB,SA2->A2_EST,.T.,.F.)
														If Empty(nAliq) // se nao achou regra pela excecao, segue	
															nAliq := GetMv("MV_ICMPAD",,0)	 
														Endif	
													Elseif SB1->B1_TIPO == "MO" .or. Empty(SB1->B1_ORIGEM)	
														nAliq := 0	 
													Else
														SA2->(dbSetOrder(1))
														If SA2->(dbSeek(xFilial("SA2")+(cAlias1)->C3_FORNECE+(cAlias1)->C3_LOJA))
															SM0->(dbSetOrder(1))
															cFilEnt := IIf(Empty((cAlias1)->C1_FILENT),cFilAnt,(cAlias1)->C1_FILENT)
															If SM0->(dbSeek(FWGrpCompany()+cFilEnt))
																If SB1->B1_ORIGEM $ "0/4/5"

																	// verifica antes excecao fiscal
																	If SA2->A2_EST == SM0->M0_ESTENT
																		nAliq := ExcFisX(SB1->B1_GRTRIB,SA2->A2_GRPTRIB,SA2->A2_EST,.T.,.F.)
																	Else
																		nAliq := ExcFisX(SB1->B1_GRTRIB,SA2->A2_GRPTRIB,SA2->A2_EST,.F.,.T.)
																	Endif
																	If Empty(nAliq) // se nao achou regra pela excecao, segue	
																		If At(SA2->A2_EST,GetMv("MV_NORTE")) > 0
																			If At(SM0->M0_ESTENT,GetMv("MV_NORTE")) > 0
																				If SA2->A2_EST == SM0->M0_ESTENT
																					nAliq := Val(Subs(GetMv("MV_ESTICM"),At(SM0->M0_ESTENT,GetMv("MV_ESTICM"))+2,2))
																				Else
																					nAliq := 12
																				Endif
																			Else
																				nAliq := 12
																			Endif
																		Else
																			If At(SM0->M0_ESTENT,GetMv("MV_NORTE")) > 0
																				nAliq := 7
																			Else
																				If SA2->A2_EST == SM0->M0_ESTENT
																					nAliq := Val(Subs(GetMv("MV_ESTICM"),At(SM0->M0_ESTENT,GetMv("MV_ESTICM"))+2,2))
																				Else
																					nAliq := 12
																				Endif
																			Endif
																		Endif
																	Endif					
																Endif
																If SB1->B1_ORIGEM $ "2/3/7/8"
																	If SM0->M0_ESTENT == SA2->A2_EST 
																		nAliq := Val(Subs(GetMv("MV_ESTICM"),At(SM0->M0_ESTENT,GetMv("MV_ESTICM"))+2,2))
																	Else
																		nAliq := GetMv("MGF_ICMPAD",,0)
																	Endif
																Endif
															Endif
															SM0->(RestArea(aAreaSM0))
														Endif
													Endif
												Endif

												//tratamento para origem = 2 importados adquiridos merc interno e estado <> est. filial
												If SB1->B1_ORIGEM $ "2" // se for importado
													SA2->(dbSetOrder(1))
													If SA2->(dbSeek(xFilial("SA2")+(cAlias1)->C3_FORNECE+(cAlias1)->C3_LOJA))
														SM0->(dbSetOrder(1))
														cFilEnt := IIf(Empty((cAlias1)->C1_FILENT),cFilAnt,(cAlias1)->C1_FILENT)
														If SM0->(dbSeek(FWGrpCompany()+cFilEnt))
															If SA2->A2_EST != SM0->M0_ESTENT // se estado diferente
																nAliq := 4
															Endif
														Endif
													Endif
												Endif				



											Endif	

											If nAliq > 0
												nValitem := ROUND(nValitem/((100-nAliq)/100),6) // embute valor de icms no preco unitario
												//										nValitem := nValitem // embute valor de icms no preco unitario
											Endif	


											//msgalert("item "+(cAlias1)->C3_ZCOMP)
											//aAdd(aObs,{(cAlias1)->C3_NUM,(cAlias1)->C3_ITEM,"SC - " + ALLTRIM((cAlias1)->C1_NUM)+(cAlias1)->C1_ITEM})
											aAdd(aObs,{cNumPC,cItem,"SC - " + ALLTRIM((cAlias1)->C1_NUM)+(cAlias1)->C1_ITEM})

											_COBS := ""  // NOVA OBS 16/09/18
											_COBS := "SC - " + ALLTRIM((cAlias1)->C1_NUM)+(cAlias1)->C1_ITEM+" - "+ALLTRIM((cAlias1)->C1_OBS) // NOVA OBS 16/09/18

											aAdd(aItem,{'C7_ITEM'   ,cItem,Nil})               //cItem
											aAdd(aItem,{'C7_PRODUTO',(cAlias1)->C1_PRODUTO,Nil})
											aAdd(aItem,{'C7_QUANT'  ,(cAlias1)->C1_QUANT  ,Nil})
											aAdd(aItem,{'C7_PRECO'  , nValitem            ,Nil})
											aAdd(aItem,{'C7_TOTAL'  , Round(nValitem*(cAlias1)->C1_QUANT,2),Nil})
											aAdd(aItem,{'C7_CC'		,(cAlias1)->C1_CC     ,Nil})
											aAdd(aItem,{'C7_NUMSC'  ,_cContr              ,Nil})
											aAdd(aItem,{'C7_CLVL'   ,(cAlias1)->C1_CLVL   ,Nil})
											aAdd(aItem,{'C7_ITEMSC' ,_cItContr   ,Nil})
											aAdd(aItem,{'C7_IPI'    ,(cAlias1)->C3_IPI    ,Nil})
											aAdd(aItem,{'C7_OBS'    , _COBS ,Nil}) 
											//aAdd(aItem,{'C7_OBS'    , "SC - " + cnumsol +(cAlias1)->C1_ITEM,Nil}) 
											aAdd(aItem,{'C7_COMPRA'  ,(cAlias1)->C3_ZCODCOM    ,Nil})
											aAdd(aItem,{'C7_DATPRF'  ,(cAlias1)->C1_DATPRF    ,Nil})
											aAdd(aItem,{'C7_ITEMCTA'  ,(cAlias1)->C1_ITEMCTA    ,Nil})
											aAdd(aItem,{'C7_ZWFPC'  ,(cAlias1)->C1_ZWFPC    ,Nil})
											aAdd(aItem,{'C7_LOCAL'  ,(cAlias1)->C1_LOCAL    ,Nil}) //NOVO LOCAL 06/09/18

											zcompn := ""
											zcompn := (cAlias1)->C3_ZCODCOM

											If !Empty((cAlias1)->C3_ZTES)
												//aAdd(aItem,{'C7_TES'    ,(cAlias1)->C3_ZTES    ,Nil})
											Endif	

											// grava preco unitario antes da alteracao do icms
											If nAliq > 0
												If SC7->(FieldPos("C7_ZPRCACO")) > 0
													//aAdd(aItem,{'C7_ZPRCACO'  , (cAlias1)->C3_PRECO		,Nil})
												Endif
												If SC7->(FieldPos("C7_ZALQACO")) > 0
													//aAdd(aItem,{'C7_ZALQACO'  , nAliq		,Nil})
												Endif
											Endif

											xMntRatx((cAlias1)->C1_FILIAL ,(cAlias1)->C1_NUM ,(cAlias1)->C1_ITEM,@aRateio,cNumPC,(cAlias1)->C3_FORNECE,(cAlias1)->C3_LOJA)

											aAdd(aItens,aItem)

										EndIf 

									EndIf	

								EndIf
							EndIf
							(cAlias1)->(dbSkip())

						EndDo

					Else
						//If xRet <> .T.
						//MsgAlert("Nao  sera gerado a Autorizacao de entrega, pois nao h� contrato de parceria vigente para os Produtos da Solicitacao de compras! " )
						//EndIf
						Return
					EndIf

					If Len(aCab) > 0 .and. Len(aItens) > 0
						zUserId		:= __cUserId
						__cUserId	:= Alltrim(GetMv("MGF_USRAUT"))

						aCont := xIncPedx( aCab,aItens,aRateio )

						If aCont[1]
							alert(aCont[2])
							RollbackSx8()
							DisarmTransaction()
							cMsg += "SC numero "+cNumSol+" nao processada(erro) "+chr(13)+chr(10)

						Else
							cMsg += "SC numero "+cNumSol+" processada "+chr(13)+chr(10)

							SC7->(ConfirmSx8())


							SC7->(dbSetOrder(1))
							If SC7->(dbSeek(xFilial("SC7")+cNumPC))
								While SC7->(!Eof()) .and. xFilial("SC7")+cNumPC == SC7->C7_FILIAL+SC7->C7_NUM
									If Empty(SC7->C7_OBS)      
										//aAdd(aObs,{"SC - " + ALLTRIM((cAlias1)->C1_NUM)})
										For nCnt:=1 To Len(aObs)
											If aObs[nCnt][1] == SC7->C7_NUM .and. aObs[nCnt][2] == SC7->C7_ITEM
												SC7->(RecLock("SC7",.F.))
												SC7->C7_OBS := aObs[nCnt][3]
												SC7->(MsUnLock())
												Exit
											Endif
										Next
									Endif
									SC7->(dbSkip())
								Enddo
							Endif					

							_cQryCMP	:= " UPDATE " + RetSqlName("SC7") + " SET C7_COMPRA='"+zcompn+"' "
							_cQryCMP	+= " WHERE C7_NUM = '"+cNumPC+"' AND C7_FILIAL='"+xFilial("SC7")+"' "
							TcSqlExec(_cQryCMP)

							_cQrySOL	:= "UPDATE " + RetSqlName("SCR") + " SET CR_STATUS='03' "
							_cQrySOL	+= "WHERE CR_NUM = '"+cNumsol+"' AND CR_STATUS='02' "
							TcSqlExec(_cQrySOL)

							_cQryCMP	:= " UPDATE " + RetSqlName("SC7") + " SET C7_FILIAL='"+NFIL+"' "
							_cQryCMP	+= " WHERE C7_NUM = '"+cNumPC+"' AND C7_FILIAL='"+xFilial("SC7")+"' "
							TcSqlExec(_cQryCMP)

						EndIf

						__cUserId	:= zUserId

					Endif

				End Transaction
			endif	

		EndDo



		//If xRet <> .T.
		//	//MsgAlert("Nao  sera gerado a Autorizacao de entrega, pois nao h� contrato de parceria vigente para os Produtos da Solicitacao de compras! " )
		//EndIf
		//DbCloseArea(cAlias1)
		(cAlias1)->(DbClosearea())

		aEval(aArea,{|x| RestArea(x)})

		//If xRet = .T.	
		//cAlias2	:= GetNextAlias()
		//cQry := "SELECT C7_FILIAL,C7_ITEMSC,C7_NUM, C1_FILIAL,C1_ITEM,C1_NUM,C1_PRODUTO,C7_PRODUTO,C1_QUANT "
		//cQry += " 	FROM " + RetSqlName("SC1") + " C1, " + RetSqlName("SC7") + " C7 " 
		//cQry += "   WHERE C1.C1_NUM = '" + cNumsol + "' " 
		//cQry += "     AND C7.C7_NUM = '" + cNumPC + "' " 
		//cQry += "     AND C7_PRODUTO <> C1_PRODUTO "
		//cQry += "     AND C1.C1_FILIAL = C7.C7_FILIAL " 
		//cQry += "     AND C1.D_E_L_E_T_  <>  '*' "
		//cQry += "     AND C7.D_E_L_E_T_  <>  '*' "    


		//TG PROBLEMA COM MAIS DE UM ITEM	

		//cQry := "SELECT C1_PRODUTO,C7_PRODUTO,C1_QUANT "
		//cQry += " FROM " + RetSqlName("SC1") + " " 
		//cQry += " LEFT OUTER JOIN " + RetSqlName("SC7") + " ON C7_NUM='" + cNumPC + "' AND C7_PRODUTO=C1_PRODUTO AND SC7010.D_E_L_E_T_<>'*' AND SUBSTR(C7_OBS,12,4)=C1_ITEM "
		//cQry += " WHERE C1_NUM = '" + cNumsol + "' "
		//cQry += " AND SC1010.D_E_L_E_T_  <>  '*'     

		//cQry := ChangeQuery(cQry)
		//DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQry),cAlias2, .F., .T.)

		//While (cAlias2)->(!EOF())  
		//tratamento para mensagens de erro por falta de saldo ou pedido bloqueado.
		//IF (cAlias2)->C7_PRODUTO = " "

		//cQuery3 = " SELECT C3_QUANT,C3_QUJE,C3_DATPRF FROM " + RetSqlName("SC3") + ""
		//cQuery3 += " WHERE C3_PRODUTO='" + (cAlias2)->C1_PRODUTO +"' AND C3_CONAPRO<>'B' " 
		//cQuery3 += " AND C3_DATPRF >='" + dtos(dDatabase) + "' "
		//cQuery3 += " AND D_E_L_E_T_  <>  '*' "
		//If Select("TEMP3") > 0
		//	TEMP3->(dbCloseArea())
		//EndIf
		//cQuery3  := ChangeQuery(cQuery3)
		//dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery3),"TEMP3",.T.,.F.)
		//dbSelectArea("TEMP3")    
		//TEMP3->(dbGoTop())

		//_MSG := ""
		//While TEMP3->(!Eof())
		//	IF C3_QUANT-C3_QUJE < (cAlias2)->C1_QUANT
		//	   _MSG := "contrato sem saldo para atender "
		//	ELSE
		//	   _MSG := "Contrato nao encontrado "
		//	ENDIF
		//	TEMP3->(dbSKIP())
		//EndDo


		//MsgAlert("Nao  gerou AE para o Produto: " + (cAlias2)->C1_PRODUTO +" "+_MSG+" ")
		//Liberar o item como nao atendido na tabela SCR CR_STATUS=02
		//_cQrySOL	:= "UPDATE " + RetSqlName("SCR") + " SET CR_STATUS='02' "
		//_cQrySOL	+= "WHERE CR_NUM = '"+cNumsol+"' "
		//TcSqlExec(_cQrySOL)

		//ENDIF
		//(cAlias2)->(dbSkip())
		//END
		//ENDIF


		TEMP1->(dbSKIP())

		cnumsol :=""

	EndDo
	xfil := SPACE(06)
	scde := SPACE(06)
	scate :=SPACE(06)
	if alltrim(cMsg)<>"" //alteracao  Rafael 21/12/2018
		alert(cMsg)
	endif 
Return



Static Function xMntRatx(cxFil,cSC,cItemSC,aRateio,cNumPC,cFornec,cLoja)

	Local cNextAlias := GetNextAlias()
	Local aAux	:={}

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

		SELECT *
		FROM %Table:SCX% SCX
		WHERE 
		SCX.%notdel% AND
		SCX.CX_FILIAL = %exp:cxFil% AND
		SCX.CX_SOLICIT = %exp:cSC% AND
		SCX.CX_ITEMSOL = %exp:cItemSC%

		Order BY CX_FILIAL,CX_SOLICIT,CX_ITEMSOL

	EndSql

	(cNextAlias)->(DbGoTop())

	While (cNextAlias)->(!EOF())

		aAux := {}
		aAdd(aAux,{"CH_FILIAL"		, cxFil           			, nil})
		aAdd(aAux,{"CH_PEDIDO"		, cNumPC           			, nil})
		aAdd(aAux,{"CH_FORNECE"		, cFornec           		, nil})
		aAdd(aAux,{"CH_LOJA"		, cLoja           			, nil})		
		aAdd(aAux,{"CH_ITEMPD"		, cItemSC           		, nil}) //Nro do Item do Pedido de Compras
		aAdd(aAux,{"CH_ITEM"		, (cNextAlias)->CX_ITEM		, nil})
		aAdd(aAux,{"CH_PERC"		, (cNextAlias)->CX_PERC		, nil})
		aAdd(aAux,{"CH_CC"			, (cNextAlias)->CX_CC		, nil})
		aAdd(aAux,{"CH_CONTA"		, (cNextAlias)->CX_CONTA	, nil})
		aAdd(aAux,{"CH_ITEMCTA"		, (cNextAlias)->CX_ITEMCTA	, nil})
		aAdd(aAux,{"CH_CLVL"		, (cNextAlias)->CX_CLVL		, nil})
		aAdd(aAux,{"CH_ZFILDES"		, (cNextAlias)->CX_ZFILDES	, nil})
		aadd(aRateio,aAux)

		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

return 

Static Function xIncPedx(aCab,aItens,aRateio)
    Local cError        := ''
	Local cRet			:= ''
	Local cFld			:= ''
	Local nX			:= 0
	Local nY			:= 0
	Local nZ			:= 0
	Local aRatPedGCT	:= {}

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.

	/*For nX:= 1 to Len(a)
	For nY := 1 to Len(aRateio[nX])
	nZ++
	aAdd(aRatPedGCT,{})
	aRatPedGCT[nZ] := aRateio[nX,nY]
	Next nY
	Next nX
	nX := 0
	nY := 0*/

	If Type("_XMGFcCC")  == "U"
		Public _XMGFcCC	 := ''
	Else
		_XMGFcCC := ''
	EndIf

	//MsExecAuto({|x,y,z,w| Mata120(x,y,z,w)},2,aCab,aItens,3,,aRateio)
	//msgalert("ITENS "+str(LEN(aItens)))

	MsExecAuto({|v,x,y,z,w,a| Mata120(v,x,y,z,w,a)},2,aCab,aItens,3)

	If lMsErroAuto
		If (!IsBlind()) // COM INTERFACE GRAFICA
		cRet := MostraErro()
	    Else // EM ESTADO DE JOB
	        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
	
	        ConOut(PadC("Automatic routine ended with error", 80))
	        ConOut("Error: "+ cError)
	        
	        cRet := PadC("Automatic routine ended with error", 80) + " Error: "+ cError
	    EndIf
	Else

		For nX := 1 to Len(aRateio)

			RecLock("SCH",.T.)
			For nY := 1 to Len(aRateio[nX])

				cFld := "SCH->" + aRateio[nX,nY,1]
				&(cFld) := aRateio[nX,nY,2]

			next nY
			SCH->(MsUnlock())
		next nX

	EndIf

Return {lMsErroAuto,cret}

Static Function ExcFisX(cGrupoProd,cGrupoCli,cEst,lInt,lExt)

	Local aArea := {SF7->(GetArea()),GetArea()}
	Local nAliq := 0

	If !Empty(cGrupoProd)
		SF7->(dbSetOrder(1)) //F7_FILIAL+F7_GRTRIB
		If SF7->(DbSeek(xFilial("SF7")+cGrupoProd))
			While SF7->(!Eof()) .and. xFilial("SF7")+cGrupoProd == SF7->F7_FILIAL+SF7->F7_GRTRIB
				If SF7->F7_GRPCLI == cGrupoCli .and. (SF7->F7_EST == cEst .or. SF7->F7_EST == "**")
					If (lInt .and. !Empty(SF7->F7_ALIQINT)) .or. (lExt .and. !Empty(SF7->F7_ALIQEXT))
						If lInt
							nAliq := SF7->F7_ALIQINT
						Endif
						If lExt
							nAliq := SF7->F7_ALIQEXT
						Endif
						Exit
					Endif
				Endif
				SF7->(dbSkip())
			Enddo
		Endif
	Endif

	aEval(aArea,{|x| RestArea(x)})

Return(nAliq)
