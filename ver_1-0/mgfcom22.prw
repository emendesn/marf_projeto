#Include 'Protheus.ch'
#include "topconn.ch"
#include "tbiconn.ch"

#DEFINE XCABSOL  1
#DEFINE XITESOL  2
#DEFINE XAPRSOL  3

User Function MC22Tel()
	
	Processa({|| U_MGFCOM22(.T.)},"Aguarde...","Processando Regra...",.F.)
	
Return

User Function MGFC22SH()
	
	RpcSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '010001' TABLES "SCR","SC1","DBM","SAL","DBL","SAK","SCX","SC7","SE2"
		U_MGFCOM22()
	RESET ENVIRONMENT
	
Return

User Function MGFCOM22(lProc)
	
	Local cxAlias := nil
	Local cCodFlg := ''
	Local cCodSCFLG	:= ''
	
	Default lProc := .F.
	
	//Inclusão de Usuario
	
	cxAlias := xVerUsr()
	(cxAlias)->(DbGoTop())
	
	While (cxAlias)->(!EOF())
		
		If lProc
			IncProc('Integrando USR')
		EndIf		
		
		//Cadastrar Usuario
		If !(xUsrExiFlg((cxAlias)->ZA2_CODUSU))
			aDados := xDadUser((cxAlias)->ZA2_CODUSU)
			If !(xCadFLGUS(aDados))
				ZA2->(dbGoTo((cxAlias)->ZA2RECNO))
				RecLock('ZA2',.F.)
					ZA2->ZA2_IDINTE := ''
				ZA2->(MsUnlock())
			EndIf
		EndIf
		
		(cxAlias)->(dbSkip())
	EndDo
	
	If Select(cxAlias) > 0
		(cxAlias)->(DbClosearea())
	Endif
	
	//Inclusão SC
	cxAlias := xVerDados('INC','SC')
	(cxAlias)->(DbGoTop())
	
	While (cxAlias)->(!EOF())
		
		If lProc
			IncProc('Integrando SC')
		EndIf
		
		cCodSCFLG	:= xCdFLG("SC",(cxAlias)->C1_FILIAL,(cxAlias)->C1_NUM)
		If !Empty(cCodSCFLG)//!Empty((cxAlias)->C1_ZCODFLG)
			xExcFLG(cCodSCFLG)
		EndIf
		
		If xCdEXC("SC",(cxAlias)->C1_FILIAL,(cxAlias)->C1_NUM)//(cxAlias)->DEL <> '*'
			aDados := xPreDadSC((cxAlias)->C1_FILIAL,(cxAlias)->C1_NUM)//Preparada Array com os Dados
			If Len(aDados) > 0
				cCodFlg := xIncFlg(aDados,'SC')
				xAtReg('SC',(cxAlias)->C1_FILIAL,(cxAlias)->C1_NUM,cCodFlg)
			EndIf
		EndIf
		
		(cxAlias)->(dbSkip())
	EndDo
	
	If Select(cxAlias) > 0
		(cxAlias)->(DbClosearea())
	Endif
	
	//Inclusão PC
	cxAlias := xVerDados('INC','PC')
	While (cxAlias)->(!EOF())		

		If lProc
			IncProc('Integrando PC')
		EndIf
		
		cCodSCFLG	:= xCdFLG("PC",(cxAlias)->C7_FILIAL,(cxAlias)->C7_NUM)
		If !Empty(cCodSCFLG)//!Empty((cxAlias)->C7_ZCODFLG)
			xExcFLG(cCodSCFLG)
		EndIf
		
		If xCdEXC("PC",(cxAlias)->C7_FILIAL,(cxAlias)->C7_NUM)//(cxAlias)->DEL <> '*'
			aDados := xPreDadPC((cxAlias)->C7_FILIAL,(cxAlias)->C7_NUM)//Preparada Array com os Dados
			If Len(aDados) > 0
				cCodFlg := xIncFlg(aDados,'PC')
				xAtReg('PC',(cxAlias)->C7_FILIAL,(cxAlias)->C7_NUM,cCodFlg)
			EndIf
		EndIf
		
		(cxAlias)->(dbSkip())
	EndDo

	If Select(cxAlias) > 0
		(cxAlias)->(DbClosearea())
	Endif
	
	//Inclusão Titulo
	cxAlias := xVerDados('INC','ZC')
	While (cxAlias)->(!EOF())

		If lProc
			IncProc('Integrando Titulos')
		EndIf

		If !Empty((cxAlias)->E2_ZCODFLG)
			xExcFLG((cxAlias)->E2_ZCODFLG)
		EndIf
		
		If (cxAlias)->DEL <> '*'
			aDados := xPreDadTi((cxAlias)->E2_FILIAL,(cxAlias)->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA))//Preparada Array com os Dados
			If Len(aDados) > 0
				cCodFlg :=  xIncFlg(aDados,'ZC')
				xAtReg('ZC',(cxAlias)->E2_FILIAL,(cxAlias)->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA),cCodFlg)
			EndIf
		EndIf
		
		(cxAlias)->(dbSkip())
	EndDo

	If Select(cxAlias) > 0
		(cxAlias)->(DbClosearea())
	Endif
	
	//Aprovação
	cxAlias := xVerDados('APR')
	While (cxAlias)->(!EOF())		

		If lProc
			IncProc('Integrando Aprovações')
		EndIf
		
		//If xPodAprv((cxAlias)->CR_TIPO,(cxAlias)->CR_FILIAL,(cxAlias)->CR_COD)
		xAprvSCR(xVerTipo((cxAlias)->CR_STATUS),(cxAlias)->CR_USER,(cxAlias)->CR_ZUSELIB,(cxAlias)->CR_TIPO,(cxAlias)->CR_FILIAL,(cxAlias)->CR_NUM,(cxAlias)->CR_NIVEL,(cxAlias)->CR_OBS)
		//EndIf
		
		(cxAlias)->(dbSkip())
	EndDo
		
	If Select(cxAlias) > 0
		(cxAlias)->(DbClosearea())
	Endif
	
	//Reprocessamento
	cxAlias := xVerDados('RPR')
	While (cxAlias)->(!EOF())		

		If lProc
			IncProc('Integrando Aprovações')
		EndIf
		
		//If xPodAprv((cxAlias)->CR_TIPO,(cxAlias)->CR_FILIAL,(cxAlias)->CR_COD)
		xAprvSCR(xVerTipo((cxAlias)->CR_STATUS),(cxAlias)->CR_USER,(cxAlias)->CR_ZUSELIB,(cxAlias)->CR_TIPO,(cxAlias)->CR_FILIAL,(cxAlias)->CR_NUM,(cxAlias)->CR_NIVEL,(cxAlias)->CR_OBS)
		//EndIf
		
		(cxAlias)->(dbSkip())
	EndDo
		
	If Select(cxAlias) > 0
		(cxAlias)->(DbClosearea())
	Endif

Return

Static Function xAtReg(cTipo,cFil,cCod,cFlgCod)
	
	Local aArea 	:= GetArea()
	Local aAreaSC1:= SC1->(GetArea())	
	Local aAreaSC7:= SC7->(GetArea())
	Local aAreaSE2:= SE2->(GetArea())
		
	If cTipo == 'SC'
		dbSelectArea('SC1')
		SC1->(dbSetOrder(1))//C1_FILIAL, C1_NUM, C1_ITEM, C1_ITEMGRD
		If SC1->(dbSeek(cFil + cCod)) 
			While SC1->(!EOF()) .and. SC1->(C1_FILIAL + C1_NUM) == cFil + cCod
				RecLock('SC1',.F.)
					If !Empty(cFlgCod)
						SC1->C1_ZCODFLG := cFlgCod
					Else
						SC1->C1_ZIDINTE := ''
					EndIf
					SC1->C1_ZEMITE := ''
				SC1->(MsUnLock())
				SC1->(dbSkip())
			EndDo
		EndIf
	ElseIf cTipo == 'PC'
		dbSelectArea('SC7')
		SC7->(dbSetOrder(1))//C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN
		If SC7->(dbSeek(cFil + cCod)) 
			While SC7->(!EOF()) .and. SC7->(C7_FILIAL + C7_NUM) == cFil + cCod
				RecLock('SC7',.F.)
					If !Empty(cFlgCod)
						SC7->C7_ZCODFLG := cFlgCod
					Else
						SC7->C7_ZIDINTE := ''
					EndIf
					SC7->C7_ZEMITE := ''
				SC7->(MsUnLock())
				SC7->(dbSkip())
			EndDo		
		EndIf
	ElseIf cTipo == 'ZC'
		dbSelectArea('SE2')
		SE2->(dbSetOrder(1))//E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA
		If SE2->(dbSeek(cFil + cCod)) 
			RecLock('SE2',.F.)
				If !Empty(cFlgCod)
					SE2->E2_ZCODFLG := cFlgCod
				Else
					SE2->E2_ZIDINTE := ''
				EndIf
				SE2->E2_ZEMITE := ''
			SE2->(MsUnLock())		
		EndIf
	EndIf
	
	RestArea(aAreaSE2)
	RestArea(aAreaSC7)
	RestArea(aAreaSC1)
	RestArea(aArea)
	
Return

Static Function xVerTipo(cStatus)
	
	Local cRet := ''
	
	If cStatus == '03' //Liberado
		cRet := 'AP'
	ElseIf cStatus == '04' //Bloqueado
		cRet := 'BL'
	ElseIf cStatus == '06' //Rejeitado
		cRet := 'RP'
	EndIf
		
Return cRet

