#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

User Function MATA131()
	
	Local aParam     := PARAMIXB
	Local xRet       := .T.
	Local oObj       := ''
	Local cIdPonto   := ''
	Local cIdModel   := ''
	Local lIsGrid    := .F.
	
	Local nLinha     := 0
	Local nQtdLinhas := 0
	Local cMsg       := ''
	
	If aParam <> NIL
		
		oObj       := aParam[1]
		cIdPonto   := aParam[2]
		cIdModel   := aParam[3]
		/*lIsGrid    := ( Len( aParam ) > 3 )
		
		If lIsGrid
			nQtdLinhas := oObj:GetQtdLine()
			nLinha     := oObj:nLine
		EndIf*/
		
		If cIdPonto == "MODELVLDACTIVE"
			
			xRet := xVldGrdPed()
			
			If !xRet
				Alert('Na Seleção existe algum CC de custo que não possue Grade de aprovação para Pedido de Compra')
			EndIf
			
			If xRet
				xRet := xMdlVldCont()
				If !xRet
					Alert('Quando for escolhido o tipo de Contrato Não é possivel selecionar Itens de SC com CC diferentes')
					//Help('',1,'CC. Diferente CC. Contratos',,'Quando for escolhido o tipo de Contrato Não é possivel selecionar Itens de SC com CC diferentes',1,0) 
				EndIf
			EndIf	
			

			/*
			=====================================================================================
			GAP GCT075_082 - Mostrar Número da Cotação gerada
			=====================================================================================
			*/
		ElseIf cIdPonto == "MODELCOMMITNTTS"
		
			MsgAlert('COTAÇÃO NÚMERO '+SC8->C8_NUM,SC8->C8_NUMSC,SC8->C8_PRODUTO,SC8->C8_ITEMSC)
			//AQUI
			Grvsc8(SC8->C8_NUM,SC8->C8_NUMSC,SC8->C8_PRODUTO,SC8->C8_ITEMSC)	
			
		EndIf
		
	EndIf
	
	
Return xRet


Static Function xVldGrdPed()

	Local aArea		:= GetArea()
	Local aAreaSC1  := SC1->(GetArea())
	Local cAliasSC1 := "a131PROCES"

	Local aAreaTMP := (cAliasSC1)->(GetArea()) 
	
	Local lRet := .T.
	
	(cAliasSC1)->(dbGoTop())
	
	While (cAliasSC1)->(!Eof())
		If (cAliasSC1)->C1_OK == ThisMark() 
			If !(U_xM10vGrd((cAliasSC1)->C1_CC ))
				lRet := .F.
				Exit
			EndIf
		EndIf
		(cAliasSC1)->(dbSkip())
	EndDo
	
	(cAliasSC1)->(dbGoTop())
	RestArea(aAreaTMP)
	RestArea(aAreaSC1)
	RestArea(aArea)

Return lRet

Static Function xMdlVldCont()
	
	Local aArea		:= GetArea()
	Local aAreaSC1  := SC1->(GetArea())
	Local cAliasSC1 := "a131PROCES"

	Local aAreaTMP := (cAliasSC1)->(GetArea()) 
	Local aStruSC1  := SC1->(dbStruct())

	Local cQuery 	:= ""
	Local cFilQry	:= cQuerySC1

	Local nCntFor	:= 0
	Local cCC		:= ''
	
	Local lRet 		:= .T.
	
	If MV_PAR14 == 2
		
		(cAliasSC1)->(dbGoTop())
		
		While (cAliasSC1)->(!Eof())
			
			If (cAliasSC1)->C1_OK == ThisMark() 
				If Empty(cCC)
					cCC := (cAliasSC1)->C1_CC 
				Else
					If cCC <> (cAliasSC1)->C1_CC
						lRet := .F.
						Exit
					EndIf
				EndIf
			EndIf
			
			(cAliasSC1)->(dbSkip())
		EndDo
	EndIf
	(cAliasSC1)->(dbGoTop())
	RestArea(aAreaTMP)
	RestArea(aAreaSC1)
	RestArea(aArea)
	
Return lRet

Static Function Grvsc8(cNUM,cNUMSC,cPRODUTO,cITEMSC)

	Local lRet := .T.
	Local cwf  :=""
	

   //fazer query
	cQuery = " "	
	cQuery = " SELECT C8_FILIAL,C8_NUMSC,C8_ITEMSC "
	cQuery += " From " + RetSqlName("SC8") + " "
	cQuery += " WHERE C8_NUM='"+cNUM+"' AND C8_FILIAL='"+cfilant+"' "	
	cQuery += " AND D_E_L_E_T_<>'*' "
	If Select("TEMP15") > 0
		TEMP15->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TEMP15",.T.,.F.)
	dbSelectArea("TEMP15")    
	TEMP15->(dbGoTop())

	While TEMP15->(!Eof())

	//MSGALERT("TESTE "+cNUM+cnumsc+cPRODUTO+cITEMSC)
	DbSelectArea("SC1")
	SC1->(dbSetOrder(1))//C1_FILIAL+C1_NUM+C1_ITEM+C1_ITEMGRD
	If SC1->(dbSeek(TEMP15->C8_FILIAL+TEMP15->C8_NUMSC+TEMP15->C8_ITEMSC))
       cwf := SC1->C1_ZWFPC
	ENDIF
		
	//GRAVA SC8       
		_cQryCMP	:=" "
		_cQryCMP	:= " UPDATE " + RetSqlName("SC8") + " SET C8_ZWFPC='"+CWF+"' "
		_cQryCMP	+= " WHERE C8_NUMSC = '"+TEMP15->C8_NUMSC+"' AND C8_ITEMSC='"+TEMP15->C8_ITEMSC+"' AND C8_FILIAL='"+TEMP15->C8_FILIAL+"' "
		TcSqlExec(_cQryCMP)

	
	
	//RecLock("SC8",.F.)
	//	SC8->C8_ZWFPC := CWF
	//SC8->(MsUnLock())            


 	    TEMP15->(dbSKIP())
	EndDo
   


Return lRet
