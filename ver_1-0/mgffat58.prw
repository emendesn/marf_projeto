#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFFAT58
Autor...............: Mauricio Gresele
Data................: Nov/2017
Descricao / Objetivo: Rotina para preencher o TES a partir do tipo de operacao
Doc. Origem.........: Protheus
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/
User Function MGFFAT58()
/*
//Rotina chamada no campo C5_ZTPOPER, no X3_VLDUSER
Local lRet := .T.
Local nCnt := 0
Local aDadosCfo := {}
Local cTes := ""
Local cCfo := ""

If !Empty(M->C5_ZTPOPER) .and. M->C5_ZTPOPER < "A"
	lRet := .F.
	APMsgStop("Tipo de Operacao deve ser de Saida.")
Endif

If lRet .and. !Empty(M->C5_ZTPOPER)
	For nCnt:=1 To Len(aCols)
		If !gdDeleted(nCnt)
			aDadosCfo := {}
			cTes := ""
			cCfo := ""
			//gdFieldPut("C6_TES",MaTesInt(2,,M->C5_CLIENT,M->C5_LOJAENT,If(M->C5_TIPO$'DB',"F","C"),gdFieldGet("C6_PRODUTO",nCnt),"C6_TES"),nCnt)
			gdFieldPut("C6_OPER",M->C5_ZTPOPER,nCnt)
			cTes := MaTesInt(2,,M->C5_CLIENT,M->C5_LOJAENT,If(M->C5_TIPO$'DB',"F","C"),gdFieldGet("C6_PRODUTO",nCnt),"C6_TES")
			gdFieldPut("C6_TES",cTes,nCnt)
			Aadd(aDadosCfo,{"OPERNF","S"})
			Aadd(aDadosCfo,{"TPCLIFOR",GetAdvFVal("SA1","A1_TIPO",xFilial("SA1")+M->C5_CLIENT+M->C5_LOJAENT,1,"")})
			Aadd(aDadosCfo,{"UFDEST",GetAdvFVal("SA1","A1_EST",xFilial("SA1")+M->C5_CLIENT+M->C5_LOJAENT,1,"")})
			cCfo := MaFisCfo(,GetAdvFVal("SF4","F4_CF",xFilial("SF4")+cTes,1,""),aDadosCfo)
			If Len(Alltrim(cCfo)) < 4
				cCfo := ""
			Endif	
			gdFieldPut("C6_CF",cCfo,nCnt)
			//If ExistTrigger("C6_OPER")
			//	RunTrigger(2,nCnt)
			//EndIf
		Endif
	Next
	
	If Type('oGetDad:oBrowse')<>"U"
		oGetDad:oBrowse:Refresh()
	Endif
Endif

Return(lRet)
*/

//Rotina chamada no gatilho do campo C6_PRODUTO
/*
OBS: gatilhos necessarios para este GAP funcionar

CAMPO: C6_PRODUTO
SEQ: xxx
CNT. DOMINIO: C6_OPER
TIPO: PRIMARIO
REGRA: M->C5_ZTPOPER                                                                                       
POSICIONA: NAO

CAMPO: C6_PRODUTO
SEQ: xxx
CNT. DOMINIO: C6_PRODUTO
TIPO: PRIMARIO
REGRA: U_MGFFAT58()
POSICIONA: NAO
*/
Local cRet := M->C6_PRODUTO
Local cTes := CriaVar("C6_TES")
Local cCfo := CriaVar("C6_CF")
Local cCodLan := CriaVar("C6_CODLAN")
//Local aDadosCfo := {}
Local cClasFis := CriaVar("C6_CLASFIS")

if alltrim(M->C5_ZTPOPER)<>""
	cTes := MaTesInt(2,M->C5_ZTPOPER,M->C5_CLIENT,M->C5_LOJAENT,If(M->C5_TIPO$'DB',"F","C"),M->C6_PRODUTO,"C6_TES") 
	gdFieldPut("C6_TES",cTes)
endif

/*
Aadd(aDadosCfo,{"OPERNF","S"})
Aadd(aDadosCfo,{"TPCLIFOR",GetAdvFVal("SA1","A1_TIPO",xFilial("SA1")+M->C5_CLIENT+M->C5_LOJAENT,1,"")})
Aadd(aDadosCfo,{"UFDEST",GetAdvFVal("SA1","A1_EST",xFilial("SA1")+M->C5_CLIENT+M->C5_LOJAENT,1,"")})
cCfo := MaFisCfo(,GetAdvFVal("SF4","F4_CF",xFilial("SF4")+cTes,1,""),aDadosCfo)
If Len(Alltrim(cCfo)) < 4
	cCfo := CriaVar("C6_CF")
Endif	
gdFieldPut("C6_CF",cCfo)
*/
If !Empty(cTes)
	cClasFis := CodSitTri()
	gdFieldPut("C6_CLASFIS",cClasFis)
	cCodLan := GetAdvFVal("SF4","F4_CODLAN",xFilial("SF4")+cTes,1,"")
	gdFieldPut("C6_CCODLAN",cCodLan)
Endif	

If Type('oGetDad:oBrowse')<>"U"
	oGetDad:oBrowse:Refresh()
Endif

Return(cRet)