Static function xPodAprv(cTipo,cFil,cCod)
	
	Local aArea 	:= GetArea()
	Local aAreaSC1	:= SC1->(GetArea())
	Local aAreaSC7	:= SC7->(GetArea())
	Local aAreaSE2	:= SE2->(GetArea())
	
	Local nTamChv	:= 0
	
	Local lRet := .F.
	
	If cTipo == 'SC'
		nTamChv	:= Len(SC1->C1_NUM)//TamSX3('C1_NUM')[1]
		dbSelectArea('SC1')
		SC1->(dbSetOrder(1))//C1_FILIAL, C1_NUM, C1_ITEM, C1_ITEMGRD
		If SC1->(dbSeek(cFil + SubStr(cCod,1,nTamChv)))
			lRet := SC1->C1_ZBLQFLG == 'N' .and. !(Empty(SC1->C1_ZCODFLG)) 
		EndIf
	ElseIf cTipo == 'PC'
		nTamChv	:= Len(SC7->C7_NUM)//TamSX3('C7_NUM')[1]
		dbSelectArea('SC7')
		SC7->(dbSetOrder(1))//C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN
		If SC7->(dbSeek(cFil + SubStr(cCod,1,nTamChv)))
			lRet := SC7->C7_ZBLQFLG == 'N' .and. !(Empty(SC7->C7_ZCODFLG))	
		EndIf			
	ElseIf cTipo == 'ZC'
		//nTamChv	:= TamSX3('E2_PREFIXO')[1] + TamSX3('E2_NUM')[1] + TamSX3('E2_PARCELA')[1] + TamSX3('E2_TIPO')[1] + TamSX3('E2_FORNECE')[1] + TamSX3('E2_LOJA')[1]
		nTamChv	:= Len(SE2->E2_PREFIXO) + Len(SE2->E2_NUM) + Len(SE2->E2_PARCELA) + Len(SE2->E2_TIPO) + Len(SE2->E2_FORNECE) + Len(SE2->E2_LOJA)
		dbSelectArea('SE2')
		SE2->(dbSetOrder(1))//E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA
		If SE2->(dbSeek(cFil + SubStr(cCod,1,nTamChv)))
			lRet := SE2->E2_ZBLQFLG == 'N' .and. !(Empty(SE2->E2_ZCODFLG))
		EndIf			
	EndIf
	
	RestArea(aAreaSE2)
	RestArea(aAreaSC7)
	RestArea(aAreaSC1)
	RestArea(aArea)
	
Return lRet

Static function xAprvSCR(cTpLib,cUserApr,cUserSub,cTpDoc,cxFil,cNum,cNivel,cXOBS)
	
	Local aArea 	:= GetArea()
	Local aAreaSC1	:= SC1->(GetArea())
	Local aAreaSC7	:= SC7->(GetArea())
	Local aAreaSE2	:= SE2->(GetArea())
	Local aAreaSCR	:= SCR->(GetArea())
	
	Local aItem 	:= {}
	
	//Local oModel	:= FwModelActive()
	//Local oMdlSCR	:= oModel:GetModel('FieldSCR')
	Local oObj 		:= WSECMWorkflowEngineServiceService():New()
	Local oResulObj := nil
	
	Local ni
	Local nf
	Local nChosse 	:= 0
	//Local nTamChv	:= TamSx3('E2_PREFIXO')[1] + TamSx3('E2_NUM')[1] + TamSx3('E2_PARCELA')[1] + TamSx3('E2_TIPO')[1] + TamSx3('E2_FORNECE')[1] + TamSx3('E2_LOJA')[1]
	Local nTamChv	:= Len(SE2->E2_PREFIXO) + Len(SE2->E2_NUM) + Len(SE2->E2_PARCELA) + Len(SE2->E2_TIPO) + Len(SE2->E2_FORNECE) + Len(SE2->E2_LOJA)
	Local cCodFlg	:= ''
	Local cNumApr	:= ''
	Local cObs		:= Alltrim(cXOBS)//''//oMdlSCR:GetValue('CR_OBS')
	Local cText		:= ''
	
	dbSelectArea('SCR')
	SCR->(dbSetOrder(1))//CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL
	
	If SCR->(dbSeek(cxFil + cTpDoc + cNum + cNivel))
		
		If cTpDoc == 'SC'
			dbSelectArea('SC1')
			SC1->(dbSetOrder(1))
			If SC1->(dbSeek(xFilial('SC1',cxFil) + SUBSTR(SCR->CR_NUM,1,Len(SC1->C1_NUM))))
				cCodFlg := SC1->C1_ZCODFLG
			EndIf
		ElseIf cTpDoc == 'PC'
			dbSelectArea('SC7')
			SC7->(dbSetOrder(1))
			If SC7->(dbSeek(xFilial('SC7',cxFil) + SUBSTR(SCR->CR_NUM,1,Len(SC7->C7_NUM))))
				cCodFlg := SC7->C7_ZCODFLG
			EndIf
		ElseIf cTpDoc == 'ZC'
			dbSelectArea('SE2')
			SE2->(dbSetOrder(1))
			If SE2->(dbSeek(xFilial('SE2',cxFil) + SUBSTR(SCR->CR_NUM,1,nTamChv)))
				cCodFlg := SE2->E2_ZCODFLG
			EndIf
		EndIf
		
		xAtBlqReg(cTpDoc,.T.)
		
		If cTpLib == 'AP'
			nChosse := 9
			cText	:= "Aprovacão via Protheus"
		ElseIf cTpLib == 'RP'
			nChosse := 10
			cText	:= "Reprovado via Protheus"
		ElseIf cTpLib == 'BL'
			nChosse := 35
			cText	:= "Bloqueado via Protheus"
		EndIf
		
		If cTpLib $ 'AP|RP|BL'
			
			oObj:cusername			:= Alltrim(SuperGetMV("MGF_FLGUSR",.F.,'adm'))//GetMv("TI_FLGUSR")		//("MV_FLGUSR",,"cristina.poffo@totvs.com.br")
			oObj:cpassword			:= Alltrim(SuperGetMV("MGF_FLGPSW",.F.,'adm'))//GetMv("TI_FLGPSW")		//("MV_FLGPSW",,"Totvs@123")
			oObj:cuserId			:= cUserApr//xxRetUser()//GetMv("TI_FLGID")		//("MV_FLGID",,"13849989")
			oObj:ncompanyId			:= 1
			oObj:nProcessInstanceId	:= Val(cCodFlg)//"saveAndSendTaskClassic"
			oObj:nchoosedState		:= nChosse //9 = Aprovado, 10 = reprovado, 35 = Bloqueado
			oObj:ccomments 			:= IIF(!Empty(cObs),cObs,'OK')//Alltrim(cObs)//cText
			oObj:lcompleteTask		:= .T.
			oObj:lmanagerMode		:= .F.
			oObj:nThreadSequence 	:= 0
			
			oObj:getInstanceCardData()
			aItem := oObj:oWSgetInstanceCardDataCardData:oWSitem
			
			//Indica que a solicitação foi movimentada pelo Protheus
			For ni:= 1 to Len(aItem)
				
				If UPPER(AllTrim(aItem[ni]:cITEM[1])) == 'HUSERPROTHEUS'
					aItem[ni]:cITEM[2] := 'true'
					Exit
				EndIf
				
			Next ni
			
			//Inidica qual o Aprovador Atual
			For ni:= 1 to Len(aItem)
				
				If UPPER(AllTrim(aItem[ni]:cITEM[1])) == 'HIDXAPROVATUAL'
					cNumApr	:= aItem[ni]:cITEM[2]
					Exit
				EndIf
				
			Next ni
			
			//Atualiza a Observação
			/*For ni:= 1 to Len(aItem)
				
				If UPPER(AllTrim(aItem[ni]:cITEM[1])) == 'TOBSAPROVADOR___' + Alltrim(cNumApr)
					aItem[ni]:cITEM[2] := " "
					Exit
				EndIf
				
			Next ni
			
			//Observacao Aprovacao Atual
			For ni:= 1 to Len(aItem)
				
				If UPPER(AllTrim(aItem[ni]:cITEM[1])) == 'HOBSERVACAOAPROVATUAL'
					aItem[ni]:cITEM[2] := Alltrim(cObs)
					Exit
				EndIf
				
			Next ni*/
			
			If  Alltrim(cUserApr) == Alltrim(cUserSub)
				
				oObj:oWsSaveAndSendTaskAppointment := ECMWorkflowEngineServiceService_processTaskAppointmentDto():New()
				oObj:oWsSaveAndSendTaskAttachments := ECMWorkflowEngineServiceService_processAttachmentDto():New()
				oObj:oWsSaveAndSendTaskCardData:oWSItem := aItem
				
				oObj:saveAndSendTask()
				If Val(oObj:oWsSaveAndSendTaskResult:oWsItem[1]:cItem[2]) == nChosse
					//Alert('Deu Fluigueira')
					RecLock('SCR',.F.)
						SCR->CR_ZBLQFLG := 'N'
						SCR->CR_ZHRINT  := SUBSTR(TIME(),1,2) 
					SCR->(MsUnLock())
				Else
					xAtBlqReg(cTpDoc,.F.)
					RecLock('SCR',.F.)
						SCR->CR_ZBLQFLG := ' '
						SCR->CR_ZIDINTE := ' '
						SCR->CR_ZHRINT  := '  '
					SCR->(MsUnLock())
					If !IsBlind()
						Alert('Erro de integração aprovacao: ' + cTpDoc + ' ' + Alltrim(SCR->CR_NUM) + ' - ' + Alltrim(oObj:oWsSaveAndSendTaskResult:oWsItem[1]:cItem[2]))
					Else
						conout('Erro de integração aprovacao: ' + cTpDoc + ' ' + Alltrim(SCR->CR_NUM) + ' - ' + Alltrim(oObj:oWsSaveAndSendTaskResult:oWsItem[1]:cItem[2]))
					EndIf
				EndIf
				
			Else
				
				oObj:oWsSaveAndSendTaskByReplacementAppointment := ECMWorkflowEngineServiceService_processTaskAppointmentDto():New()
				oObj:oWsSaveAndSendTaskByReplacementAttachments := ECMWorkflowEngineServiceService_processAttachmentDto():New()
				oObj:oWsSaveAndSendTaskByReplacementCardData:oWSItem := aItem
				
				oObj:cReplacementId := cUserSub
				oObj:saveAndSendTaskByReplacement()
				
				If Val(oObj:oWsSaveAndSendTaskByReplacementResult:oWsItem[1]:cItem[2]) == nChosse
					RecLock('SCR',.F.)
						SCR->CR_ZBLQFLG := 'N'
						SCR->CR_ZHRINT  := SUBSTR(TIME(),1,2) 
					SCR->(MsUnLock())
				Else					
					xAtBlqReg(cTpDoc,.F.)
					RecLock('SCR',.F.)
						SCR->CR_ZBLQFLG := ' '
						SCR->CR_ZIDINTE := ' '
						SCR->CR_ZHRINT  := '  '
					SCR->(MsUnLock())
					If !IsBlind()
						Alert('Erro de integração aprovacao: ' + cTpDoc + ' ' + Alltrim(SCR->CR_NUM) + ' - ' + Alltrim(oObj:oWsSaveAndSendTaskByReplacementResult:oWsItem[1]:cItem[2]) )
					Else
						conout('Erro de integração aprovacao: ' + cTpDoc + ' ' + Alltrim(SCR->CR_NUM) + ' - ' + Alltrim(oObj:oWsSaveAndSendTaskResult:oWsItem[1]:cItem[2]))
					EndIf
				EndIf
			
			EndIf
			
		EndIf
	EndIf
	
	RestArea(aAreaSCR)
	RestArea(aAreaSE2)
	RestArea(aAreaSC7)
	RestArea(aAreaSC1)
	RestArea(aArea)
	
