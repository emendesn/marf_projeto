#include "Protheus.ch"
#include "rwmake.ch"

/*
=====================================================================================
Programa............: MGFEST39
Autor...............: Mauricio Gresele
Data................: 09/06/2017
Descrição / Objetivo: Rotina temporaria para limpar o empenho de todos os produto. OBS: Deletar do RPO depois de rodado o refaz empenho.
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/     
User Function MGFEST30()

//Local cPerg := "MGFEST29"
Local oDlg
Local nOpc := 0
Local lRet := .T.
Local aPergs := {}

Private cPass := Space(50)

@ 067,020 To 169,312 Dialog oDlg Title OemToAnsi("Liberação de Acesso")
@ 015,005 Say OemToAnsi("Informe a senha para o acesso ?") Size 80,8
@ 015,089 Get cPass Size 50,10 Password
@ 037,055 BmpButton Type 1 Action fOK(oDlg,@lRet)
@ 037,106 BmpButton Type 2 Action (lRet:=.F.,Close(oDlg))
Activate Dialog oDlg CENTERED

If !lRet
	Return()
Endif

//aadd(aPergs,{"Produto ?"					,"","","mv_ch1","C",15,0,0 ,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","","","","",""})
//aadd(aPergs,{"Local ?"						,"","","mv_ch2","C",02,0,0 ,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","NNR","","","","","","",""})

//StaticCall(MGFEST26,AjustaSx1,cPerg,aPergs)

//pergunte(cPerg,.T.)

oDlg := Nil
	  
DEFINE FONT oFont NAME "Mono AS" SIZE 8,15

Define MsDialog oDlg Title "Acerto de Empenho GERAL do SB2 ( ***ROTINA TEMPORÁRIA*** )" From 116,090 To 300,630 Pixel

@ 012,010 Say OemToAnsi("Rotina para acertar os empenhos da tabela SB2.") PIXEL OF oDlg FONT oFont
@ 022,010 Say OemToAnsi("***Para uso temporariamente***.") PIXEL OF oDlg FONT oFont
@ 032,010 Say OemToAnsi("Rodar somente até o acerto dos Empenhos pelo padrão do ERP.") PIXEL OF oDlg FONT oFont
@ 042,010 Say OemToAnsi("***Acerta o Empenho de TODOS OS PRODUTOS DO SB2.***") PIXEL OF oDlg FONT oFont

SButton():New(060,045, 1,{|| (nOpc:=1,oDlg:End())},oDlg,.T.,,)
//SButton():New(060,095, 5,{|| Pergunte(cPerg,.T.)},oDlg,.T.,,)
SButton():New(060,145, 2,{|| oDlg:End()},oDlg,.T.,,)

Activate MsDialog oDlg Center

If nOpc == 1
	Processa({|| GeraTrb("","","")})
Endif	

Return()


Static Function fOK(oDlg,lRet)

If ALLTRIM(cPass) <> Alltrim(GetMv("MGF_PSWEMP",,"empenho"))
   MsgStop("Senha não Confere !!!")
   cPass  := Space(50)
   lRet := .F.
   dlgRefresh(oDlg)
Else
   Close(oDlg)
   lRet := .T.
Endif

Return


Static Function GeraTrb(cAssunto,cMemo,cAnexo)

Local cAliasTrb := GetNextAlias()
Local nReg := 0
Local cQ := ""
Local cQAux := ""
Local cNomArqTrb := ""
Local aEstrut := SB2->(dbStruct())
Local cAliasMark := GetNextAlias()
Local cAliasErro := GetNextAlias()
Local aStruErro := {}
Local cArqErro := ""
Local nCnt := 0
Local nI := 0
Local nHandle := 0
Local lContinua := .T.
Local nCount := 0
Local aFileOut := {}

//--- Objetos da Dialog
Local oDlg
Local oChk
Local oInv
Local oMark
Local nOpc := 0

//--- MarkBrowse
Local aCampos := {}
   
Local aButtons
Local nQuantSD4 := 0
Local aQuantSD4 := {}

Private lInverte := .F.
Private cMarca := GetMark()
Private lTodos := .T.
Private lChang := .T.
Private oTotal := Nil
Private nTotal := 0
Private oValTotal := Nil
Private nValTotal := 0

// adiciona campo de marca
aAdd(aEstrut,{"RECNO","N",10,0})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Campos visualizados no MarkBrowse ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aCampos, { "B2_OK"		,, "" } )
aAdd( aCampos, { "B2_COD"		,, "Produto" } )
aAdd( aCampos, { "B2_LOCAL"		,, "Local" } )
aAdd( aCampos, { "B2_QATU"		,, "Qtd. Atual" } )
aAdd( aCampos, { "B2_QEMP"		,, "Empenho" } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o arquivo temporario ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArqTRB := CriaTrab( aEstrut, .T. )
dbUseArea( .T.,,cNomArqTRB, cAliasMark, .F., .F. )

//IndRegua( cAliasMark, cNomArqTRB,"B2_COD+B2_LOCAL",,,"Criando Indice, aguarde..." )
//dbClearIndex()
//dbSetIndex( cNomArqTRB + OrdBagExt() )

cQAux := "FROM "+RetSqlName("SB2")+" SB2 " 
cQAux += "WHERE B2_FILIAL = '"+xFilial("SB2")+"' "
cQAux += "AND SB2.D_E_L_E_T_ = ' ' "
//cQAux += "AND B2_COD = '"+mv_par01+"' "
//cQAux += "AND B2_LOCAL = '"+mv_par02+"' "
cQAux += "AND B2_QEMP > 0 "

cQ := "SELECT COUNT(*) NREG "
cQ += cQAux
           
cQ := ChangeQuery(cQ)
//MEMOWRIT("RLOJM01.SQL",cQ)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.F.)

nReg := (cAliasTrb)->NREG
ProcRegua(nReg)

(cAliasTrb)->(dbCloseArea())

If nReg == 0
	MsgAlert("Não há Empenhos para exibir neste filtro.")
	Return()
Endif	

cQ := "SELECT SB2.R_E_C_N_O_ AS RECNO,SB2.* "
cQ += cQAux
cQ += "ORDER BY B2_COD,B2_LOCAL "
           
cQ := ChangeQuery(cQ)
//MEMOWRIT("RLOJM01.SQL",cQ)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.F.)

For nCnt := 1 To Len(aEstrut)
	If ( aEstrut[nCnt,2]<>"C" )
		TcSetField(cAliasTrb,aEstrut[nCnt,1],aEstrut[nCnt,2],aEstrut[nCnt,3],aEstrut[nCnt,4])
	EndIf
Next

SB1->(dbSetOrder(1))
// Cria TRB a partir do resultado da Query
While (cAliasTrb)->(!Eof())
	// verifica se produto controla lote e endereco
	If SB1->(dbSeek(xFilial("SB1")+(cAliasTrb)->B2_COD))
		If SB1->B1_RASTRO $ "LS"
			lContinua := .F.
		Endif
		If SB1->B1_LOCALIZA == "S"
			lContinua := .F.
		Endif
	Endif
	
	If lContinua
		// verifica se a quantidade empenhada esta em OP
		nQuantSD4 := QuantSD4((cAliasTrb)->B2_COD,(cAliasTrb)->B2_LOCAL)		
		If nQuantSD4 > 0
			If (cAliasTrb)->(B2_QEMP) <= nQuantSD4
				lContinua := .F.
			Else	
				aAdd(aQuantSD4,{(cAliasTrb)->B2_COD,(cAliasTrb)->B2_LOCAL,nQuantSD4})
			Endif	
		Endif
	
		If lContinua
			(cAliasMark)->(DbAppend())
			For nI := 1 To Len(aEstrut)
				If (nPos:=aScan(aCampos,{|x| x[1]==(cAliasTrb)->( FieldName( ni ))})) > 0
					cCampo := aCampos[nPos][1]
					If (nPos:=(cAliasMark)->(FieldPos((cAliasTrb)->( FieldName( ni ))))) > 0
						(cAliasMark)->(FieldPut(nPos,(cAliasTrb)->(FieldGet((cAliasTrb)->(FieldPos(cCampo))))))
					EndIf
				Endif	
			Next
			(cAliasMark)->RECNO := (cAliasTrb)->RECNO
		Endif	
	Endif	
	(cAliasTrb)->(dbSkip())
EndDo
(cAliasTrb)->(dbCloseArea())

// MarkBrowse
dbSelectArea(cAliasMark)
dbGotop()
If (cAliasMark)->(Eof())
	(cAliasMark)->(dbCloseArea())
	MsgAlert("Não há Empenhos para exibir neste filtro.")
	Return()
Endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a Tela com MsSelect e Objetos de Check Box ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oFont NAME "Mono AS" SIZE 8,15 BOLD

DEFINE MSDIALOG oDlg TITLE "Seleção de Empenhos" From 7,0 To 29,80

//@ 035,010 SAY "Total Marcados: " SIZE 050,010 PIXEL OF oDlg
//@ 030,055 MSGET oTotal VAR nTotal WHEN .F. SIZE 020,010 OF oDlg PIXEL

//@ 035,090 SAY "Valor Marcados: " SIZE 050,010 PIXEL OF oDlg
//@ 030,145 MSGET oValTotal VAR nValTotal WHEN .F. SIZE 050,010 Picture PesqPict("SE5","E5_VALOR") OF oDlg PIXEL

oMark := MsSelect():New(cAliasMark,"B2_OK",,aCampos, @lInverte, @cMarca, { 50, 0, 140, 318 } )

oMark:oBrowse:lhasMark := .T.
oMark:oBrowse:bAllMark := {|| Nil} //{|| MarkAll( oMark,cAliasMark,lTodos ) }
oMark:bMark := {|| Nil} //{ || MarkItem(cMarca,lInverte,cAliasMark)}

//@ 145,010 CHECKBOX oChk VAR lTodos PROMPT "Marca/Desmarca Todos" SIZE 80,7 COLOR CLR_HBLUE OF oDlg PIXEL ON CLICK MarkAll( oMark,cAliasMark,lTodos ); lTodos := .F.; oChk:oFont := oDlg:oFont
//@ 145,110 CHECKBOX oInv VAR lChang PROMPT "Inverte Seleção" SIZE 80,7 COLOR CLR_HBLUE OF oDlg PIXEL ON CLICK MarkInv( oMark,cAliasMark ); lChang := .F.; oChk:oFont := oDlg:oFont

aButtons := {}
//aadd(aButtons,{'RELATORIO',{|| GeraExcel(cAliasMark)},'Exporta para Excel'})

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, {||( nOpc := 1, oDlg:End() )}, {||(nOpc := 0, oDlg:End())},,@aButtons) CENTERED

DeleteObject( oMark )
DeleteObject( oDlg )
DeleteObject( oChk )
DeleteObject( oInv )

If nOpc == 1
	If APMsgYesNo("Confirma ajuste do Empenho ?")
		dbSelectArea(cAliasMark)
		dbGotop()
		While (cAliasMark)->(!Eof())
			IncProc()
			dbSelectArea(cAliasMark)
			//If IsMark( "B2_MSEXP" , cMarca , lInverte )
				SB2->(dbGoto((cAliasMark)->RECNO))
				If SB2->(Recno()) == (cAliasMark)->RECNO
					ProcSB2(cAliasMark,aQuantSD4)
				Endif	
			//Endif	
			(cAliasMark)->(dbSkip())
		EndDo
		
		APMsgInfo("Empenho ajustado.")
	Endif
Endif		
		
(cAliasMark)->(dbCloseArea())

Return()


Static Function ProcSB2(cAliasMark,aQuantSD4)

Local nQuant := 0
Local nPos := 0

nPos := aScan(aQuantSD4,{|x| x[1] == (cAliasMark)->B2_COD .and. x[2] == (cAliasMark)->B2_LOCAL})
If nPos > 0
	nQuant := aQuantSD4[nPos][3]
Endif	
SB2->(RecLock("SB2",.F.))
SB2->B2_QEMP := nQuant
SB2->(MsUnLock())        

Return()


Static Function MarkItem(cMarca,lInverte,cAliasMark)

If IsMark("B2_MSEXP",cMarca,lInverte)
	nTotal++
	//nValTotal := nValTotal+(cAliasMark)->E5_VALOR
Else
	nTotal--
	nTotal := Iif(nTotal<0,0,nTotal)
	//nValTotal := nValTotal-(cAliasMark)->E5_VALOR
	//nValTotal := Iif(nValTotal<0,0,nValTotal)
End

oTotal:Refresh()
//oValTotal:Refresh()

Return


// Marca / Desmarca todos os clientes
Static Function MarkAll( oMark,cAliasMark,lTodos )

Local nRec := (cAliasMark)->( Recno() )

dbSelectArea(cAliasMark)
dbGoTop()

nTotal := 0
//nValTotal := 0
While !EOF()
	
	RecLock(cAliasMark, .F. )
	//(cAliasMark)->A1_OK := If( (cAliasMark)->A1_OK == cMarca, "", cMarca )
	(cAliasMark)->B2_MSEXP := IIf(lTodos,cMarca,"")
	MsUnlock()
	If (cAliasMark)->B2_MSEXP == cMarca	
		nTotal++
		//nValTotal := nValTotal+(cAliasMark)->E5_VALOR
	Endif	
	
	dbSkip()
EndDo

(cAliasMark)->( DbGoTo( nRec ) )

//lInverte := !lInverte

oMark:oBrowse:Refresh()
oTotal:Refresh()
//oValTotal:Refresh()

Return Nil


// Inverte a Selecao 
Static Function MarkInv( oMark,cAliasMark )

Local nRec  := (cAliasMark)->( Recno() )
Local cFlag := " "

dbSelectArea(cAliasMark)
dbGoTop()

nTotal := 0
//nValTotal := 0
While !EOF()
	
	If IsMark( "B2_MSEXP" , cMarca , lInverte )
		cFlag := " "
	Else
		cFlag := cMarca
	EndIf
	
	RecLock(cAliasMark, .F. )
	(cAliasMark)->B2_MSEXP := cFlag
	MsUnlock()

	If (cAliasMark)->B2_MSEXP == cFlag
		nTotal++
		//nValTotal := nValTotal+(cAliasMark)->E5_VALOR
	Endif	
	
	dbSkip()
EndDo

(cAliasMark)->( DbGoTo( nRec ) )

oMark:oBrowse:Refresh()
oTotal:Refresh()
//oValTotal:Refresh()

Return Nil


Static Function QuantSD4(cProd,cLocal)

Local cQ := ""
Local cAliasTrb := GetNextAlias()
Local nRet := 0

cQ := "SELECT SUM(D4_QUANT) D4_QUANT "
cQ += "FROM "+RetSqlName("SD4")+" SD4 " 
cQ += "WHERE D4_FILIAL = '"+xFilial("SD4")+"' "
cQ += "AND SD4.D_E_L_E_T_ = ' ' "
cQ += "AND D4_COD = '"+cProd+"' "
cQ += "AND D4_LOCAL = '"+cLocal+"' "
cQ += "AND D4_SITUACA = ' ' "
cQ += "AND D4_QUANT > 0 "
       
cQ := ChangeQuery(cQ)
//MEMOWRIT("RLOJM01.SQL",cQ)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.F.)

If (cAliasTrb)->(!Eof())
	nRet := (cAliasTrb)->D4_QUANT
Endif
	
(cAliasTrb)->(dbCloseArea())

Return(nRet)