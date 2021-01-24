#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#INCLUDE "TOPCONN.CH"

/*
=====================================================================================
Programa............: MGFCOM28()
Autor...............: Flávio Dentello
Data................: 04/04/20
17
Descricao / Objetivo: Criação de autorização de entrega
Doc. Origem.........: Compras - COM03
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/

User function MGFCOM28()

MsAguarde({|| MGFCOM28Proc()},"Verificando geração de Autorização de Entrega, aguarde...")

Return()


Static Function MGFCOM28Proc()

	Local aArea := {SC7->(GetArea()),SA2->(GetArea()),SM0->(GetArea()),GetArea()}
	Local cQuery  := " "
	Local cQry    := " "
	Local cNumsol := AllTrim(SCR->CR_NUM)
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
	Local cNumSCA := ""

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
	
/*
   	cQuery += "   INNER JOIN " + RetSqlName("ZD5") + " ZD5 "
    cQuery += "      ON   ZD5.ZD5_FILIAL = '" + xFilial("ZD5") + "' "  
    cQuery += "      AND  SC1.C1_FORNECE = ZD5.ZD5_FORNEC "
    cQuery += "      AND  SC1.C1_LOJA    = ZD5.ZD5_LOJA "
    cQuery += " 	 AND  ZD5.D_E_L_E_T_=' ' "


	cAlias1	:= GetNextAlias()

	cQuery := "SELECT * FROM " + RetSqlName("SC3") + " SC3, "+RetSqlName("SC1") + " SC1 " 
	cQuery += " WHERE SC1.C1_NUM = '" + cNumsol + "' "
	cQuery += " AND SC1.C1_FORNECE = SC3.C3_FORNECE "	
	cQuery += " AND SC1.C1_LOJA = SC3.C3_LOJA "	
	cQuery += " AND SC1.C1_PRODUTO = SC3.C3_PRODUTO "
	cQuery += " AND SC1.C1_FILIAL = '" + xFilial("SC1") + "' "
	cQuery += " AND SC3.C3_FILIAL = '" + xFilial("SC3") + "' "
	cQuery += " AND C3_DATPRI <= '" + dtos(dDatabase) + "' "
	cQuery += " AND C3_DATPRF >= '" + dtos(dDatabase) + "' "
	cQuery += " AND SC1.C1_QUANT <= (SC3.C3_QUANT - SC3.C3_QUJE) "
	cQuery += " AND SC1.D_E_L_E_T_=' ' "
	cQuery += " AND SC3.D_E_L_E_T_=' ' "
	cQuery += " AND C1_ZGEAUTE <> '2' "
	cQuery += " AND C1_PEDIDO = ' ' "
	cQuery += " ORDER BY C3_FORNECE, C1_PRODUTO, C3_DATPRI, C3_DATPRF, C3_NUM "

	cQuery := ChangeQuery(cQuery)
    //Memowrite("C:\Temp\QryC3_A.sql",cQuery)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias1, .F., .T.)

		cQuery := "SELECT C1_NUM,C1_FORNECE,C1_LOJA,C1_PRODUTO,C1_QUANT,C1_FILIAL,C1_ZGEAUTE,C1_PEDIDO,C1_FILENT,C1_ITEM,C1_QUJE,C1_ITEMPED,C1_CC,C1_CLVL,C1_ZGEAUTE,"
    	cQuery += "	C3_NUM,C3_FILIAL,C3_FORNECE,C3_LOJA,C3_PRODUTO,C3_DATPRI,C3_DATPRF,C3_QUANT,C3_QUJE,C3_ITEM,C3_COND,C3_IPI,C3_PRECO,C3_ZTES,"
    	cQuery += "	ZD5_FILIAL,ZD5_FORNEC,ZD5_LOJA,ZD5_PROD,NVL(ZD5_CONTRA,' ') AS ZD5_CONTRA"
    	cQuery += "		FROM " + RetSqlName("SC1") + " SC1 " + RetSqlName("SC3") + " SC3, " 
    	cQuery += "   LEFT JOIN " + RetSqlName("ZD5") + " ZD5 "
        cQuery += "      ON   ZD5.ZD5_FILIAL = '" + xFilial("ZD5") + "' "  
	    cQuery += "      AND  SC3.C3_FORNECE = ZD5.ZD5_FORNEC "
	    cQuery += "      AND  SC3.C3_LOJA    = ZD5.ZD5_LOJA "
	    cQuery += "      AND  SC3.C3_PRODUTO = ZD5.ZD5_PROD "
	    cQuery += " 		AND ZD5.D_E_L_E_T_=' ' " 
		cQuery += " WHERE SC1.C1_NUM = '" + cNumsol + "' "  
		cQuery += " AND SC1.C1_PRODUTO = SC3.C3_PRODUTO "
		cQuery += " AND SC1.C1_FILIAL = '" + xFilial("SC1") + "' "
		cQuery += " AND SC3.C3_FILIAL = '" + xFilial("SC3") + "' "
		cQuery += " AND C3_DATPRI <= '" + dtos(dDatabase) + "' "
		cQuery += " AND C3_DATPRF >= '" + dtos(dDatabase) + "' "
		cQuery += " AND SC1.C1_QUANT <= (SC3.C3_QUANT - SC3.C3_QUJE) "
		cQuery += " AND SC1.D_E_L_E_T_=' ' "
		cQuery += " AND SC3.D_E_L_E_T_=' ' "
		cQuery += " AND C1_ZGEAUTE <> '2' "
		cQuery += " AND C1_PEDIDO = ' ' "
		cQuery += " ORDER BY C3_FORNECE, C1_PRODUTO, C3_DATPRI, C3_DATPRF, C3_NUM "


*/
//	If (cAlias1)->(eof()) <> .F.
	