Return

Static Function xAtBlqReg(cTpDoc,lBlq)
	
	Local cBlq := IIF(lBlq,'S','N')

	Local aArea 	:= GetArea()
	Local aAreaSC1	:= SC1->(GetArea())
	Local aAreaSC7	:= SC7->(GetArea())
	Local aAreaSE2	:= SE2->(GetArea())
	Local aAreaSCR	:= SCR->(GetArea())

	Local nTamChv	:= Len(SE2->E2_PREFIXO) + Len(SE2->E2_NUM) + Len(SE2->E2_PARCELA) + Len(SE2->E2_TIPO) + Len(SE2->E2_FORNECE) + Len(SE2->E2_LOJA)

	If cTpDoc == 'SC'
		dbSelectArea('SC1')
		SC1->(dbSetOrder(1))
		If SC1->(dbSeek(xFilial('SC1',SCR->CR_FILIAL) + SUBSTR(SCR->CR_NUM,1,Len(SC1->C1_NUM))))
			While SC1->(!EOF()) .and. SC1->(C1_FILIAL + C1_NUM) == xFilial('SC1',SCR->CR_FILIAL) + SUBSTR(SCR->CR_NUM,1,Len(SC1->C1_NUM))
				cCodFlg := SC1->C1_ZCODFLG
				
				RecLock('SC1')
				SC1->C1_ZBLQFLG := cBlq
				SC1->(MsUnlock())
				
				SC1->(dbSkip())
			EndDo
		EndIf
	ElseIf cTpDoc == 'PC'
		dbSelectArea('SC7')
		SC7->(dbSetOrder(1))
		If SC7->(dbSeek(xFilial('SC7',SCR->CR_FILIAL) + SUBSTR(SCR->CR_NUM,1,Len(SC7->C7_NUM))))
			While SC7->(!EOF()) .and. SC7->(C7_FILIAL + C7_NUM) == xFilial('SC7',SCR->CR_FILIAL) + SUBSTR(SCR->CR_NUM,1,Len(SC7->C7_NUM))
				cCodFlg := SC7->C7_ZCODFLG
				RecLock('SC7')
				SC7->C7_ZBLQFLG := cBlq
				SC7->(MsUnlock())
				SC7->(dbSkip())
			EndDo
		EndIf
	ElseIf cTpDoc == 'ZC'
		dbSelectArea('SE2')
		SE2->(dbSetOrder(1))
		If SE2->(dbSeek(xFilial('SE2',SCR->CR_FILIAL) + SUBSTR(SCR->CR_NUM,1,nTamChv)))
			cCodFlg := SE2->E2_ZCODFLG
			RecLock('SE2')
			SE2->E2_ZBLQFLG := cBlq
			SE2->(MsUnlock())
		EndIf
	EndIf
	
	RestArea(aAreaSCR)
	RestArea(aAreaSE2)
	RestArea(aAreaSC7)
	RestArea(aAreaSC1)
	RestArea(aArea)
	
Return

