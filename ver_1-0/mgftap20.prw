#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFTAP20
Chamada de execautos MATA261

@author Marcelo de Almeida Carneiro
@since 18/01/2019 
@type Função  
/*/ 
User Function MGFTAP20( aParami )

Local nI, nX

Local aRotThread:= aParami[1]
Local _cuuid	:= aParami[2]
Local _nrecno	:= aParami[3]
Local cErro		:= ""
Local aErro
Local cNumDoc	:= ""
Local cFilOrd, cCodOrig, nQtd, cCodDest , dEmissao
Local cCodLoc                       
Local aCab      := {}
Local lMsBlq1,lMsBlq2,cChave
Local cUpd      := '' 
Local _lretloc  := .T.

Local cMsgErr	:= ""
Local cFunName	:= "MGFTAP20" // Incluir NomeRotina

SetFunName(cFunName)

private lMsHelpAuto     := .T.
private lMsErroAuto     := .F.
private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros

Private cError
Private cOPTaura        := ''

BEGIN SEQUENCE

For nI := 1 to Len( aRotThread )

	BEGIN TRANSACTION

	cMsgErr	:= ""
	aRotAuto	:= aRotThread[nI]
	cFilOrd	  := aRotAuto[01]
	cCodOrig  := aRotAuto[02]
	cCodDest  := aRotAuto[03]
	nQtd      := aRotAuto[04]
	cCodLoc	  := aRotAuto[05]
    dEmissao  := aRotAuto[06]
	cOPTaura  := aRotAuto[07]
	cIdSeq	  := aRotAuto[08]
	cNumDoc	  := aRotAuto[09]
	cChave    := aRotAuto[10]
	
	SB1->( dbSeek( xFilial("SB1")+cCodDest ) )
	If !SB2->( dbSeek( xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD ) )
		CriaSB2(SB1->B1_COD,SB1->B1_LOCPAD)
	EndIf
	
	cFilAnt		:= cFilOrd
	dDataBase	:= dEmissao
	
	lMsHelpAuto := .T.
	lMsErroAuto := .F.
	

    aCab := {{cNumDoc,dDataBase}}  
	aItem := {}    
                                              
	SB1->( dbSeek( xFilial("SB1")+cCodOrig ) )
	If SB1->B1_MSBLQL == '1'
		RecLock("SB1",.F.)
		SB1->B1_MSBLQL	:= '2'
		SB1->( msUnlock() )
		lMsBlq1			:= .T.
	Else
		lMsBlq1			:= .F.
	EndIf
	
	AAdd(aItem,{"ITEM"      ,'001'       , Nil})
	AAdd(aItem,{"D3_COD"    ,cCodOrig    , Nil}) //D3_COD
	AAdd(aItem,{"D3_DESCRI" ,SB1->B1_DESC, Nil}) //D3_DESCRI
	AAdd(aItem,{"D3_UM"     ,SB1->B1_UM  , Nil}) //D3_UM
	AAdd(aItem,{"D3_LOCAL"  ,cCodLoc     , Nil}) //D3_LOCAL
	AAdd(aItem,{"D3_LOCALIZ",""          , Nil}) //D3_LOCALIZ
		
	SB1->( dbSeek( xFilial("SB1")+cCodDest ) )
	If SB1->B1_MSBLQL == '1'
		RecLock("SB1",.F.)
		SB1->B1_MSBLQL	:= '2'
		SB1->( msUnlock() )
		lMsBlq2			:= .T.
	Else
		lMsBlq2			:= .F.
	EndIf

	AAdd(aItem,{"D3_COD"    ,cCodDest    , Nil}) //D3_COD
	AAdd(aItem,{"D3_DESCRI" ,SB1->B1_DESC, Nil}) //D3_DESCRI
	AAdd(aItem,{"D3_UM"     ,SB1->B1_UM  , Nil}) //D3_UM
	AAdd(aItem,{"D3_LOCAL"  ,cCodLoc     , Nil}) //D3_LOCAL
	AAdd(aItem,{"D3_LOCALIZ",""          , Nil}) //D3_LOCALIZ                                             
	AAdd(aItem,{"D3_NUMSERI",""          , Nil}) //D3_NUMSERI
	AAdd(aItem,{"D3_LOTECTL",CriaVar("D3_LOTECTL",.F.), Nil})   	//D3_LOTECTL
	AAdd(aItem,{"D3_NUMLOTE","      "    , Nil}) //D3_NUMLOTE
	AAdd(aItem,{"D3_DTVALID",CriaVar("D1_DTVALID",.F.), Nil})   	//D3_DTVALID
	AAdd(aItem,{"D3_POTENCI",0           , Nil}) //D3_POTENCI
	AAdd(aItem,{"D3_QUANT"  ,nQtd        , Nil}) //D3_QUANT
	AAdd(aItem,{"D3_QTSEGUM",0           , Nil}) //D3_QTSEGUM
	AAdd(aItem,{"D3_ESTORNO",""          , Nil}) //D3_ESTORNO
	AAdd(aItem,{"D3_NUMSEQ" ,""          , Nil}) //D3_NUMSEQ
	AAdd(aItem,{"D3_LOTECTL",CriaVar("D3_LOTECTL",.F.), Nil})   	//D3_LOTECTL
	AAdd(aItem,{"D3_DTVALID",""          , Nil}) 
	AAdd(aItem,{"D3_ITEMGRD",""          , Nil}) //D3_ITEMGRD
	AAdd(aItem,{"D3_CODLAN" ,""          , Nil}) //CAT 83 Cod. Lanc
	AAdd(aItem,{"D3_CODLAN" ,""          , Nil}) // CAT 83 Cod. Lanc  
	AAdd(aItem,{"D3_OBSERVA","Produzindo Recebendo" , Nil})//D3_OBSERVAC   
	AAdd(aCab,aItem)
	
	MSExecAuto({|x,y| mata261(x,y)},aCab,3)
	 
	If lMsBlq1
		SB1->( dbSeek( xFilial("SB1")+cCodOrig ) )
		RecLock("SB1",.F.)
		SB1->B1_MSBLQL	:= '1'
		SB1->( msUnlock() )
	EndIf
	
	If lMsBlq2
	    SB1->( dbSeek( xFilial("SB1")+cCodDest ) )
		RecLock("SB1",.F.)
		SB1->B1_MSBLQL	:= '1'
		SB1->( msUnlock() )
	EndIf	

	cErro := ""
	If lMsErroAuto .And. Empty(  GetAdvFVal("SD3","D3_DOC", xFilial("SD3")+cNumDoc+cCodOrig,2,"" ) )
		cStatus := "2"
		cMsgErr := "ExecAuto Mata261"
		cErro := ""
		cErro += FunName() +" - ExecAuto Mata261" + CRLF
		cErro += "Filial    - "+ cFilOrd + CRLF
		cErro += "Num.Doc.  - "+ cNumDoc + CRLF
		cErro += "Orig/dest - "+ Alltrim(cCodOrig)+'/'+cCodDest + CRLF
		cErro += "Quant.    - "+ AllTrim(Str(nQtd)) + CRLF
		cErro += "Data      - "+ DTOC(dEmissao) + CRLF
		cErro += "Sequ.     - "+ cIdSeq + CRLF
		cErro += " " + CRLF

		aErro := GetAutoGRLog() // Retorna erro em array
		for nX := 1 to len(aErro)
			cErro += aErro[nX] + CRLF
		next nX
	Else

		cStatus := "1"
		_cteste := posicione("SD3",2, xFilial("SD3")+cNumDoc+cCodOrig,"D3_DOC" )
		//Grava referências na SD3
		Reclock("SD3",.F.)
		SD3->D3_ZCHAVEU := alltrim(_cuuid)
		SD3->(Msunlock())

	EndIf
	
	ZZE->( dbGoTo( _nrecno ) )
			
	RecLock("ZZE",.F.)
	ZZE->ZZE_DOC	:= cNumDoc
	ZZE->ZZE_STATUS	:= cStatus
	ZZE->ZZE_DTPROC	:= DATE()
	ZZE->ZZE_HRPROC	:= TIME()
	ZZE->ZZE_DESCER	:= "["+FunName()+"] "+IIF(cStatus == "1","Ação efetivada.",cMsgErr) 
	ZZE->ZZE_MSGERR	:= cErro

	If cStatus == "1"
		ZZE->ZZE_IDPROC := strzero(SD3->(Recno()),15)
	Endif

	ZZE->( msUnlock() )

	END TRANSACTION
	
Next nI

END SEQUENCE


Return _lretloc

/*/
==============================================================================================================================================================================
{Protheus.doc} TAP20_CP
Chamada de ajuste da SD3 pelo MT261TDOK

@author Marcelo de Almeida Carneiro
@since 18/01/2019 
@type Função  
/*/ 

User Function TAP20_CP                    

cD3_FILIAL := SD3->D3_FILIAL
cD3_DOC	   := SD3->D3_DOC
cD3_NUMSEQ := SD3->D3_NUMSEQ

SD3->(dbSetOrder(8))
SD3->(dbSeek(cD3_FILIAL+cD3_DOC+cD3_NUMSEQ))
While  SD3->(!Eof())               .And.;
	cD3_FILIAL == SD3->D3_FILIAL   .And.;
	cD3_DOC	   == SD3->D3_DOC      .And.;
	cD3_NUMSEQ == SD3->D3_NUMSEQ
	
	Reclock("SD3",.F.)
	SD3->D3_ZOPTAUR := cOPTaura
	SD3->(MsUnlock())
	SD3->(dbSkip())
	
End

Return
