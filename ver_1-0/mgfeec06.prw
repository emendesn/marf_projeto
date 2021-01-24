#Include 'Protheus.ch'

/*/{Protheus.doc} MG100Crit
Validações do Orçamento de Exportação.
@author leonardo.kume
@since 09/01/2017
@version 1.0
@param cCampo, character, Campo
@param lMENSA, boolean, Aparece mensagem?
@param lOK, boolean, 
@return boolean, retorna se está ok
/*/
User Function MG100Crit(cCampo,lMENSA,lOK)
	Local lRet:=.T.,cOldArea:=select(),cSK:="",cMenserr:="",cCOMPERR , nVar := 0 , cSeek:="", nRec:=0, nTaxa1 , nTaxa2
	Local nOrdSY9,nTotal := 0, i,;
	bTotal := {|| nTotal += If(lConvUnid,;
	(AvTransUnid(WorkIt->EE8_UNIDAD,WorkIt->EE8_UNPRC,WorkIt->EE8_COD_I,WorkIt->EE8_SLDINI,.F.)*;
	WorkIt->EE8_PRECO),WorkIt->(EE8_SLDINI*EE8_PRECO))}
	/* By JBJ - 17/12/02
	bTotal := {|| nTotal += If(lConvUnid,;
	(AvTransUnid(WorkIt->EE8_UNPRC,WorkIt->EE8_UNIDAD,WorkIt->EE8_COD_I,WorkIt->EE8_PRECO,.F.)*;
	WorkIt->EE8_SLDINI),WorkIt->(EE8_SLDINI*EE8_PRECO))}
	*/
	//bTotal := {|| nTotal += WorkIt->(EE8_SLDINI*EE8_PRECO) }

	Local aORD:=SAVEORD({"SY9","SY6","EE9"}), lAux,  cTipmen:="",nFob:=0
	Local nA,nB,nC,nD, lAtuStatus := .t.
	Local cFil, cFilEx, cFilBr, aUnid
	Local cMsg, nSaldo, nTotalAEmb, nSldLC, nSldLCReais, cPreemb, aProdutos, lControlaPeso
	Local nPos := 0
	Local aAreaSYR := SYR->(GetArea())

	Local nTaxaSeguro := GetMv("MV_AVG0124",,10)
	Local aOrdEXJ := SaveOrd("EXJ") //MCF - 11/05/2015
	//LOCAL aORDSX3 := {SX3->(INDEXORD()),SX3->(RECNO())}
	Default lMENSA:=.T.,lOK:=.F.

	Begin Sequence

		//DFS - 05/10/12 - Verifica o tipo da variavel
		If Type("lFaturado") <> "L"
			lFaturado := .F.
		EndIf 

		Do Case



			Case cCampo = "ZZD_FABR"                                                  

			IF !Empty(M->ZZD_FABR)
				SA2->(dbSetOrder(1))
				lAux := SA2->(dbSeek(xFilial("SA2")+M->ZZD_FABR+M->ZZD_FALOJA))

				// Verifica se o fornecedor esta cadastrado ...
				lRet := ExistCpo("SA2",M->ZZD_FABR+IF(lAux,M->ZZD_FALOJA,""))

				IF lRet
					M->ZZD_FALOJA := SA2->A2_LOJA
				Endif
			EndIf

			Case cCampo = "ZZD_FORN" 

			SA2->(dbSetOrder(1))
			lAux := SA2->(dbSeek(xFilial("SA2")+M->ZZD_FORN+M->ZZD_FOLOJA))

			// Verifica se o fornecedor esta cadastrado ...
			lRet := ExistCpo("SA2",M->ZZD_FORN+IF(lAux,M->ZZD_FOLOJA,""))

			IF lRet
				M->ZZD_FOLOJA := SA2->A2_LOJA
			Endif

			Case cCampo == "ZZC_CONDPA"   //RMD - 06/09/05 - Impede que seja incluido um pedido com uma condição de pag. inexistente
			If !ExistCpo("SY6",M->ZZC_CONDPA)
				lRet := .F.
				Break
			EndIf

			Case cCampo = "ZZC_FORN"                                                  
			SA2->(dbSetOrder(1)) 

			// NCF - 28/04/2014 - Tratamento para forçar a carga da variáel de memória do campo EE7_FOLOJA uma vez detectado que a rotina automática Enchauto não
			// está gatilhando a variável quando executado a executo a partir do adapter(EECAP100) de integração com o ERP Logix.
			If AVFLAGS("EEC_LOGIX") .And. Type("lEE7Auto") <> "U" .And. lEE7Auto 
				If (nPosFornLj := aScan( aAutoCab, {|x| x[1] == "ZZC_FOLOJA"} ) ) > 0 .And. ValType(M->ZZC_FOLOJA) <> NIL .And. aAutocab[nPosFornLj][2] <> M->ZZC_FOLOJA    
					M->ZZC_FOLOJA := aAutocab[nPosFornLj][2]   
				EndIf 
			EndIf

			lAux := SA2->(dbSeek(xFilial("SA2")+M->ZZC_FORN+M->ZZC_FOLOJA))

			// Verifica se o fornecedor esta cadastrado ...
			lRet := ExistCpo("SA2",M->ZZC_FORN+IF(lAux,M->ZZC_FOLOJA,""))

			IF lRet
				M->ZZC_FOLOJA := SA2->A2_LOJA
			Endif

			CASE cCAMPO $ "ZZC_VIA/ZZC_ORIGEM/ZZC_DEST/ZZC_TIPTRA"

			If ReadVar() == "M->ZZC_VIA" .OR. (Type("lGatVia") # "U" .AND. lGatVia)   // GFP - 27/05/2014
				nVar  := 1
				If SYR->YR_ORIGEM == M->ZZC_ORIGEM .AND. SYR->YR_VIA == M->ZZC_VIA .AND. SYR->YR_DESTINO == M->ZZC_DEST
					cSeek := M->ZZC_VIA+SYR->YR_ORIGEM+SYR->YR_DESTINO
				Else
					cSeek := M->ZZC_VIA
				EndIf
			ElseIf ReadVar() == "M->ZZC_ORIGEM"
				nVar  := 2
				If SYR->YR_ORIGEM == M->ZZC_ORIGEM .AND. SYR->YR_VIA == M->ZZC_VIA .AND. SYR->YR_DESTINO == M->ZZC_DEST
					cSeek := M->ZZC_VIA+M->ZZC_ORIGEM+M->ZZC_DEST  
				Else
					cSeek := M->ZZC_VIA+M->ZZC_ORIGEM  
				EndIf
			ElseIf ReadVar() == "M->ZZC_DEST"
				nVar  := 3
				cSeek := M->ZZC_VIA+M->ZZC_ORIGEM+M->ZZC_DEST
			Else
				nVar  := 4
				cSeek := M->ZZC_VIA+M->ZZC_ORIGEM+M->ZZC_DEST+M->ZZC_TIPTRA
			Endif
			If SYR->YR_VIA <> M->ZZC_VIA .OR. SYR->YR_ORIGEM <> M->ZZC_ORIGEM	
				M->ZZC_ORIGEM := ""
			EndIf
			If SYR->YR_VIA <> M->ZZC_VIA .OR.  SYR->YR_DESTINO <> M->ZZC_DEST
				M->ZZC_DEST := ""
			EndIf
			DbSelectArea("SYR")
			DbSetOrder(1)
			If !SYR->(DbSeek(xFilial("SYR")+cSeek))
				MsgStop("A Via não está cadastrada.", "Aviso") //"A Via não está cadastrada."###"Aviso"
				lRet := .F.
				M->ZZC_VIA := ""
				M->ZZC_ORIGEM := ""
				M->ZZC_DEST := ""
				M->ZZC_TIPTRA := ""
			Else
				If nVar <= 1
					M->ZZC_VIA_DE := Posicione("SYQ",1,xFilial("SYQ")+M->ZZC_VIA,"YQ_DESCR")
					M->ZZC_ORIGEM := SYR->YR_ORIGEM
				Endif
				If nVar <= 2
					M->ZZC_DEST   := SYR->YR_DESTINO 
				Endif
				If nVar <= 3
					M->ZZC_TIPTRA := SYR->YR_TIPTRAN
				Endif
			EndIf
			SYR->(RestArea(aAreaSYR))

			If lRet .And. ! lOk  // By JPP - 06/04/2005 - 09:25 - A atualização com os dados da tabela taxas de frete só deverá ser realizada na digitação dos dados.                 


				M->ZZC_PAISDT := SYR->YR_PAIS_DE 
				M->ZZC_PAISET := SYR->YR_PAIS_DE
				M->ZZC_TRSTIM := SYR->YR_TRANS_T
				SY9->(dbSetOrder(2))
				IF SY9->(dbSeek(XFILIAL("SY9")+M->ZZC_ORIGEM))
					M->ZZC_DSCORI  := SY9->Y9_DESCR  
					M->ZZC_URFDSP := SY9->Y9_URF
					M->ZZC_URFENT  := SY9->Y9_URF
				Endif 
			Endif

			M->ZZC_DSCORI := Posicione("SY9",2,xFilial("SY9")+M->ZZC_ORIGEM,"Y9_DESCR") 
			M->ZZC_DSCDES := Posicione("SY9",2,xFilial("SY9")+M->ZZC_DEST,"Y9_DESCR")

			lREFRESH:=.T.
			Case cCampo == "ZZC_IMLOJA"
			EE9->(DbSetOrder(1))

			If !Empty(M->ZZC_IMPORT) .AND. !Empty(M->ZZC_IMLOJA)  // GFP - 27/05/2014
				cDestino := ""
				SA1->(dbSetOrder(1))
				If SA1->(dbSeek(xFilial("SA1")+M->ZZC_IMPORT+M->ZZC_IMLOJA))
					Do Case 
						Case !Empty(SA1->A1_DEST_1)
						cDestino := Posicione("SYR",4,xFilial("EE4")+SA1->A1_DEST_1,"YR_VIA") 
						Case !Empty(SA1->A1_DEST_2)
						cDestino := Posicione("SYR",4,xFilial("EE4")+SA1->A1_DEST_2,"YR_VIA")
						Case !Empty(SA1->A1_DEST_3)
						cDestino := Posicione("SYR",4,xFilial("EE4")+SA1->A1_DEST_3,"YR_VIA")
					End Case                      
				EndIf
				If !Empty(cDestino) .And. Empty(M->ZZC_VIA) //MCF - 11/05/2015
					M->ZZC_VIA := AllTrim(cDestino)
					lGatVia := .T.
					u_MG100Crit("ZZC_VIA")
					lGatVia := .F.
				EndIf
			EndIf


			Case cCampo = "ZZC_IMPORT"

			SA1->(dbSetOrder(1))
			lAux := SA1->(dbSeek(xFilial("SA1")+M->ZZC_IMPORT+M->ZZC_IMLOJA))

			// Verifica se o importador esta cadastrado ...
			lRet := ExistCpo("SA1",M->ZZC_IMPORT+IF(lAux,M->ZZC_IMLOJA,""))

			IF lRet
				M->ZZC_IMLOJA := SA1->A1_LOJA // MCF - 30/10/2015
				M->ZZC_IMPODE := SA1->A1_NOME // GFP - 07/02/2014
			Endif

			IF lRET .AND. !EMPTY(SA1->A1_CONDPAG) .AND. ! lOK
				M->ZZC_CONDPA := SA1->A1_CONDPAG
				M->ZZC_DIASPA := SA1->A1_DIASPAG
				SY6->(DBSETORDER(1))
				SY6->(DBSEEK(XFILIAL("SY6")+M->ZZC_CONDPA+STR(M->ZZC_DIASPA,2,0)))
				M->ZZC_DESCPA := MSMM(SY6->Y6_DESC_P,50,1)
			ENDIF

			If !Empty(M->ZZC_IMPORT) .AND. !Empty(M->ZZC_IMLOJA)  // GFP - 27/05/2014
				cVia := ""
			EndIf

			Case cCampo == "EE7_PEDIDO"
			IF M->EE7_STATUS <> ST_RV .And. Left(AllTrim(M->EE7_PEDIDO), 1) == "*"
				MsgInfo("O No. do Pedido não pode conter *, como simbolo inicial. Definição reservada para Pedido especial com R.V. sem vinculação.", "Itens") //
				lRet := .F.
			EndIf

			Case cCampo == "EE7_DTPEDI"
			IF M->EE7_DTPEDI > M->EE7_DTPROC
				Help(" ",1,"AVG0000083")
				lRet := .F.
			Endif

			Case cCampo =="EE7_DTSLCR"
			If !EMPTY(M->EE7_DTSLCR) .AND. M->EE7_DTSLCR < M->EE7_DTPEDI
				HELP(" ",1,"AVG0000068")
				lRET:=.F.
			ELSEIF EMPTY(M->EE7_DTSLCR)
				IF M->EE7_STATUS <> ST_RV
					M->EE7_STATUS:=ST_SC
					//atualizar descricao de status
					DSCSITEE7()
				Endif
			EndIf

			Case cCampo =="EE7_DTSLAP"
			If !EMPTY(M->EE7_DTSLAP) 
				If M->EE7_DTSLAP < M->EE7_DTPEDI
					MsgAlert("Data de Solicitação de Aprovação da Proforma não pode ser menor que a data de sua emissão!","AVISO")//HELP(" ",1,"AVG0000068")
					lRET:=.F.
				Else
					/* WFS - a aprovação de crédito ocorrerá no ERP
					ElseIf M->EE7_STATUS == ST_CL
					M->EE7_STATUS:=ST_AP
					Else
					IF ( !EMPTY(M->EE7_DTSLCR) )
					M->EE7_STATUS:=ST_LC
					ELSE
					M->EE7_STATUS:=ST_SC
					ENDIF*/
					M->EE7_STATUS:= ST_AP ////Aguardando Aprovação da Proforma
				EndIf
			ELSEIF EMPTY(M->EE7_DTSLAP)
				/* WFS - a aprovação do crédito ocorrerá no ERP.                    
				IF M->EE7_STATUS <> ST_CL
				IF ( !EMPTY(M->EE7_DTSLCR) )
				M->EE7_STATUS:=ST_LC
				ELSE
				M->EE7_STATUS:=ST_SC
				ENDIF                 
				Endif*/
				M->EE7_STATUS:= ST_PB
			EndIf
			//atualizar descricao de status
			DSCSITEE7()   

			Case cCampo =="EE7_DTAPPE"
			//atualizar status e validar se dt. aprv. proforma >=dt Pedido
			If EMPTY(M->EE7_DTAPPE)
				//IF M->EE7_STATUS <> ST_CL //wfs - a aprovação do crédito ocorrerá no ERP
				IF ( !EMPTY(M->EE7_DTSLAP) )
					M->EE7_STATUS:= ST_AP ////Aguardando Aprovação da Proforma
				ELSE
					M->EE7_STATUS:= ST_PB //Proforma em Edição //ST_CL
				ENDIF
				DSCSITEE7()
				//Endif
			ELSEIf M->EE7_DTAPPE < M->EE7_DTSLAP
				MsgAlert("Data de Aprovação da Proforma não pode ser menor que a data de Solicitação da Aprovação!","AVISO")//HELP(" ",1,"AVG0000069")
				lRET:=.F.
			ElseIf M->EE7_TOTITE==0
				HELP(" ",1,"AVG0000070")
				lRET:=.F.
			ElseIf M->EE7_DTAPPE < M->EE7_DTPEDI	
				MsgAlert('Data de aprovação da Proforma não pode ser menor que a data de sua emissão!','AVISO')
				lRET := .F.
			ElseIf EMPTY(M->EE7_DTSLAP) .And. lAPROVAPF 
				MsgAlert('Nao e possivel aprovar a Proforma uma vez que a data de solicitacao de aprovacao nao foi informada!','AVISO')
				lRET := .F.
			Else

				IF !Inclui
					aOrdEE9 := SaveOrd("EE9",1)
					lAtuStatus := ! EE9->(dbSeek(xFilial()+M->EE7_PEDIDO))
					RestOrd(aOrdEE9,.T.)
				Endif

				IF M->EE7_STATUS == ST_PA
					lAtuStatus := .f.
				Endif

				IF lAtuStatus
					M->EE7_STATUS := ST_PA
				Endif
				//atualizar descricao de status
				DSCSITEE7()
			EndIf             

			CASE cCAMPO = "EE7_GPV"
			IF M->EE7_GPV $ cNAO
				lREFRESH      := .T.
				//M->EE7_DTSLCR := M->EE7_DTPROC //LRS 29/11/2013 
				//M->EE7_DTAPCR := M->EE7_DTPROC //LRS 29/11/2013
				IF M->EE7_STATUS <> ST_RV
					M->EE7_STATUS := ST_SC //LRS 29/11/2013 - Trocado o Status para "aguardando solicitacao de credito"
					DSCSITEE7() //atualizar descricao de status
				Endif
			ENDIF
			CASE cCAMPO == "EE7_AMOSTR"

			IF !lLibCredAuto
				cOpcao := AP102CboxAmo("M->EE7_AMOSTR")  // GFP - 03/11/2015
				IF (cOpcao == "2")  // GFP - 03/11/2015
					IF M->EE7_STATUS <> ST_RV
						If lIntegra
							M->EE7_STATUS:= ST_AF               
						Else
							M->EE7_STATUS:=ST_CL
						EndIF
					Endif
				ENDIF               
				IF (cOpcao <> "2")  // GFP - 03/11/2015
					lREFRESH:=.T.
					M->EE7_DTSLCR:=M->EE7_DTPROC
					M->EE7_DTAPCR:=M->EE7_DTPROC

					// ** By JBJ - 28/08/01 - 10:59                
					IF M->EE7_STATUS <> ST_RV
						If (cOpcao == "4") .AND. lIntegra  // GFP - 03/11/2015
							M->EE7_STATUS:= ST_AF               
						Else
							M->EE7_STATUS:=ST_CL
						EndIF
					Endif
					// **

					//atualizar descricao de status               
					DSCSITEE7()

				ELSEIF (nSelecao = 3) .or. (lALTERA .AND. !lAPROVA .AND. EMPTY(M->EE7_DTAPCR)) .or. (lALTERA .AND. !lAPROVAPF .AND. If(lIntPrePed,EMPTY(M->EE7_DTAPPE),.T.) )
					lREFRESH:=.T.

					If !lOk //Não limpa quando for gravação.
						M->EE7_DTSLCR := CriaVar("EE7_DTSLCR")
						M->EE7_DTAPCR := CriaVar("EE7_DTAPCR")
						If lIntPrePed
							M->EE7_DTSLAP := CriaVar("EE7_DTSLAP")
							M->EE7_DTAPPE := CriaVar("EE7_DTAPPE")                        
						EndIf
					EndIf

					// ** By JBJ - 28/08/01 - 11:13                                
					IF M->EE7_STATUS <> ST_RV .AND. EE7->EE7_STATUS < ST_AE    // GFP - 24/10/2014
						If lIntegra .And. !lFaturado
							M->EE7_STATUS:=ST_AF
						ElseIf lFaturado //DFS - 08/11/10 - Inclusão de Status Faturado.
							M->EE7_STATUS:=ST_FA
						Else            
							If Empty(M->EE7_DTSLCR)
								M->EE7_STATUS := ST_SC //Aguardando solicitacao de credito.
							Else
								M->EE7_STATUS := ST_LC //Aguardando liberacao de credito.
							EndIf
						EndIf
					Endif
				Endif
				// **

				//atualizar descricao de status
				DSCSITEE7()
			ENDIF
			Case cCampo == "EE7_FRPREV"  //necessario lancar frete
			If Type("lEE7Auto") == "L" .And. !lEE7Auto
				SYJ->(DBSETORDER(1))
				SYJ->(DBSEEK(XFILIAL("SYJ")+M->EE7_INCOTE))
				If SYJ->YJ_CLFRETE $ cSim .and. M->EE7_FRPREV==0
					If AVFLAGS("EEC_LOGIX_PREPED") //05/05/2014 - Não permite gravar seguro zerado se incoterm prever Seguro 
						lRet:=.F.                   //             e integração para envio do pedido ao ERP LOGIX estiver ativa
					Else
						lRet:=.T.
					EndIf
					HELP(" ",1,"AVG0000066",,"FRETE",2,1)
				ElseIf SYJ->YJ_CLFRETE $ cNao .AND. M->EE7_FRPREV#0
					lRet:=.F.
					M->EE7_FRPREV:=0
					HELP(" ",1,"AVG0000067",,"FRETE",2,1)
				EndIf
			Else
				lRet := .T.
			EndIf

			Case cCampo == "EE7_SEGPRE" .OR. cCampo == "EE7_SEGURO"
			SYJ->(dbSetOrder(1))
			SYJ->(dbSeek(XFILIAL("SYJ")+M->EE7_INCOTE))

			//ER - Utilização de Parametro para Calcular taxa de Seguro
			nTaxaSeguro := 1 + (nTaxaSeguro / 100)

			If cCampo == "EE7_SEGURO"
				IF ( M->EE7_SEGURO#0 )
					IF M->EE7_PRECOA $ cSim
						nRecNo := WorkIt->(RecNo())
						WorkIt->(dbGoTop())
						WorkIt->(dbEval(bTotal,{||.t.}))
						WorkIt->(dbGoTo(nRecNo))

						IF EE7->(FieldPos("EE7_DESSEG")) > 0 .And. M->EE7_DESSEG == "1" //LRS - 11/09/2015
							nA            := nTOTAL + M->EE7_FRPREV - M->EE7_DESCON
						Else
							nA            := nTOTAL+M->EE7_FRPREV
						EndIF

						nB            := (M->EE7_SEGURO/100) * nTaxaSeguro
						nC            := 1 - nB
						nD            := nA / nC

						If GetMv("MV_AVG0183", .F., .F.) //habilita o cálculo direto do seguro previsto (total x percentual do seguro)
							//WFS 28/07/2009 - Alterado como melhoria, conforme chamado 077797.
							M->EE7_SEGPRE := ROUND(nA * nB,AVSX3("EE7_SEGPRE",AV_DECIMAL))
						Else
							M->EE7_SEGPRE := ROUND(nD-nA,AVSX3("EE7_SEGPRE",AV_DECIMAL))
						EndIf
					Else 
						M->EE7_SEGPRE := ROUND(M->EE7_TOTPED*nTaxaSeguro*(M->EE7_SEGURO/100),AVSX3("EE7_SEGPRE",AV_DECIMAL))                
					Endif
				Else
					If lMENSA .And. M->EE7_TIPSEG == "1"
						M->EE7_SEGPRE := 0
					EndIf

				Endif
			ElseIf cCampo == "EE7_SEGPRE"
				/*
				If M->EE7_SEGPRE # 0
				If M->EE7_PRECOA $ cSim
				nRecNo := WorkIt->(RecNo())
				WorkIt->(dbGoTop())
				WorkIt->(dbEval(bTotal,{||.t.}))
				WorkIt->(dbGoTo(nRecNo))
				nA            := nTOTAL+M->EE7_FRPREV
				nC            := nA/(M->EE7_SEGPRE + nA)
				nB            := 1 - nC
				nSeguro       := ((nB * 100) / nTaxaSeguro)
				M->EE7_SEGURO := ROUND(nSeguro, AVSX3("EE7_SEGURO",AV_DECIMAL))
				Else
				nSeguro       := (M->EE7_SEGPRE /(M->EE7_TOTPED * nTaxaSeguro)) * 100
				M->EE7_SEGURO := Round(nSeguro, AvSx3("EE7_SEGURO", AV_DECIMAL))
				EndIf
				Else
				If lMensa
				M->EE7_SEGURO := 0
				EndIf
				EndIf
				*/
				If lMensa .And. !lOk
					M->EE7_SEGURO := 0
				EndIf
			EndIf

			If Type("lEE7Auto") == "L" .And. !lEE7Auto
				If SYJ->YJ_CLSEGUR $ cSim .and. (M->EE7_SEGPRE==0.AND.M->EE7_SEGURO==0)
					If AVFLAGS("EEC_LOGIX_PREPED") //05/05/2014 - Não permite gravar seguro zerado se incoterm prever Seguro 
						lRet:=.F.                   //             e integração para envio do pedido ao ERP LOGIX estiver ativa
					Else
						lRet:=.T.
					EndIf
					IF ( lMENSA )
						HELP(" ",1,"AVG0000066",,"SEGURO",2,1)
					ENDIF
				ElseIf SYJ->YJ_CLSEGUR $ cNao .AND. (M->EE7_SEGPRE#0.OR.M->EE7_SEGURO#0)
					lRet:=.F.
					M->EE7_SEGPRE:=0
					M->EE7_SEGURO:=0
					IF ( lMENSA )
						HELP(" ",1,"AVG0000067",,"SEGURO",2,1)
					ENDIF
				EndIf                
			Else
				lRet := .T.
			EndIf             

			// by CAF 15/03/2000 14:07
			IF lMensa
				AP100PrecoI()
			Endif

			lREFRESH:=.T.                                       

			// ** JBJ - 27/07/01    



			Case cCampo = "EE7_BENEF"                                                  
			IF !Empty(M->EE7_BENEF)           
				SA2->(dbSetOrder(1))
				lAux := SA2->(dbSeek(xFilial("SA2")+M->EE7_BENEF+M->EE7_BELOJA))

				// Verifica se o fornecedor esta cadastrado ...
				lRet := ExistCpo("SA2",M->EE7_BENEF+IF(lAux,M->EE7_BELOJA,""))

				IF lRet
					M->EE7_BELOJA := SA2->A2_LOJA
				Endif
			EndIf
			//JBJ - 08/08/2001 - 11:54                                  

			Case cCampo = "EE7_CLIENT"
			IF !Empty(M->EE7_CLIENT)
				SA1->(dbSetOrder(1))
				lAux := SA1->(dbSeek(xFilial("SA1")+M->EE7_CLIENT+M->EE7_CLLOJA))

				// Verifica se o fornecedor esta cadastrado ...
				lRet := ExistCpo("SA1",M->EE7_CLIENT+IF(lAux,M->EE7_CLLOJA,""))

				IF lRet
					M->EE7_CLLOJA := SA1->A1_LOJA
				Endif
			Else
				If lIntermed
					/* by jbj - 24/06/04 17:44 - Com a rotina de off-shore ativa o cliente
					passa a ser obrigatório na filial do Brasil */
					If (M->EE7_INTERM $ cSim) .And.;
					(xFilial("EE7") == cFilBr) //AllTrim(GetMv("MV_AVG0023",,"")))

						If Empty(M->EE7_CLIENT)
							MsgInfo("O campo '"+AvSx3("EE7_CLIENT",AV_TITULO)+"' na pasta '"+AvSx3("EE7_CLIENT",15)+"' deve ser "+ENTER+;
							"informado para processos com tratamentos de off-shore.","Atencao") 
							lRet:=.f.
						EndIf

						// lRet:=NaoVazio(M->EE7_CLIENT)
					Else
						lRet:=Vazio(M->EE7_CLIENT)
					EndIf
				Else
					lRet:=Vazio(M->EE7_CLIENT)
				EndIf
			EndIf

			Case cCampo = "EEN_IMPORT"
			IF !Empty(M->EEN_IMPORT)
				// ** JPM 03/11/04 - alterações na validação de notifys
				// Verifica se o Notify esta cadastrado ... 
				SA1->(dbSetOrder(1))
				If SA1->(dbSeek(xFilial("SA1")+M->EEN_IMPORT+IF(!Empty(M->EEN_IMLOJA),M->EEN_IMLOJA,"")))
					If !(SA1->A1_TIPCLI $ "3/4")
						MsgStop("O código informado não corresponde a um cliente do tipo " + BSCXBOX("A1_TIPCLI","3") + ".","Aviso" )// //   
						lRet := .f.
					Else
						M->EEN_IMLOJA := SA1->A1_LOJA                 
					EndIf              
				Else
					MsgStop("Notify não Cadastrado.","Aviso")// //                              
					lRet:=.f.              
				EndIf                            
				/*
				SA1->(dbSetOrder(1))
				lAux := SA1->(dbSeek(xFilial("SA1")+M->EEN_IMPORT+M->EEN_IMLOJA))

				// Verifica se o fornecedor esta cadastrado ...
				lRet := ExistCpo("SA1",M->EEN_IMPORT+IF(lAux,M->EEN_IMLOJA,""))

				IF lRet
				M->EEN_IMLOJA := SA1->A1_LOJA
				Endif*/
			EndIf

			Case cCampo = "EE7_MOTSIT"                                                  
			IF !Empty(M->EE7_MOTSIT)
				// Verifica se a descrição esta cadastrada ...
				lRet := ExistCpo("EE4",M->EE7_MOTSIT)

				cTipmen := Posicione("EE4",1,xFilial("EE4")+M->EE7_MOTSIT,"EE4_TIPMEN")                      
				If lRet .And. (Val(SubStr(cTipmen,1,1))#1)
					Help(" ",1,"AVG0005072")// O item selecionado não é uma descrição valida
					lRet:= .F.               
				Endif 
			Endif
			Case cCampo = "EE8_PRECO"
			// ** By JBJ - 27/06/02 - 10:35 ...
			If !lCommodity
				lRet:=NaoVazio(M->EE8_PRECO)
			EndIf
			//RMD - 31/08/05
			If GetMv( "MV_EECFAT",,.F.) .And. AVSX3("EE8_PRECO",AV_DECIMAL) > AVSX3("C6_PRCVEN",AV_DECIMAL)
				cPreco := STR(M->EE8_PRECO,,AVSX3("EE8_PRECO",AV_DECIMAL))
				nDecimais := AVSX3("EE8_PRECO",AV_DECIMAL) - AVSX3("C6_PRCVEN",AV_DECIMAL)

				For i := 1 to nDecimais
					If !(SUBSTR(cPreco,-i,1) $ "0")
						//                     MsgInfo(STR0082 + ALLTRIM(STR(AVSX3("C6_PRCVEN",AV_DECIMAL))) + STR0083,AVSX3("EE8_PRECO",AV_TITULO))
						lRet := .F.
						Exit
					EndIf 
				Next            
			EndIf   

			If GetMv("MV_EECFAT",.F.,.F.) .And. nOpcI <> INC_DET
				If WorkIt->EE8_PRECO <> M->EE8_PRECO
					If IsFaturado(WorkIt->EE8_PEDIDO,WorkIt->EE8_SEQUEN)
						MsgInfo("Esse item possui NFs geradas no Faturamento. Para alterar o Preço Unitário estorne a NF","Atenção")//
						lRet := .F.
						Break
					EndIf
				EndIf
			EndIf

			//** By JBJ - 26/07/01 8:40
			/*    
			Case cCampo$"EE7_IMPORT/EE7_IMLOJA" 
			IF ( EMPTY(M->EE7_ENDIMP).OR.EMPTY(M->EE7_END2IM).OR.(INCLUI.AND.!lOK) )
			M->EE7_ENDIMP := EECMEND("SA1",1,M->EE7_IMPORT,.T.)[1]
			M->EE7_END2IM := EECMEND("SA1",1,M->EE7_IMPORT,.T.)[2]                                    
			ENDIF
			IF ( EMPTY(M->EE7_IDIOMA) )
			M->EE7_IDIOMA:=POSICIONE("SYA",1,XFILIAL("SYA")+POSICIONE("SA1",1,XFILIAL("SA1")+M->EE7_IMPORT+M->EE7_IMLOJA,"A1_PAIS"),"YA_IDIOMA")
			ENDIF
			Case cCampo$"EE7_BENEF/EE7_BELOJA" 
			IF ( EMPTY(M->EE7_ENDBEN).OR.EMPTY(M->EE7_END2BE).OR.(INCLUI.AND.!lOK) )                
			M->EE7_ENDBEN := EECMEND("SA2",1,M->EE7_BENEF,.T.)[1]
			M->EE7_END2BE := EECMEND("SA2",1,M->EE7_BENEF,.T.)[2]
			ENDIF
			*/  

			Case cCampo=="EE7_TIPCOM"  //informar tipo de comissao
			IF ! lOk
				If (EMPTY(M->EE7_TIPCOM) .AND. !EMPTY(M->EE7_TIPCVL) .AND. !EMPTY(M->EE7_VALCOM)) .OR. ;
				(EMPTY(M->EE7_TIPCOM) .AND. EMPTY(M->EE7_TIPCVL) .AND. !EMPTY(M->EE7_VALCOM)) .OR. ;
				(EMPTY(M->EE7_TIPCOM) .AND. !EMPTY(M->EE7_TIPCVL) .AND. EMPTY(M->EE7_VALCOM))
					lRet:=.F.
					HELP(" ",1,"AVG0000036")
					// ** By JBJ - 03/04/02 - 11:10
					//ELSEIF M->EE7_VALCOM==0
					//    M->EE7_TIPCOM:=""
				EndIf
			Endif
			Case cCAMPO=="EE7_TIPCVL"  //informar tipo de valor de comissao
			IF !lOk
				If (!EMPTY(M->EE7_TIPCOM) .AND. EMPTY(M->EE7_TIPCVL) .AND. !EMPTY(M->EE7_VALCOM)) .OR. ;
				(EMPTY(M->EE7_TIPCOM)  .AND. EMPTY(M->EE7_TIPCVL) .AND. !EMPTY(M->EE7_VALCOM)) .OR. ;
				(!EMPTY(M->EE7_TIPCOM) .AND. EMPTY(M->EE7_TIPCVL) .AND. EMPTY(M->EE7_VALCOM))
					lRet:=.F.
					HELP(" ",1,"AVG0000060")  
					// ** By JBJ - 03/04/02 - 11:10    
					//ELSEIF M->EE7_VALCOM==0
					//    M->EE7_TIPCVL:=""
				EndIf
			Endif

			If M->EE7_TIPCVL = "3" .And. EE8->(FieldPos("EE8_PERCOM")) = 0
				MsgInfo("Opcao invalida. O campo EE8_PERCOM não existe na base !","Aviso") //
				lRet:=.f.
			EndIf

			Case cCAMPO=="EE7_VALCOM"  //informar comissao
			If (!EMPTY(M->EE7_TIPCOM) .AND. !EMPTY(M->EE7_TIPCVL) .AND. EMPTY(M->EE7_VALCOM)) .OR. ;
			(!EMPTY(M->EE7_TIPCOM) .AND. EMPTY(M->EE7_TIPCVL) .AND. EMPTY(M->EE7_VALCOM)) .OR. ;
			(EMPTY(M->EE7_TIPCOM) .AND. !EMPTY(M->EE7_TIPCVL) .AND. EMPTY(M->EE7_VALCOM))
				WorkAg->(dbGoTop())
				lRet:=.T.
				While !WorkAg->(Eof())
					If LEFT(WorkAg->EEB_TIPOAG,1)==CD_AGC  //agente a receber comissao
						lRet:=.F.
						Exit
					EndIf
					WorkAg->(DBSKIP(1))
				Enddo
				IF !lRet
					HELP(" ",1,"AVG0000077")
					// ** By JBJ 03/04/2002 - 14:02
					//ELSE
					//M->EE7_TIPCVL:=""
					//M->EE7_TIPCOM:=""
					//HELP(" ",1,"AVG0000076")
				Endif   
			Else //exigir um agente que deve receber comisao
				/* by CAF 13/03/2002 SMagalhães (Tem comissão, mas não sabe quem é o agente.)
				IF ( !EMPTY(M->EE7_VALCOM))
				WorkAg->(dbGoTop())
				lRet:=.F.
				While !WorkAg->(EOF())
				If LEFT(WorkAg->EEB_TIPOAG,1)==CD_AGC  //agente a receber comissao
				lRet:=.T.
				EndIf
				WorkAg->(DBSKIP(1))
				End
				IF ( !lRET )
				HELP(" ",1,"AVG0000072")
				ENDIF                  
				ENDIF   
				*/
			EndIf

			// ** By JBJ - 03/04/02 11:14
			If M->EE7_TIPCVL = "1"
				If M->EE7_VALCOM > 99.99
					MsgInfo("A porcentagem de comissão deve ser inferior a 100 %","Aviso") //
					Return .f. 
				EndIf
			ElseIf M->EE7_TIPCVL = "2"
				nFob := (M->EE7_TOTPED+M->EE7_DESCON)-(M->EE7_FRPREV+M->EE7_FRPCOM+M->EE7_SEGPRE+;
				M->EE7_DESPIN+AvGetCpo("M->EE7_DESP1")+;
				AvGetCpo("M->EE7_DESP2"))
				IF nFob > 0
					If M->EE7_VALCOM >= nFob
						MsgInfo("O valor da comissão deve ser inferior ao valor FOB.","Aviso")  //
						Return .f.
					EndIf
				EndIf
				/*
				IF M->EE7_TOTPED <> 0 // by CAF 20/07/2002
				nFob := (M->EE7_TOTPED+M->EE7_DESCON)-(M->EE7_FRPREV+M->EE7_FRPCOM+M->EE7_SEGPRE+M->EE7_DESPIN+AvGetCpo("M->EE7_DESP1")+AvGetCpo("M->EE7_DESP2"))
				If M->EE7_VALCOM >= nFob
				MsgInfo(STR0042,STR0038)  //"O valor da comissão deve ser inferior ao valor FOB."###"Aviso"
				Return .f.
				EndIf
				Endif
				*/
			EndIf
			Case cCAMPO=="EE7_LC_NUM"      

			EEL->(DbSetOrder(1))   

			If EEL->(DbSeek(xFilial("EEL")+M->EE7_LC_NUM)) .And. EECFlags("ITENS_LC")
				If Posicione("EE7",1,M->(EE7_FILIAL+EE7_PEDIDO),"EE7_LC_NUM") <> M->EE7_LC_NUM .And. EEL->EEL_FINALI $ cSim // Se a L/C estiver finalizada, não pode ser utilizada
					MsgStop("Esta Carta de Crédito já está finalizada. Sendo assim, não poderá ser utilizada.","Aviso") // 
					lRet := .f.
					Break
				EndIf
			EndIf

			If lNRotinaLC .And. !EECFlags("ITENS_LC")// JPM - 28/12/04 - Nova Rotina de Carta de Crédito

				nRec := EE7->(RecNo())
				/*EE9->(DbSetOrder(1))
				If EE9->(DbSeek(xFilial("EE9")+M->EE7_PEDIDO))
				If !Empty(M->EE7_PEDIDO) .And. Posicione("EE7",1,xFilial("EE7")+M->EE7_PEDIDO,"EE7_LC_NUM") <> M->EE7_LC_NUM
				MsgInfo(STR0070,STR0038)//"A carta de crédito não poderá ser alterada, pois este pedido já possui embarque.","Aviso"
				lRet := .f.
				EndIf
				EndIf*/

				If !Empty(M->EE7_LC_NUM) .And. lRet

					EE9->(DbSetOrder(1))
					EEC->(DbSetOrder(1))
					nSaldo := 0
					nTotalAEmb := 0

					nRec2 := WorkIt->(RecNo())
					WorkIt->(DbGoTop())
					While WorkIt->(!EoF())
						nSaldo  := WorkIt->EE8_SLDATU
						cPreemb := ""
						If EE9->(dbSeek(xFilial("EE9")+M->EE7_PEDIDO+WorkIt->EE8_SEQUEN))
							While EE9->(!Eof()) .And. EE9->EE9_FILIAL == xFilial("EE9") .And.;
							EE9->EE9_PEDIDO == M->EE7_PEDIDO .And.;
							EE9->EE9_SEQUEN == WorkIt->EE8_SEQUEN
								If EE9->EE9_PREEMB <> cPreemb
									EEC->(DbSeek(xFilial("EEC")+EE9->EE9_PREEMB))
									cPreemb := EE9->EE9_PREEMB
								EndIf
								If Empty(EEC->EEC_DTEMBA) .And. If(lMultiOffShore,Empty(EEC->EEC_NIOFFS),.t.)
									nSaldo += EE9->EE9_SLDINI
								EndIf
								EE9->(DbSkip())
							EndDo
						EndIf

						IF lConvUnid 
							nTotalAEmb += AvTransUnid(WorkIt->EE8_UNIDAD, WorkIt->EE8_UNPRC,WorkIt->EE8_COD_I,;
							nSaldo,.F.)*WorkIt->(EE8_PRCUN-If(GetMv("MV_AVG0085",,.f.),EE8_VLDESC/EE8_SLDINI,0)) 
							WorkIt->(DbSkip())          
						Else                                                                                                                                                                        
							nTotalAEmb += nSaldo * WorkIt->(EE8_PRCUN-If(GetMv("MV_AVG0085",,.f.),EE8_VLDESC/EE8_SLDINI,0) )//Se o MV está ligado, o desconto não está sendo incluído no preço do item
							WorkIt->(DbSkip())
						EndIf      
					EndDo
					WorkIt->(DbGoTo(nRec2))

					nTaxa1 := 1
					nTaxa2 := 1

					If EEL->EEL_MOEDA <> "R$ " 
						nTaxa1 := BuscaTaxa(EEL->EEL_MOEDA,dDataBase)
					Endif
					If M->EE7_MOEDA <> "R$ " 
						nTaxa2 := BuscaTaxa(M->EE7_MOEDA,dDataBase)
					Endif

					nSldLC := EEL->EEL_SLDEMB
					nSldLCReais := (EEL->EEL_SLDEMB * nTaxa1)
					lRet := (Round(nSldLCReais,2) >= Round(nTotalAEmb * nTaxa2,2))

					If !lRet
						//                     cMsg := STR0071+Alltrim(M->EE7_LC_NUM)+STR0072+AllTrim(M->EE7_MOEDA)+" "
						cMsg += AllTrim(Transf(nTotalAEmb,AvSx3("EE7_TOTPED",AV_PICTURE)))
						If M->EE7_MOEDA <> "R$ " .And. M->EE7_MOEDA <> EEL->EEL_MOEDA
							cMsg += " (R$ "+AllTrim(Transf(Round(nTotalAEmb * nTaxa2,2),;
							AvSx3("EE7_TOTPED",AV_PICTURE)))+")"
						EndIf   
						//                     cMsg += STR0073+AllTrim(EEL->EEL_MOEDA)+" "
						cMsg += AllTrim(Transf(nSldLC,AvSx3("EEL_SLDEMB",AV_PICTURE)))
						If EEL->EEL_MOEDA <> "R$ " .And. M->EE7_MOEDA <> EEL->EEL_MOEDA
							cMsg += " (R$ " +AllTrim(Transf(Round(nSldLCReais,2),;
							AvSx3("EEL_SLDEMB",AV_PICTURE)))+")"
						EndIf
						cMsg += "."

						MsgStop(cMsg,"Aviso")
						//"O Saldo da L/C "##" não é suficiente."
						// Saldo necessário: "##". Saldo L/C: "## ,"Aviso"
					EndIf

					EE7->(DbGoTo(nRec))

				EndIf

				If !lRet
					Break
				EndIf

			EndIf       

			If !lOk .And. EECFlags("ITENS_LC")
				nRec := WorkIt->(RecNo())
				/*
				WorkIt->(DbGoTop())
				While WorkIt->(!EoF())
				WorkIt->EE8_LC_NUM := M->EE7_LC_NUM
				WorkIt->EE8_SEQ_LC := CriaVar("EE8_SEQ_LC")
				WorkIt->(DbSkip())
				EndDo
				*/
				WorkIt->(DbGoTop())
				If !Ae107AtuIt()
					lRet := .f.
				EndIf

				WorkIt->(DbGoTo(nRec))
				oMsSelect:oBrowse:Refresh()
				If !lRet
					Break
				EndIf

			EndIf


			Case cCampo == "EE8_LC_NUM" // JPM - 15/07/05

			If !Empty(M->EE8_LC_NUM)
				If M->EE8_LC_NUM <> M->EE7_LC_NUM
					M->EE7_LC_NUM := CriaVar("EE7_LC_NUM")
				EndIf

				If Posicione("EEL",1,xFilial("EEL")+M->EE8_LC_NUM,"EEL_FINALI") $ cSim
					MsgStop("Esta Carta de Crédito já está finalizada. Sendo assim, não poderá ser utilizada.","Aviso") // 
					lRet := .f.
					Break               
				EndIf

				If EEL->EEL_CTPROD $ cNao //só valida se a L/C não controlar produtos. Se controla, esta validação é feita no preenchimento da sequência da L/C
					If !Ae107ValIt(OC_PE,If(nOPCI == INC_DET,WorkIt->(RecNo()),0) )
						lRet := .f.
						Break
					EndIf
				EndIf   
			Else
				If !Empty(M->EE7_LC_NUM)
					M->EE7_LC_NUM := CriaVar("EE7_LC_NUM")
				EndIf
			EndIf

			Case cCAMPO == "EE8_SEQ_LC" // JPM - 19/07/05

			If !Empty(M->EE8_SEQ_LC)
				If Posicione("EXS",1,xFilial("EXS")+M->EE8_LC_NUM+M->EE8_SEQ_LC,"EXS_COD_I" ) <> M->EE8_COD_I
					MsgInfo("O Produto da Sequência de L/C informada não é igual ao Produto do item atual.","Aviso") // 
					lRet := .f.
					Break
				EndIf

				If !Ae107ValIt(OC_PE,If(nOPCI == INC_DET,0,WorkIt->(RecNo())) )
					lRet := .f.
					Break
				EndIf
			EndIf


			CASE cCAMPO == "EE7_LICIMP"
			IF ( M->EE7_EXLIMP $ cSim .AND. EMPTY(M->EE7_LICIMP))
				lRET:=.F.
				HELP(" ",1,"AVG0000073")
			ENDIF
			CASE cCAMPO == "EE7_DTLIMP"
			IF ( (M->EE7_EXLIMP $ cSim .OR. !EMPTY(M->EE7_LICIMP)).AND.EMPTY(M->EE7_DTLIMP) )
				lRET:=.F.
				HELP(" ",1,"AVG0000074")
			ENDIF 


			CASE cCAMPO == "EE7_CONSIG"
			// LCS - 19/09/2002 - TODA A CONSISTENCIA
			IF ! EMPTY(M->EE7_CONSIG)
				IF ! EXISTCPO("SA1",M->EE7_CONSIG+IF(!EMPTY(M->EE7_COLOJA),M->EE7_COLOJA,""))
					lRET := .F.
				ELSE
					SA1->(DBSETORDER(1))
					SA1->(DBSEEK(XFILIAL("SA1")+M->EE7_CONSIG+IF(!EMPTY(M->EE7_COLOJA),M->EE7_COLOJA,"")))
					IF SA1->A1_TIPCLI # "2" .AND.;  // CONSIGNATARIO
					SA1->A1_TIPCLI # "4"         // TODOS
						*
						MSGINFO("Codigo invalido para Consignatario !","Atencao") //
						lRET := .F.
					ENDIF
				ENDIF
				IF lRET
					AP100CRIT("EE7_MARCAC")
				ENDIF
			ENDIF
			Case cCampo == "EEB_TIPCVL"
			If lTratComis//JPM - 01/02/05 - Nova validação para não haver ag. de perc. p/ item e de Valor Fixo/Percentual no mesmo processo.
				nRec := WorkAg->(RecNo())
				WorkAg->(DbGoTop())
				While WorkAg->(!EoF())
					/*If WorkAg->(EEB_CODAGE) == M->EEB_CODAGE .Or. Left(WorkAg->EEB_TIPOAG,1) <> CD_AGC Nopado por MCF - 01/10/2015 
					WorkAg->(DbSkip())
					Loop
					EndIf*/
					If M->EEB_TIPCVL = "3" // Comissão por item.   
						If WorkAg->EEB_TIPCVL <> "3"
							MsgStop("Não podem haver agentes de percentual por item e agentes com outro tipo de valor de comissão em um mesmo processo.","Aviso")//
							lRet := .f.
						EndIf
					Else
						If WorkAg->EEB_TIPCVL = "3"
							MsgStop("Não podem haver agentes de percentual por item e agentes com outro tipo de valor de comissão em um mesmo processo.Já existe(m) agente(s) com o tipo do valor de comissão 'percentual por item'.","Aviso")//
							lRet := .f.
							M->EEB_VALCOM := 0 //MCF - 03/09/2015
						EndIf  
					EndIf
					If !lRet
						WorkAg->(DbGoto(nRec))
						Break
					EndIf   
					WorkAg->(DbSkip())
				EndDo
				WorkAg->(DbGoto(nRec))
			EndIf

			If M->EEB_TIPCVL = "3" // Comissão por item.   
				MsgInfo("O percentual para este tipo de comissão, deve ser informado "+ENTER+;  //
				"na tela de edição de itens.","Aviso") // "Aviso" //
				M->EEB_VALCOM := 0 //MCF - 03/09/2015
			EndIf

			Case cCampo == "EEB_VALCOM"
			If Type("M->EE7_TOTPED") <> "U"
				cAlias := "EE7"
			Else
				cAlias := "EEC"
			EndIf

			If M->EEB_TIPCVL = "1"
				If M->EEB_VALCOM > 99.99
					MsgInfo("A porcentagem de comissão deve ser inferior a 100 %","Aviso") //
					lRet := .f. 
				EndIf
			ElseIf M->EEB_TIPCVL = "2"
				nFob := EECFob(If(cAlias == "EE7",OC_PE,OC_EM))
				/*nFob := (M->&(cAlias+"_TOTPED")+M->&(cAlias+"_DESCON"))-(M->&(cAlias+"_FRPREV")+;
				M->&(cAlias+"_FRPCOM")+M->&(cAlias+"_SEGPRE")+;
				M->&(cAlias+"_DESPIN")+AvGetCpo("M->"+cAlias+"_DESP1")+;
				AvGetCpo("M->"+cAlias+"_DESP2")) */
				IF nFob > 0
					If M->EEB_VALCOM >= nFob
						MsgInfo("O valor da comissão deve ser inferior ao valor FOB.","Aviso")  //
						Return .f.
					EndIf
				Endif
				/*
				IF M->&(cAlias+"_TOTPED") <> 0
				nFob := (M->&(cAlias+"_TOTPED")+M->&(cAlias+"_DESCON"))-(M->&(cAlias+"_FRPREV")+;
				M->&(cAlias+"_FRPCOM")+M->&(cAlias+"_SEGPRE")+M->&(cAlias+"_DESPIN")+;
				AvGetCpo("M->"+cAlias+"_DESP1")+AvGetCpo("M->"+cAlias+"_DESP2"))

				If M->EEB_VALCOM >= nFob
				MsgInfo(STR0042,STR0038)  //"O valor da comissão deve ser inferior ao valor FOB."###"Aviso"
				Return .f.
				EndIf
				Endif
				*/
			EndIf

			If lTratComis .And. !lOkAg //MCF - 11/01/2016
				AP100CRIT("EEB_TIPCVL")
			Endif

			// Case cCampo == "EE8_CODAGE" - JPM - 02/06/05
			Case cCampo $ "EE8_CODAGE/EE8_TIPCOM"

			If !Empty(M->EE8_CODAGE)
				//If WorkAg->(DbSeek(M->EE8_CODAGE+CD_AGC)) - JPM - 02/06/05
				If WorkAg->(DbSeek(M->EE8_CODAGE+AvKey(CD_AGC+"-"+Tabela("YE",CD_AGC,.f.),"EEB_TIPOAG")+;
				If(EE8->(FieldPos("EE8_TIPCOM")) > 0,M->EE8_TIPCOM,"")))

					If WorkAg->EEB_TIPCVL = "1" // Percentual.
						M->EE8_PERCOM := WorkAg->EEB_VALCOM
						M->EE8_VLCOM  := Round(M->EE8_PRCINC*(M->EE8_PERCOM/100),2)

					ElseIf WorkAg->EEB_TIPCVL = "2" // Valor Fixo.
						M->EE8_PERCOM := 0
						M->EE8_VLCOM  := WorkAg->EEB_VALCOM

					Else // Percentual por item.
						M->EE8_PERCOM := 0
						M->EE8_VLCOM  := 0
					EndIf
				EndIf
			Else
				M->EE8_PERCOM := 0
				M->EE8_VLCOM  := 0
			EndIf

			// ** By JBJ - 28/08/03 - 15:27. (Validação do campo de flag para tratamento de OffShore).
			Case cCampo == "EE7_INTERM"

			If INCLUI
				Break
			EndIf

			Do Case
				Case ALTERA .And. EE7->EE7_INTERM == M->EE7_INTERM
				Break

				Case ALTERA .And. (EE7->EE7_INTERM <> M->EE7_INTERM) .And. (M->EE7_INTERM $ cSim)

				EE8->(DbSetOrder(1))
				EE8->(DbSeek(xFilial("EE8")+M->EE7_PEDIDO))
				Do While EE8->(!Eof()) .And. EE8->EE8_FILIAL == xFilial("EE8") .And.;
				EE8->EE8_PEDIDO == M->EE7_PEDIDO
					If EECFlags("COMMODITY") .Or. EECFlags("CAFE") // By JPP - 03/03/2008 - 16:30 - Não permitir transformar pedido normal em offshore quando existir fixação de preço.
						If !Empty(EE8->EE8_DTFIX)
							MsgInfo("Este processo possui fixação de Preço/RV, este campo não pode ser alterado. Estorne a fixação para alterar este campo.","Atenção") // 
							lRet := .F.
							Break
						EndIf
					EndIf 
					If EE8->EE8_SLDINI <> EE8->EE8_SLDATU
						MsgStop("Problema:"+ENTER+; //
						"Este processo foi lançado em fase de embarque na filial Brasil. Para que o sistema "+; //
						"gere o pedido na filial de off-shore, o embarque deverá ser eliminado na filial Brasil.","Atenção") //
						lRet:=.f.
						Break
					EndIf

					/*
					// ** Verifica o saldo disponível na filial Brasil.
					If Empty(EE8->EE8_SLDATU)
					MsgStop(STR0056+ENTER+; //"Problema:"
					STR0060+ENTER+; //"Este processo foi lançado na fase de embarque e não possui saldo disponível "
					STR0061,STR0051) //"para geração de processo na filial de OffShore."###"Atenção"
					lRet:=.f.
					Break
					EndIf
					*/
					EE8->(DbSkip())
				EndDo
			EndCase
			// JPP - 11/01/05 - 10:15 - Na alteração do Pais é verificado se existe normas vinculadas a produtos.               
			Case cCampo == "EE7_PAISET" 
			If ! lOK
				AP100Normas(OC_PE) 
			EndIf    


			Case cCampo == "EE8_PERCOM"//LGS-26/12/2014 - Preciso validar antes e calcular se tiver zero pra que o valor da comissao seja calculado
			If M->EE8_PRCTOT == 0
				M->EE8_PRCTOT := M->(EE8_SLDINI * EE8_PRECO)
				M->EE8_PRCINC := M->(EE8_SLDINI * EE8_PRECO)
			EndIf

			Case cCampo == "EE8_VLCOM"  //LRS - 27/11/2014 - Validação para pegar a porcentagem calculada de acordo com o valor digitado
			If M->EE8_PRCTOT == 0   //LGS-26/12/2014 - Preciso validar antes e calcular se tiver zero pra que o valor da comissao seja calculado
				M->EE8_PRCTOT := M->(EE8_SLDINI * EE8_PRECO)
				M->EE8_PRCINC := M->(EE8_SLDINI * EE8_PRECO)
			EndIf

			IF M->EE8_VLCOM > M->EE8_PRCINC
				MsgInfo("Valor da comissão maior que o valor total do item","Atenção") //
				lRet := .F.
			Else
				M->EE8_PERCOM:= Round(((M->EE8_VLCOM/M->EE8_PRCINC)*100),2)
			EndIF 


			/*
			ER - 03/10/2006 às 15:00
			Para a utilização de Adiantamento, é necessário utilizar a rotina de "Pagamento Antecipado",
			portanto a Condição de Pagamento não deverá ter essa opção.
			*/
			SY6->(DbSetOrder(1))
			If SY6->(DbSeek(xFilial("SY6")+M->EE7_CONDPA))
				If SY6->Y6_TIPO = "3"
					For nPos := 1 To 10
						If SY6->&("Y6_DIAS_" + StrZero(nPos, 2)) < 0 
							MsgStop("A condição de pagamento selecionada, contém uma ou mais parcelas de adiantamento. Informe uma condição de pagamento onde não haja parcelas de adiantamento.","Atenção")//)
							lRet := .F.
							Break
						EndIf
					Next
				EndIf
			EndIf

			Case cCampo == "EE7_DESSEG" //LRS - 11/09/2015
			AP100Crit("EE7_SEGURO")

		End Case

	End Sequence

	RESTORD(aORD)
	dbselectarea(cOldArea)

Return lRet


user function EEC06VIA()
	local aAreaYQ		:= SYQ->(GetArea())
	local aLstVias	:= {}
	local cOpcoes		:= ""
	local cTitulo		:= "Seleção de Via"
	local MvPar		:= &(Alltrim(ReadVar()))		// Carrega Nome da Variavel do Get em Questao
	local mvRet		:= "M->ZZC_VIA"		// Iguala Nome da Variavel ao Nome variavel de Retorno

	DBSelectArea("SYQ")
	dbGoTop()
	while !SYQ->(EOF())
		aadd(aLstVias, allTrim(SYQ->YQ_COD_DI) + " - " + allTrim(SYQ->YQ_DESCR) + " - " +  allTrim(SYQ->YQ_VIA))
		cOpcoes += SYQ->(YQ_VIA)
		SYQ->(DBSkip())
	enddo()
	SYQ->(DBCloseArea())

	if f_Opcoes(    @MvPar		,;    //Variavel de Retorno
	cTitulo		,;    //Titulo da Coluna com as opcoes
	@aLstVias	,;    //Opcoes de Escolha (Array de Opcoes)
	@cOpcoes	,;    //String de Opcoes para Retorno
	NIL			,;    //Nao Utilizado
	NIL			,;    //Nao Utilizado
	.T.			,;    //Se a Selecao sera de apenas 1 Elemento por vez
	TamSx3("YQ_VIA")[1],; //TamSx3("A6_COD")[1],; //
	900,;				//No maximo de elementos na variavel de retorno
	)

		&MvRet := mvpar
	endif

	restArea(aAreaYQ)
return .T.

user function EEC06ORI()
	local aAreaYR		:= SYR->(GetArea())
	local aLstOrig	:= {}
	local cOpcoes		:= ""
	local cTitulo		:= "Seleção de Via"
	local MvPar		:= &(Alltrim(ReadVar()))		// Carrega Nome da Variavel do Get em Questao
	local mvRet	:= "M->ZZC_ORIGEM"		// Iguala Nome da Variavel ao Nome variavel de Retorno
	local mvRet2	:= "M->ZZC_DESTINO"		// Iguala Nome da Variavel ao Nome variavel de Retorno

	DBSelectArea("SYR")
	dbGoTop()
	while !SYR->(EOF())
		If SYR->YR_VIA == M->ZZC_VIA
			aadd(aLstOrig, SYR->(YR_ORIGEM) + SYR->(YR_DESTINO) + " - Origem: " + allTrim(SYR->YR_ORIGEM) + " - Destino: " + allTrim(SYR->YR_DESTINO))
			cOpcoes += SYR->(YR_ORIGEM) + SYR->(YR_DESTINO)
		EndIf	
		SYR->(DBSkip())
	enddo
	SYR->(DBCloseArea())

	If Len(aLstOrig) == 0
		aadd(aLstOrig,"-")
		cOpcoes := "-"
	EndIf

	if f_Opcoes(    @MvPar		,;    //Variavel de Retorno
	cTitulo		,;    //Titulo da Coluna com as opcoes
	@aLstOrig	,;    //Opcoes de Escolha (Array de Opcoes)
	@cOpcoes	,;    //String de Opcoes para Retorno
	NIL			,;    //Nao Utilizado
	NIL			,;    //Nao Utilizado
	.T.			,;    //Se a Selecao sera de apenas 1 Elemento por vez
	TamSx3("YR_ORIGEM")[1] + TamSx3("YR_DESTINO")[1],; //TamSx3("A6_COD")[1],; //
	900,;				//No maximo de elementos na variavel de retorno
	)
		if !Empty(mvpar)
			&MvRet := Substr(mvpar,1,TamSx3("YR_ORIGEM")[1])
			&MvRet2 := Substr(mvpar,TamSx3("YR_ORIGEM")[1]+1,TamSx3("YR_DESTINO")[1])
		Else
			&mvRet := " "
		EndIf
	endif

	restArea(aAreaYR)
return .T.

User Function MGFVLD06(cCAMPO)
	Local cCpoCont:= ""

	Local lRet    := .T.
	Local lReposic:= Type("SB1->B1_REPOSIC") <> "U"
	Local oModel := FwModelActive()


	BEGIN SEQUENCE
		//DFS - 19/07/2011 - Ponto de entrada para que, retire a validação dos campos desejados.
		DO CASE

			CASE cCAMPO="ZZD_QTDEM1"
			// GFP - 21/07/2012 - Inclusão de calculo de Quantidade na embalagem
			IF !EMPTY(oModel:GetModel("EEC19DETAIL"):GetValue("ZZD_QTDEM1"))
				IF (oModel:GetModel("EEC19DETAIL"):GetValue("ZZD_SLDINI") % oModel:GetModel("EEC19DETAIL"):GetValue("ZZD_QTDEM1")) != 0
					HELP(" ",1,"AVG0000637") //MsgStop("Quantidade informada não e multipla pela quantidade na Embalagem !","Aviso")
					oModel:GetModel("EEC19DETAIL"):SetValue("ZZD_QE",Int(oModel:GetModel("EEC19DETAIL"):GetValue("ZZD_SLDINI")/oModel:GetModel("EEC19DETAIL"):GetValue("ZZD_QTDEM1"))+1) //QUANT.NA EMBAL.
					lRet    := .T.
				Else
					oModel:GetModel("EEC19DETAIL"):SetValue("ZZD_QE",oModel:GetModel("EEC19DETAIL"):GetValue("ZZD_SLDINI")/oModel:GetModel("EEC19DETAIL"):GetValue("ZZD_QTDEM1")) //QUANT.NA EMBAL.
				Endif
			Endif
			CASE cCAMPO="ZZD_QE"
			IF !EMPTY(oModel:GetModel("EEC19DETAIL"):GetValue("ZZD_QE"))
				IF (oModel:GetModel("EEC19DETAIL"):GetValue("ZZD_SLDINI") % oModel:GetModel("EEC19DETAIL"):GetValue("ZZD_QE")) != 0
					HELP(" ",1,"AVG0000637") //MsgStop("Quantidade informada não e multipla pela quantidade na Embalagem !","Aviso")
					oModel:GetModel("EEC19DETAIL"):SetValue("ZZD_QTDEM1",Int(oModel:GetModel("EEC19DETAIL"):GetValue("ZZD_SLDINI")/oModel:GetModel("EEC19DETAIL"):GetValue("ZZD_QE"))+1) //QUANT.DE EMBAL.
					lRet    := .T.
				Else
					oModel:GetModel("EEC19DETAIL"):SetValue("ZZD_QTDEM1",oModel:GetModel("EEC19DETAIL"):GetValue("ZZD_SLDINI")/oModel:GetModel("EEC19DETAIL"):GetValue("ZZD_QE")) //QUANT.DE EMBAL.
				Endif
			Endif

		ENDCASE
	ENDSEQUENCE


RETURN lRET