Static Function xVerDados(cProc,cTipo)
	
	Local aArea 	:= GetArea()
	Local cNextAlias:= GetNextAlias()
	Local cUpd		:= ''
	Local cUser		:= Space(Len(SCR->CR_ZUSELIB)) 
	Local cCod 		:= AllTrim(GetMv('MGF_IDIFLG'))
	Local cNum		:= '03'//AllTrim(GetMv('MGF_TPRENV'))
	
	PUTMV('MGF_IDIFLG', Soma1(cCod))
	
	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	
	If cProc == 'INC'
		If cTipo == 'SC'

			cUpd := "UPDATE " + RetSQLName("SC1")  + " SC1 " + CRLF
			cUpd += " SET C1_ZIDINTE = '" + cCod + "' , C1_ZEMITE = 'S' "   + CRLF
			cUpd += " WHERE " + CRLF
			cUpd += " SC1.C1_ZIDINTE = '" + Space(Len(SC1->C1_ZIDINTE)) + "' AND C1_ZEMITE <> 'S'  AND  ( " + CRLF
			cUpd += " ( SC1.D_E_L_E_T_ = ' ' AND SC1.C1_ZBLQFLG = 'S' ) OR " + CRLF
			cUpd += " ( SC1.D_E_L_E_T_ = '*' AND SC1.C1_ZBLQFLG = 'S' AND SC1.C1_ZCODFLG <> '" + Space(Len(SC1->C1_ZCODFLG)) + "' ) ) "
			
			TcSQLExec(cUpd)
			
			BeginSql Alias cNextAlias		
				SELECT DISTINCT
					SC1.C1_FILIAL,
					SC1.C1_NUM
				FROM
					%Table:SC1% SC1
				WHERE
					SC1.C1_ZIDINTE = %exp:cCod%
			EndSql
		ElseIf cTipo == 'PC'

			cUpd := "UPDATE " + RetSQLName("SC7")  + " SC7 " + CRLF
			cUpd += " SET C7_ZIDINTE = '" + cCod + "' , C7_ZEMITE = 'S' "   + CRLF
			cUpd += " WHERE " + CRLF
			cUpd += " SC7.C7_ZIDINTE = '" + Space(Len(SC7->C7_ZIDINTE)) + "' AND C7_ZEMITE <> 'S' AND ( " + CRLF
			cUpd += " ( SC7.D_E_L_E_T_ = ' ' AND SC7.C7_ZBLQFLG = 'S' ) OR " + CRLF
			cUpd += " ( SC7.D_E_L_E_T_ = '*' AND SC7.C7_ZBLQFLG = 'S' AND SC7.C7_ZCODFLG <> '" + Space(Len(SC7->C7_ZCODFLG)) + "' ) ) "
			
			TcSQLExec(cUpd)
		
			BeginSql Alias cNextAlias		
				SELECT DISTINCT
					SC7.C7_FILIAL,
					SC7.C7_NUM
				FROM
					%Table:SC7% SC7
				WHERE
					SC7.C7_ZIDINTE = %exp:cCod%			
			EndSql
		ElseIf cTipo == 'ZC'

			cUpd := "UPDATE " + RetSQLName("SE2")  + " SE2 " + CRLF
			cUpd += " SET E2_ZIDINTE = '" + cCod + "' , E2_ZEMITE = 'S'  "   + CRLF
			cUpd += " WHERE " + CRLF
			cUpd += " SE2.E2_ZIDINTE = '" + Space(Len(SE2->E2_ZIDINTE)) + "' AND E2_ZEMITE <> 'S' AND SE2.E2_ZBLQFLG = 'S' AND ( " + CRLF
			cUpd += " ( SE2.D_E_L_E_T_ = ' ' ) OR " + CRLF
			cUpd += " ( SE2.D_E_L_E_T_ = '*' AND SE2.E2_ZCODFLG <> '" + Space(Len(SE2->E2_ZCODFLG)) + "' ) ) "
			
			TcSQLExec(cUpd)
			
			BeginSql Alias cNextAlias		
				SELECT
					SE2.E2_FILIAL, 
					SE2.E2_PREFIXO, 
					SE2.E2_NUM, 
					SE2.E2_PARCELA, 
					SE2.E2_TIPO, 
					SE2.E2_FORNECE, 
					SE2.E2_LOJA,
					SE2.E2_ZCODFLG,
					SE2.D_E_L_E_T_ DEL
				FROM
					%Table:SE2% SE2
				WHERE
					SE2.E2_ZIDINTE = %exp:cCod%				
			EndSql
		EndIf
	ElseIf cProc == 'APR'

		//SC
		cUpd := "UPDATE " + RetSQLName("SCR") + " SCR " + CRLF 
		cUpd += "  SET CR_ZIDINTE = '" + cCod + "' " + CRLF 
		cUpd += " WHERE " + CRLF 
		cUpd += "  SCR.D_E_L_E_T_ = ' ' AND " + CRLF 
		cUpd += "  SCR.CR_FILIAL || SCR.CR_TIPO || SCR.CR_NUM  || SCR.CR_NIVEL IN (SELECT " + CRLF  
		cUpd += "                  ZSCR.CR_FILIAL || ZSCR.CR_TIPO || ZSCR.CR_NUM  || MIN(ZSCR.CR_NIVEL) CHV " + CRLF 
		cUpd += "                FROM " + CRLF 
		cUpd += "                  " + RetSQLName("SCR") + " ZSCR " + CRLF  
		cUpd += "                INNER JOIN " + RetSQLName("SC1")  + " ZSC1 " + CRLF 
		cUpd += "                   ON ZSCR.CR_FILIAL = ZSC1.C1_FILIAL " + CRLF 
		cUpd += "                  AND RTRIM(ZSCR.CR_NUM) = ZSC1.C1_NUM " + CRLF 
		cUpd += "                WHERE " + CRLF  
		cUpd += "                  ZSCR.D_E_L_E_T_ = ' ' AND " + CRLF 
		cUpd += "                  ZSC1.D_E_L_E_T_ = ' ' AND " + CRLF     
		cUpd += "                  ZSCR.CR_ZBLQFLG <> 'N' AND " + CRLF  
		cUpd += "                  ZSCR.CR_STATUS IN ('03','04','06') AND " + CRLF 
		cUpd += "				   ZSCR.CR_ZHRINT = '  ' AND "  + CRLF
		cUpd += "                  ZSC1.C1_ZBLQFLG = 'N' " + CRLF 
		cUpd += "                GROUP BY ZSCR.CR_FILIAL||ZSCR.CR_TIPO|| ZSCR.CR_NUM) " 
		
		TcSQLExec(cUpd)

		//PC
		cUpd := "UPDATE " + RetSQLName("SCR") + " SCR " + CRLF  
		cUpd += "    SET CR_ZIDINTE = '" + cCod  + "' " + CRLF 
		cUpd += " WHERE " + CRLF 
		cUpd += "    SCR.D_E_L_E_T_ = ' ' AND " + CRLF 
		cUpd += "    SCR.CR_FILIAL || SCR.CR_TIPO || SCR.CR_NUM  || SCR.CR_NIVEL IN (SELECT " + CRLF  
		cUpd += "                    ZSCR.CR_FILIAL || ZSCR.CR_TIPO || ZSCR.CR_NUM  || MIN(ZSCR.CR_NIVEL) CHV " + CRLF 
		cUpd += "                  FROM " + CRLF  
		cUpd += "                    " + RetSQLName("SCR") + " ZSCR " + CRLF  
		cUpd += "                  INNER JOIN " + RetSQLName("SC7") + " ZSC7 " + CRLF 
		cUpd += "                     ON ZSCR.CR_FILIAL = ZSC7.C7_FILIAL " + CRLF 
		cUpd += "                    AND RTRIM(ZSCR.CR_NUM) = ZSC7.C7_NUM " + CRLF 
		cUpd += "                  WHERE " + CRLF  
		cUpd += "                    ZSCR.D_E_L_E_T_ = ' ' AND " + CRLF 
		cUpd += "                    ZSC7.D_E_L_E_T_ = ' ' AND " + CRLF     
		cUpd += "                    ZSCR.CR_ZBLQFLG <> 'N' AND " + CRLF  
		cUpd += "                    ZSCR.CR_STATUS IN ('03','04','06') AND " + CRLF 
		cUpd += "				     ZSCR.CR_ZHRINT = '  ' AND "  + CRLF
		cUpd += "                    ZSC7.C7_ZBLQFLG = 'N' " + CRLF 
		cUpd += "                  GROUP BY ZSCR.CR_FILIAL||ZSCR.CR_TIPO|| ZSCR.CR_NUM) "		
		
		TcSQLExec(cUpd)
		
		//ZC
		cUpd := "UPDATE " + RetSQLName("SCR") + " SCR " + CRLF   
		cUpd += "  SET CR_ZIDINTE = '" + cCod + "' " + CRLF 
		cUpd += " WHERE " + CRLF 
		cUpd += "  SCR.D_E_L_E_T_ = ' ' AND " + CRLF 
		cUpd += "  SCR.CR_FILIAL || SCR.CR_TIPO || SCR.CR_NUM  || SCR.CR_NIVEL IN (SELECT " + CRLF  
		cUpd += "                  ZSCR.CR_FILIAL || ZSCR.CR_TIPO || ZSCR.CR_NUM  || MIN(ZSCR.CR_NIVEL) CHV " + CRLF 
		cUpd += "                FROM " + CRLF 
		cUpd += "                  " + RetSQLName("SCR") + " ZSCR " + CRLF  
		cUpd += "                INNER JOIN " + RetSQLName("SE2") + " ZSE2 " + CRLF 
		cUpd += "                   ON ZSCR.CR_FILIAL = ZSE2.E2_FILIAL " + CRLF 
		cUpd += "                  AND RTRIM(ZSCR.CR_NUM) = ZSE2.E2_PREFIXO || ZSE2.E2_NUM || ZSE2.E2_PARCELA || ZSE2.E2_TIPO || ZSE2.E2_FORNECE || ZSE2.E2_LOJA " + CRLF 
		cUpd += "                WHERE " + CRLF 
		cUpd += "                  ZSCR.D_E_L_E_T_ = ' ' AND " + CRLF 
		cUpd += "                  ZSE2.D_E_L_E_T_ = ' ' AND " + CRLF     
		cUpd += "                  ZSCR.CR_ZBLQFLG <> 'N' AND " + CRLF 
		cUpd += "                  ZSCR.CR_STATUS IN ('03','04','06') AND " + CRLF 
		cUpd += "				   ZSCR.CR_ZHRINT = '  ' AND "  + CRLF
		cUpd += "                  ZSE2.E2_ZBLQFLG = 'N' " + CRLF 
		cUpd += "                GROUP BY ZSCR.CR_FILIAL||ZSCR.CR_TIPO|| ZSCR.CR_NUM) "				
		
		TcSQLExec(cUpd)
		
		BeginSql Alias cNextAlias		
			SELECT
				SCR.CR_FILIAL,
				SCR.CR_TIPO,
				SCR.CR_NUM,
				SCR.CR_TIPO,
				SCR.CR_USER,
				SCR.CR_STATUS,
				SCR.CR_ZUSELIB,
				SCR.CR_NIVEL,
				CASE 
				WHEN SYS.UTL_RAW.CAST_TO_VARCHAR2(SCR.CR_OBS) IS NULL THEN ' ' 
				ELSE SYS.UTL_RAW.CAST_TO_VARCHAR2(SCR.CR_OBS) END CR_OBS
			FROM 
				%Table:SCR% SCR
			WHERE
				SCR.CR_ZIDINTE = %exp:cCod%
		EndSql

	ElseIf cProc == 'RPR'

		If SubStr(Time(),1,2) == '00'
			nMin := 3
			nMax := 21 
		ElseIf SubStr(Time(),1,2) == '01'
			nMin := 4
			nMax := 22
		ElseIf SubStr(Time(),1,2) == '02'
			nMin := 5
			nMax := 23			
		ElseIf SubStr(Time(),1,2) == '03'
			nMin := 6
			nMax := 24			
		ElseIf SubStr(Time(),1,2) == '21'
			nMin := 0
			nMax := 18
		ElseIf SubStr(Time(),1,2) == '22'
			nMin := 1
			nMax := 19			
		ElseIf SubStr(Time(),1,2) == '23'
			nMin := 2
			nMax := 20						
		Else
														//04 - 05 - 06 - 07 - 08 - 09 - 10 - 11 - 12 - 13 - 14 - 15 - 16 - 17 - 18 - 19 - 20  hora
			nMax := val(SubStr(Time(),1,2)) - Val(cNum) //01 - 02 - 03 - 04 - 05 - 06 - 07 - 08 - 09 - 10 - 11 - 12 - 13 - 14 - 15 - 16 - 17  hora - 3
			nMin := val(SubStr(Time(),1,2)) + Val(cNum) //07 - 08 - 09 - 10 - 11 - 12 - 13 - 14 - 15 - 16 - 17 - 18 - 19 - 20 - 21 - 22 - 23  hora + 3
		EndIf

		//SC
		cUpd := "UPDATE " + RetSQLName("SCR") + " SCR " + CRLF
		cUpd += "  SET CR_ZIDINTE = '" + cCod + "' " + CRLF
		cUpd += " WHERE " + CRLF
		cUpd += "  SCR.D_E_L_E_T_ = ' ' AND " + CRLF
		cUpd += "  SCR.CR_FILIAL || SCR.CR_TIPO || SCR.CR_NUM  || SCR.CR_NIVEL IN (SELECT " + CRLF
		cUpd += "                  ZSCR.CR_FILIAL || ZSCR.CR_TIPO || ZSCR.CR_NUM  || ZSCR.CR_NIVEL CHV " + CRLF
		cUpd += "                FROM " + CRLF
		cUpd += "                  " + RetSQLName("SCR") + " ZSCR " + CRLF
		cUpd += "                INNER JOIN " + RetSQLName("SC1")  + " ZSC1 " + CRLF
		cUpd += "                   ON ZSCR.CR_FILIAL = ZSC1.C1_FILIAL " + CRLF
		cUpd += "                  AND RTRIM(ZSCR.CR_NUM) = ZSC1.C1_NUM " + CRLF
		cUpd += "                WHERE " + CRLF
		cUpd += "                  ZSCR.D_E_L_E_T_ = ' ' AND " + CRLF
		cUpd += "                  ZSC1.D_E_L_E_T_ = ' ' AND " + CRLF
		cUpd += "                  ZSCR.CR_ZBLQFLG = 'N' AND " + CRLF
		cUpd += "                  ZSCR.CR_STATUS IN ('03','04','06') AND " + CRLF
		cUpd += "				   ZSCR.CR_ZHRINT <> '  ' AND "  + CRLF
		cUpd += "				   (ZSCR.CR_ZHRINT > '" + STRZERO(nMin,2,0) + "' AND ZSCR.CR_ZHRINT < '" + STRZERO(nMax,2,0) + "') AND "  + CRLF
		cUpd += "                  ZSC1.C1_ZBLQFLG = 'S') " + CRLF
		
		TcSQLExec(cUpd)

		//PC
		cUpd := "UPDATE " + RetSQLName("SCR") + " SCR " + CRLF
		cUpd += "    SET CR_ZIDINTE = '" + cCod  + "' " + CRLF
		cUpd += " WHERE " + CRLF
		cUpd += "    SCR.D_E_L_E_T_ = ' ' AND " + CRLF
		cUpd += "    SCR.CR_FILIAL || SCR.CR_TIPO || SCR.CR_NUM  || SCR.CR_NIVEL IN (SELECT " + CRLF
		cUpd += "                    ZSCR.CR_FILIAL || ZSCR.CR_TIPO || ZSCR.CR_NUM  || MIN(ZSCR.CR_NIVEL) CHV " + CRLF
		cUpd += "                  FROM " + CRLF
		cUpd += "                    " + RetSQLName("SCR") + " ZSCR " + CRLF
		cUpd += "                  INNER JOIN " + RetSQLName("SC7") + " ZSC7 " + CRLF
		cUpd += "                     ON ZSCR.CR_FILIAL = ZSC7.C7_FILIAL " + CRLF
		cUpd += "                    AND RTRIM(ZSCR.CR_NUM) = ZSC7.C7_NUM " + CRLF
		cUpd += "                  WHERE " + CRLF
		cUpd += "                    ZSCR.D_E_L_E_T_ = ' ' AND " + CRLF
		cUpd += "                    ZSC7.D_E_L_E_T_ = ' ' AND " + CRLF
		cUpd += "                    ZSCR.CR_ZBLQFLG = 'N' AND " + CRLF
		cUpd += "                    ZSCR.CR_STATUS IN ('03','04','06') AND " + CRLF
		cUpd += "				   ZSCR.CR_ZHRINT <> '  ' AND "  + CRLF
		cUpd += "				   (ZSCR.CR_ZHRINT > '" + STRZERO(nMin,2,0) + "' AND ZSCR.CR_ZHRINT < '" + STRZERO(nMax,2,0) + "') AND "  + CRLF
		cUpd += "                    ZSC7.C7_ZBLQFLG = 'S' " + CRLF
		cUpd += "                  GROUP BY ZSCR.CR_FILIAL||ZSCR.CR_TIPO|| ZSCR.CR_NUM) "
		
		TcSQLExec(cUpd)
		
		//ZC
		cUpd := "UPDATE " + RetSQLName("SCR") + " SCR " + CRLF
		cUpd += "  SET CR_ZIDINTE = '" + cCod + "' " + CRLF
		cUpd += " WHERE " + CRLF
		cUpd += "  SCR.D_E_L_E_T_ = ' ' AND " + CRLF
		cUpd += "  SCR.CR_FILIAL || SCR.CR_TIPO || SCR.CR_NUM  || SCR.CR_NIVEL IN (SELECT " + CRLF
		cUpd += "                  ZSCR.CR_FILIAL || ZSCR.CR_TIPO || ZSCR.CR_NUM  || MIN(ZSCR.CR_NIVEL) CHV " + CRLF
		cUpd += "                FROM " + CRLF
		cUpd += "                  " + RetSQLName("SCR") + " ZSCR " + CRLF
		cUpd += "                INNER JOIN " + RetSQLName("SE2") + " ZSE2 " + CRLF
		cUpd += "                   ON ZSCR.CR_FILIAL = ZSE2.E2_FILIAL " + CRLF
		cUpd += "                  AND RTRIM(ZSCR.CR_NUM) = ZSE2.E2_PREFIXO || ZSE2.E2_NUM || ZSE2.E2_PARCELA || ZSE2.E2_TIPO || ZSE2.E2_FORNECE || ZSE2.E2_LOJA " + CRLF
		cUpd += "                WHERE " + CRLF
		cUpd += "                  ZSCR.D_E_L_E_T_ = ' ' AND " + CRLF
		cUpd += "                  ZSE2.D_E_L_E_T_ = ' ' AND " + CRLF
		cUpd += "                  ZSCR.CR_ZBLQFLG = 'N' AND " + CRLF
		cUpd += "                  ZSCR.CR_STATUS IN ('03','04','06') AND " + CRLF
		cUpd += "				   ZSCR.CR_ZHRINT <> '  ' AND "  + CRLF
		cUpd += "				   (ZSCR.CR_ZHRINT > '" + STRZERO(nMin,2,0) + "' AND ZSCR.CR_ZHRINT < '" + STRZERO(nMax,2,0) + "') AND "  + CRLF
		cUpd += "                  ZSE2.E2_ZBLQFLG = 'S' " + CRLF
		cUpd += "                GROUP BY ZSCR.CR_FILIAL||ZSCR.CR_TIPO|| ZSCR.CR_NUM) "
		
		TcSQLExec(cUpd)
		
		BeginSql Alias cNextAlias		
			SELECT
				SCR.CR_FILIAL,
				SCR.CR_TIPO,
				SCR.CR_NUM,
				SCR.CR_TIPO,
				SCR.CR_USER,
				SCR.CR_STATUS,
				SCR.CR_ZUSELIB,
				SCR.CR_NIVEL,
				CASE 
				WHEN SYS.UTL_RAW.CAST_TO_VARCHAR2(SCR.CR_OBS) IS NULL THEN ' ' 
				ELSE SYS.UTL_RAW.CAST_TO_VARCHAR2(SCR.CR_OBS) END CR_OBS
			FROM 
				%Table:SCR% SCR
			WHERE
				SCR.CR_ZIDINTE = %exp:cCod%
		EndSql	
	
	EndIf
	
	(cNextAlias)->(DbGoTop())
	
	RestArea(aArea)

