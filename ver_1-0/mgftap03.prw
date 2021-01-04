#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFTAP03
Chamada de execauto para Mata650 Ordens de Produção 

@author Atilio Amarilla
@since 12/11/2016 
@type Função  
/*/   
User Function MGFTAP03( aParam )

Local aMata650	:= {}
Local nOpc		:= 3
Local _lretloc := .T.
Local dDatIni	:= Date()
Local cHorIni	:= Time()
Local cHorOrd, nI, nX
Local cAcao		:= aParam[1]
Local aRotThread:= aParam[2]
Local cArqThr	:= aParam[3]
Local cDirLog	:= aParam[4]
Local cIdProc	:= aParam[5]
Local _cuuid	:= aParam[7]
Local _nRecno   := aParam[8]
Local aErro, cErro, cArqLog
Local cFilOrd, dDatOrd, cNumOrd, cCodPro, nQtdOrd, cTpOrd, cNumLot
Local cCodInt, cCodTpInt
Local aTables	:= { "SB1" , "SB2" , "SM0" , "SC2" , "ZZE" }
Local cFunName	:= "MGFTAP03"
Local lRet		:= .T.

SetFunName(cFunName)

cCodInt		:= GetMv("MGF_TAP03A",,"001") // Taura Produção
cCodTpInt	:= GetMv("MGF_TAP03B",,"003") // Inclusão OP

private lMsHelpAuto     := .T.
private lMsErroAuto     := .F.
private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros

Private cError

BEGIN SEQUENCE

For nI := 1 to Len( aRotThread )
	
	aRotAuto	:= aRotThread[nI]
	
	cFilOrd	:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "C2_FILIAL"})][2]
	dDatOrd	:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "C2_DATPRI"})][2]
	cNumOrd	:= 	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "C2_NUM"})][2]+;
				aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "C2_ITEM"})][2]+;
				aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "C2_SEQUEN"})][2]
	cCodPro	:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "C2_PRODUTO"})][2]
	nQtdOrd	:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "C2_QUANT"})][2]
	cTpOrd	:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "__ZTPOP"})][2]
	
	
	SB1->( dbSeek( xFilial("SB1")+cCodPro ) )
	
	If SB1->B1_RASTRO $ "LS" .And. aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "C2_LOTECTL"}) > 0
		cNumLot	:=	aRotAuto[aScan(aRotAuto,{|aAux|alltrim(aAux[1]) == "C2_LOETCTL"})][2]
	Else
		cNumLot	:=	""
	EndIf
		
	cFilAnt		:= cFilOrd
	dDataBase	:= dDatOrd
	
	lMsHelpAuto := .T.
	lMsErroAuto := .F.
	
	lMsBlq			:= .F.
	If SB1->B1_MSBLQL == '1'
		RecLock("SB1",.F.)
		SB1->B1_MSBLQL	:= '2'
		SB1->( msUnlock() )
		lMsBlq			:= .T.
	Else
		lMsBlq			:= .F.
	EndIf
		
	msExecAuto({|x,Y| Mata650(x,Y)},aRotAuto,nOpc)
	
	If lMsBlq
		RecLock("SB1",.F.)
		SB1->B1_MSBLQL	:= '1'
		SB1->( msUnlock() )
	EndIf
	
	cHorOrd	:= Time()
	cErro := ""

	If lMsErroAuto .Or. Empty(  GetAdvFVal("SC2","C2_NUM", xFilial("SC2")+cNumOrd,1,"" ) )
		
		cStatus := "2"
		
		cErro := ""
		cErro += FunName() +" - ExecAuto Mata650" + CRLF
		
		cErro += "Id Proc - "+ cIdProc + CRLF
		cErro += "Filial  - "+ cFilOrd + CRLF
		cErro += "Ordem   - "+ cNumOrd + CRLF
		cErro += "Produto - "+ cCodPro + CRLF
		cErro += "Data    - " + DTOC(dDatOrd) + CRLF
		cErro += " " + CRLF
		
		aErro := GetAutoGRLog() // Retorna erro em array

		for nX := 1 to len(aErro)
			cErro += aErro[nX] + CRLF
		next nX
		
		cDocOri	:= cIdProc
		
	Else
		
		cStatus := "1"
		cErro	:= "Fil/OP/Prod "+cFilOrd + "/" + cNumOrd + "/" + cNumOrd + "/" + cCodPro
		cDocOri	:= cNumOrd
		
	EndIf
	
	If cStatus == "2"
		cHorOrd	:= Time()
		cTempo	:= ElapTime(cHorIni,cHorOrd)
	EndIf

Next nI

END SEQUENCE                               

Return _lretloc
