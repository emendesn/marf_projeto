#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
=====================================================================================
Programa............: MGFFATAB
Autor...............: Totvs
Data................: Outubro/2018
Descricao / Objetivo: FAT
Doc. Origem.........: FAT
Solicitante.........: Cliente
Uso.................: 
Obs.................: Rotina chamada pelo PE M410TOK
=====================================================================================
*/
User Function MGFFATAB()

Local aArea := {GetArea()}
Local lRet := .T.	
Local nCnt := 0
Local nSav := n
Local aDadosCfo := {}
Local cTes := ""
Local cCfo := ""
Local cOper := ""

If IsInCallStack("A410Copia")
	For nCnt := 1 To Len(aCols)
		If !gdDeleted(nCnt)
			If !Empty(gdFieldGet("C6_OPER",nCnt)) // pega primeiro a operacao do item
				cOper := gdFieldGet("C6_OPER",nCnt)
			Elseif !Empty(M->C5_ZTPOPER)
				cOper := M->C5_ZTPOPER
			Endif	
			If !Empty(cOper)
				n := nCnt
				aDadosCfo := {}
				cTes := ""
				cCfo := ""
				cTes := MaTesInt(2,cOper,M->C5_CLIENT,M->C5_LOJAENT,If(M->C5_TIPO$'DB',"F","C"),gdFieldGet("C6_PRODUTO",nCnt),"C6_TES")
				gdFieldPut("C6_TES",cTes,nCnt)
				If !Empty(cTes)
					Aadd(aDadosCfo,{"OPERNF","S"})
					Aadd(aDadosCfo,{"TPCLIFOR",GetAdvFVal("SA1","A1_TIPO",xFilial("SA1")+M->C5_CLIENT+M->C5_LOJAENT,1,"")})
					Aadd(aDadosCfo,{"UFDEST",GetAdvFVal("SA1","A1_EST",xFilial("SA1")+M->C5_CLIENT+M->C5_LOJAENT,1,"")})
					cCfo := MaFisCfo(,GetAdvFVal("SF4","F4_CF",xFilial("SF4")+cTes,1,""),aDadosCfo)
					If Len(Alltrim(cCfo)) < 4
						cCfo := ""
					Endif	
					gdFieldPut("C6_CF",cCfo,nCnt)
					gdFieldPut("C6_CLASFIS",CodSitTri(),nCnt)
					gdFieldPut("C6_CODLAN",GetAdvFVal("SF4","F4_CODLAN",xFilial("SF4")+cTes,1,""),nCnt)
				Else
					lRet := .F.
					APMsgAlert("TES nao encontrado para este tipo de operacao. Item: "+gdFieldGet("C6_ITEM",nCnt))
					Exit
				Endif	
			Endif
		Endif	
	Next
		
	If Type('oGetDad:oBrowse')<>"U"
		oGetDad:oBrowse:Refresh()
	Endif
Endif
				
n := nSav

aEval(aArea,{|x| RestArea(x)})

Return(lRet)