Return (cNextAlias)

Static Function xPreDadSC(cxFil,cSC)

	Local aArea 	:= GetArea()
	Local aAreaSC1	:= SC1->(GetArea())
	Local aAreaSCR	:= SCR->(GetArea())
	
	Local aDados	:= {}
	Local aCabSol	:= {}
	Local aItemSol  := {}
	Local aGrpSol	:= {}
	Local aAprov	:= {}
	Local aGrpAprov := {}
	
	Local cChvSCR	:= ''
	Local cRateio	:= ''
	
	If Type('__aXAllUser') <> 'A'
		//U_xMGC10CRIP()
		xCarUsers()
	EndIf
	
	dbSelectArea('SC1')
	SC1->(dbSetOrder(1))//C1_FILIAL, C1_NUM, C1_ITEM, C1_ITEMGRD
	
	If SC1->(DbSeek( cxFil + cSC))
		
		//Cabeçalho
		AADD(aCabSol,SC1->C1_FILIAL)
		AADD(aCabSol,SC1->C1_NUM)
		AADD(aCabSol,SC1->C1_SOLICIT)
		AADD(aCabSol,DtoC(SC1->C1_EMISSAO))
		AADD(aCabSol,SC1->C1_UNIDREQ)
		AADD(aCabSol,FWFilialName())
		AADD(aCabSol,UsrRetMail(RetCodUsr()))
		
		AADD(aDados,aCabSol)
		
		//Itens da Solicitação de Compra
		While SC1->(!Eof()) .and. cxFil + cSC == SC1->(C1_FILIAL + C1_NUM)
			
			aItemSol  := {}
			
			cRateio := IIF(SC1->C1_RATEIO=='1','Sim','Não')
			
			AADD(aItemSol,SC1->C1_ITEM)
			AADD(aItemSol,SC1->C1_PRODUTO)
			AADD(aItemSol,POSICIONE('SB1',1,xFilial('SB1',cxFil) + SC1->C1_PRODUTO,'B1_GRUPO'))
			AADD(aItemSol,SC1->C1_UM)
			AADD(aItemSol,SC1->C1_DESCRI)
			AADD(aItemSol,TRANSFORM(SC1->C1_QUANT,'@E 999999999.99'))
			AADD(aItemSol,DtoC(SC1->C1_DATPRF))
			AADD(aItemSol,SC1->C1_OBS)
			AADD(aItemSol,SC1->C1_CC)
			AADD(aItemSol,SC1->C1_CONTA)
			AADD(aItemSol,SC1->C1_ITEMCTA)
			AADD(aItemSol,SC1->C1_CLVL)
			AADD(aItemSol,TRANSFORM(SC1->C1_VUNIT,'@E 999,999,999.99'))
			AADD(aItemSol,SC1->C1_FLAGGCT)
			AADD(aItemSol,cRateio)
			
			AADD(aGrpSol,aItemSol)
			
			SC1->(dbSkip())
		EndDo
			
		AADD(aDados,aGrpSol)	
		
		dbSelectArea('SCR')
		SCR->(dbSetOrder(1))//CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL
		cChvSCR := xFilial('SCR',cxFil) + 'SC' + cSC
		If SCR->(dbSeek(cChvSCR))
			While SCR->(!Eof()) .and. cChvSCR == SCR->(CR_FILIAL + CR_TIPO ) + SUBSTR(SCR->CR_NUM,1,6)
				
				aAprov := {}
				
				AADD(aAprov,SCR->CR_NIVEL)
				AADD(aAprov,SCR->CR_USER)
				AADD(aAprov,U_MGFc8USER(SCR->CR_USER))
				AADD(aAprov,U_MGF3Achr(SCR->CR_APROV)[1])
				
				AADD(aGrpAprov,aAprov)
				SCR->(dbSkip())
			EndDo
			
			AADD(aDados,aGrpAprov)
			
		EndIf
			
	EndIf
		
	RestArea(aAreaSCR)
	RestArea(aAreaSC1)
	RestArea(aArea)

Return aDados

Static Function xPreDadPC(cxFil,cPed)

	Local aArea 	:= GetArea()
	Local aAreaSC7	:= SC7->(GetArea()) 
	Local aAreaSCR	:= SCR->(GetArea())
	Local aAreaSA2	:= SA2->(GetArea())
	Local aAreaSE4	:= SE4->(GetArea())	
	
	Local aDados	:= {}
	Local aCabSol	:= {}
	Local aItemSol  := {}
	Local aGrpSol	:= {}
	Local aAprov	:= {}
	Local aGrpAprov := {}
	
	Local cChvSCR	:= ''
	Local cRateio	:= ''
	
	Local nTotal	:= 0
	
	If Type('__aXAllUser') <> 'A'
		//U_xMGC10CRIP()
		xCarUsers()
	EndIf
	
	dbSelectArea('SC7')
	SC7->(dbSetOrder(1))//C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN
	
	If SC7->(DbSeek( cxFil + cPed))
		
		//Cabeçalho C7_FORNECE,C7_LOJA
		AADD(aCabSol,SC7->C7_FORNECE)
		AADD(aCabSol,SC7->C7_LOJA)
		AADD(aCabSol,SC7->C7_COND + ' - ' + POSICIONE('SE4',1,xFilial('SE4',cxFil) + SC7->C7_COND ,'E4_COND') )
		AADD(aCabSol,SC7->C7_FILIAL)
		AADD(aCabSol,SC7->C7_FILENT)
		AADD(aCabSol,DtoC(SC7->C7_EMISSAO))
		AADD(aCabSol,SC7->C7_NUM)
		AADD(aCabSol,TRANSFORM(SC7->C7_MOEDA,PesqPict('SC7','C7_MOEDA')) + ' - ' + GetMv('MV_MOEDA' + Alltrim(Str(SC7->C7_MOEDA))))
		AADD(aCabSol,TRANSFORM(SC7->C7_TXMOEDA,PesqPict('SC7','C7_TXMOEDA')))
		AADD(aCabSol,UsrRetMail(RetCodUsr()))
		AADD(aCabSol,Posicione('SA2',1,xFilial('SA2',cxFil)+SC7->C7_FORNECE + SC7->C7_LOJA,'A2_NREDUZ'))
		AADD(aCabSol,FWFilialName())
		AADD(aCabSol,FWFilialName(cEmpAnt,SC7->C7_FILENT))
				
		AADD(aDados,aCabSol)
		
		//Itens da Solicitação de Compra
		While SC7->(!Eof()) .and. cxFil + cPed == SC7->(C7_FILIAL + C7_NUM)
			
			aItemSol  := {}
			
			AADD(aItemSol,SC7->C7_ITEM)
			AADD(aItemSol,SC7->C7_PRODUTO)
			AADD(aItemSol,SC7->C7_DESCRI)
			AADD(aItemSol,SC7->C7_UM)
			AADD(aItemSol,TRANSFORM(SC7->C7_QUANT,PesqPict('SC7','C7_QUANT')))
			AADD(aItemSol,TRANSFORM(SC7->C7_PRECO,PesqPict('SC7','C7_PRECO')))
			AADD(aItemSol,TRANSFORM(SC7->C7_TOTAL,PesqPict('SC7','C7_TOTAL')))
			AADD(aItemSol,DtoC(SC7->C7_DATPRF))
			AADD(aItemSol,SC7->C7_OBS)
			AADD(aItemSol,TRANSFORM(SC7->C7_VLDESC,PesqPict('SC7','C7_VLDESC')))
			AADD(aItemSol,TRANSFORM(SC7->C7_DESC,PesqPict('SC7','C7_DESC')))
			AADD(aItemSol,TRANSFORM(SC7->C7_SEGURO,PesqPict('SC7','C7_SEGURO')))
			AADD(aItemSol,TRANSFORM(SC7->C7_DESPESA,PesqPict('SC7','C7_DESPESA')))
			AADD(aItemSol,TRANSFORM(SC7->C7_VALFRE,PesqPict('SC7','C7_VALFRE')) )
			AADD(aItemSol,TRANSFORM(SC7->C7_TPFRETE,PesqPict('SC7','C7_TPFRETE')))
			AADD(aItemSol,TRANSFORM(SC7->C7_IPI,PesqPict('SC7','C7_IPI')))
			AADD(aItemSol,TRANSFORM(SC7->C7_VALIPI,PesqPict('SC7','C7_VALIPI')))
			AADD(aItemSol,TRANSFORM(SC7->C7_PICM,PesqPict('SC7','C7_PICM')))
			AADD(aItemSol,TRANSFORM(SC7->C7_VALICM,PesqPict('SC7','C7_VALICM')))
			AADD(aItemSol,SC7->C7_CONTRA)
			If SC7->C7_BASIMP5 > 0 .and. SC7->C7_VALIMP5 > 0
				AADD(aItemSol,TRANSFORM((SC7->C7_VALIMP5 / SC7->C7_BASIMP5) * 100,PesqPict('SC7','C7_PICM')))
			Else
				AADD(aItemSol,TRANSFORM(0,PesqPict('SC7','C7_PICM')))
			EndIf
			AADD(aItemSol,TRANSFORM(SC7->C7_VALIMP5,PesqPict('SC7','C7_VALIMP5')))
			If !Empty(SC7->C7_CC)
				AADD(aItemSol,SC7->C7_CC)
			Else
				AADD(aItemSol,SC7->C7_ZCC)
			EndIf
				
			AADD(aGrpSol,aItemSol)
			
			nTotal += SC7->C7_TOTAL
			
			SC7->(dbSkip())
		EndDo
			
		AADD(aDados,aGrpSol)
		
		dbSelectArea('SCR')
		SCR->(dbSetOrder(1))//CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL
		cChvSCR := xFilial('SCR',cxFil) + 'PC' + cPed
		If SCR->(dbSeek(cChvSCR))
			While SCR->(!Eof()) .and. cChvSCR == SCR->(CR_FILIAL + CR_TIPO ) + SUBSTR(SCR->CR_NUM,1,6)
				
				aAprov := {}
				
				AADD(aAprov,SCR->CR_NIVEL)
				AADD(aAprov,SCR->CR_USER)
				AADD(aAprov,U_MGFc8USER(SCR->CR_USER))
				AADD(aAprov,U_MGF3Achr(SCR->CR_APROV)[1])
				
				AADD(aGrpAprov,aAprov)
				SCR->(dbSkip())
			EndDo
			
			AADD(aDados,aGrpAprov)
			
		EndIf
			
	EndIf
	
	AADD(aDados[1],TRANSFORM(nTotal,PesqPict('SC7','C7_TOTAL')))
	
	RestArea(aAreaSE4)	
	RestArea(aAreaSA2)	
	RestArea(aAreaSCR)
	RestArea(aAreaSC7)
	RestArea(aArea)

