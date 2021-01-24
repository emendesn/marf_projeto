#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
===========================================================================================
Programa.:              MGFCTB06
Autor....:              Mauricio Gresele
Data.....:              Set/2017
Descricao / Objetivo:   Rotina de exportacao em arquivo .CSV para integracao com o sistema Hyperion
Doc. Origem:            MIT044
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/
User Function MGFCTB06()

Local cPerg := Padr("MGFCTB06",10)

Private cRetxx8 := Space(12) // usado na consulta padrao customizada XX8EM1

AjustaSx1(cPerg)

If !Pergunte(cPerg,.T.)
	Return()
EndIf 

MsAguarde({|| Ctb06Proc()},"Processando/gravando registros, aguarde...")

Return()


Static Function Ctb06Proc()

Local aArea := {XX8->(GetArea()),SM0->(GetArea()),GetArea()}
//Local cAlias := ""
//Local cIdent := ""
//Local cHeader := ""
Local dDataIni := mv_par01
Local dDataFim := mv_par02
Local cContaIni := ""
Local cContaFim := ""
Local cCCIni := ""
Local cCCFim := ""
Local cItemIni := ""
Local cItemFim := ""
Local cClVlIni := ""
Local cClVlFim := ""
Local cMoeda := ""
Local cSaldos := ""
Local aSetOfBook := {}
Local lImpAntLP := .F.
Local dDataLP := cTod("")
Local cArqTmp := "" 
Local aSelFil := {}
Local cFilAntSav := cFilAnt
Local lFirst := .T.
Local nCnt := 0
//Local aPeriodos := {}
Local cArqTxt := Alltrim(mv_par18)+"MGFCTB06.CSV"
Local nArq := 0
Local lGravou := .F.    
Local nDet := 0
Local cItem := ""
Local lComp := .F.
//Local lImp3Ent := .F.
//Local lImp4Ent := .F.
Local aMeses := {}
Local cArqInd := CriaTrab(Nil,.F.)
Local lUsaConta	:= .F.
Local lUsaCusto	:= .F.
Local lUsaItem	:= .F.
Local lUsaClVl	:= .F.
Local aFilM0 := {}

If mv_par04 == 1
	cContaIni := mv_par05
	cContaFim := mv_par06
Endif

If mv_par07 == 1 
	cCCIni := mv_par08
	cCCFim := mv_par09
Endif

If mv_par10 == 1
	cItemIni := mv_par11
	cItemFim := mv_par12
Endif

If mv_par13 == 1
	cClVlIni := mv_par14
	cClVlFim := mv_par15
Endif

// conta
If mv_par04 == 1 .and. mv_par07 == 2 .and. mv_par10 == 2 .and. mv_par13 == 2
	//cAlias := "CT7"
	//cIdent := ""
	//cHeader := ""
	cTipo := "1"
// custo
Elseif mv_par04 == 2 .and. mv_par07 == 1 .and. mv_par10 == 2 .and. mv_par13 == 2
	//cAlias := "CTU"
	//cIdent := "CTT"
	//cHeader := ""
	cTipo := "2"
// item
Elseif mv_par04 == 2 .and. mv_par07 == 2 .and. mv_par10 == 1 .and. mv_par13 == 2
	//cAlias := "CTU"
	//cIdent := "CTD"
	//cHeader := ""
	cTipo := "3"
// classe
Elseif mv_par04 == 2 .and. mv_par07 == 2 .and. mv_par10 == 2 .and. mv_par13 == 1
	//cAlias := "CTU"
	//cIdent := "CTH"
	//cHeader := ""
	cTipo := "4"
// conta x custo
Elseif mv_par04 == 1 .and. mv_par07 == 1 .and. mv_par10 == 2 .and. mv_par13 == 2
	//cAlias := "CT3"
	//cIdent := ""
	//cHeader := "CT1"
	cTipo := "5"
// conta x item
Elseif mv_par04 == 1 .and. mv_par07 == 2 .and. mv_par10 == 1 .and. mv_par13 == 2
	//cAlias := "CT4"
	//cIdent := ""
	//cHeader := "CT1"
	cTipo := "6"
// conta x classe
Elseif mv_par04 == 1 .and. mv_par07 == 2 .and. mv_par10 == 2 .and. mv_par13 == 1
	//cAlias := "CTI"
	//cIdent := ""
	//cHeader := "CT1" // "CTH"
	cTipo := "7"
// custo x item
Elseif mv_par04 == 2 .and. mv_par07 == 1 .and. mv_par10 == 1 .and. mv_par13 == 2
	//cAlias := "CTV"
	//cIdent := ""
	//cHeader := "CTT"
	cTipo := "8"
// custo x classe 
Elseif mv_par04 == 2 .and. mv_par07 == 1 .and. mv_par10 == 2 .and. mv_par13 == 1
	//cAlias := "CTW"
	//cIdent := ""
	//cHeader := "CTT"
	cTipo := "9"
// item x classe
Elseif mv_par04 == 2 .and. mv_par07 == 2 .and. mv_par10 == 1 .and. mv_par13 == 1
	//cAlias := "CTX"
	//cIdent := ""
	//cHeader := "CTD"
	cTipo := "10"
// conta x custo x item
Elseif mv_par04 == 1 .and. mv_par07 == 1 .and. mv_par10 == 1 .and. mv_par13 == 2
	//cAlias := "CT4"
	//cIdent := ""
	//cHeader := "CTT"
	//lImp3Ent := .T.
	lComp := .T.
	cTipo := "11"
// conta x custo x classe
Elseif mv_par04 == 1 .and. mv_par07 == 1 .and. mv_par10 == 2 .and. mv_par13 == 1
	//cAlias := "CT4"
	//cIdent := ""
	//cHeader := "CTT"
	//lImp3Ent := .T.
	lComp := .T.
	cTipo := "12"
	ApMsgStop("Parâmetros para considerar Entidades Contábeis ('Sim'/'Nao'), incorretos para execução desta rotina.")
	Return()
	cTipo := "12"
// conta x item x classe
Elseif mv_par04 == 1 .and. mv_par07 == 2 .and. mv_par10 == 1 .and. mv_par13 == 1
	//cAlias := "CT4"
	//cIdent := ""
	//cHeader := "CTT"
	//lImp3Ent := .T.
	lComp := .T.
	cTipo := "13"
	ApMsgStop("Parâmetros para considerar Entidades Contábeis ('Sim'/'Nao'), incorretos para execução desta rotina.")
	Return()
	cTipo := "13"