cAlias1	:= GetNextAlias()

//procura contrato na filial	   
cQuery := "SELECT C1_NUM,C1_FORNECE,C1_LOJA,C1_PRODUTO,C1_QUANT,C1_FILIAL,C1_ZGEAUTE,C1_PEDIDO,C1_FILENT,C1_ITEM,C1_QUJE,C1_ITEMPED,C1_CC,C1_CLVL,C1_ITEMCTA,C1_ZGEAUTE,C1_DATPRF,"
cQuery += "	C1_ZWFPC,C1_OBS,C1_LOCAL,C3_NUM,C3_FILIAL,C3_FORNECE,C3_LOJA,C3_PRODUTO,C3_DATPRI,C3_DATPRF,C3_QUANT,C3_QUJE,C3_ITEM,C3_COND,C3_IPI,C3_PRECO,C3_ZTES,C3_FILENT,C3_ZCODCOM,C3_MOEDA,"
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
cQuery += " SC1.C1_FILIAL = '" + xFilial("SC1") + "' "
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
cQuery += "	C1_ZWFPC,C1_OBS,C1_LOCAL,C3_NUM,C3_FILIAL,C3_FORNECE,C3_LOJA,C3_PRODUTO,C3_DATPRI,C3_DATPRF,C3_QUANT,C3_QUJE,C3_ITEM,C3_COND,C3_IPI,C3_PRECO,C3_ZTES,C3_FILENT,C3_ZCODCOM,C3_MOEDA,"
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
cQuery += " SC1.C1_FILIAL = '" + xFilial("SC1") + "' "
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
		
		Begin Transaction 

			cChave := (cAlias1)->C3_FORNECE
            lConf :=.F.
            
            //msgalert("aqui"+(cAlias1)->ZD5_CONTRA+" "+(cAlias1)->C3_NUM)
            //Se nao houver filiais no ZD5
            IF alltrim((cAlias1)->ZD5_CONTRA) = "" .and. alltrim((cAlias1)->C3_NUM) <> ""  
                  lConf :=.T.
                  msgalert ("Vai gerar pedido pelo contrato da global")
            ELSE 
            	
            	IF alltrim((cAlias1)->C3_NUM) <> "" .AND. alltrim((cAlias1)->ZD5_CONTRA) <> ""   
                  	lConf :=.T.
                  	msgalert ("Vai gerar pedido pelo contrato filial")
            	ELSE
                  	lConf :=.F.
                  	msgalert ("Contrato nao encontrado")
               	ENDIF
            ENDIF 
			
			//Alterado se não achar registro no ZD5 mas houver no SC3 vai rodar pelo contraro global. 
   			//DbCloseArea("TEMP2")
			
			If (cAlias1)->(!EOF()) .AND. lConf 
  				
  				aItens := {}    
 				aCab := {}
			
				cNumPC := CriaVar("C7_NUM",.T.)
				CNUMSCA := (cAlias1)->C1_NUM
				CNUMITA := (cAlias1)->C1_ITEM
				 
				While ( GetSX8Len() > nSaveSX8 )
					ConfirmSx8()
				EndDo
				If ( Empty(cNumPC) )
					cNumPC := GetSxeNum("SC7","C7_NUM")//GetNumSC7(.F.)
				EndIf

				//aAdd(aCab,{'C7_FILIAL' ,xFilial("SC7"),Nil}) //Incluido por Barbi
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
				//aAdd(aCab,{'C7_COMPRA' ,(cAlias1)->C3_ZCOMP  ,Nil})
				
				aItens := {}
				aItem  := {}
				ccont  :=0 
				
     			While (cAlias1)->(!EOF())  .AND. cChave == (cAlias1)->C3_FORNECE  //alteração de MIT
				   //--------------------FILIAL ENTREGA-------------------------------------------------------
					if empty((cAlias1)->ZD5_CONTRA)
						_cContr := (cAlias1)->C3_NUM
						_cItContr := (cAlias1)->C3_ITEM
					else
						_cContr := (cAlias1)->ZD5_CONTRA
						_cItContr := (cAlias1)->C3_ITEM
					endif
				    
				    dbSelectArea("SC3")
					SC3->(dbSetOrder(1))//C3_FILIAL+C3_NUM+C3_ITEM  //(dbSeek(xFilial("SC3")+(cAlias1)->C3_NUM+(cAlias1)->C3_ITEM))
                    SC3->(dBGotop())
       				If SC3->(dbSeek(xFilial("SC3")+_cContr+(cAlias1)->C3_ITEM))
						If (SC3->C3_QUANT - SC3->C3_QUJE) >= (cAlias1)->C1_QUANT

							SC1->(dbSetOrder(1))//C3_FILIAL+C3_NUM+C3_ITEM
							If SC1->(dbSeek(xFilial("SC1") + (cAlias1)->C1_NUM + (cAlias1)->C1_ITEM))    //C1_FILIAL+C1_NUM+C1_ITEM

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
								//SC1->C1_ITEMPED := StrZero(nxItem,TamSX3('C1_ITEMPED')[1])  //item do pedido
								SC1->C1_ITEMPED := cItem
								SC1->(MsUnLock())        
			                    
			                    //cItem  := strZero ( 0 , tamSX3("C7_ITEM")[1] )							
                      			//cItem  := soma1(cItem)

								//nxItem += 1 
								//ccont :=ccont+1
								
								//cItem  := "0000"+AllTrim(trans(ccont,"99"))							
                      			//cItem  := right(cItem,4)
								
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
														nAliq := ExcFis(SB1->B1_GRTRIB,SA2->A2_GRPTRIB,SA2->A2_EST,.F.,.T.)
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
												nAliq := ExcFis(SB1->B1_GRTRIB,SA2->A2_GRPTRIB,SA2->A2_EST,.T.,.F.)
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
																nAliq := ExcFis(SB1->B1_GRTRIB,SA2->A2_GRPTRIB,SA2->A2_EST,.T.,.F.)
															Else
																nAliq := ExcFis(SB1->B1_GRTRIB,SA2->A2_GRPTRIB,SA2->A2_EST,.F.,.T.)
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
									aAdd(aObs,{(cAlias1)->C3_NUM,(cAlias1)->C3_ITEM,"SC - " + ALLTRIM((cAlias1)->C1_NUM)+(cAlias1)->C1_ITEM})
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
									//aAdd(aItem,{'C7_OBS'    , "SC - " + ALLTRIM((cAlias1)->C1_NUM)+(cAlias1)->C1_ITEM,Nil}) 
									aAdd(aItem,{'C7_OBS'    , _COBS ,Nil})               // NOVA OBS 06/09/18
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
									
									xMntRat((cAlias1)->C1_FILIAL ,(cAlias1)->C1_NUM ,(cAlias1)->C1_ITEM,@aRateio,cNumPC,(cAlias1)->C3_FORNECE,(cAlias1)->C3_LOJA)
									
									aAdd(aItens,aItem)

								EndIf 

							EndIf	

						EndIf
					EndIf
					(cAlias1)->(dbSkip())
					
				EndDo
			Else
				If xRet <> .T.
					MsgAlert("Não será gerado a Autorização de entrega, pois não há contrato de parceria vigente para os Produtos da Solicitação de compras! " )
				EndIf
				Return
			EndIf

			If Len(aCab) > 0 .and. Len(aItens) > 0
				zUserId		:= __cUserId
				__cUserId	:= Alltrim(GetMv("MGF_USRAUT"))
				
				aCont := xIncPed( aCab,aItens,aRateio )
				
				If aCont[1]
					alert(aCont[2])
					RollbackSx8()
					DisarmTransaction()
				Else
					SC7->(ConfirmSx8())
					
					SC7->(dbSetOrder(1))
					If SC7->(dbSeek(xFilial("SC7")+cNumPC))
						While SC7->(!Eof()) .and. xFilial("SC7")+cNumPC == SC7->C7_FILIAL+SC7->C7_NUM
							If Empty(SC7->C7_OBS)      
							    //aAdd(aObs,{"SC - " + ALLTRIM((cAlias1)->C1_NUM)})
								For nCnt:=1 To Len(aObs)
									If aObs[nCnt][1] == SC7->C7_NUMSC .and. aObs[nCnt][2] == SC7->C7_ITEMSC
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


				EndIf

				__cUserId	:= zUserId

			Endif

		End Transaction

	EndDo

	If xRet <> .T.
		MsgAlert("Não será gerado a Autorização de entrega, pois não há contrato de parceria vigente para os Produtos da Solicitação de compras! " )
	EndIf
	DbCloseArea(cAlias1)
             
	aEval(aArea,{|x| RestArea(x)})

	If xRet = .T.	
	   cAlias2	:= GetNextAlias()
       //cQry := "SELECT C7_FILIAL,C7_ITEMSC,C7_NUM, C1_FILIAL,C1_ITEM,C1_NUM,C1_PRODUTO,C7_PRODUTO,C1_QUANT "
	   //cQry += " 	FROM " + RetSqlName("SC1") + " C1, " + RetSqlName("SC7") + " C7 " 
       //cQry += "   WHERE C1.C1_NUM = '" + cNumsol + "' " 
	   //cQry += "     AND C7.C7_NUM = '" + cNumPC + "' " 
	   //cQry += "     AND C7_PRODUTO <> C1_PRODUTO "
       //cQry += "     AND C1.C1_FILIAL = C7.C7_FILIAL " 
       //cQry += "     AND C1.D_E_L_E_T_  <>  '*' "
       //cQry += "     AND C7.D_E_L_E_T_  <>  '*' "    
	     
	