Return aDados

Static Function xPreDadTi(cxFil,cTit)

	Local aArea 	:= GetArea()
	Local aAreaSE2	:= SE2->(GetArea())
	Local aAreaSCR	:= SCR->(GetArea())
	
	Local aDados	:= {}
	Local aCabSol	:= {}
	Local aItemSol  := {}
	Local aGrpSol	:= {}
	Local aAprov	:= {}
	Local aGrpAprov := {}
	
	Local cChvSCR	:= ''
	Local cRateio	:= ''
	
	//Local nTamChav	:= TamSx3('E2_PREFIXO')[1] + TamSx3('E2_NUM')[1] + TamSx3('E2_PARCELA')[1] + TamSx3('E2_TIPO')[1] + TamSx3('E2_FORNECE')[1] + TamSx3('E2_LOJA')[1]
	Local nTamChav	:= Len(SE2->E2_PREFIXO) + Len(SE2->E2_NUM) + Len(SE2->E2_PARCELA) + Len(SE2->E2_TIPO) + Len(SE2->E2_FORNECE) + Len(SE2->E2_LOJA)
	
	If Type('__aXAllUser') <> 'A'
		//U_xMGC10CRIP()
		xCarUsers()
	EndIf
	
	dbSelectArea('SE2')
	SE2->(dbSetOrder(1))//E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA
	
	If SE2->(DbSeek(cxFil + cTit))
		
		AADD(aCabSol,SE2->E2_FILIAL)											//01
		AADD(aCabSol,SE2->E2_PREFIXO)											//02
		AADD(aCabSol,SE2->E2_PARCELA)											//03
		AADD(aCabSol,SE2->E2_TIPO)												//04
		AADD(aCabSol,SE2->E2_NATUREZ)											//05
		AADD(aCabSol,SE2->E2_FORNECE)											//06
		AADD(aCabSol,SE2->E2_LOJA)												//07
		AADD(aCabSol,SE2->E2_NOMFOR)											//08
		AADD(aCabSol,DtoC(SE2->E2_EMISSAO))										//09
		AADD(aCabSol,DtoC(SE2->E2_VENCTO))										//10
		AADD(aCabSol,DtoC(SE2->E2_VENCREA))										//11
		AADD(aCabSol,TRANSFORM(SE2->E2_VALOR,PesqPict('SE2','E2_VALOR')))		//12
		AADD(aCabSol,TRANSFORM(SE2->E2_ISS,PesqPict('SE2','E2_ISS')))			//13
		AADD(aCabSol,TRANSFORM(SE2->E2_IRRF,PesqPict('SE2','E2_IRRF')))			//14
		AADD(aCabSol,SE2->E2_HIST)												//15
		AADD(aCabSol,TRANSFORM(SE2->E2_SALDO,PesqPict('SE2','E2_SALDO')))		//16
		AADD(aCabSol,TRANSFORM(SE2->E2_VALJUR,PesqPict('SE2','E2_VALJUR')))		//17
		AADD(aCabSol,TRANSFORM(SE2->E2_PORCJUR,PesqPict('SE2','E2_PORCJUR')))	//18
		AADD(aCabSol,TRANSFORM(SE2->E2_MOEDA,PesqPict('SE2','E2_MOEDA')))		//19
		AADD(aCabSol,SE2->E2_RATEIO)											//20
		AADD(aCabSol,TRANSFORM(SE2->E2_VALOR,PesqPict('SE2','E2_VALOR')))		//21
		AADD(aCabSol,TRANSFORM(SE2->E2_ACRESC,PesqPict('SE2','E2_ACRESC')))		//22
		AADD(aCabSol,SE2->E2_FLUXO)												//23
		AADD(aCabSol,TRANSFORM(SE2->E2_INSS,PesqPict('SE2','E2_INSS')))			//24
		AADD(aCabSol,TRANSFORM(SE2->E2_TXMOEDA,PesqPict('SE2','E2_TXMOEDA')))	//25
		AADD(aCabSol,TRANSFORM(SE2->E2_DECRESC,PesqPict('SE2','E2_DECRESC')))	//26
		AADD(aCabSol,SE2->E2_CODRET)											//27
		AADD(aCabSol,TRANSFORM(SE2->E2_SEST,PesqPict('SE2','E2_SEST')))			//28
		AADD(aCabSol,TRANSFORM(SE2->E2_COFINS,PesqPict('SE2','E2_COFINS')))		//29
		AADD(aCabSol,TRANSFORM(SE2->E2_PIS,PesqPict('SE2','E2_PIS')))			//30
		AADD(aCabSol,TRANSFORM(SE2->E2_CSLL,PesqPict('SE2','E2_CSLL')))			//31
		AADD(aCabSol,DtoC(SE2->E2_VENCISS))										//32
		AADD(aCabSol,TRANSFORM(SE2->E2_VBASISS,PesqPict('SE2','E2_VBASISS')))	//33
		AADD(aCabSol,SE2->E2_MDCONTR)											//34
		AADD(aCabSol,TRANSFORM(SE2->E2_TXMDCOR,PesqPict('SE2','E2_TXMDCOR')))	//35
		AADD(aCabSol,TRANSFORM(SE2->E2_ISS,PesqPict('SE2','E2_ISS')))			//36
		AADD(aCabSol,TRANSFORM(SE2->E2_RETCNTR,PesqPict('SE2','E2_RETCNTR')))	//37
		AADD(aCabSol,TRANSFORM(SE2->E2_MDDESC,PesqPict('SE2','E2_MDDESC')))		//38
		AADD(aCabSol,TRANSFORM(SE2->E2_MDBONI,PesqPict('SE2','E2_MDBONI')))		//39
		AADD(aCabSol,TRANSFORM(SE2->E2_MDMULT,PesqPict('SE2','E2_MDMULT')))		//40
		AADD(aCabSol,SE2->E2_CCUSTO)											//41
		AADD(aCabSol,SE2->E2_TPESOC)											//42
		AADD(aCabSol,SE2->E2_NUM)												//43
		
		AADD(aDados,aCabSol)
	
		dbSelectArea('SCR')
		SCR->(dbSetOrder(1))//CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL
		cChvSCR := xFilial('SCR',cxFil) + 'ZC' + cTit
		If SCR->(dbSeek(cChvSCR))
			While SCR->(!Eof()) .and. cChvSCR == SCR->(CR_FILIAL + CR_TIPO ) + SUBSTR(SCR->CR_NUM,1,nTamChav)
				aAprov := {}
				AADD(aAprov,SCR->CR_NIVEL)
				AADD(aAprov,SCR->CR_USER)
				AADD(aAprov,U_MGFc8USER(SCR->CR_USER))
				AADD(aAprov,U_MGF3Achr(SCR->CR_APROV)[1])
				AADD(aGrpAprov,aAprov)
				SCR->(dbSkip())
			EndDo
			AADD(aDados,aGrpAprov)
		EndIf
	EndIf
		
	RestArea(aAreaSCR)
	RestArea(aAreaSE2)
	RestArea(aArea)

Return aDados

