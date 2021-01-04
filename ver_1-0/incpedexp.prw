#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

User Function IncPedExp(aCabec,aItens)

aParamBox := {}
aRet := {}

AAdd(aParamBox, {1, "PEDIDO"			, Space(tamSx3("EE7_PEDIDO")[1])																							, PesqPict("EE7","EE7_PEDIDO")	, ,      	,	, 070	, .F.	})
AAdd(aParamBox, {1, "FILIAL"			, Space(6)																													, "@!"							, ,       	,	, 070	, .F.	})

IF !ParamBox(aParambox, "PARAMETROS"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
	Return()
Endif

aRet := {}
//aRet := StartJob("U__IncPedExp",GetEnvServer(),.T.,mv_par01,mv_par02)
aRet := U__IncPedExp(mv_par01,mv_par02)

If !aRet[1]
	MsgStop(aRet[2])
Endif

Return()

User Function _IncPedExp(par01,par02)

Local lExecAuto := .t.//GetMv("MGF_EEC13E",,.T.)
Local lRet := .F.
Local nI := 0
Local nY := 0
Local aCab := {}
Local aIt := {}
Local nPosPed := 0
Local aRet := {.F.,""}
Local cRet := ""
Local cSeq := ""

Private lMsHelpAuto := .T. // Determina se as mensagens de help devem ser direcionadas para o arq. de log
Private lMsErroAuto := .F. // Determina se houve alguma inconsistência na execução da rotina
Private lEE7Auto := .T.
Private lSched	:= .T.

nModulo := 29
cModulo := "EEC"

//RpcSetType(3)
//PREPARE ENVIRONMENT EMPRESA "01" FILIAL par02 MODULO "EEC" TABLES "EE7","EE8"

cPed := par01//"EXP00110017         "//GetSxeNum("EE7","EE7_PEDIDO")
cFIL := par02//"020001"
cFilAnt := par02

EE7->(dbSetOrder(1))
If EE7->(dbSeek(cFil+cPed)) 
/*
	aCab := {;
	{'EE7_PEDIDO' 	,EE7->EE7_PEDIDO ,NIL},; //
	{'EE7_CALCEM' 	,EE7->EE7_CALCEM ,NIL},; //
	{'EE7_IMPORT' 	,EE7->EE7_IMPORT ,NIL},;
	{'EE7_IMLOJA' 	,EE7->EE7_IMLOJA ,NIL},;
	{'EE7_IMPODE' 	,EE7->EE7_IMPODE ,NIL},;
	{'EE7_FORN' 	,EE7->EE7_FORN ,NIL},;
	{'EE7_FOLOJA' 	,EE7->EE7_FOLOJA ,NIL},;
	{'EE7_CONDPA' 	,EE7->EE7_CONDPA ,NIL},;
	{'EE7_DIASPA' 	,EE7->EE7_DIASPA ,NIL},;
	{'EE7_MPGEXP' 	,EE7->EE7_MPGEXP ,NIL},;
	{'EE7_INCOTE' 	,EE7->EE7_INCOTE ,NIL},;
	{'EE7_MOEDA' 	,EE7->EE7_MOEDA ,NIL},;
	{'EE7_FRPPCC' 	,EE7->EE7_FRPPCC ,NIL},;
	{'EE7_VIA' 		,EE7->EE7_VIA ,NIL},;
	{'EE7_ORIGEM' 	,EE7->EE7_ORIGEM ,NIL},;
	{'EE7_DEST' 	,EE7->EE7_DEST ,NIL},;
	{'EE7_PAISET' 	,EE7->EE7_PAISET ,NIL},;
	{'EE7_IDIOMA' 	,EE7->EE7_IDIOMA ,NIL},;
	{'EE7_TIPTRA' 	,EE7->EE7_TIPTRA ,NIL},;
	{'EE7_TPDESC' 	,EE7->EE7_TPDESC ,NIL},;
	{'EE7_CODBOL' 	,EE7->EE7_CODBOL,NIL}}
*/
	aCab := ArraySX3("EE7",.F.)
Endif
//{'EE7_FILIAL' ,xFilial("EE7") ,NIL},;
//{'EE7_CODBOL' ,"NY" ,NIL},; //

EE8->(dbSetOrder(1))
If EE8->(dbSeek(cFil+cPed))
	While EE8->(!Eof()) .and. cFil+cPed == EE8->EE8_FILIAL+EE8->EE8_PEDIDO
		
		aItem := ArraySX3("EE8",.F.,cFil,cPed,@cSeq)
		aAdd(aIt,aClone(aItem))
		//cSeq := '     2'
		/*
		cSeq := EE8->EE8_SEQUEN
		
		aAdd(aIt,{;
		{'LINPOS' 		,EE8->EE8_SEQUEN , cSeq},;
		{'EE8_PEDIDO' 	,EE8->EE8_PEDIDO , NIL},;
		{'EE8_SEQUEN' 	,cSeq , NIL},;
		{'EE8_COD_I' 	,EE8->EE8_COD_I , NIL},;
		{'EE8_VM_DES' ,'CANNED CORNED BEEF 12/340G' , NIL},;
		{'EE8_FORN' 	,EE8->EE8_FORN , NIL},;
		{'EE8_SLDINI' 	,EE8->EE8_SLDINI, NIL},;
		{'EE8_EMBAL1' 	,EE8->EE8_EMBAL1 , NIL},;
		{'EE8_UNIDAD' 	,EE8->EE8_UNIDAD , NIL},;
		{'EE8_QE' 		,EE8->EE8_QE , NIL},;
		{'EE8_PSLQUN' 	,EE8->EE8_PSLQUN , NIL},;
		{'EE8_POSIPI' 	,EE8->EE8_POSIPI   , NIL},;
		{'EE8_PRECO' 	,EE8->EE8_PRECO, NIL},;
		{'EE8_TES' 		,EE8->EE8_TES , NIL},;
		{'EE8_CF' 		,EE8->EE8_CF , NIL},;
		{'EE8_ZQTDSI' 	,EE8->EE8_ZQTDSI , NIL},;
		{'EE8_ZGERSI' 	,EE8->EE8_ZGERSI , NIL},;
		{'EE8_FATIT' 	,EE8->EE8_FATIT , NIL},;
		{'AUTDELETA' 	,"N" , NIL},;
		{'EE8_PRENEG' 	,EE8->EE8_PRENEG , NIL},;
		{'EE8_SLDATU' 	,EE8->EE8_SLDATU, NIL},;
		{'EE8_QTDEM1' 	,EE8->EE8_QTDEM1 , NIL},;
		{'EE8_PART_N' 	,EE8->EE8_PART_N , NIL},;
		{'EE8_DESC' 	,EE8->EE8_DESC , NIL},;
		{'EE8_FOLOJA' 	,EE8->EE8_FOLOJA , NIL},;
		{'EE8_PRCINC' 	,EE8->EE8_PRCINC , NIL},;//
		{'EE8_PRCTOT' 	,EE8->EE8_PRCTOT , NIL};//
		})
		*/
		//{'EE8_VM_DES' ,'CANNED CORNED BEEF 12/340G' , NIL},;
		//{'EE8_PRCINC' , 10 , NIL},;//
		//{'EE8_PRCTOT' , 90 , NIL},;//
		//{'EE8_QTDEM1' , 9 , NIL},;//
		//{'EE8_UNIDAD' , "KG" , NIL},;
		//{'AUTDELETA' , "N" , NIL};

		aItem := ArraySX3("EE8",.T.,cFil,cPed,@cSeq)
		aAdd(aIt,aClone(aItem))
		/*
		cSeq := Seq(cFil,cPed)
		aAdd(aIt,{;
		{'LINPOS' 		,EE8->EE8_SEQUEN , cSeq},;
		{'EE8_PEDIDO' 	,EE8->EE8_PEDIDO , NIL},;
		{'EE8_SEQUEN' 	,cSeq , NIL},;
		{'EE8_COD_I' 	,EE8->EE8_COD_I , NIL},;
		{'EE8_VM_DES' ,'CANNED CORNED BEEF 12/340G' , NIL},;
		{'EE8_FORN' 	,EE8->EE8_FORN , NIL},;
		{'EE8_SLDINI' 	,EE8->EE8_SLDINI, NIL},;
		{'EE8_EMBAL1' 	,EE8->EE8_EMBAL1 , NIL},;
		{'EE8_UNIDAD' 	,EE8->EE8_UNIDAD , NIL},;
		{'EE8_QE' 		,EE8->EE8_QE , NIL},;
		{'EE8_PSLQUN' 	,EE8->EE8_PSLQUN , NIL},;
		{'EE8_POSIPI' 	,EE8->EE8_POSIPI   , NIL},;
		{'EE8_PRECO' 	,EE8->EE8_PRECO, NIL},;
		{'EE8_TES' 		,EE8->EE8_TES , NIL},;
		{'EE8_CF' 		,EE8->EE8_CF , NIL},;
		{'EE8_ZQTDSI' 	,EE8->EE8_ZQTDSI , NIL},;
		{'EE8_ZGERSI' 	,EE8->EE8_ZGERSI , NIL},;
		{'EE8_FATIT' 	,EE8->EE8_FATIT , NIL},;
		{'AUTDELETA' 	,"N" , NIL},;
		{'EE8_PRENEG' 	,EE8->EE8_PRENEG , NIL},;
		{'EE8_SLDATU' 	,EE8->EE8_SLDATU, NIL},;
		{'EE8_QTDEM1' 	,EE8->EE8_QTDEM1 , NIL},;
		{'EE8_PART_N' 	,EE8->EE8_PART_N , NIL},;
		{'EE8_DESC' 	,EE8->EE8_DESC , NIL},;
		{'EE8_FOLOJA' 	,EE8->EE8_FOLOJA , NIL},;
		{'EE8_PRCINC' 	,EE8->EE8_PRCINC , NIL},;//
		{'EE8_PRCTOT' 	,EE8->EE8_PRCTOT , NIL};//
		})
		*/

		EE8->(dbSkip())
	Enddo
Endif


/*
cSeq := '     3'
aAdd(aIt,{;
{'LINPOS' ,'EE8_SEQUEN' , cSeq},;
{'EE8_PEDIDO' ,cPed , NIL},;
{'EE8_SEQUEN' ,cSeq , NIL},;
{'EE8_COD_I' ,'302209         ' , NIL},;
{'EE8_VM_DES' ,'CARNE BOVINA COZIDA EM CONSERVA (CORNED BEEF) 24X3' , NIL},;
{'EE8_FORN' ,'001441' , NIL},;
{'EE8_FOLOJA' ,'01' , NIL},;
{'EE8_SLDINI' ,5000, NIL},;
{'EE8_EMBAL1' , 'BJ' , NIL},;
{'EE8_UNIDAD' , "BJ" , NIL},;
{'EE8_QE' , 1 , NIL},;
{'EE8_PSLQUN' ,4.0800000 , NIL},;
{'EE8_POSIPI' , "01029090  " , NIL},;
{'EE8_PRECO' ,15.689322 , NIL},;
{'EE8_TES' , "846" , NIL},;
{'EE8_CF' , "7101" , NIL},;
{'EE8_ZQTDSI' , 0 , NIL},;
{'EE8_ZGERSI' , "" , NIL},;
{'EE8_FATIT' , "03" , NIL},;
{'AUTDELETA' , "N" , NIL},;
{'EE8_PRENEG' , 1 , NIL};
})


//{'EE8_PRCINC' , 10 , NIL},;//
//{'EE8_PRCTOT' , 90 , NIL},;//
//{'EE8_QTDEM1' , 9 , NIL},;//
//{'EE8_TES' , "501" , NIL},;//
//{'EE8_CF' , "7101" , NIL},;//
//{'EE8_UNIDAD' , "KG" , NIL},;
//{'AUTDELETA' , "N" , NIL};

//{'EE8_FILIAL' ,xFilial("EE8") , NIL},;

cSeq := '     4'
aAdd(aIt,{;
{'LINPOS' ,'EE8_SEQUEN' , cSeq},;
{'EE8_PEDIDO' ,cPed , NIL},;
{'EE8_SEQUEN' ,cSeq , NIL},;
{'EE8_COD_I' ,'302209         ' , NIL},;
{'EE8_VM_DES' ,'CARNE BOVINA COZIDA EM CONSERVA (CORNED BEEF) 24X3' , NIL},;
{'EE8_FORN' ,'001441' , NIL},;
{'EE8_FOLOJA' ,'01' , NIL},;
{'EE8_SLDINI' ,6000, NIL},;
{'EE8_EMBAL1' , 'BJ' , NIL},;
{'EE8_UNIDAD' , "BJ" , NIL},;
{'EE8_QE' , 1 , NIL},;
{'EE8_PSLQUN' ,4.0800000 , NIL},;
{'EE8_POSIPI' , "01029090  " , NIL},;
{'EE8_PRECO' ,15.689322 , NIL},;
{'EE8_TES' , "846" , NIL},;
{'EE8_CF' , "7101" , NIL},;
{'EE8_ZQTDSI' , 0 , NIL},;
{'EE8_ZGERSI' , "" , NIL},;
{'EE8_FATIT' , "" , NIL},;
{'AUTDELETA' , "N" , NIL},;
{'EE8_PRENEG' , 1 , NIL};
})

cSeq := '     5'
aAdd(aIt,{;
{'LINPOS' ,'EE8_SEQUEN' , cSeq},;
{'EE8_PEDIDO' ,cPed , NIL},;
{'EE8_SEQUEN' ,cSeq , NIL},;
{'EE8_COD_I' ,'302207         ' , NIL},;
{'EE8_VM_DES' ,'CANNED CORNED BEEF 12/340G' , NIL},;
{'EE8_FORN' ,'001441' , NIL},;
{'EE8_SLDINI' ,8000, NIL},;
{'EE8_EMBAL1' , 'BJ' , NIL},;
{'EE8_UNIDAD' , "BJ" , NIL},;
{'EE8_QE' , 1 , NIL},;
{'EE8_PSLQUN' , 1 , NIL},;
{'EE8_POSIPI' , "16025000  " , NIL},;
{'EE8_PRECO' ,0.952600, NIL},;
{'EE8_TES' , "846" , NIL},;
{'EE8_CF' , "7101" , NIL},;
{'EE8_ZQTDSI' , 0 , NIL},;
{'EE8_ZGERSI' , "" , NIL},;
{'EE8_FATIT' , "" , NIL},;
{'AUTDELETA' , "N" , NIL},;
{'EE8_PRENEG' , 1 , NIL};
})
*/

dbselectarea("EE7")
dbselectarea("EE8")

If lExecAuto  

	CTIME1:=TIME()

	conout("entrou auto eec")
	conout("len itens: "+str(len(aIt)))
	conout("funname: "+funname())
	
	MSExecAuto( {|X,Y,Z| EECAP100(X,Y,Z)},aCab ,aIt, 4)

	CTIME2:=TIME()
	CONOUT("TEMPO EXECAUTO: "+ELAPTIME(CTIME1,CTIME2)+CRLF)
	
	conout("saiu auto eec")
	
	conout("lMsErroAuto eec: "+iif(lMsErroAuto,".t.",".f."))
	
	If lMsErroAuto
		lRet := .F.
		//MostraErro()
		cFileLog := NomeAutoLog()
		If !Empty(cFileLog)
			cRet := MemoRead(cFileLog)
			conout(cRet)
		Endif
	Else
		lRet := .T.
	EndIf
Else
	Begin Transaction
	RecLock("EE7",.T.)
	For nI := 1 To Len(aCabec)
		&("EE7->"+aCabec[nI][1]) := aCabec[nI][2]
	Next nI
	EE7->(MsUnlock())
	For nI := 1 To Len(aItens)
		RecLock("EE8",.T.)
		For nY := 1 to Len(aItens[nI])
			&("EE8->"+aItens[nI][nY][1]) := aItens[nI][nY][2]
		Next nY
		EE8->(MsUnlock())
	Next nI
	End Transaction
	lRet := .T.
EndIf

aRet := {lRet,cRet}

//RESET ENVIRONMENT

Return(aRet)


Static Function Seq(cFil,cPed,cSeq)

nRecno := EE8->(Recno())
If Empty(cSeq)
	While EE8->(!Eof()) .and. cFil+cPed == EE8->EE8_FILIAL+EE8->EE8_PEDIDO
		cSeq := EE8->EE8_SEQUEN
		EE8->(dbSkip())
	Enddo
Endif	
cSeq1 := Val(cSeq)+1
If Subs(cSeq,1,1) == "0"
	cSeq := Padl(cSeq1,6,"0")
Else
	cSeq := Padl(cSeq1,6," ")
Endif

EE8->(dbGoto(nRecno))

Return(cSeq)


Static Function ArraySX3(cAlias,lItemNovo,cFil,cPed,cSeq)

Local aArea := {SX3->(GetArea()),GetArea()}
Local aRet := {}
//Local aNaoCpos := {"EE8_DTPREM","EE8_DTENTR","EE7_UNIDAD","EE7_CODBOL"} // array com campos para nao serem acrescentados, pois estao dando problema na validacao da rotina automatica
//Local aNaoCpos := {"EE7_FILIAL","EE8_FILIAL","C5_FILIAL","C6_FILIAL"} // adicionado os campos de filial, pois alguns trechos do fonte esperam localizar o campo _ITEM no 1 
//Local aZeraCpos := {"EE8_FATIT","EE8_DESC","EE8_SLDATU","EE8_PSLQTO","EE8_PSBRTO","EE8_DESCON","EE8_VLCOM","EE8_VLFRET","EE8_VLSEGU","EE8_VLOUTR","EE8_VLDESC","EE8_QTDEM1","EE8_PRCTOT","EE8_PRCINC"}
//Local aNaoCpos := {"EE8_SLDATU","EE8_PSLQTO","EE8_PSBRTO","EE8_DESCON","EE8_VLCOM","EE8_VLFRET","EE8_VLSEGU","EE8_VLOUTR","EE8_VLDESC","EE8_QTDEM1","EE8_PRCTOT","EE8_PRCINC"}
Local aNaoCpos := {"EE8_PSLQTO","EE8_PSBRTO","EE8_DESCON","EE8_VLCOM","EE8_VLFRET","EE8_VLSEGU","EE8_VLOUTR","EE8_VLDESC","EE8_QTDEM1","EE8_PRCTOT","EE8_PRCINC"}
//"EE8_FATIT"
Local aZeraCpos := {"EE8_FATIT"}
Local cSeq1 := ""
				
SX3->(dbSetOrder(1))
SX3->(dbSeek(cAlias))
While SX3->(!Eof()) .and. SX3->X3_ARQUIVO == cAlias
	If X3Uso(SX3->X3_USADO) .and. SX3->X3_CONTEXT != "V" .and. aScan(aNaoCpos,Alltrim(SX3->X3_CAMPO)) == 0 .and. SX3->X3_TIPO != "M" 
	//If SX3->X3_CONTEXT != "V" .and. aScan(aNaoCpos,Alltrim(SX3->X3_CAMPO)) == 0 .and. SX3->X3_TIPO != "M" 
		If !Empty(&(cAlias+"->"+SX3->X3_CAMPO))
			If lItemNovo .and. aScan(aZeraCpos,Alltrim(SX3->X3_CAMPO)) > 0
				aAdd(aRet,{Alltrim(SX3->X3_CAMPO),CriaVar(SX3->X3_CAMPO),Nil})			
			Else	
				aAdd(aRet,{Alltrim(SX3->X3_CAMPO),&(cAlias+"->"+SX3->X3_CAMPO),Nil})			
			Endif	
		Endif
	Endif		
	SX3->(dbSkip())
Enddo

If cAlias == "EE8"
	If !lItemNovo
		cSeq1 := EE8->EE8_SEQUEN
	Else
		cSeq1 := Seq(cFil,cPed,@cSeq)
	Endif	
	aAdd(aRet,{"LINPOS","EE8_SEQUEN",cSeq1})
	//aAdd(aRet,{"LINPOS","EE8_COD_I",aRet[aScan(aRet,{|x| Alltrim(x[1])=="EE8_COD_I"})][2]})
	aAdd(aRet,{"AUTDELETA","N",Nil})
	If lItemNovo
		aRet[aScan(aRet,{|x| Alltrim(x[1])=="EE8_SLDINI"})][2] := aRet[aScan(aRet,{|x| Alltrim(x[1])=="EE8_SLDINI"})][2]/2
		aRet[aScan(aRet,{|x| Alltrim(x[1])=="EE8_SEQUEN"})][2] := cSeq1
	Endif	
	conout(cseq1)
Endif

aEval(aArea,{|x| RestArea(x)})

Return(aRet)
