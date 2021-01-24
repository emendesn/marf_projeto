#include "protheus.ch"

Static nVlrTot := 0 // variavel usada em mais de um ponto de entrada

/*
=====================================================================================
Programa............: MGFCOM65
Autor...............: Totvs
Data................: 02/02/2018 
Descricao / Objetivo: Compras 
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Rotina chamada pelo ponto de entrada MA103BUT
=====================================================================================
*/
User Function MGFCOM65()

Local oDlg                 
Local cTit := OemToAnsi("Valor Total da Nota - Marfrig")
Local oBut1
Local oBut2
Local nOpcA := 0
Local lWhen := .F.

If IsInCallStack("MATA103")
	If !Empty(SF1->F1_ZVLRTOT)
		nVlrTot := SF1->F1_ZVLRTOT
	Else
		nVlrTot := 0
	Endif

	If (IIf(Type("l103Class")!="U",l103Class,.F.)) // .and. Empty(SF1->F1_STATUS) .and. Empty(SF1->F1_ZBLQVAL))
		lWhen := .T.
	Endif	
Elseif IsInCallStack("MATA140")
	If Inclui
		// nao faz nada
	Else
		If !Empty(SF1->F1_ZVLRTOT) .and. Empty(nVlrTot)
			nVlrTot := SF1->F1_ZVLRTOT
		Endif
	Endif	

	If Altera .or. Inclui
		lWhen := .T.
	Endif	
Endif	
	
DEFINE MSDIALOG oDlg TITLE cTit FROM 200,001 TO 300,350 OF oMainWnd PIXEL

@ 10,05	SAY OemToAnsi("Valor Total Marfrig:") OF oDlg SIZE 50,10 PIXEL
@ 10,60 MSGET nVlrTot Picture PesqPict("SF1","F1_VALBRUT") WHEN lWhen Valid !Empty(nVlrTot) SIZE 60,10 PIXEL

DEFINE SBUTTON oBut1 FROM 30,50 TYPE 1 ACTION IIf(!Empty(nVlrTot),(nOpcA := 1,oDlg:End()),.F.) ENABLE OF oDlg
DEFINE SBUTTON oBut2 FROM 30,100 TYPE 2 ACTION (oDlg:End()) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

If nOpcA == 1
	If IsInCallStack("MATA103")
		If nVlrTot != SF1->F1_ZVLRTOT
			SF1->(RecLock("SF1",.F.))
			SF1->F1_ZVLRTOT := nVlrTot
			SF1->(MsUnLock())
		Endif	
	Endif	
Endif	

Return()


// gravacao do campo F1_ZVLRTOT 
User Function COM65PreNota()

Local lInclui := ParamIxb[1]
Local lAltera := ParamIxb[2]
Local cGrupo := GetMv("MGF_GRPNFE")
Local aArea := {SCR->(GetArea()),GetArea()}
Local cDocto := ""
Local lLib := .F.
Local lBlqVal := .F.
Local cDocto1 := ""
Local nVlrTotAnt := 0
Local nVlrClaAnt := 0

// verifica se a alteracao realizada na pre-nota alterou valores da nota ou valor total marfrig
// guarda valores anteriores antes de qq alteracao
If Altera
	If !Empty(SF1->F1_ZVLRTOT) .and. !Empty(SF1->F1_ZVLTOCL)
		nVlrTotAnt := SF1->F1_ZVLRTOT
		nVlrClaAnt := SF1->F1_ZVLTOCL
	Endif
Endif		

If (lInclui .or. lAltera) .and. !Empty(nVlrTot) .and. nVlrTot != SF1->F1_ZVLRTOT
	SF1->(RecLock("SF1",.F.))
	SF1->F1_ZVLRTOT := nVlrTot
	SF1->(MsUnLock())
Endif	

// verifica se regra de bloqueio por valor jah foi executada antes
If Altera
	// verifica se valor calculado pelo sistema jah estah gravado na sf1, se estiver atualiza o valor
	If !Empty(SF1->F1_ZVLTOCL)
		If Type("a140Total[3]") != "U" .and. a140Total[3] != 0 .and. a140Total[3] != SF1->F1_ZVLTOCL
			SF1->(RecLock("SF1",.F.))
			SF1->F1_ZVLTOCL := a140Total[3]
			SF1->(MsUnLock())
		Endif
	Endif		
	
	If !Empty(SF1->F1_ZVLRTOT) .and. !Empty(SF1->F1_ZVLTOCL) .and. Type("a140Total[3]") != "U" .and. a140Total[3] != 0
		// soh refaz bloqueio se houve alteracao de valores
		//If Abs(SF1->F1_ZVLTOCL-SF1->F1_ZVLRTOT) > GetMv("MGF_TOLNFE",,0) .and. !(nVlrTotAnt == SF1->F1_ZVLRTOT .and. nVlrClaAnt == SF1->F1_ZVLTOCL) 	
		If Abs(a140Total[3] - SF1->F1_ZVLRTOT) > GetMv("MGF_TOLNFE",,0) .and. !(nVlrTotAnt == SF1->F1_ZVLRTOT) 	
			StaticCall(MGFCOM66,Com66Bloq)
		Else 
				
			Begin Transaction 

			// soh refaz bloqueio se houve alteracao de valores
			//If !(nVlrTotAnt == SF1->F1_ZVLRTOT .and. nVlrClaAnt == SF1->F1_ZVLTOCL)	
			If !(nVlrTotAnt == SF1->F1_ZVLRTOT)	
				// estorna alcadas anteriores
				MaAlcDoc({SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+"_VALOR_NFE","NF",SF1->F1_VALBRUT,,,cGrupo,,IIf(Empty(SF1->F1_MOEDA),1,SF1->F1_MOEDA),SF1->F1_TXMOEDA,SF1->F1_EMISSAO},SF1->F1_EMISSAO,3)
			Endif	
			
			// valida se existe bloqueio da sf1
			cDocto := SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
			SCR->(dbSetOrder(1))
			If SCR->(dbSeek(xFilial("SCR")+"NF"+cDocto))
				While SCR->(!Eof()) .and. xFilial("SCR")+"NF"+cDocto == SCR->CR_FILIAL+SCR->CR_TIPO+Subs(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
					If "_VALOR_NFE" $ Alltrim(SCR->CR_NUM)
						lBlqVal := .T.
						Exit
					Endif
					SCR->(dbSkip())
				Enddo
			Endif
			//.T. = Está liberado, .F. = não está liberdado.
			cDocto1 := cDocto+"_VALOR_NFE"
			lLib := StaticCall(MGFCOM72,_MtGLastSCR,"NF",cDocto) .and. StaticCall(MGFCOM72,_MtGLastSCR,"NF",cDocto+"_VALOR_NFE")
			SF1->(RecLock("SF1",.F.))
			SF1->F1_STATUS := IIf(lLib," ","B")
			SF1->F1_ZBLQVAL := IIf((lBlqVal .and. lLib),"N",IIf((lBlqVal .and. !lLib),"S"," "))
			SF1->(MsUnLock())
			
			End Transaction 
			
		Endif
	Endif
Endif	
	
nVlrTot := 0 // zera variavel

aEval(aArea,{|x| RestArea(x)})
	
Return()


// rotina chamada pelo ponto de entrada MT140CPO
// limpa variaveis
User Function COM65Limpa()

If ValType(nVlrTot) != "U"
	nVlrTot := 0
Endif

Return()	