Static Function xIncSC(aDados)
	
	Local aArea 	 := GetArea()
	Local aItem		 := {}
	Local oClassCard := nil
	Local nf
	
	If Len(aDados) == 3
		
		/*oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := 'tNumFluig'
		oClassCard:cvalue := aDados[ni][XCABSOL][1]
		aAdd(aItem,oClassCard)*/
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tFilial')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][1])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tNumSolicCompra')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][2])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tSolicitante')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][3])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('dDataSolic')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][4])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tUnidRequisitante')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][5])
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tDescFilial')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][6])
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('hEmailSolicitante')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][7])
		aAdd(aItem,oClassCard)
		
		//Preenchimento dos Itens
		For nf := 1 to Len(aDados[XITESOL])
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('nItem___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][1])
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('nCodProduto___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][2])
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('nCodGrupoProduto___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][3])
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tUniMedida___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][4])
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tDescricao___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][5])
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('nQuantidade___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][6])
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('dDtNecessidade___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][7])
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tObservacao___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][8])
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('nCentroCusto___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][9])
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('nContaContabil___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][10])
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tItemCC___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][11])
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tClasseValor___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][12])
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('vPrecoEstimado___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][13])
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tCtrContrato___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][14])
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tRateio___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][15])
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
			oClassCard:cvalue := AllTrim(aDados[XAPRSOL][nf][1])
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tMatriculaAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XAPRSOL][nf][2])
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tNomeAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XAPRSOL][nf][3])
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('hPrazo___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XAPRSOL][nf][4])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tDecisaoAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := ' '
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tDataAprovacao___' + Alltrim(Str(nf)))
			oClassCard:cvalue := ' '
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tHoraAprovacao___' + Alltrim(Str(nf)))
			oClassCard:cvalue := ' '
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tObsAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := ' '
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
	
	RestArea(aArea)
	
Return aItem

Static Function xIncPC(aDados)

	Local aArea 	 := GetArea()
	Local aItem		 := {}
	Local oClassCard := nil
	Local nf
	
	If Len(aDados) == 3

		/*oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tNumFluig')
		oClassCard:cvalue := aDados[XCABSOL][1]
		aAdd(aItem,oClassCard)*/

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tFornecedor')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][1])
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tLoja')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][2])
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tCondicaoPagto')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][3])
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tFilial')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][4])
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tFilialEntrada')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][5])
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tDataEmissao')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][6])
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tNumPC')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][7])
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tMoeda')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][8])
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tTaxaMoeda')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][9])
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('hEmailSolicitante')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][10])
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tDescFornecedor')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][11])
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tDescFilial')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][12])
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tDescFilialEntrada')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][13])
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tValorTotal')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][14])
		aAdd(aItem,oClassCard)
		
		//Preenchimento dos Itens
		For nf := 1 to Len(aDados[XITESOL])

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('nItem___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][1])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('nCodProduto___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][2])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tDescricao___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][3])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tUnidade___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][4])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tQuantidade___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][5])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('mPrecoUnitario___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][6])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('mValorTotal___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][7])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('dDataEntrega___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][8])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tObservacoes___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][9])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('mValorDesconto___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][10])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('pDescontoItem___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][11])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('mValorSeguro___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][12])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('mValorDespesas___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][13])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('mValorFrete___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][14])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tTipoFrete___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][15])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('pAliqIPI___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][16])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('mValorIPI___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][17])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('pAliqICMS___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][18])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('mValorICMS___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][19])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tNumContrato___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][20])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('pImposto5___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][21])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('mImposto5___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][22])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tCentroCusto___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][23])
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
			oClassCard:cvalue := AllTrim(aDados[XAPRSOL][nf][1])
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tMatriculaAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XAPRSOL][nf][2])
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tNomeAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XAPRSOL][nf][3])
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('hPrazo___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XAPRSOL][nf][4])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tDecisaoAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := ' '
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tDataAprovacao___' + Alltrim(Str(nf)))
			oClassCard:cvalue := ' '
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tHoraAprovacao___' + Alltrim(Str(nf)))
			oClassCard:cvalue := ' '
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tObsAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := ' '
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
	
	RestArea(aArea)
	
Return aItem

Static Function xIncTIT(aDados)

	Local aArea 	 := GetArea()
	Local aItem		 := {}
	Local oClassCard := nil
	Local nf
	
	If Len(aDados) == 2
		
		/*oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tNumFluig')
		oClassCard:cvalue := aDados[XCABSOL][1]
		aAdd(aItem,oClassCard)*/
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tFilial')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][1])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tPrefixo')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][2])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tParcela')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][3])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tTipo')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][4])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tNatureza')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][5])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tFornecedor')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][6])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tLoja')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][7])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tNomeFornecedor')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][8])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('dDataEmissao')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][9])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('dVencimento')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][10])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('dVencimentoReal')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][11])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('mValorTitulo')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][12])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('pISS')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][13])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('pIRRF')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][14])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tHistorico')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][15])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('mSaldo')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][16])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('mTaxaPerman')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][17])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tPCJuros')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][18])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tMoeda')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][19])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tRateio')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][20])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('mValor')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][21])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tAcrescimo')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][22])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tFluxoCaixa')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][23])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('pINSS')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][24])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tTaxaMoeda')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][25])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tDecrescimo')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][26])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tCDRetencao')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][27])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tSestSenat')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][28])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('pCOFINS')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][29])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('pPisPasep')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][30])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('pCSLL')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][31])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('dVencISS')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][32])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('mVlrAcServ')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][33])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tNumContrato')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][34])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('pTxCorMoeda')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][35])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tCodAliqISS')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][36])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tRetencaoCtr')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][37])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('nDescontoCtr')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][38])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tBonificacaoCtr')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][39])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('mMultaCtr')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][40])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tCentroCusto')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][41])
		aAdd(aItem,oClassCard)
		
		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tTipoServico')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][42])
		aAdd(aItem,oClassCard)

		oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
		oClassCard:ckey := UPPER('tNumTitulo')
		oClassCard:cvalue := AllTrim(aDados[XCABSOL][43])
		aAdd(aItem,oClassCard)
		
		//Preenchimento dos Aprovadores
		For nf := 1 to Len(aDados[XITESOL])
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('nSeqAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := STRZERO(nf,2)//aDados[XAPRSOL][nf][1]
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('nNivelAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][1])
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tMatriculaAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][2])
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tNomeAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][3])
			aAdd(aItem,oClassCard)
			
			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('hPrazo___' + Alltrim(Str(nf)))
			oClassCard:cvalue := AllTrim(aDados[XITESOL][nf][4])
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tDecisaoAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := ' '
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tDataAprovacao___' + Alltrim(Str(nf)))
			oClassCard:cvalue := ' '
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tHoraAprovacao___' + Alltrim(Str(nf)))
			oClassCard:cvalue := ' '
			aAdd(aItem,oClassCard)

			oClassCard	:= ECMWorkflowEngineServiceService_keyValueDto():New()
			oClassCard:ckey := UPPER('tObsAprovador___' + Alltrim(Str(nf)))
			oClassCard:cvalue := ' '
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
	
	RestArea(aArea)
	
Return aItem

Static Function xIncFlg(aDados,cTip)
	
	Local aArea := GetArea()
	
	Local oObj := WSECMWorkflowEngineServiceService():New()
	Local oResulObj := nil
	
	Local aItem := {}
	Local cCodFlg	:= ''
	Local cProcId 	:= ''
	Local cComents	:= ''
	Local ni
	
	If cTip == 'SC'
		cProcId := "WfSolicitacaoCompras"
		aItem 	:= xIncSC(aDados)
		cComents:= 'Solicitação incluido via Protheus'
	ElseIf cTip == 'PC' 
		cProcId := "wfPedidoCompras"
		aItem 	:= xIncPC(aDados)
		cComents:= 'Pedido incluido via Protheus'
	ElseIf cTip == 'ZC'
		cProcId := "wfTituloPagar"
		aItem 	:= xIncTIT(aDados)//aqui coloco pro fluig
		cComents:= 'Titulo incluido via Protheus'
	EndIf
	
	oObj:cusername		:= Alltrim(SuperGetMV("MGF_FLGUSR",.F.,'adm'))//GetMv("TI_FLGUSR")		//("MV_FLGUSR",,"cristina.poffo@totvs.com.br")
	oObj:cpassword		:= Alltrim(SuperGetMV("MGF_FLGPSW",.F.,'adm'))//GetMv("TI_FLGPSW")		//("MV_FLGPSW",,"Totvs@123")
	oObj:cuserId		:= Alltrim(SuperGetMV("MGF_FLGUSR",.F.,'adm'))//GetMv("TI_FLGID")		//("MV_FLGID",,"13849989")
	oObj:ncompanyId		:= 1
	oObj:cprocessId		:= cProcId
	oObj:nchoosedState	:= 40
	oObj:ccomments 		:= cComents
	oObj:lcompleteTask	:= .T.
	oObj:lmanagerMode	:= .F.
	
	If Len(aItem) > 0
		
		oObj:oWSstartProcessClassiccardData:oWSitem := aItem
		
		If oObj:startProcessClassic()
			oResulObj:= oObj:oWSstartProcessClassicResult
			
			For ni := 1 to Len(oResulObj:oWsItem)
				
				If Alltrim(UPPER(oResulObj:oWsItem[ni]:cKey)) == 'ERROR'
					If !IsBlind()
						Alert('Erro ao Integrar com o Fluig Inclusao: ' + cTip + ': ' + oResulObj:oWsItem[ni]:cValue)
					Else
						conout('Erro ao Integrar com o Fluig Inclusao: ' + cTip + ': ' + oResulObj:oWsItem[ni]:cValue)
					EndIf
					Exit
				Else
					If Alltrim(UPPER(oResulObj:oWsItem[ni]:cKey)) == 'IPROCESS'
						cCodFlg := STRZERO(Val(oResulObj:oWsItem[ni]:cValue),9)
					EndIf
				EndIf
			Next ni
		Else
			If !IsBlind()
				Alert('Processo teve problema no metodo oObj:startProcessClassic()')
			Else
				conout('Processo teve problema no metodo oObj:startProcessClassic()')
			EndIf
		EndIf
		
	EndIf
	
	RestArea(aArea)
	
Return cCodFlg

Static Function xExcFLG(cCodFlg)
	
	Local aArea 	:= GetArea()
	
	Local oObj 		:= WSECMWorkflowEngineServiceService():New()
	Local oResulObj := nil
	Local lRet		:= .F.
	
	oObj:cusername			:= Alltrim(SuperGetMV("MGF_FLGUSR",.F.,'adm'))//GetMv("TI_FLGUSR")		//("MV_FLGUSR",,"cristina.poffo@totvs.com.br")
	oObj:cpassword			:= Alltrim(SuperGetMV("MGF_FLGPSW",.F.,'adm'))//GetMv("TI_FLGPSW")		//("MV_FLGPSW",,"Totvs@123")
	oObj:cuserId			:= Alltrim(SuperGetMV("MGF_FLGUSR",.F.,'adm'))//xxRetUser()//GetMv("TI_FLGID")		//("MV_FLGID",,"13849989")
	oObj:ncompanyId			:= 1
	oObj:nProcessInstanceId	:= Val(cCodFlg)//"saveAndSendTaskClassic"
	
	/*If cDel == '*'
		oObj:ccancelText := 'DELETADO'
	Else
		oObj:ccancelText := 'Excluido Pelo Protheus'
	EndIf*/
	
	oObj:ccancelText := 'Excluido Pelo Protheus'
	
	oObj:cancelInstance()
	
	lRet := Alltrim(UPPER(oObj:cResult)) == 'OK'
	
	RestArea(aArea)
	
Return lRet

User Function xUsuarios()
	Public __aXAllUser := FwSFAllUsers()
Return

