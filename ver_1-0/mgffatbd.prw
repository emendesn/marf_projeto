#include 'protheus.ch'
#include 'parmtype.ch'

User Function MGFFATBD()
	
	Local aArea    	 := GetArea()
	Local aAreaSF2 	 := SF2->(GetArea())
	Local aAreaSD2 	 := SD2->(GetArea())
	Local aAreaSF3 	 := SF3->(GetArea())
	Local aAreaSFT 	 := SFT->(GetArea())
	Local _cChaveSF2 := ''
	Local _cChaveSF3 := ''
	Local _cChaveSFT := ''
	Local aTimeUf    := FwTimeUF(SM0->M0_ESTENT,,.F.,,.F.)
	Local dHVeraoI:= SuperGetMV("MV_HVERAOI",.F.,CTOD('  /  /    '))
	Local dHVeraoF:= SuperGetMV("MV_HVERAOF",.F.,CTOD('  /  /    '))
	Local lHverao	:= .F.

	//Verifica se é horário de verão
	If !Empty(dHVeraoI) .And. !Empty(dHVeraoF) .And. date() >= dHVeraoI .And. date() <= dHVeraoF
		lHverao := .T.
		aTimeUf := FwTimeUF(SM0->M0_ESTENT,,lHverao,,lHverao)
	EndIf	

	//Verificar parametro MV_HORARMT - Fuso horário
	nHoras := Val(SuperGetMV("MV_HORARMT",.F.,0))
	If nHoras == 3
		dDiaGravar := CTOD(substr(aTimeUF[1],7,2) +'/'+ substr(aTimeUF[1],5,2) +'/'+ substr(aTimeUF[1],1,4))
	Else
		dDiaGravar := date()
	EndIf

	
	_cChaveSF2 := SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA

	DbSelectArea("SF2")
	SF2->(DbSetOrder(1))//F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
	
	If SF2->(MsSeek(xFilial('SF2')+_cChaveSF2,.T.))
		
		dbSelectArea("SF2")
		If RecLock("SF2",.F.)
			SF2->F2_EMISSAO := dDiaGravar
			SF2->(MsUnLock())
		EndIf
		
		DbSelectArea("SD2")
		SD2->(DbSetOrder(3))//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
		IF SD2->(DbSeek(xFilial("SD2")+_cChaveSF2))
			While ! SD2->(EOF()) .AND. SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA =  _cChaveSF2
				
				If RecLock("SF2",.F.)
					SD2->D2_EMISSAO := dDiaGravar
					SD2->(MsUnLock())
				EndIf
				
				SD2->(dbSkip())
			EndDo
		EndIf
		
		_cChaveSF3 := SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE
		
		DBSelectArea("SF3")
		SF3->(DBSetOrder(4))//F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE
		
		IF SF3->(DbSeek(xFilial("SF3")+_cChaveSF3))
			While SF3->(!Eof()) .AND. SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE =  _cChaveSF3
				
				If RecLock("SF3",.F.)
					SF3->F3_EMISSAO := dDiaGravar
					SF3->F3_ENTRADA := dDiaGravar
					SF3->(MsUnLock())
				EndIf
				
				SF3->(dbSkip())
			EndDo
		EndIf
		
		_cChaveSFT := "S" + SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA
		
		DbSelectArea("SFT")
		SFT->(dbSetOrder(1))//FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO
		If SFT->(DbSeek(xFilial("SFT")+_cChaveSFT))
			While SFT->(!Eof()) .AND. SFT->FT_TIPOMOV+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA = _cChaveSFT  
				
				If RecLock("SFT",.F.)
					SFT->FT_EMISSAO := dDiaGravar
					SFT->FT_ENTRADA := dDiaGravar
					SFT->(MsUnLock())
				EndIf
				
				SFT->(dbSkip())
			EndDo			
		EndIf
		
	Endif
	
	RestArea(aAreaSFT)
	RestArea(aAreaSF3)
	RestArea(aAreaSD2)
	RestArea(aAreaSF2)	
	RestArea(aArea)

Return