//TG PROBLEMA COM MAIS DE UM ITEM	
       
       cQry := "SELECT C1_PRODUTO,C7_PRODUTO,C1_QUANT "
	   cQry += " FROM " + RetSqlName("SC1") + " " 
	   cQry += " LEFT OUTER JOIN " + RetSqlName("SC7") + " ON C7_NUM='" + cNumPC + "' AND C7_PRODUTO=C1_PRODUTO AND SC7010.D_E_L_E_T_<>'*' AND SUBSTR(C7_OBS,12,4)=C1_ITEM "
	   cQry += " WHERE C1_NUM = '" + cNumsol + "' "
	   cQry += " AND SC1010.D_E_L_E_T_  <>  '*'     

		cQry := ChangeQuery(cQry)
		DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQry),cAlias2, .F., .T.)
                       
	   While (cAlias2)->(!EOF())  
            //tratamento para mensagens de erro por falta de saldo ou pedido bloqueado.
            IF (cAlias2)->C7_PRODUTO = " "
             
            	cQuery3 = " SELECT C3_QUANT,C3_QUJE,C3_DATPRF FROM " + RetSqlName("SC3") + ""
            	cQuery3 += " WHERE C3_PRODUTO='" + (cAlias2)->C1_PRODUTO +"' AND C3_CONAPRO<>'B' " 
				cQuery3 += " AND C3_DATPRF >='" + dtos(dDatabase) + "' "
				cQuery3 += " AND D_E_L_E_T_  <>  '*' "
				If Select("TEMP3") > 0
					TEMP3->(dbCloseArea())
				EndIf
				cQuery3  := ChangeQuery(cQuery3)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery3),"TEMP3",.T.,.F.)
				dbSelectArea("TEMP3")    
				TEMP3->(dbGoTop())
                
                _MSG := ""
				While TEMP3->(!Eof())
        			IF C3_QUANT-C3_QUJE < (cAlias2)->C1_QUANT
        			   _MSG := "contrato sem saldo para atender "
        			ELSE
        			   _MSG := "Contrato nao encontrado "
        			ENDIF
        			TEMP3->(dbSKIP())
				EndDo


	    	MsgAlert("Não gerou AE para o Produto: " + (cAlias2)->C1_PRODUTO +" "+_MSG+" ")
            //Liberar o item como não atendido na tabela SCR CR_STATUS=02
		    //_cQrySOL	:= "UPDATE " + RetSqlName("SCR") + " SET CR_STATUS='02' "
		    //_cQrySOL	+= "WHERE CR_NUM = '"+cNumsol+"' "
		    //TcSqlExec(_cQrySOL)
            
            ENDIF
            (cAlias2)->(dbSkip())
       END
	ENDIF
	//TEMP3->(dbCloseArea())
