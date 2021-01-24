#INCLUDE 'Protheus.ch'

#DEFINE XCABSOL  1
#DEFINE XITESOL  2
#DEFINE XAPRSOL  3

/*
=====================================================================================
Programa............: xMC10GerSol
Autor...............: Joni Lima
Data................: 25/01/2016
Descrição / Objetivo: Função para envio dos dados para o Fluig
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Recebe os dados e envia Cabeçalho, itens e alçada de aprovação para o FLuig
=====================================================================================
*/
User Function xMC10GerSol(aDados)
	
	Local aArea 	:= GetArea()
	Local aAreaSC1	:= SC1->(GetArea())
	
	Local oObj := WSECMWorkflowEngineServiceService():New()
	Local oResulObj := nil
	Local aItem := {}
	Local ni
	Local nf
	Local cCodFlg	:= ''
	
	oObj:cusername		:= Alltrim(SuperGetMV("MGF_FLGUSR",.F.,'adm'))//GetMv("TI_FLGUSR")		//("MV_FLGUSR",,"cristina.poffo@totvs.com.br")
	oObj:cpassword		:= Alltrim(SuperGetMV("MGF_FLGPSW",.F.,'adm'))//GetMv("TI_FLGPSW")		//("MV_FLGPSW",,"Totvs@123")
	oObj:cuserId		:= Alltrim(SuperGetMV("MGF_FLGUSR",.F.,'adm'))//GetMv("TI_FLGID")		//("MV_FLGID",,"13849989")
	oObj:ncompanyId		:= 1
	oObj:cprocessId		:= "WfSolicitacaoCompras"
	oObj:nchoosedState	:= 40
	oObj:ccomments 		:= "Solicitação incluida via Protheus"
	oObj:lcompleteTask	:= .T.
	oObj:lmanagerMode	:= .F.
	
	If Len(aDados) > 0
		
		/*oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := 'tNumFluig'
		oClassCard:cvalue := aDados[ni][XCABSOL][1]
		aAdd(aItem,oClassCard)*/
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tFilial')
		oClassCard:cvalue := aDados[XCABSOL][1]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tNumSolicCompra')
		oClassCard:cvalue := aDados[XCABSOL][2]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tSolicitante')
		oClassCard:cvalue := aDados[XCABSOL][3]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('dDataSolic')
		oClassCard:cvalue := aDados[XCABSOL][4]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tUnidRequisitante')
		oClassCard:cvalue := aDados[XCABSOL][5]
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tDescFilial')
		oClassCard:cvalue := aDados[XCABSOL][6]
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('hEmailSolicitante')
		oClassCard:cvalue := aDados[XCABSOL][7]
		aAdd(aItem,oClassCard)
		
		//Preenchimento dos Itens
		For nf := 1 to Len(aDados[XITESOL])
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('nItem___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][1]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('nCodProduto___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][2]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('nCodGrupoProduto___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][3]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tUniMedida___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][4]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tDescricao___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][5]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('nQuantidade___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][6]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('dDtNecessidade___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][7]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tObservacao___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][8]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('nCentroCusto___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][9]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('nContaContabil___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][10]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tItemCC___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][11]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tClasseValor___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][12]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('vPrecoEstimado___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][13]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tCtrContrato___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][14]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tRateio___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][15]
			aAdd(aItem,oClassCard)
			
		Next nf
		
		//Preenchimento dos Aprovadores
		For nf := 1 to Len(aDados[XAPRSOL])
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('nSeqAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := STRZERO(nf,2)//aDados[XAPRSOL][nf][1]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('nNivelAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XAPRSOL][nf][1]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tMatriculaAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XAPRSOL][nf][2]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tNomeAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XAPRSOL][nf][3]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('hPrazo___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XAPRSOL][nf][4]
			aAdd(aItem,oClassCard)
			
			/*oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := 'tDataAprovacao'
			oClassCard:cvalue := aDados[ni][XAPRSOL][nf][6]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := 'tHoraAprovacao'
			oClassCard:cvalue := aDados[ni][XAPRSOL][nf][7]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := 'tObsAprovador'
			oClassCard:cvalue := aDados[ni][XAPRSOL][nf][8]
			aAdd(aItem,oClassCard)*/
			
		Next nf
		
	EndIf
	
	oObj:oWSstartProcessClassiccardData:oWSitem := aItem
	
	If Len(aItem) > 0 .and. Len(oObj:oWSstartProcessClassiccardData:oWSitem) > 0
		
		If oObj:startProcessClassic()
			
			oResulObj:= oObj:oWSstartProcessClassicresult
			
			For ni := 1 to Len(oResulObj:oWsItem)
				
				If Alltrim(UPPER(oResulObj:oWsItem[ni]:cKey)) == 'ERROR'
					Alert('Erro ao Integrar com o Fluig: ' + oResulObj:oWsItem[ni]:cValue)
					exit
				Else
					If Alltrim(UPPER(oResulObj:oWsItem[ni]:cKey)) == 'IPROCESS'
						cCodFlg := STRZERO(Val(oResulObj:oWsItem[ni]:cValue),9,0)
					EndIf
				EndIf
			Next ni
			
			If !Empty(cCodFlg)
				
				dbSelectArea('SC1')
				SC1->(dbSetOrder(1))//C1_FILIAL, C1_NUM, C1_ITEM, C1_ITEMGRD
				
				If SC1->(dbSeek(xFilial('SC1') + aDados[XCABSOL][2]))
					While SC1->(!Eof()) .and. xFilial('SC1') + aDados[XCABSOL][2] == SC1->(C1_FILIAL + C1_NUM)
						
						RecLock('SC1',.F.)
						SC1->C1_ZCODFLG := cCodFlg
						SC1->(MsUnLock())
						
						SC1->(dbSkip())
					EndDo
					Alert('integrado com Fluig')
				EndIf
			Else
				Alert('Código Fluig Em Branco')
			EndIf
		Else
			Alert('Processo não consegui sair do Protheus')
		EndIf
		
	Else
		Alert('Problema com array para envio ao fluig')
	EndIf
	
	RestArea(aAreaSC1)
	RestArea(aArea)
	
Return

/*
=====================================================================================
Programa............: xMC10ExSol
Autor...............: Joni Lima
Data................: 25/01/2016
Descrição / Objetivo: Função para exclusão de SC no Fluig chamado no PE MT110CON
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Envia o código Fluig e realiza a Exclusão no Fluig
=====================================================================================
*/
User Function xMC10ExSol(cSc)
	
	Local aArea 	:= GetArea()
	Local aAreaSC1	:= SC1->(GetArea()) 
	Local aAreaSCR	:= SCR->(GetArea())	
	
	Local oObj 		:= WSECMWorkflowEngineServiceService():New()
	Local oResulObj := nil
	
	Local cCodFlg	:= ''
	Local lRet		:= .F.
	
	dbSelectArea('SC1')
	SC1->(dbSetOrder(1))//C1_FILIAL, C1_NUM, C1_ITEM, C1_ITEMGRD
	
	If SC1->(DbSeek( xFilial('SC1') + cSC))
		cCodFlg := SC1->C1_ZCODFLG
		
		oObj:cusername			:= Alltrim(SuperGetMV("MGF_FLGUSR",.F.,'adm'))//GetMv("TI_FLGUSR")		//("MV_FLGUSR",,"cristina.poffo@totvs.com.br")
		oObj:cpassword			:= Alltrim(SuperGetMV("MGF_FLGPSW",.F.,'adm'))//GetMv("TI_FLGPSW")		//("MV_FLGPSW",,"Totvs@123")
		oObj:cuserId			:= Alltrim(SuperGetMV("MGF_FLGUSR",.F.,'adm'))//xxRetUser()//GetMv("TI_FLGID")		//("MV_FLGID",,"13849989")
		oObj:ncompanyId			:= 1
		oObj:nProcessInstanceId	:= Val(cCodFlg)//"saveAndSendTaskClassic"
		oObj:ccancelText 		:= 'Excluido Pelo Protheus'
	
		oObj:cancelInstance()
		
		lRet := Alltrim(UPPER(oObj:cResult)) == 'OK'
		
	EndIf	
	
	RestArea(aAreaSCR)
	RestArea(aAreaSC1)
	RestArea(aArea)
	
Return lRet

User Function xMGC10CRIP()
	Public __aXAllUser := FwSFAllUsers()
Return

User Function xM10PedGer(aDados)
	
	Local aArea 	:= GetArea()
	Local aAreaSC7	:= SC7->(GetArea())
	
	Local oObj := WSECMWorkflowEngineServiceService():New()
	Local oResulObj := nil
	Local aItem := {}
	Local ni
	Local nf
	Local cCodFlg	:= ''
	
	oObj:cusername		:= Alltrim(SuperGetMV("MGF_FLGUSR",.F.,'adm'))//GetMv("TI_FLGUSR")		//("MV_FLGUSR",,"cristina.poffo@totvs.com.br")
	oObj:cpassword		:= Alltrim(SuperGetMV("MGF_FLGPSW",.F.,'adm'))//GetMv("TI_FLGPSW")		//("MV_FLGPSW",,"Totvs@123")
	oObj:cuserId		:= Alltrim(SuperGetMV("MGF_FLGUSR",.F.,'adm'))//GetMv("TI_FLGID")		//("MV_FLGID",,"13849989")
	oObj:ncompanyId		:= 1
	oObj:cprocessId		:= "wfPedidoCompras"
	oObj:nchoosedState	:= 40
	oObj:ccomments 		:= "Pedido incluido via Protheus"
	oObj:lcompleteTask	:= .T.
	oObj:lmanagerMode	:= .F.
	
	If Len(aDados) == 3


		/*oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tNumFluig')
		oClassCard:cvalue := aDados[XCABSOL][1]
		aAdd(aItem,oClassCard)*/

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tFornecedor')
		oClassCard:cvalue := aDados[XCABSOL][1]
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tLoja')
		oClassCard:cvalue := aDados[XCABSOL][2]
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tCondicaoPagto')
		oClassCard:cvalue := aDados[XCABSOL][3]
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tFilial')
		oClassCard:cvalue := aDados[XCABSOL][4]
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tFilialEntrada')
		oClassCard:cvalue := aDados[XCABSOL][5]
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tDataEmissao')
		oClassCard:cvalue := aDados[XCABSOL][6]
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tNumPC')
		oClassCard:cvalue := aDados[XCABSOL][7]
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tMoeda')
		oClassCard:cvalue := aDados[XCABSOL][8]
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tTaxaMoeda')
		oClassCard:cvalue := aDados[XCABSOL][9]
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('hEmailSolicitante')
		oClassCard:cvalue := aDados[XCABSOL][10]
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tDescFornecedor')
		oClassCard:cvalue := aDados[XCABSOL][11]
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tDescFilial')
		oClassCard:cvalue := aDados[XCABSOL][12]
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tDescFilialEntrada')
		oClassCard:cvalue := aDados[XCABSOL][13]
		aAdd(aItem,oClassCard)
		
		//Preenchimento dos Itens
		For nf := 1 to Len(aDados[XITESOL])

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('nItem___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][1]
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('nCodProduto___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][2]
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tDescricao___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][3]
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tUnidade___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][4]
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tQuantidade___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][5]
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('mPrecoUnitario___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][6]
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('mValorTotal___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][7]
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('dDataEntrega___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][8]
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tObservacoes___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][9]
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('mValorDesconto___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][10]
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('pDescontoItem___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][11]
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('mValorSeguro___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][12]
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('mValorDespesas___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][13]
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('mValorFrete___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][14]
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tTipoFrete___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][15]
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('pAliqIPI___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][16]
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('mValorIPI___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][17]
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('pAliqICMS___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][18]
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('mValorICMS___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][19]
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tNumContrato___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][20]
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('pImposto5___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][21]
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('mImposto5___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][22]
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tCentroCusto___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][23]
			aAdd(aItem,oClassCard)
			
		Next nf		

		//Preenchimento dos Aprovadores
		For nf := 1 to Len(aDados[XAPRSOL])
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('nSeqAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := STRZERO(nf,2)//aDados[XAPRSOL][nf][1]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('nNivelAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XAPRSOL][nf][1]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tMatriculaAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XAPRSOL][nf][2]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tNomeAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XAPRSOL][nf][3]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('hPrazo___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XAPRSOL][nf][4]
			aAdd(aItem,oClassCard)
			
			/*oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := 'tDataAprovacao'
			oClassCard:cvalue := aDados[ni][XAPRSOL][nf][6]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := 'tHoraAprovacao'
			oClassCard:cvalue := aDados[ni][XAPRSOL][nf][7]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := 'tObsAprovador'
			oClassCard:cvalue := aDados[ni][XAPRSOL][nf][8]
			aAdd(aItem,oClassCard)*/
			
		Next nf
	
	EndIf
	
	oObj:oWSstartProcessClassiccardData:oWSitem := aItem
	
	If Len(aItem) > 0 .and. Len(oObj:oWSstartProcessClassiccardData:oWSitem) > 0
		
		If oObj:startProcessClassic()
			
			oResulObj:= oObj:oWSstartProcessClassicresult
			
			For ni := 1 to Len(oResulObj:oWsItem)
				
				If Alltrim(UPPER(oResulObj:oWsItem[ni]:cKey)) == 'ERROR'
					Alert('Erro ao Integrar com o Fluig: ' + oResulObj:oWsItem[ni]:cValue)
					exit
				Else
					If Alltrim(UPPER(oResulObj:oWsItem[ni]:cKey)) == 'IPROCESS'
						cCodFlg := STRZERO(Val(oResulObj:oWsItem[ni]:cValue),9,0)
					EndIf
				EndIf
			Next ni
			
			If !Empty(cCodFlg)
				
				dbSelectArea('SC7')
				SC7->(dbSetOrder(1))//C7_FILIAL, C7_NUM, C7_ITEM, C7_ITEMGRD
				
				If SC7->(dbSeek(xFilial('SC7') + aDados[XCABSOL][7]))
					While SC7->(!Eof()) .and. xFilial('SC7') + aDados[XCABSOL][7] == SC7->(C7_FILIAL + C7_NUM)
						
						RecLock('SC7',.F.)
							SC7->C7_ZCODFLG := cCodFlg
						SC7->(MsUnLock())
						
						SC7->(dbSkip())
					EndDo
					Alert('integrado com Fluig')
				EndIf
			Else
				Alert('Código Fluig Em Branco')
			EndIf
		Else
			Alert('Processo não consegui sair do Protheus')
		EndIf
		
	Else
		Alert('Problema com array para envio ao fluig')
	EndIf	
	
	
	RestArea(aAreaSC7)
	RestArea(aArea)

Return

User Function xM10PedEx(cPed)
	
	Local aArea 	:= GetArea()
	Local aAreaSC7	:= SC7->(GetArea()) 
	Local aAreaSCR	:= SCR->(GetArea())	
	
	Local oObj 		:= WSECMWorkflowEngineServiceService():New()
	Local oResulObj := nil
	
	Local cCodFlg	:= ''
	Local lRet		:= .F.
	
	dbSelectArea('SC7')
	SC7->(dbSetOrder(1))//C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN
	
	If SC7->(DbSeek( xFilial('SC7') + cPed))
		cCodFlg := SC7->C7_ZCODFLG
		
		oObj:cusername			:= Alltrim(SuperGetMV("MGF_FLGUSR",.F.,'adm'))//GetMv("TI_FLGUSR")		//("MV_FLGUSR",,"cristina.poffo@totvs.com.br")
		oObj:cpassword			:= Alltrim(SuperGetMV("MGF_FLGPSW",.F.,'adm'))//GetMv("TI_FLGPSW")		//("MV_FLGPSW",,"Totvs@123")
		oObj:cuserId			:= Alltrim(SuperGetMV("MGF_FLGUSR",.F.,'adm'))//xxRetUser()//GetMv("TI_FLGID")		//("MV_FLGID",,"13849989")
		oObj:ncompanyId			:= 1
		oObj:nProcessInstanceId	:= Val(cCodFlg)//"saveAndSendTaskClassic"
		oObj:ccancelText 		:= 'Excluido Pelo Protheus'
	
		oObj:cancelInstance()
		
		lRet := Alltrim(UPPER(oObj:cResult)) == 'OK'
		
	EndIf	
	
	RestArea(aAreaSCR)
	RestArea(aAreaSC7)
	RestArea(aArea)
	
Return lRet

User Function xjM10TitGer(aDados)
	
	Local aArea 	:= GetArea()
	Local aAreaSE2	:= SE2->(GetArea())
	
	Local oObj := WSECMWorkflowEngineServiceService():New()
	Local oResulObj := nil
	Local aItem := {}
	Local ni
	Local nf
	Local cCodFlg	:= ''
	
	oObj:cusername		:= Alltrim(SuperGetMV("MGF_FLGUSR",.F.,'adm'))//GetMv("TI_FLGUSR")		//("MV_FLGUSR",,"cristina.poffo@totvs.com.br")
	oObj:cpassword		:= Alltrim(SuperGetMV("MGF_FLGPSW",.F.,'adm'))//GetMv("TI_FLGPSW")		//("MV_FLGPSW",,"Totvs@123")
	oObj:cuserId		:= Alltrim(SuperGetMV("MGF_FLGUSR",.F.,'adm'))//GetMv("TI_FLGID")		//("MV_FLGID",,"13849989")
	oObj:ncompanyId		:= 1
	oObj:cprocessId		:= "wfTituloPagar"
	oObj:nchoosedState	:= 40
	oObj:ccomments 		:= "Titulo incluido via Protheus"
	oObj:lcompleteTask	:= .T.
	oObj:lmanagerMode	:= .F.
	
	If Len(aDados) == 2
		
		/*oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tNumFluig')
		oClassCard:cvalue := aDados[XCABSOL][1]
		aAdd(aItem,oClassCard)*/
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tFilial')
		oClassCard:cvalue := aDados[XCABSOL][1]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tPrefixo')
		oClassCard:cvalue := aDados[XCABSOL][2]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tParcela')
		oClassCard:cvalue := aDados[XCABSOL][3]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tTipo')
		oClassCard:cvalue := aDados[XCABSOL][4]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tNatureza')
		oClassCard:cvalue := aDados[XCABSOL][5]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tFornecedor')
		oClassCard:cvalue := aDados[XCABSOL][6]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tLoja')
		oClassCard:cvalue := aDados[XCABSOL][7]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tNomeFornecedor')
		oClassCard:cvalue := aDados[XCABSOL][8]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('dDataEmissao')
		oClassCard:cvalue := aDados[XCABSOL][9]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('dVencimento')
		oClassCard:cvalue := aDados[XCABSOL][10]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('dVencimentoReal')
		oClassCard:cvalue := aDados[XCABSOL][11]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('mValorTitulo')
		oClassCard:cvalue := aDados[XCABSOL][12]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('pISS')
		oClassCard:cvalue := aDados[XCABSOL][13]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('pIRRF')
		oClassCard:cvalue := aDados[XCABSOL][14]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tHistorico')
		oClassCard:cvalue := aDados[XCABSOL][15]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('mSaldo')
		oClassCard:cvalue := aDados[XCABSOL][16]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('mTaxaPerman')
		oClassCard:cvalue := aDados[XCABSOL][17]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tPCJuros')
		oClassCard:cvalue := aDados[XCABSOL][18]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tMoeda')
		oClassCard:cvalue := aDados[XCABSOL][19]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tRateio')
		oClassCard:cvalue := aDados[XCABSOL][20]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('mValor')
		oClassCard:cvalue := aDados[XCABSOL][21]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tAcrescimo')
		oClassCard:cvalue := aDados[XCABSOL][22]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tFluxoCaixa')
		oClassCard:cvalue := aDados[XCABSOL][23]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('pINSS')
		oClassCard:cvalue := aDados[XCABSOL][24]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tTaxaMoeda')
		oClassCard:cvalue := aDados[XCABSOL][25]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tDecrescimo')
		oClassCard:cvalue := aDados[XCABSOL][26]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tCDRetencao')
		oClassCard:cvalue := aDados[XCABSOL][27]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tSestSenat')
		oClassCard:cvalue := aDados[XCABSOL][28]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('pCOFINS')
		oClassCard:cvalue := aDados[XCABSOL][29]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('pPisPasep')
		oClassCard:cvalue := aDados[XCABSOL][30]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('pCSLL')
		oClassCard:cvalue := aDados[XCABSOL][31]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('dVencISS')
		oClassCard:cvalue := aDados[XCABSOL][32]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('mVlrAcServ')
		oClassCard:cvalue := aDados[XCABSOL][33]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tNumContrato')
		oClassCard:cvalue := aDados[XCABSOL][34]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('pTxCorMoeda')
		oClassCard:cvalue := aDados[XCABSOL][35]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tCodAliqISS')
		oClassCard:cvalue := aDados[XCABSOL][36]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tRetencaoCtr')
		oClassCard:cvalue := aDados[XCABSOL][37]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('nDescontoCtr')
		oClassCard:cvalue := aDados[XCABSOL][38]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tBonificacaoCtr')
		oClassCard:cvalue := aDados[XCABSOL][39]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('mMultaCtr')
		oClassCard:cvalue := aDados[XCABSOL][40]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tCentroCusto')
		oClassCard:cvalue := aDados[XCABSOL][41]
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tTipoServico')
		oClassCard:cvalue := aDados[XCABSOL][42]
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tNumTitulo')
		oClassCard:cvalue := aDados[XCABSOL][43]
		aAdd(aItem,oClassCard)
		
		//Preenchimento dos Aprovadores
		For nf := 1 to Len(aDados[XITESOL])
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('nSeqAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := STRZERO(nf,2)//aDados[XAPRSOL][nf][1]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('nNivelAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][1]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tMatriculaAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][2]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tNomeAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][3]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('hPrazo___' + Alltrim(Str(nf)))
			oClassCard:cvalue := aDados[XITESOL][nf][4]
			aAdd(aItem,oClassCard)
			
			/*oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := 'tDataAprovacao'
			oClassCard:cvalue := aDados[ni][XAPRSOL][nf][6]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := 'tHoraAprovacao'
			oClassCard:cvalue := aDados[ni][XAPRSOL][nf][7]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := 'tObsAprovador'
			oClassCard:cvalue := aDados[ni][XAPRSOL][nf][8]
			aAdd(aItem,oClassCard)*/
			
		Next nf
	
	EndIf
	
	oObj:oWSstartProcessClassiccardData:oWSitem := aItem
	
	If Len(aItem) > 0 .and. Len(oObj:oWSstartProcessClassiccardData:oWSitem) > 0
		
		If oObj:startProcessClassic()
			
			oResulObj:= oObj:oWSstartProcessClassicresult
			
			For ni := 1 to Len(oResulObj:oWsItem)
				
				If Alltrim(UPPER(oResulObj:oWsItem[ni]:cKey)) == 'ERROR'
					Alert('Erro ao Integrar com o Fluig: ' + oResulObj:oWsItem[ni]:cValue)
					exit
				Else
					If Alltrim(UPPER(oResulObj:oWsItem[ni]:cKey)) == 'IPROCESS'
						cCodFlg := STRZERO(Val(oResulObj:oWsItem[ni]:cValue),9,0)
						Alert('Cod_FLuig: ' + cCodFlg)
					EndIf
				EndIf
			Next ni
			
			If !Empty(cCodFlg)
				
				dbSelectArea('SE2')
				SE2->(dbSetOrder(1))//E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA
				
				If SE2->(dbSeek(xFilial('SE2') + aDados[XCABSOL][2] + aDados[XCABSOL][43] + aDados[XCABSOL][3] + aDados[XCABSOL][4] + aDados[XCABSOL][6] + aDados[XCABSOL][7] ))
						
						RecLock('SE2',.F.)
							SE2->E2_ZCODFLG := cCodFlg
						SE2->(MsUnLock())
						
					Alert('integrado com Fluig')
				Else
					Alert('Não Incontrou a Chave: ' + xFilial('SE2') + aDados[XCABSOL][2] + aDados[XCABSOL][43] + aDados[XCABSOL][3] + aDados[XCABSOL][4] + aDados[XCABSOL][6] + aDados[XCABSOL][7])
				EndIf
			Else
				Alert('Código Fluig Em Branco')
			EndIf
		Else
			Alert('Processo não consegui sair do Protheus')
		EndIf
		
	Else
		Alert('Problema com array para envio ao Fluig')
	EndIf	
	
	RestArea(aAreaSE2)
	RestArea(aArea)

Return

User Function xM10TitEx(cTit)
	
	Local aArea 	:= GetArea()
	Local aAreaSE2	:= SE2->(GetArea()) 
	Local aAreaSCR	:= SCR->(GetArea())	
	
	Local oObj 		:= WSECMWorkflowEngineServiceService():New()
	Local oResulObj := nil
	
	Local cCodFlg	:= ''
	Local lRet		:= .F.
	
	dbSelectArea('SE2')
	SE2->(dbSetOrder(1))//E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA
	
	If SE2->(DbSeek(cTit))
		cCodFlg := SE2->E2_ZCODFLG
		
		oObj:cusername			:= Alltrim(SuperGetMV("MGF_FLGUSR",.F.,'adm'))//GetMv("TI_FLGUSR")		//("MV_FLGUSR",,"cristina.poffo@totvs.com.br")
		oObj:cpassword			:= Alltrim(SuperGetMV("MGF_FLGPSW",.F.,'adm'))//GetMv("TI_FLGPSW")		//("MV_FLGPSW",,"Totvs@123")
		oObj:cuserId			:= Alltrim(SuperGetMV("MGF_FLGUSR",.F.,'adm'))//xxRetUser()//GetMv("TI_FLGID")		//("MV_FLGID",,"13849989")
		oObj:ncompanyId			:= 1
		oObj:nProcessInstanceId	:= Val(cCodFlg)//"saveAndSendTaskClassic"
		oObj:ccancelText 		:= 'Excluido Pelo Protheus'
	
		oObj:cancelInstance()
		
		lRet := Alltrim(UPPER(oObj:cResult)) == 'OK'
		
	EndIf	
	
	RestArea(aAreaSCR)
	RestArea(aAreaSE2)
	RestArea(aArea)
	
Return lRet