// custo x item x classe
Elseif mv_par04 == 2 .and. mv_par07 == 1 .and. mv_par10 == 1 .and. mv_par13 == 1
	//cAlias := "CTY"
	//cIdent := ""
	//cHeader := "CTT"
	lComp := .T.
	cTipo := "14"
	ApMsgStop("Parâmetros para considerar Entidades Contábeis ('Sim'/'Nao'), incorretos para execução desta rotina.")
	Return()
	cTipo := "14"
	//APMsgStop("Conta Contábil não considerada."+CRLF+;
	//"Considere sempre a Conta Contábil nesta rotina.")
	//Return()
// conta x custo x item x classe
Elseif mv_par04 == 1 .and. mv_par07 == 1 .and. mv_par10 == 1 .and. mv_par13 == 1
	//cAlias := "CTI"
	//cIdent := ""
	//cHeader := "CTT"
	//lImp4Ent := .T.
	lComp := .T.
	cTipo := "15"
	ApMsgStop("Parâmetros para considerar Entidades Contábeis ('Sim'/'Nao'), incorretos para execução desta rotina.")
	Return()
	cTipo := "15"
Else
	ApMsgStop("Parâmetros para considerar Entidades Contábeis ('Sim'/'Nao'), incorretos para execução desta rotina.")
	Return()
Endif

lUsaConta := (mv_par04 == 1) 
lUsaCusto := (mv_par07 == 1)
lUsaItem := (mv_par10 == 1)
lUsaClVl := (mv_par13 == 1)

cMoeda := "01"
cSaldos := "1"
aSetOfBook := CTBSetOf(Space(3))
lImpAntLP := Iif(mv_par16==1,.T.,.F.)
dDataLP := mv_par17

If mv_par19 == 2 // por filial
	While .T.
		aFilM0 := ADMGETFIL()
		If Len(aFilM0) > 0
			Exit
		Else
			APMsgAlert("Marque pelo menos uma filial.")	
		Endif	
	Enddo	
Endif	

XX8->(dbSetOrder(3))
If XX8->(dbSeek(Padr(FWGrpCompany(),12)+Padr(mv_par03,12)))
	While XX8->(!Eof()) .and. Padr(FWGrpCompany(),12)+Padr(mv_par03,12) == XX8->XX8_GRPEMP+XX8->XX8_EMPR
		If IIf(mv_par19==1,.T.,aScan(aFilM0,{|x| Alltrim(x)==Alltrim(XX8->XX8_EMPR)+Alltrim(XX8->XX8_CODIGO)}) > 0)
			If lFirst
				cFilAnt := Alltrim(XX8->XX8_EMPR)+Alltrim(XX8->XX8_CODIGO)
				lFirst := .F.
			Endif	
			aAdd(aSelFil,Alltrim(XX8->XX8_EMPR)+Alltrim(XX8->XX8_CODIGO))
		Endif	
		XX8->(dbSkip())
	Enddo
Endif		

If Empty(aSelFil)
	APMsgStop("Não foi possível encontrar nenhuma Filial válida para esta Empresa.")
	Return()
Endif	

If File(cArqTxt)
	If fErase(cArqTxt) <> 0
		APMsgStop("Não foi possível apagar o arquivo gerado anteriormente pela rotina: "+cArqTxt+CRLF+;
		"Verifique se o mesmo está aberto por outro aplicativo e feche o arquivo.")
		Return()
	Endif
End   

MakeDir(Alltrim(mv_par18))

nArq := fCreate(cArqTxt,0)

nMes := Month(dDataIni)
nYear := Year(dDataIni)

// monta periodos para cada mes/ano
While .T.
	If Empty(aMeses)
		aAdd(aMeses,{"",dDataIni,IIf((Month(dDataIni)==Month(dDataFim) .and. Year(dDataIni)==Year(dDataFim)),dDataFim,LastDay(dDataIni))})
	Else
		nMes++
		If nMes > 12
			nMes := 1
			nYear++	
		Endif
		aAdd(aMeses,{"",cTod("01"+"/"+StrZero(nMes,2)+"/"+Alltrim(Str(nYear))),IIf((nMes==Month(dDataFim) .and. nYear==Year(dDataFim)),dDataFim,LastDay(cTod("01"+"/"+StrZero(nMes,2)+"/"+Alltrim(Str(nYear)))))})
	Endif		 
	If nMes==Month(dDataFim) .and. nYear==Year(dDataFim)
		Exit
	Endif	
Enddo
/*
aPeriodos := ctbPeriodos(cMoeda,mv_par01,mv_par02,.T.,.F.)

For nCnt := 1 to Len(aPeriodos)
	//Se a Data do periodo eh maior ou igual a data inicial solicitada no relatorio.
	If aPeriodos[nCnt][1] >= mv_par01 .And. aPeriodos[nCnt][2] <= mv_par02
		If nMeses <= 12
			aAdd(aMeses,{StrZero(nMeses,2),aPeriodos[nCnt][1],aPeriodos[nCnt][2]})
		EndIf
		nMeses += 1
	EndIf
Next

If Len( aMeses ) == 0
	aAdd(aMeses,{'01',mv_par01,mv_par02})
EndIf	
*/

SM0->(dbSetOrder(1))

For nCnt:=1 To Len(aMeses)
	// posiciona na 1 filial da empresa
	SM0->(dbSeek(FWGrpCompany()+aSelFil[1]))
	XX8->(dbSeek(Padr(FWGrpCompany(),12)+Padr(mv_par03,12)))
    
	SaldoCQ(lUsaConta,lUsaCusto,lUsaItem,lUsaClVl,lImpAntLP,dDataLP,cMoeda,cSaldos,aSelFil,aMeses[nCnt][2],aMeses[nCnt][3],cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClVlIni,cClVlFim)

	dbSelectArea("cArqTmp")
	dbGotop()
	
	While cArqTmp->(!Eof())
		If !Empty(cArqTmp->VAL_CQ1) .or. !Empty(cArqTmp->VAL_CQ3) .or. !Empty(cArqTmp->VAL_CQ5) .or. !Empty(cArqTmp->VAL_CQ7)
			If !GravItem(cArqTmp,@nDet,@cItem,@lGravou,nArq,Alltrim(Str(Month(aMeses[nCnt][2]))),Alltrim(Str(Year(aMeses[nCnt][3]))),lComp)
				CloseTemp(cArqTmp,nArq)
				Return()
			Endif
		Endif	
		
		cArqTmp->(dbSkip())
	Enddo
	
	CloseTemp(cArqTmp)
Next

CloseTemp(cArqTmp,nArq)
	
If lGravou
	APMsgInfo("Arquivo: '"+cArqTxt+"' gerado com sucesso.")
Else
	APMsgStop("Não foram encontrados saldos para esta Empresa.") 	
Endif