Return

User function xM28IPed(cEmpresa,cxFil,aCab,aItens,cUser,cPsw,aRateio)
	
	Local aRet := {}
	
	RpcSetEnv( cEmpresa , cxFil,cUser,cPsw)
	
		aRet := xIncPed(aCab,aItens,aRateio)
	
	RpcClearEnv()
	
Return aRet

Static Function xIncPed(aCab,aItens,aRateio)
	Local cError    := ''
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
		If (!IsBlind()) // COM INTERFACE GRÁFICA
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


// rotina chamada pelo ponto de entrada MT110TEL 
User Function COM28Tel()

Local oNewDialog := PARAMIXB[1]
Local aPosGet    := PARAMIXB[2]
Local nOpcx      := PARAMIXB[3]
Local nReg       := PARAMIXB[4]
Local oContr := Nil
Local aContr := {"Sim","Nao"} 
Local oWf		 := Nil
Local aWf		 := {"Sim","Nao"} 

Local nCompr := ""

//if inclui .or. altera
	//nCompr :=GetAdvFVal("SY1","Y1_COD",xFilial("SY1")+RetCodUsr(),3,"")
//msgalert("aqui"+csolic)
//nCompr := M->CCODCOMPR

//msgalert("aqui"+csolic+" "+nCompr)

	//cCodCompr :=.f.