Static Function xVerUsr()

	Local aArea 	:= GetArea()
	Local cNextAlias:= GetNextAlias()
	Local cUpd		:= ''
	Local cUser		:= Space(Len(SCR->CR_ZUSELIB)) 
	Local cCod 		:= AllTrim(GetMv('MGF_IDIFLG'))
	
	PUTMV('MGF_IDIFLG', Soma1(cCod))

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	EndIf

	/*cUpd := "UPDATE " + RetSQLName("SAK")  + " SAK " + CRLF
	cUpd += " SET AK_ZIDINTE = '" + cCod + "' "   + CRLF
	cUpd += " WHERE " + CRLF
	cUpd += " SAK.AK_ZIDINTE = '" + Space(Len(SAK->AK_ZIDINTE)) + "' AND " + CRLF
	cUpd += " SAK.D_E_L_E_T_ = ' ' "*/

	cUpd := "UPDATE " + RetSQLName("ZA2")  + " ZA2 " + CRLF
	cUpd += " SET ZA2_IDINTE = '" + cCod + "' "   + CRLF
	cUpd += " WHERE " + CRLF
	cUpd += " ZA2.ZA2_IDINTE = '" + Space(Len(ZA2->ZA2_IDINTE)) + "' AND " + CRLF
	cUpd += " ZA2.D_E_L_E_T_ = ' ' "

	TcSQLExec(cUpd)

	BeginSql Alias cNextAlias		
		SELECT DISTINCT
			ZA2.ZA2_FILIAL,
			ZA2.ZA2_COD,
			ZA2.ZA2_CODUSU,
			ZA2.D_E_L_E_T_ DEL,
			ZA2.R_E_C_N_O_ ZA2RECNO
		FROM
			%Table:ZA2% ZA2
		WHERE
			ZA2.ZA2_IDINTE = %exp:cCod%
	EndSql

/*	BeginSql Alias cNextAlias		
		SELECT DISTINCT''
			SAK.AK_FILIAL,
			SAK.AK_COD,
			SAK.AK_USER,
			SAK.D_E_L_E_T_ DEL,
			SAK.R_E_C_N_O_ SAKRECNO
		FROM
			%Table:SAK% SAK
		WHERE
			SAK.AK_ZIDINTE = %exp:cCod%
	EndSql*/

	(cNextAlias)->(DbGoTop())
	
	RestArea(aArea)

Return (cNextAlias)

Static Function xDadUser(cUser)
	
	Local aDados := {}
		
	Local nPos 	  := 0
	Local cNome   := ''
	Local cLogin  := ''
	Local cEmail  := ''
	
	If Type('__aXAllUser') <> 'A'
		//U_xMGC10CRIP()
		xCarUsers()
	EndIf	
	
	nPos := aScan(__aXAllUser,{|x| Alltrim(x[2]) == Alltrim(cUser)})
	
	cNome  := Alltrim(__aXAllUser[nPos][4])
	cLogin := Alltrim(__aXAllUser[nPos][3])
	cEmail := Alltrim(__aXAllUser[nPos][5])
	
	aDados := {cUser,cNome,cLogin,cEmail}
	
Return aDados

Static Function xCadFLGUS(aDados)
	
	Local oObj 		:= WSECMColleagueServiceService():New()
	Local oResulObj := nil
	Local lRet		:= .T.
	Local xResult
	                   
	Local oColleague:= ECMColleagueServiceService_colleagueDto():New()
					   
	oObj:cpassword			:= Alltrim(SuperGetMV("MGF_FLGPSW",.F.,'adm'))//GetMv("TI_FLGPSW")		//("MV_FLGPSW",,"Totvs@123")
	oObj:cUserName 			:= Alltrim(SuperGetMV("MGF_FLGUSR",.F.,'adm'))//xxRetUser()//GetMv("TI_FLGID")		//("MV_FLGID",,"13849989")
	oObj:ncompanyId			:= 1	
			   
	oColleague:ccolleagueId		:= aDados[1]
	oColleague:ccolleagueName 	:= aDados[2]
	oColleague:nCompanyId      	:= 1	
	oColleague:cLogin			:= aDados[3]
	oColleague:cMail			:= aDados[4]
	oColleague:cPasswd			:= '12345'
	
	AADD(oObj:OWSCreateColleagueColleagues:oWSItem,oColleague)
				
	oObj:CreateColleague()
	
	If Upper(Alltrim(oObj:cResultXML)) <> 'OK' .and. AT(Upper("já cadastrado"), Upper(Alltrim(oObj:cResultXML))) == 0
		conout('ERRO cadastro usuario: ' + Alltrim(oObj:cResultXML))
		lRet		:= .F.
	EndIf

Return lRet

Static Function xUsrExiFlg(cMatric)
	
	Local lRet := .F.
	Local oObj 		:= WSECMColleagueServiceService():New()
	Local cUserFLG  := Alltrim(SuperGetMV("MGF_FLGUSR",.F.,'adm'))
	Local cPaswFLG  := Alltrim(SuperGetMV("MGF_FLGPSW",.F.,'adm'))
	
	oObj:getColleague(cUserFLG,cPaswFLG,1,cMatric)
	
	If Len(oObj:oWSgetColleaguecolab:oWSItem) > 0
		If oObj:oWSgetColleaguecolab:oWSItem[1]:ccolleagueId <> NIL
			lRet := .T.
		EndIf
	EndIf
	
Return lRet

Static Function xCdFLG(cTp,cxFil,cCod)
	
	Local cRet 		:= ""
	Local cNextAlias:= GetNextAlias()	
	
	If cTp == "SC"
	
		BeginSql Alias cNextAlias		
			
			SELECT DISTINCT
				SC1.C1_ZCODFLG
			FROM
				%Table:SC1% SC1
			WHERE
				SC1.C1_FILIAL = %exp:cxFil% AND
				SC1.C1_NUM = %exp:cCod% AND
				SC1.C1_ZCODFLG <> ' '
		EndSql	
		
		(cNextAlias)->(dbGoTop())
		
		While (cNextAlias)->(!EOF()) 
			cRet := (cNextAlias)->C1_ZCODFLG
			(cNextAlias)->(dbSkip())
		EndDo
		
		If Select(cNextAlias) > 0
			(cNextAlias)->(DbClosearea())
		EndIf
			
	ElseIf cTp == "PC"

		BeginSql Alias cNextAlias		
			
			SELECT DISTINCT
				SC7.C7_ZCODFLG
			FROM
				%Table:SC7% SC7
			WHERE
				SC7.C7_FILIAL = %exp:cxFil%  AND
				SC7.C7_NUM = %exp:cCod% AND
				SC7.C7_ZCODFLG <> ' '
		EndSql	
		
		(cNextAlias)->(dbGoTop())
		
		While (cNextAlias)->(!EOF()) 
			cRet := (cNextAlias)->C7_ZCODFLG
			(cNextAlias)->(dbSkip())
		EndDo
		
		If Select(cNextAlias) > 0
			(cNextAlias)->(DbClosearea())
		EndIf
	
	EndIf

return cRet

Static Function xCdEXC(cTp,cxFil,cCod)

	Local lRet 		:= .T.
	Local cNextAlias:= GetNextAlias()	
	
	If cTp == "SC"

		BeginSql Alias cNextAlias		
			
			SELECT 
				SC1.C1_FILIAL, 
				SC1.C1_NUM, 
				COUNT(*) TOTAL
			FROM 
				%Table:SC1% SC1
			WHERE 
				SC1.C1_FILIAL = %exp:cxFil% AND 
				SC1.C1_NUM = %exp:cCod%
			GROUP BY SC1.C1_FILIAL, SC1.C1_NUM
			HAVING COUNT(*) =
						(	SELECT 
								COUNT(*)
						    FROM %Table:SC1% SC1B
			                WHERE 
			                	SC1B.C1_FILIAL = %exp:cxFil% AND 
			                	SC1B.C1_NUM = %exp:cCod% AND 
			                	SC1B.D_E_L_E_T_ = '*')

		EndSql
			
		(cNextAlias)->(dbGoTop())
		
		While (cNextAlias)->(!EOF()) 
			lRet := .F.
			(cNextAlias)->(dbSkip())
		EndDo
		
		If Select(cNextAlias) > 0
			(cNextAlias)->(DbClosearea())
		EndIf
		
	ElseIf cTp == "PC"

		BeginSql Alias cNextAlias		
			
			SELECT 
				SC7.C7_FILIAL, 
				SC7.C7_NUM, 
				COUNT(*) TOTAL
			FROM 
				%Table:SC7% SC7
			WHERE 
				SC7.C7_FILIAL = %exp:cxFil% AND 
				SC7.C7_NUM = %exp:cCod%
			GROUP BY SC7.C7_FILIAL, SC7.C7_NUM
			HAVING COUNT(*) =
						(	SELECT 
								COUNT(*)
						    FROM %Table:SC7% SC7B
			                WHERE 
			                	SC7B.C7_FILIAL = %exp:cxFil% AND 
			                	SC7B.C7_NUM = %exp:cCod% AND 
			                	SC7B.D_E_L_E_T_ = '*' )

		EndSql
			
		(cNextAlias)->(dbGoTop())
		
		While (cNextAlias)->(!EOF()) 
			lRet := .F.
			(cNextAlias)->(dbSkip())
		EndDo
		
		If Select(cNextAlias) > 0
			(cNextAlias)->(DbClosearea())
		EndIf
		
	EndIf
	
Return lRet

Static Function xCarUsers()
	
		Local cNextAlias := GetNextAlias()
		Local aUser 	 := {}	
		
		Public __aXAllUser := {}
		
		BeginSql Alias cNextAlias
			
			SELECT  
				R_E_C_N_O_ Rec,
				USR_ID,
				USR_CODIGO,
				USR_NOME,
				USR_EMAIL,
				USR_DEPTO,
				USR_CARGO  
			FROM 
				SYS_USR
			WHERE  
				D_E_L_E_T_ =' '
		
		EndSql
		
		(cNextAlias)->(dbGoTop())
		
		While (cNextAlias)->(!EOF()) 
			AADD(__aXAllUser,{(cNextAlias)->Rec,(cNextAlias)->USR_ID,(cNextAlias)->USR_CODIGO,(cNextAlias)->USR_NOME,(cNextAlias)->USR_EMAIL,(cNextAlias)->USR_DEPTO,(cNextAlias)->USR_CARGO})
			(cNextAlias)->(dbSkip())
		EndDo
		
		If Select(cNextAlias) > 0
			(cNextAlias)->(DbClosearea())
		EndIf
return

/*Static Function xCarUsers()
	Public __aXAllUser := FwSFAllUsers()
Return*/