cFilAnt := cFilAntSav
	
aEval(aArea,{|x| RestArea(x)})

Return()


Static Function GravItem(cArqTmp,nDet,cItem,lGravou,nArq,cMes,cAno,lComp)

Local lRet := .T.
Local cSeq := ";"

cItem := Alltrim(cAno)+cSeq
cItem += Alltrim(cMes)+cSeq
If mv_par19 == 1
	cItem += Alltrim(mv_par03)+cSeq
Else
	cItem += Alltrim(cArqTmp->FILIAL)+cSeq
Endif	
cItem += Alltrim(cArqTmp->CONTA)+cSeq	
cItem += Alltrim(cArqTmp->CUSTO)+cSeq	
cItem += Alltrim(cArqTmp->ITEM)+cSeq	
cItem += Alltrim(cArqTmp->CLVL)+cSeq	
//If !lComp
//	cItem += Alltrim(Transform(cArqTmp->SALDOATU*-1,"@E 999,999,999,999.99"))
//Else
//	cItem += Alltrim(Transform(cArqTmp->COLA1*-1,"@E 999,999,999,999.99"))
//Endif	
cItem += Alltrim(Transform(IIf(!Empty(cArqTmp->VAL_CQ7),cArqTmp->VAL_CQ7,IIf(!Empty(cArqTmp->VAL_CQ5),cArqTmp->VAL_CQ5,IIf(!Empty(cArqTmp->VAL_CQ3),cArqTmp->VAL_CQ3,IIf(!Empty(cArqTmp->VAL_CQ1),cArqTmp->VAL_CQ1,0))))*-1,"@E 999,999,999,999.99"))
cItem += chr(13) + chr(10)

lRet := ChkGrvFile(@nDet,@cItem,@lGravou,nArq)	

Return(lRet)       


Static Function ChkGrvFile(nDet,cItem,lGravou,nArq)

nDet := Len(cItem)
lGravou := IIf(fWrite(nArq,cItem) == nDet,.T.,.F.)

If !lGravou
	APMsgStop("Erro ao gravar linha no arquivo de saida" + chr(13) + ;
	"Codigo do erro: " + AllTrim(Str(fError())), "ATENCAO" )
	Return(.F.)
EndIf
         
Return(.T.)


Static Function CloseTemp(cArqTmp,nArq)

If Select("cArqTmp") > 0
	dbSelectArea("cArqTmp")
	Set Filter To
	dbCloseArea()
	If Select("cArqTmp") == 0
		FErase(cArqTmp+GetDBExtension())
		FErase(cArqTmp+OrdBagExt())
	Endif
Endif

If nArq <> Nil
	If nArq <> 0
		If !fClose(nArq) 
			APMsgStop("Nao foi possivel finalizar o arquivo de saida! Codigo do erro: " + AllTrim(Str(fError())),"Stop")
		EndIf
	Endif	
Endif
	
Return()


// rotina criada, pois na P12 esta funcao foi removida do RPO
// foi usada como base a rotina padrao da versao P11.8
Static Function AjustaSX1(cPerg)
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local cKey		:= ""
Local nj		:= 1
Local aArea		:= GetArea()
Local lUpdHlp	:= .T.
Local aPergs	:= {}

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
			"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
			"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
			"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
			"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
			"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
			"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
			"X1_F3","X1_PYME","X1_GRPSXG","X1_HELP","X1_PICTURE","X1_IDFIL"}