//endif

If Type("__cContr") == "U"
	Public __cContr := ""
Else
	__cContr := ""
Endif
   
If !Inclui
	If SC1->C1_ZGEAUTE == "2"
		__cContr := aContr[2]
	Else
		__cContr := aContr[1]
	Endif
Endif

// WF
//If Type("__cWf") == "U"
//	Public __cWf := ""
//Else
//	__cWf := ""
//Endif
   
//If !Inclui
//	If SC1->C1_ZEMITE == "2"
//		__cWf := aWf[2]
//	Else
//		__cWf := aWf[1]
//	Endif
//Endif

aadd(aPosGet[1],0)
aadd(aPosGet[1],0)

@ aPosGet[1,1]+42,aPosGet[1,3] SAY "Gera Autorização de Entrega" Of oNewDialog PIXEL
@ aPosGet[1,1]+42,aPosGet[1,4] COMBOBOX oContr VAR __cContr ITEMS aContr When (Altera .or. Inclui) SIZE 070,10 Of oNewDialog PIXEL

//@ aPosGet[1,1]+42,aPosGet[1,5] SAY "Envio WF PC" Of oNewDialog PIXEL
//@ aPosGet[1,1]+42,aPosGet[1,6] COMBOBOX oWf VAR __cWf ITEMS aWf When (Altera .or. Inclui) SIZE 070,10 Of oNewDialog PIXEL


Return()


// rotina chamada pelo ponto de entrada MT110TEL 
User Function COM25Tel()

	Local oNewDialog 	:= PARAMIXB[1]
	Local aPosGet    	:= PARAMIXB[2]
	Local nOpcx      	:= PARAMIXB[3]
	Local nReg       	:= PARAMIXB[4]
	Local nCompr 		:= GetAdvFVal("SY1","Y1_COD",xFilial("SY1")+RetCodUsr(),3,"")
	Local naCompr 		:= GetAdvFVal("SC3","C3_ZCODCOM",xFilial("SC3")+CA125NUM,1,"")
	Local nanCompr 		:= GetAdvFVal("SC3","C3_ZNOMCOM",xFilial("SC3")+CA125NUM,1,"")
	local cCompr		:= space(40)
	Local oCompra 		:= Nil
	Local lEdit := .F.

    public cCodCompr    	:= space(03)

