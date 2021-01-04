#Include 'Protheus.ch'

User Function MGFCOM15(nRec)
	
	Local aRegistros := xMC8PrepPA(nRec)//Carrega dados para Geração do PA
	
	If Len(aRegistros) > 0
		If xMC8GerPa(aRegistros) //Realiza Inclusão do 'PA'
			xAltChv(nRec) //Muda o historico de Aprovação
			xMC8ExcPR(nRec) //Deleta titulo 'PR'
		EndIf
	EndIf
	
Return

Static Function xMC8PrepPA(nRec)
	
	Local aArea 	:= GetArea()
	Local aAreaSE2	:= SE2->(GetArea())
	Local aAreaSX3	:= SX3->(GetArea())
	Local aRet		:= {}
	Local cFldSE2	:= ''
	Local xCtdSE2	:= ''
	Local ni		:= 0
		
	dbSelectArea('SX3')
	SX3->(dbSetOrder(1))//X3_ARQUIVO+X3_ORDEM
	If SX3->(dbSeek('SE2'))
		While SX3->(!EOF()) .and. SX3->X3_ARQUIVO == 'SE2'	
			
			If SX3->X3_CONTEXT <> 'V' .and. SX3->X3_CAMPO <> 'E2_VENCREA'
				AADD(aRet,{SX3->X3_CAMPO,''})
			EndIf
			
			SX3->(dbSkip())
		EndDo
	EndIf

	dbSelectArea('SE2')
	SE2->(dbGoTo(nRec))

	For ni := 1 To Len(aRet)
		cFldSE2 := 'SE2->' + ALLTRIM(aRet[ni,1])	
		xCtdSE2 := &(cFldSE2)
		If !(Empty(xCtdSE2)) .and. AllTrim(aRet[ni,1]) <> 'E2_HIST'
			If Alltrim(aRet[ni,1]) <> 'E2_TIPO'
				If Alltrim(aRet[ni,1]) $ 'E2_EMISSAO|E2_VENCTO|E2_EMIS1'
					aRet[ni,2] := DataValida(dDataBase,.T.)
				Else
					aRet[ni,2] := xCtdSE2
				EndIf
			Else
				aRet[ni,2] := 'PA'
			EndIf
		EndIf
		
		If Alltrim(aRet[ni,1]) == 'E2_HIST'
			aRet[ni,2] := Alltrim(aRet[ni,2]) + " - MPA"
		EndIf
		
	Next ni
	
	RestArea(aAreaSX3)
	RestArea(aAreaSE2)
	RestArea(aArea)
	
Return aRet 

Static Function xMC8GerPa(aRegistro)
	Local cError    := ''
	Local aArea		:= GetArea()
	Local aAreaSE2	:= SE2->(GetArea())
	Local lRet		:= .T.
	
	Local aArray 	:= {}
	Local ni
	
	Private lMsErroAuto := .F.
	
	For ni := 1  to Len(aRegistro)
		If !Empty(aRegistro[ni,2])
			AAdd(aArray,{aRegistro[ni,1],aRegistro[ni,2],NIL})
		EndIf
	Next ni

	//Para utilizar na tela do contas a pagar
	AAdd(aArray,{ "AUTBANCO"   , MV_PAR01 			  , NIL })
	AAdd(aArray,{ "AUTAGENCIA" , MV_PAR02             , NIL })
	AAdd(aArray,{ "AUTCONTA"   , MV_PAR03             , NIL })     
	
	//Para utilizar na aprovação do titulo
	/*AAdd(aArray,{ "AUTBANCO"   , SE2->E2_ZBCOAD 	  , NIL })
    AAdd(aArray,{ "AUTAGENCIA" , SE2->E2_ZAGAD		  , NIL })
    AAdd(aArray,{ "AUTCONTA"   , SE2->E2_ZCNTAD		  , NIL })*/
	
	MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3) // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
	
	If lMsErroAuto
		lRet := .F.
		If (!IsBlind()) // COM INTERFACE GRÁFICA
		MostraErro()
	    Else // EM ESTADO DE JOB
	        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
	
	        ConOut(PadC("Automatic routine ended with error", 80))
	        ConOut("Error: "+ cError)
	    EndIf
	Else
		Alert("Título de adiantamento incluído com sucesso!")
	Endif
	
	RestArea(aAreaSE2)
	RestArea(aArea)
	
Return lRet

Static Function xAltChv(nRec)
	
	Local aArea 	:= GetArea()
	Local aAreaSE2	:= SE2->(GetArea())
	Local aAreaSCR	:= SCR->(GetArea())
	
	Local cChvPADel	:= ""
	
	DbSelectArea("SE2")
	SE2->(dbGoTo(nRec))
	
	cChvPADel := SE2->E2_FILIAL + 'ZC' + SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA) + "PA " + SE2->(E2_FORNECE + E2_LOJA)
	
	//Exclusão da Chave das Aprovações do PA
	DbSelectArea("SCR")
	SCR->(DbSetOrder(1))//CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL
	
	If SCR->(dbSeek(cChvPADel))
		While SCR->(!EOF()) .and. SCR->CR_FILIAL + 'ZC' + alltrim(SCR->CR_NUM) == cChvPADel
			RecLock("SCR",.F.)
				SCR->(dbDelete())
			SCR->(MsUnLock())
			SCR->(dbSkip())
		EndDo
	EndIf
	
	//Alteração da Chave das aprovações do MPA
	DbSelectArea("SCR")
	SCR->(DbSetOrder(1))//CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL
	
	If SCR->(dbSeek(SE2->(E2_FILIAL) + 'ZC' + SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA)))
		While SCR->(!EOF()) .and. SCR->CR_FILIAL + 'ZC' + Alltrim(SCR->CR_NUM) == SE2->E2_FILIAL + 'ZC' + SE2->( E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA)
			RecLock("SCR",.F.)
				SCR->CR_NUM := SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA) + "PA " + SE2->(E2_FORNECE + E2_LOJA)
			SCR->(MsUnLock())
			SCR->(dbSkip())
		EndDo
	EndIf
	
	RestArea(aAreaSCR)
	RestArea(aAreaSE2)
	RestArea(aArea)

Return

Static Function xMC8ExcPR(nRec)
	Local cError    := ''
	Local aArray := {}
	
	Private lMsErroAuto := .F.
	
	DbSelectArea("SE2")
	SE2->(dbGoTo(nRec))
	
	AADD(aArray,{ "E2_PREFIXO" , SE2->E2_PREFIXO , NIL })
	AADD(aArray,{ "E2_NUM"     , SE2->E2_NUM     , NIL })
	AADD(aArray,{ "E2_PARCELA" , SE2->E2_PARCELA , NIL })
	AADD(aArray,{ "E2_TIPO"    , SE2->E2_TIPO    , NIL })
	AADD(aArray,{ "E2_FORNECE" , SE2->E2_FORNECE , NIL })
	AADD(aArray,{ "E2_LOJA"    , SE2->E2_LOJA    , NIL })
		
	MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 5)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
	
	If lMsErroAuto
		If (!IsBlind()) // COM INTERFACE GRÁFICA
		MostraErro()
	    Else // EM ESTADO DE JOB
	        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
	
	        ConOut(PadC("Automatic routine ended with error", 80))
	        ConOut("Error: "+ cError)
	    EndIf
	Else
		Alert("Exclusão do Título com sucesso!")
	Endif
	
Return