aadd(aPergs,{"Data Inicial ?"				,"","","mv_ch1","D",08,0,0 ,"G","!Vazio()","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aPergs,{"Data Final ?"					,"","","mv_ch2","D",08,0,0 ,"G","!Vazio()","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aPergs,{"Empresa ?"					,"","","mv_ch3","C",12,0,0 ,"G","!Vazio() .and. U_VldEmp(mv_par03)","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","XX8EM1","","","","","","",""})
aadd(aPergs,{"Considera Conta ?"			,"","","mv_ch4","N",01,0,1 ,"C","U_CTB06MvPar('mv_par04')","mv_par04","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aPergs,{"Conta Inicial ?"				,"","","mv_ch5","C",20,0,0 ,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CT1","","003","","","","",""})
aadd(aPergs,{"Conta Final ?"				,"","","mv_ch6","C",20,0,0 ,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","CT1","","003","","","","",""})
aadd(aPergs,{"Considera C.Custo ?"			,"","","mv_ch7","N",01,0,1 ,"C","","mv_par07","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aPergs,{"C.Custo Inicial ?"			,"","","mv_ch8","C",09,0,0 ,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","004","","","","",""})
aadd(aPergs,{"C.Custo Final ?"				,"","","mv_ch9","C",09,0,0 ,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","004","","","","",""})
aadd(aPergs,{"Considera Item Ctb. ?"		,"","","mv_cha","N",01,0,1 ,"C","","mv_par10","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aPergs,{"Item Ctb. Inicial ?"			,"","","mv_chb","C",09,0,0 ,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","CTD","","005","","","","",""})
aadd(aPergs,{"Item Ctb. Final ?"			,"","","mv_chc","C",09,0,0 ,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","CTD","","005","","","","",""})
aadd(aPergs,{"Considera Classe Vlr. ?"		,"","","mv_chd","N",01,0,1 ,"C","","mv_par13","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aPergs,{"Classe Vlr. Inicial ?"		,"","","mv_che","C",09,0,0 ,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","CTH","","006","","","","",""})
aadd(aPergs,{"Classe Vlr. Final ?"			,"","","mv_chf","C",09,0,0 ,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","CTH","","006","","","","",""})
aadd(aPergs,{"Posicao Ant. L/P ?"			,"","","mv_chg","N",01,0,2 ,"C","","mv_par16","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aPergs,{"Data Lucros/Perdas ?"			,"","","mv_chh","D",08,0,0 ,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aPergs,{"Diretorio de Gravacao ?"		,"","","mv_chi","C",50,0,0 ,"G","!Vazio().or.(Mv_Par18:=cGetFile('Arquivos |*.*','',,,,176))","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aPergs,{"Gera por Empresa/Filial ?"	,"","","mv_chj","N",01,0,1 ,"C","","mv_par19","Empresa","Empresa","Empresa","","","Filial","Filial","Filial","","","","","","","","","","","","","","","","","","","","","","","",""})

dbSelectArea( "SX1" )
dbSetOrder(1)

cPerg := PadR( cPerg , Len(X1_GRUPO) , " " )

For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek( cPerg + Right( Alltrim( aPergs[nX][11] ) , 2) )

		If ( ValType( aPergs[nX][Len( aPergs[nx] )]) = "B" .And. Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif

	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]		
 		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
 	Endif	
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(ALLTRIM( aPergs[nX][11] ), 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0 .And. ValType(aPergs[nX][nJ]) != "A"
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
	Endif
	cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."

	If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
		aHelpSpa := aPergs[nx][Len(aPergs[nx])]
	Else
		aHelpSpa := {}
	Endif
	
	If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
		aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
	Else
		aHelpEng := {}
	Endif

	If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
		aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
	Else
		aHelpPor := {}
	Endif

	// Caso exista um help com o mesmo nome, atualiza o registro.
	lUpdHlp := ( !Empty(aHelpSpa) .and. !Empty(aHelpEng) .and. !Empty(aHelpPor) )
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa,lUpdHlp)
	
Next
RestArea(aArea)

Return()


// adaptada da funcao padrao F3XX8EMP se alterada para trazer apenas as empresas do grupo de empresas logado
User Function _F3XX8EMP

Local aArea	:= {XX8->(GetArea()),GetArea()}
Local aCpos     := {}       //Array com os dados
Local lRet      := .T. 		//Array do retorno da opcao selecionada
Local oDlgF3                  //Objeto Janela
Local oLbx                  //Objeto List box
Local cTitulo   := "Empresas"	//"Empresas"
Local aRet		:= {}
	    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Procurar campo no SX3³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("XX8")
XX8->(dbSetOrder(1))
XX8->(dbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega o vetor com os campos da tabela selecionada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

While !XX8->(Eof())
   
   If XX8_TIPO == "1"
	If XX8->XX8_GRPEMP == Padr(FWGrpCompany(),12)		   	
	   aAdd( aCpos, { XX8->XX8_CODIGO, XX8->XX8_DESCRI } )
	Endif	   
   EndIf
   
   XX8->(DbSkip())
   
Enddo

If Len( aCpos ) > 0

	DEFINE MSDIALOG oDlgf3 TITLE cTitulo FROM 0,0 TO 240,500 PIXEL
	
	   @ 10,10 LISTBOX oLbx FIELDS HEADER "Empresas", "Descrição" SIZE 230,95 OF oDlgf3 PIXEL	//"Empresas"###"Descrição" 
	
	   oLbx:SetArray( aCpos )
	   oLbx:bLine     := {|| {aCpos[oLbx:nAt,1], aCpos[oLbx:nAt,2]}}
	   oLbx:bLDblClick := {|| {oDlgF3:End(), aRet := {oLbx:aArray[oLbx:nAt,1],oLbx:aArray[oLbx:nAt,2]}}} 	                   

	DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION (oDlgF3:End(), aRet := {oLbx:aArray[oLbx:nAt,1],oLbx:aArray[oLbx:nAt,2]})  ENABLE OF oDlgF3
	ACTIVATE MSDIALOG oDlgF3 CENTER
		
EndIf	

cRetxx8 := AllTrim(iIF(Len(aRet) > 0, aRet[1],""))

If Empty(cRetxx8)
	lRet := .F.
EndIf

aEval(aArea,{|x| RestArea(x)})

Return lRet


//U_CTB06MvPar("mv_par04")                                    
User Function CTB06MvPar(cMv)		

Local lRet := .T.

If cMv == "mv_par04" .and. mv_par04 != 1
	lRet := .F.
	MsgStop("Informe 'Sim' para Considerar a Conta Contábil.")
Endif

Return(lRet)	


User Function VldEmp(cEmp)

Local aArea := {XX8->(GetArea()),GetArea()}
Local lRet := .F.

XX8->(dbSetOrder(3))
XX8->(dbGotop())
While XX8->(!Eof())
	If XX8->XX8_TIPO == "1" .and. XX8->XX8_GRPEMP == Padr(FWGrpCompany(),12)
		If Empty(XX8->XX8_EMPR) .and. XX8->XX8_CODIGO == mv_par03
			lRet := .T.
			Exit
		Endif
	Endif
	XX8->(dbSkip())
Enddo

If !lRet
	APMsgStop("Empresa informada no parâmetro não encontrada no Cadastro de Empresas.")
Endif	

aEval(aArea,{|x| RestArea(x)})

Return(lRet)


Static Function SaldoCQ(lUsaConta,lUsaCusto,lUsaItem,lUsaClVl,lImpAntLP,dDataLP,cMoeda,cSaldos,aSelFil,dDataIni,dDataFim,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClVlIni,cClVlFim)

Local aArea := {GetArea()}
Local cAliasTrb := GetNextAlias()
Local cQ := ""
Local aTamConta	:= TAMSX3("CT1_CONTA")
Local aTamCC := TAMSX3("CTT_CUSTO")
Local aTamItem := TAMSX3("CTD_ITEM")
Local aTamClVl := TAMSX3("CTH_CLVL")
Local aCampos
Local aTamFil := TAMSX3("CT2_FILIAL")
Local aTamVal := TAMSX3("CT2_VALOR")
Local nDecimais := 2
Local cArqTmp := "" 
Local cArqInd := ""
Local cChave := ""
Local cConta := ""
Local cCusto := ""
Local cItem := ""
Local cClvl := ""
Local nConta := 0
Local nCusto := 0
Local nItem := 0
Local nClvl := 0
Local nCustoTot := 0
Local nItemTot := 0
Local cFil := ""

aCampos := {;
{ "FILIAL"	   	, "C", aTamFil[1] 		, 0 },;
{ "CONTA"	   	, "C", aTamConta[1] 	, 0 },;
{ "NORMAL"		, "C", 01				, 0 },;
{ "CUSTO"		, "C", aTamCC[1]		, 0 },;
{ "ITEM"		, "C", aTamItem[1]		, 0 },;
{ "CLVL"		, "C", aTamClVl[1]		, 0 },;
{ "VAL_CQ7"		, "N", aTamVal[1]+2		, nDecimais},;
{ "VAL_CQ5"		, "N", aTamVal[1]+2		, nDecimais},;
{ "VAL_CQ3"		, "N", aTamVal[1]+2		, nDecimais},;
{ "VAL_CQ1"		, "N", aTamVal[1]+2		, nDecimais};
}

cArqTmp := CriaTrab(aCampos,.T.)
			
If ( Select ( "cArqTmp" ) <> 0 )
	dbSelectArea ( "cArqTmp" )
	dbCloseArea ()
Endif
			
dbUseArea( .T.,, cArqTmp, "cArqTmp", .F., .F. )
dbSelectArea("cArqTmp")
			
cArqInd	:= CriaTrab(Nil, .F.)
//cChave := IIf(mv_par19==1,"","FILIAL+")+"CONTA+CUSTO+ITEM+CLVL"
cChave := "FILIAL+CONTA+CUSTO+ITEM+CLVL"
			
IndRegua("cArqTmp",cArqInd,cChave,,,OemToAnsi("Selecionando Registros..."))
			
dbSelectArea("cArqTmp")
DbClearIndex()
dbSetIndex(cArqInd+OrdBagExt())

//cQ := "SELECT CONTA,CUSTO,ITEM,CLVL,VAL_CQ7,VAL_CQ5,VAL_CQ3,VAL_CQ1 "+CRLF
cQ := "SELECT "+CRLF
If mv_par19 == 2
	cQ += "FILIAL "
Endif	
If lUsaConta
	If mv_par19 == 2
		cQ += ","
	Endif	
	cQ += "CONTA "+CRLF
Endif
If lUsaCusto	
	If (lUsaConta .and. mv_par19 == 1) .or. (lUsaCusto .and. mv_par19 == 2)
		cQ += ","+CRLF
	Endif	
	cQ += "CUSTO "+CRLF
Endif
If lUsaItem
	If ((lUsaConta .or. lUsaCusto) .and. mv_par19 == 1) .or. (lUsaItem .and. mv_par19 == 2)
		cQ += ","+CRLF
	Endif	
	cQ += "ITEM "+CRLF
Endif
If lUsaClvl
	If ((lUsaConta .or. lUsaCusto .or. lUsaItem) .and. mv_par19 == 1) .or. (lUsaClvl .and. mv_par19 == 2)
		cQ += ","+CRLF
	Endif	
	cQ += "CLVL "+CRLF
Endif
cQ +=",VAL_CQ7,VAL_CQ5,VAL_CQ3,VAL_CQ1 "+CRLF
cQ += "FROM "+CRLF 
cQ += "( "+CRLF

If lUsaClvl
	cQ += "( "+CRLF
//	cQ += "SELECT CQ7_CONTA CONTA,CQ7_CCUSTO CUSTO,CQ7_ITEM ITEM,CQ7_CLVL CLVL,SUM(CQ7_CREDIT-CQ7_DEBITO) VAL_CQ7, 0 VAL_CQ5, 0 VAL_CQ3, 0 VAL_CQ1 "+CRLF
	cQ += "SELECT "
	If mv_par19 == 2
		cQ += "CQ7_FILIAL FILIAL "
	Endif	
	If lUsaConta
		If mv_par19 == 2
			cQ += ","
		Endif	
		cQ += "CQ7_CONTA CONTA "+CRLF
	Endif
	If lUsaCusto
		If (lUsaConta .and. mv_par19 == 1) .or. (lUsaCusto .and. mv_par19 == 2)
			cQ += ", "+CRLF
		Endif	
		cQ += "CQ7_CCUSTO CUSTO "+CRLF
	Endif
	If lUsaItem
		If ((lUsaConta .or. lUsaCusto) .and. mv_par19 == 1) .or. (lUsaItem .and. mv_par19 == 2)
			cQ += ", "+CRLF
		Endif	
		cQ += "CQ7_ITEM ITEM "+CRLF
	Endif
	If ((lUsaConta .or. lUsaCusto .or. lUsaItem) .and. mv_par19 == 1) .or. mv_par19 == 2
		cQ += ", "+CRLF
	Endif	
	cQ += "CQ7_CLVL CLVL,SUM(CQ7_CREDIT-CQ7_DEBITO) VAL_CQ7, 0 VAL_CQ5, 0 VAL_CQ3, 0 VAL_CQ1 "+CRLF
	cQ += "FROM "+RetSqlName("CQ7")+" CQ7 "+CRLF
	cQ += "WHERE CQ7.D_E_L_E_T_ = ' ' "+CRLF 
	cQ += "AND CQ7_FILIAL "+GetRngFil(aSelFil,"CQ7")+ " "+CRLF
	If lImpAntLP .and. dDataLP >= dDataFim
		cQ += "AND CQ7_LP <> 'Z' "
	Endif
	cQ += "AND CQ7_MOEDA = "+cMoeda+" "+CRLF
	cQ += "AND CQ7_TPSALD = "+cSaldos+" "+CRLF
	cQ += "AND CQ7_DATA <= '"+dTos(dDataFim)+"' "+CRLF
	If lUsaConta
		cQ += "AND CQ7_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "+CRLF
	Endif
	If lUsaCusto	
		cQ += "AND CQ7_CCUSTO BETWEEN '"+cCCIni+"' AND '"+cCCFim+"' "+CRLF
	Endif
	If lUsaItem	
		cQ += "AND CQ7_ITEM BETWEEN '"+cItemIni+"' AND '"+cItemFim+"' "+CRLF
	Endif	
	cQ += "AND CQ7_CLVL BETWEEN '"+cClvlIni+"' AND '"+cClvlFim+"' "+CRLF
	//cQ += "GROUP BY CQ7_CONTA,CQ7_CCUSTO,CQ7_ITEM,CQ7_CLVL "+CRLF
	cQ += "GROUP BY "+CRLF	
	If mv_par19 == 2
		cQ += "CQ7_FILIAL "
	Endif	
	If lUsaConta
		If mv_par19 == 2
			cQ += ","
		Endif	
		cQ += "CQ7_CONTA "+CRLF
	Endif
	If lUsaCusto
		If (lUsaConta .and. mv_par19 == 1) .or. (lUsaCusto .and. mv_par19 == 2)
			cQ += ", "+CRLF
		Endif	
		cQ += "CQ7_CCUSTO "+CRLF
	Endif
	If lUsaItem
		If ((lUsaConta .or. lUsaCusto) .and. mv_par19 == 1) .or. (lUsaItem .and. mv_par19 == 2)
			cQ += ", "+CRLF
		Endif	
		cQ += "CQ7_ITEM "+CRLF
	Endif
	If ((lUsaConta .or. lUsaCusto .or. lUsaItem) .and. mv_par19 == 1) .or. mv_par19 == 2
		cQ += ", "+CRLF
	Endif	
	cQ += "CQ7_CLVL "+CRLF
	cQ += ") "+CRLF
Endif
If lUsaClvl .and. lUsaItem
	cQ += "UNION "+CRLF
Endif	
If lUsaItem
	cQ += "( "+CRLF 
//	cQ += "SELECT CQ5_CONTA CONTA,CQ5_CCUSTO CUSTO,CQ5_ITEM ITEM,' ' CLVL,0 VAL_CQ7,SUM(CQ5_CREDIT-CQ5_DEBITO) VAL_CQ5, 0 VAL_CQ3, 0 VAL_CQ1 "+CRLF
	cQ += "SELECT "+CRLF
	If mv_par19 == 2
		cQ += "CQ5_FILIAL FILIAL "
	Endif	
	If lUsaConta
		If mv_par19 == 2
			cQ += ","
		Endif	
		cQ += "CQ5_CONTA CONTA "+CRLF
	Endif
	If lUsaCusto
		If (lUsaConta .and. mv_par19 == 1) .or. (lUsaCusto .and. mv_par19 == 2)
			cQ += ", "+CRLF
		Endif	
		cQ += "CQ5_CCUSTO CUSTO "+CRLF
	Endif
	If ((lUsaConta .or. lUsaCusto) .and. mv_par19 == 1) .or. mv_par19 == 2
		cQ += ", "+CRLF
	Endif	
	cQ += "CQ5_ITEM ITEM "+CRLF
	If lUsaClvl
		cQ += ",' ' CLVL "+CRLF
	Endif	
	cQ += ",0 VAL_CQ7,SUM(CQ5_CREDIT-CQ5_DEBITO) VAL_CQ5, 0 VAL_CQ3, 0 VAL_CQ1 "+CRLF
	cQ += "FROM "+RetSqlName("CQ5")+" CQ5 "+CRLF
	cQ += "WHERE CQ5.D_E_L_E_T_ = ' ' "+CRLF  
	cQ += "AND CQ5_FILIAL "+GetRngFil(aSelFil,"CQ5")+ " "+CRLF
	If lImpAntLP .and. dDataLP >= dDataFim
		cQ += "AND CQ5_LP <> 'Z' "
	Endif
	cQ += "AND CQ5_MOEDA = "+cMoeda+" "+CRLF
	cQ += "AND CQ5_TPSALD = "+cSaldos+" "+CRLF
	cQ += "AND CQ5_DATA <= '"+dTos(dDataFim)+"' "+CRLF
	If lUsaConta
		cQ += "AND CQ5_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "+CRLF
	Endif
	If lUsaCusto	
		cQ += "AND CQ5_CCUSTO BETWEEN '"+cCCIni+"' AND '"+cCCFim+"' "+CRLF
	Endif
	cQ += "AND CQ5_ITEM BETWEEN '"+cItemIni+"' AND '"+cItemFim+"' "+CRLF
//	cQ += "GROUP BY CQ5_CONTA,CQ5_CCUSTO,CQ5_ITEM "+CRLF
	cQ += "GROUP BY "+CRLF	
	If mv_par19 == 2
		cQ += "CQ5_FILIAL "
	Endif	
	If lUsaConta
		If mv_par19 == 2
			cQ += ","
		Endif	
		cQ += "CQ5_CONTA "+CRLF
	Endif
	If lUsaCusto
		If (lUsaConta .and. mv_par19 == 1) .or. (lUsaCusto .and. mv_par19 == 2)
			cQ += ", "+CRLF
		Endif	
		cQ += "CQ5_CCUSTO "+CRLF
	Endif
	If ((lUsaConta .or. lUsaCusto) .and. mv_par19 == 1) .or. mv_par19 == 2
		cQ += ", "+CRLF
	Endif	
	cQ += "CQ5_ITEM "+CRLF
	cQ += ") "+CRLF
Endif
If (lUsaClvl .or. lUsaItem) .and. lUsaCusto
	cQ += "UNION "+CRLF
Endif	
If lUsaCusto
	cQ += "( "+CRLF
//	cQ += "SELECT CQ3_CONTA CONTA,CQ3_CCUSTO CUSTO,' ' ITEM,' ' CLVL,0 VAL_CQ7,0 VAL_CQ5,SUM(CQ3_CREDIT-CQ3_DEBITO) VAL_CQ3, 0 VAL_CQ1 "+CRLF
	cQ += "SELECT "+CRLF
	If mv_par19 == 2
		cQ += "CQ3_FILIAL FILIAL "
	Endif	
	If lUsaConta
		If mv_par19 == 2
			cQ += ","
		Endif	
		cQ += "CQ3_CONTA CONTA "+CRLF
	Endif	
	If lUsaConta .or. mv_par19 == 2
		cQ += ","+CRLF
	Endif	
	cQ += "CQ3_CCUSTO CUSTO "+CRLF
	If lUsaItem
		cQ += ",' ' ITEM "+CRLF
	Endif	
	If lUsaClvl
		cQ += ",' ' CLVL "+CRLF
	Endif	
	cQ += ",0 VAL_CQ7,0 VAL_CQ5,SUM(CQ3_CREDIT-CQ3_DEBITO) VAL_CQ3, 0 VAL_CQ1 "+CRLF
	cQ += "FROM "+RetSqlName("CQ3")+" CQ3 "+CRLF
	cQ += "WHERE CQ3.D_E_L_E_T_ = ' ' "+CRLF 
	cQ += "AND CQ3_FILIAL "+GetRngFil(aSelFil,"CQ3")+ " "+CRLF
	If lImpAntLP .and. dDataLP >= dDataFim
		cQ += "AND CQ3_LP <> 'Z' "
	Endif
	cQ += "AND CQ3_MOEDA = "+cMoeda+" "+CRLF
	cQ += "AND CQ3_TPSALD = "+cSaldos+" "+CRLF
	cQ += "AND CQ3_DATA <= '"+dTos(dDataFim)+"' "+CRLF
	If lUsaConta
		cQ += "AND CQ3_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "+CRLF
	Endif
	cQ += "AND CQ3_CCUSTO BETWEEN '"+cCCIni+"' AND '"+cCCFim+"' "+CRLF
//	cQ += "GROUP BY CQ3_CONTA,CQ3_CCUSTO "+CRLF
	cQ += "GROUP BY "+CRLF	
	If mv_par19 == 2
		cQ += "CQ3_FILIAL "
	Endif	
	If lUsaConta
		If mv_par19 == 2
			cQ += ","+CRLF
		Endif	
		cQ += "CQ3_CONTA "+CRLF
	Endif
	If lUsaConta .or. mv_par19 == 2
		cQ += ","+CRLF
	Endif	
	cQ += "CQ3_CCUSTO "+CRLF
	cQ += ") "+CRLF
Endif
If (lUsaClvl .or. lUsaItem .or. lUsaCusto) .and. lUsaConta
	cQ += "UNION "+CRLF
Endif	
If lUsaConta
	cQ += "( "+CRLF
//	cQ += "SELECT CQ1_CONTA CONTA,' ' CUSTO,' ' ITEM,' ' CLVL,0 VAL_CQ7,0 VAL_CQ5,0 VAL_CQ3,SUM(CQ1_CREDIT-CQ1_DEBITO) VAL_CQ1 "+CRLF
	cQ += "SELECT "+CRLF
	If mv_par19 == 2
		cQ += "CQ1_FILIAL FILIAL "
		cQ += ","
	Endif	
	cQ += "CQ1_CONTA CONTA "+CRLF
	If lUsaCusto
		cQ += ",' ' CUSTO "+CRLF
	Endif	
	If lUsaItem
		cQ += ",' ' ITEM "+CRLF
	Endif	
	If lUsaClvl
		cQ += ",' ' CLVL "+CRLF
	Endif	
	cQ += ",0 VAL_CQ7,0 VAL_CQ5,0 VAL_CQ3,SUM(CQ1_CREDIT-CQ1_DEBITO) VAL_CQ1 "+CRLF
	cQ += "FROM "+RetSqlName("CQ1")+" CQ1 "+CRLF
	cQ += "WHERE CQ1.D_E_L_E_T_ = ' ' "+CRLF 
	cQ += "AND CQ1_FILIAL "+GetRngFil(aSelFil,"CQ1")+ " "+CRLF
	If lImpAntLP .and. dDataLP >= dDataFim
		cQ += "AND CQ1_LP <> 'Z' "
	Endif
	cQ += "AND CQ1_MOEDA = "+cMoeda+" "+CRLF
	cQ += "AND CQ1_TPSALD = "+cSaldos+" "+CRLF
	cQ += "AND CQ1_DATA <= '"+dTos(dDataFim)+"' "+CRLF
	cQ += "AND CQ1_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "+CRLF
	cQ += "GROUP BY "+CRLF 
	If mv_par19 == 2
		cQ += "CQ1_FILIAL "
		cQ += ","
	Endif	
	cQ += "CQ1_CONTA "+CRLF
	cQ += ") "+CRLF 
Endif

cQ += ") "+CRLF
cQ += "WHERE "+CRLF 
cQ += "( "+CRLF
cQ += "VAL_CQ1 <> 0 "+CRLF
cQ += "OR VAL_CQ3 <> 0 "+CRLF
cQ += "OR VAL_CQ5 <> 0 "+CRLF
cQ += "OR VAL_CQ7 <> 0 "+CRLF
cQ += ") "+CRLF

//cQ += "ORDER BY CONTA,CUSTO,ITEM,CLVL "+CRLF
cQ += "ORDER BY "+CRLF
If mv_par19 == 2
	cQ += "FILIAL "
Endif	
If lUsaConta
	If mv_par19 == 2
		cQ += ","+CRLF
	Endif	
	cQ += "CONTA "+CRLF
Endif
If lUsaCusto	
	If (lUsaConta .and. mv_par19 == 1) .or. (lUsaCusto .and. mv_par19 == 2)
		cQ += ","+CRLF
	Endif	
	cQ += "CUSTO"+CRLF
Endif
If lUsaItem
	If ((lUsaConta .or. lUsaCusto) .and. mv_par19 == 1) .or. (lUsaItem .and. mv_par19 == 2)
		cQ += ","+CRLF
	Endif	
	cQ += "ITEM "+CRLF
Endif
If lUsaClvl
	If ((lUsaConta .or. lUsaCusto .or. lUsaItem) .and. mv_par19 == 1) .or. (lUsaClvl .and. mv_par19 == 2)
		cQ += ","+CRLF
	Endif	
	cQ += "CLVL "+CRLF
Endif

cQ := ChangeQuery(cQ)
//MemoWrite("c:\temp\MGFCTB06.txt",cQ)
dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)

tcSetField(cAliasTrb,"VAL_CQ7",'N',aTamVal[1]+2,nDecimais)
tcSetField(cAliasTrb,"VAL_CQ5",'N',aTamVal[1]+2,nDecimais)
tcSetField(cAliasTrb,"VAL_CQ3",'N',aTamVal[1]+2,nDecimais)
tcSetField(cAliasTrb,"VAL_CQ1",'N',aTamVal[1]+2,nDecimais)

While (cAliasTrb)->(!Eof())
	cArqTmp->(RecLock("cArqTmp",.T.))
 	If mv_par19 == 2	
		cArqTmp->FILIAL := (cAliasTrb)->FILIAL
	Endif 	
	If lUsaConta
		cArqTmp->CONTA := (cAliasTrb)->CONTA
	Endif	
	If lUsaCusto
		cArqTmp->CUSTO := (cAliasTrb)->CUSTO
	Endif
	If lUsaItem
		cArqTmp->ITEM := (cAliasTrb)->ITEM
	Endif
	If lUsaClvl
		cArqTmp->CLVL := (cAliasTrb)->CLVL
	Endif	
	cArqTmp->VAL_CQ7 := (cAliasTrb)->VAL_CQ7
	cArqTmp->VAL_CQ5 := (cAliasTrb)->VAL_CQ5
	cArqTmp->VAL_CQ3 := (cAliasTrb)->VAL_CQ3
	cArqTmp->VAL_CQ1 := (cAliasTrb)->VAL_CQ1			
	cArqTmp->(MsUnLock())
	(cAliasTrb)->(dbSkip())
Enddo	
	
dbSelectArea("cArqTmp")
dbGoBottom()

While cArqTmp->(!Bof()) 
	cConta := ""
	nConta := 0
	cCusto := ""
	nCusto := 0
	cItem := ""
	nItem := 0
	cClvl := ""
	nClvl := 0
	nCustoTot := 0
	nItemTot := 0
	cFil := ""

	If !Empty(cArqTmp->CONTA)
		cConta := cArqTmp->CONTA
		nConta := cArqTmp->VAL_CQ1
	Endif	
	If !Empty(cArqTmp->CUSTO)
		cCusto := cArqTmp->CUSTO
		nCusto := cArqTmp->VAL_CQ3
	Endif
	If !Empty(cArqTmp->ITEM)
		cItem := cArqTmp->ITEM
		nItem := cArqTmp->VAL_CQ5
	Endif	
	If !Empty(cArqTmp->CLVL)
		cClvl := cArqTmp->CLVL
		nClvl := cArqTmp->VAL_CQ7
	Endif	
	cFil := cArqTmp->FILIAL
	cArqTmp->(dbSkip(-1))
	
	If cTipo == "5" // conta x custo
		While cArqTmp->(!Bof()) .and. cConta == cArqTmp->CONTA .and. cFil == cArqTmp->FILIAL
			If !Empty(cArqTmp->CUSTO) .and. !Empty(cArqTmp->VAL_CQ3)
				nCusto += cArqTmp->VAL_CQ3
			Endif
			If Empty(cArqTmp->CUSTO) .and. !Empty(cArqTmp->VAL_CQ1) .and. !Empty(nCusto)
				cArqTmp->(RecLock("cArqTmp",.F.))
				cArqTmp->VAL_CQ1 := cArqTmp->VAL_CQ1-nCusto
				cArqTmp->(MsUnLock())
			Endif	
			cArqTmp->(dbSkip(-1))
		Enddo		
	Endif	

	If cTipo == "6" // conta x item
		While cArqTmp->(!Bof()) .and. cConta == cArqTmp->CONTA .and. cFil == cArqTmp->FILIAL
			If !Empty(cArqTmp->ITEM) .and. !Empty(cArqTmp->VAL_CQ5)
				nItem += cArqTmp->VAL_CQ5
			Endif
			If Empty(cArqTmp->ITEM) .and. !Empty(cArqTmp->VAL_CQ1) .and. !Empty(nItem)
				cArqTmp->(RecLock("cArqTmp",.F.))
				cArqTmp->VAL_CQ1 := cArqTmp->VAL_CQ1-nItem
				cArqTmp->(MsUnLock())
			Endif	
			cArqTmp->(dbSkip(-1))
		Enddo		
	Endif	

	If cTipo == "7" // conta x classe
		While cArqTmp->(!Bof()) .and. cConta == cArqTmp->CONTA .and. cFil == cArqTmp->FILIAL
			If !Empty(cArqTmp->CLVL) .and. !Empty(cArqTmp->VAL_CQ7)
				nClvl += cArqTmp->VAL_CQ7
			Endif
			If Empty(cArqTmp->CLVL) .and. !Empty(cArqTmp->VAL_CQ1) .and. !Empty(nClvl)
				cArqTmp->(RecLock("cArqTmp",.F.))
				cArqTmp->VAL_CQ1 := cArqTmp->VAL_CQ1-nClvl
				cArqTmp->(MsUnLock())
			Endif	
			cArqTmp->(dbSkip(-1))
		Enddo		
	Endif	
				
	If cTipo == "8" // custo x item
		While cArqTmp->(!Bof()) .and. cCusto == cArqTmp->CUSTO .and. cFil == cArqTmp->FILIAL
			If !Empty(cArqTmp->ITEM) .and. !Empty(cArqTmp->VAL_CQ5)
				nItem += cArqTmp->VAL_CQ5
			Endif
			If Empty(cArqTmp->ITEM) .and. !Empty(cArqTmp->VAL_CQ3) .and. !Empty(nItem)
				cArqTmp->(RecLock("cArqTmp",.F.))
				cArqTmp->VAL_CQ3 := cArqTmp->VAL_CQ3-nItem
				cArqTmp->(MsUnLock())
			Endif	
			cArqTmp->(dbSkip(-1))
		Enddo		
	Endif	

	If cTipo == "9" // custo x classe 
		While cArqTmp->(!Bof()) .and. cCusto == cArqTmp->CUSTO .and. cFil == cArqTmp->FILIAL
			If !Empty(cArqTmp->CLVL) .and. !Empty(cArqTmp->VAL_CQ7)
				nClvl += cArqTmp->VAL_CQ7
			Endif
			If Empty(cArqTmp->CLVL) .and. !Empty(cArqTmp->VAL_CQ3) .and. !Empty(nClvl)
				cArqTmp->(RecLock("cArqTmp",.F.))
				cArqTmp->VAL_CQ3 := cArqTmp->VAL_CQ3-nClvl
				cArqTmp->(MsUnLock())
			Endif	
			cArqTmp->(dbSkip(-1))
		Enddo		
	Endif	

	If cTipo == "10" // item x classe
		While cArqTmp->(!Bof()) .and. cItem == cArqTmp->ITEM .and. cFil == cArqTmp->FILIAL
			If !Empty(cArqTmp->CLVL) .and. !Empty(cArqTmp->VAL_CQ7)
				nClvl += cArqTmp->VAL_CQ7
			Endif
			If Empty(cArqTmp->CLVL) .and. !Empty(cArqTmp->VAL_CQ5) .and. !Empty(nClvl)
				cArqTmp->(RecLock("cArqTmp",.F.))
				cArqTmp->VAL_CQ5 := cArqTmp->VAL_CQ5-nClvl
				cArqTmp->(MsUnLock())
			Endif	
			cArqTmp->(dbSkip(-1))
		Enddo		
	Endif	

	If cTipo == "11" // conta x custo x item
		nCustoTot := 0
		nItemTot := 0
		While cArqTmp->(!Bof()) .and. cConta == cArqTmp->CONTA .and. cFil == cArqTmp->FILIAL
			cCusto := cArqTmp->CUSTO
			While cArqTmp->(!Bof()) .and. cConta == cArqTmp->CONTA .and. cCusto == cArqTmp->CUSTO .and. cFil == cArqTmp->FILIAL
				If !Empty(cArqTmp->ITEM) .and. !Empty(cArqTmp->VAL_CQ5)
					nItem += cArqTmp->VAL_CQ5
				Endif
				If Empty(cArqTmp->ITEM) .and. !Empty(cArqTmp->CUSTO) .and. !Empty(cArqTmp->VAL_CQ3) .and. !Empty(nItem)
					cArqTmp->(RecLock("cArqTmp",.F.))
					cArqTmp->VAL_CQ3 := cArqTmp->VAL_CQ3-nItem
					cArqTmp->(MsUnLock())
				Endif	
				// ccusto sem item
				If Empty(cArqTmp->ITEM) .and. !Empty(cArqTmp->CUSTO) .and. !Empty(cArqTmp->VAL_CQ3) .and. Empty(nItem)
					nCusto += cArqTmp->VAL_CQ3
				Endif	
	
				cArqTmp->(dbSkip(-1))
			Enddo
			
			If !cConta == cArqTmp->CONTA
				Loop
			Endif	
			 
			// ccusto sem item
			If !Empty(cArqTmp->CUSTO) .and. !cArqTmp->CUSTO == cCusto .and. Empty(cArqTmp->ITEM)
				nCusto += cArqTmp->VAL_CQ3
			Endif	
	        
			nCustoTot += nCusto
			nItemTot += nItem
			cCusto := 0
			nCusto := 0
			nItem := 0

			If Empty(cArqTmp->ITEM) .and. Empty(cArqTmp->CUSTO) .and. !Empty(cArqTmp->CONTA) .and. !Empty(cArqTmp->VAL_CQ1) .and. (!Empty(nCustoTot) .or. !Empty(nItemTot))
				cArqTmp->(RecLock("cArqTmp",.F.))
				cArqTmp->VAL_CQ1 := cArqTmp->VAL_CQ1-nCustoTot-nItemTot
				cArqTmp->(MsUnLock())
			Endif	
		Enddo			
	Endif
Enddo

dbGotop()

aEval(aArea,{|x| RestArea(x)})

Return()