IF altera .or. inclui
    cCodCompr    := nCompr
	cCompr		:= PADR(GetAdvFVal("SY1","Y1_NOME",xFilial("SY1")+cCodCompr,1,""),15)

	__OXDIALOG := oNewDialog
	
//	@ aPosGet[1,1]+46,aPosGet[2,4] MSGET cCodCompr F3 CpoRetF3("Y1_ZCOMP") Picture PesqPict("SC3","C3_ZCOMP");
//							When VisualSX3("C3_ZCOMP") Valid ExistCpo("SY1",cCodCompr) .And. CheckSX3("C3_ZCOMP",cCodCompr) 	of oNewDialog PIXEL HASBUTTON

	@ aPosGet[1,1]+46,aPosGet[1,3] SAY "Comprador" Of oNewDialog PIXEL

	@ aPosGet[1,1]+46,aPosGet[2,4] MSGET cCodCompr F3 "SY1" Valid (u_fvalids(cCodCompr,aPosGet,oNewDialog,ccompr,oCompra,lEdit) .And. ExistCpo("SY1", cCodCompr)) 	of oNewDialog PIXEL HASBUTTON

	cCompr		:= PADR(GetAdvFVal("SY1","Y1_NOME",xFilial("SY1")+cCodCompr,1,""),15)

	//@ aPosGet[1,1]+46,aPosGet[1,4]+55	SAY "                    "	 of oNewDialog PIXEL

	//@ aPosGet[1,1]+46,aPosGet[1,4]+55	SAY cCompr 	 of oNewDialog PIXEL
	@ aPosGet[1,1]+46,aPosGet[1,4]+55 MSGET oCompra VAR cCompr Picture("@!") WHEN lEdit OF oNewDialog PIXEL SIZE 060,010


else
    cCodCompr    := naCompr
	cCompr		:= nanCompr

	@ aPosGet[1,1]+46,aPosGet[1,3] SAY "Comprador" Of oNewDialog PIXEL

	@ aPosGet[1,1]+46,aPosGet[2,4] SAY cCodCompr 	of oNewDialog PIXEL

	cCompr		:= PADR(GetAdvFVal("SY1","Y1_NOME",xFilial("SY1")+cCodCompr,1,""),15)

	@ aPosGet[1,1]+46,aPosGet[1,4]+55	SAY "                    " 	 of oNewDialog PIXEL
	@ aPosGet[1,1]+46,aPosGet[1,4]+55	SAY cCompr 	 of oNewDialog PIXEL

endif


return
                                                                  
User Function fValids(cCodCompr,aPosGet,oNewDialog,ccompr,oCompra,lEdit)
Local lRet := .T.
Local ccompx := cCodCompr
	
	cCompr		:= PADR(GetAdvFVal("SY1","Y1_NOME",xFilial("SY1")+ccompx,1,""),15)

	//@ aPosGet[1,1]+46,aPosGet[1,4]+55	SAY "                    " of oNewDialog PIXEL
	//@ aPosGet[1,1]+46,aPosGet[1,4]+55	SAY cCompr 	 of oNewDialog PIXEL
	@ aPosGet[1,1]+46,aPosGet[1,4]+55 MSGET oCompra VAR cCompr Picture("@!") WHEN lEdit OF oNewDialog PIXEL SIZE 060,010


// Seus campos recebendo o posicione
Return lRet


// rotina chamada pelo ponto de entrada MT110GRV
User Function COM28Grv()

If Type("__cContr") != "U"
	SC1->(RecLock("SC1",.F.))
	SC1->C1_ZGEAUTE := IIf(__cContr=="Sim","1","2")
	//SC1->C1_ZWFPC   := IIf(__cWf=="Sim","1","2")
	SC1->(MsUnLock())
Endif

Return()	 


Static Function ExcFis(cGrupoProd,cGrupoCli,cEst,lInt,lExt)

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

Static Function xMntRat(cxFil,cSC,cItemSC,aRateio,cNumPC,cFornec,cLoja)
	
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

// liberar contratos para várias filiais. 
user function MT094LBF()
 
Local lFil  		:=.F.
    
return(lfil)
