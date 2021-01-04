#include "protheus.ch"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*
=====================================================================================
Programa.:              MGFCOM52
Autor....:              TOTVS
Data.....:              Nov/2017
Descricao / Objetivo:   Funcao chamada pelo ponto de entrada MT120TEL
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
User Function MGFCOM52()

Local aArea := {SA2->(GetArea()),GetArea()}
Local oDlg := ParamIxb[1]
Local aPosGet := ParamIxb[2]
Local aObj := ParamIxb[3]
Local nOpcx := ParamIxb[4]
Local nReg := ParamIxb[5]
Local lEdit := .F.
Local cCnpjMar := ""
Local oCnpjMar := Nil
Local nCol := 120
Local nPulo := 45
Local oSolic := Nil
//Local cCompra := ""
//Local oCompra := Nil
//Local nCompr 		:= GetAdvFVal("SY1","Y1_COD",xFilial("SY1")+RetCodUsr(),3,"")
Public cSolic := ""
Public nCompr := GetAdvFVal("SY1","Y1_COD",xFilial("SY1")+RetCodUsr(),3,"")
Public oCompr := Nil

Public cCompr		:= PADR(GetAdvFVal("SY1","Y1_NOME",xFilial("SY1")+nCompr,1,""),15)
Public cCompra := ""
Public oCompra := Nil

If Type("__cCnpjFor")  == "U"                                                            
	Public __cCnpjFor := ""
	Public __oCnpjFor := Nil
	Public __cContFor := ""
	Public __oContFor := Nil
Else
	__cCnpjFor := ""
	__oCnpjFor := Nil                                                                    
	__cContFor := ""
	__oContFor := Nil
EndIf

If nOpcx = 3 //.or. nOpcx = 4 alterado Rafael 21/11/2018
	__cCnpjFor := Space(TamSX3("A2_CGC")[1])
	__cContFor := Space(TamSX3("A2_CONTATO")[1])
	cCnpjMar := GetAdvFVal("SM0","M0_CGC",FWGrpCompany()+cFilAnt,1,"")
	//cSolic := Space(TamSX3("C1_SOLICIT")[1])	
	//cCompra := Space(TamSX3("Y1_NOME")[1])
	cSolic := GetAdvFVal("SC1","C1_SOLICIT",xFilial("SC1")+SC7->(C7_NUMSC+C7_ITEMSC),1,"")
//	cCompra := GetAdvFVal("SY1","Y1_NOME",xFilial("SY1")+SC7->C7_COMPRA,1,""),GetAdvFVal("SY1","Y1_NOME",xFilial("SY1")+GetAdvFVal("SC1","C1_CODCOMP",xFilial("SC1")+SC7->(C7_NUMSC+C7_ITEMSC),1,""),1,""))
	cCompra := cCompr
Else
	__cCnpjFor := GetAdvFVal("SA2","A2_CGC",xFilial("SA2")+cA120Forn+cA120Loj,1,"")
	__cContFor := GetAdvFVal("SA2","A2_CONTATO",xFilial("SA2")+cA120Forn+cA120Loj,1,"")
	cCnpjMar := GetAdvFVal("SM0","M0_CGC",FWGrpCompany()+cFilAnt,1,"")
	cSolic := GetAdvFVal("SC1","C1_SOLICIT",xFilial("SC1")+SC7->(C7_NUMSC+C7_ITEMSC),1,"")
   	//nCompr  := IIf(!Empty(SC7->C7_COMPRA),GetAdvFVal("SY1","Y1_COD",xFilial("SY1")+SC7->C7_COMPRA,1,""),GetAdvFVal("SY1","Y1_CODE",xFilial("SY1")+GetAdvFVal("SC1","C1_CODCOMP",xFilial("SC1")+SC7->(C7_NUMSC+C7_ITEMSC),1,""),1,""))
	//cCompra := IIf(!Empty(SC7->C7_COMPRA),GetAdvFVal("SY1","Y1_NOME",xFilial("SY1")+SC7->C7_COMPRA,1,""),GetAdvFVal("SY1","Y1_NOME",xFilial("SY1")+GetAdvFVal("SC1","C1_CODCOMP",xFilial("SC1")+SC7->(C7_NUMSC+C7_ITEMSC),1,""),1,""))
   	nCompr  := GetAdvFVal("SY1","Y1_COD",xFilial("SY1")+SC7->C7_COMPRA,1,"")
	cCompra := GetAdvFVal("SY1","Y1_NOME",xFilial("SY1")+SC7->C7_COMPRA,1,"")
EndIf

//If nOpcx == 3 .or. nOpcx == 4 .or. nOpcx == 6
//	lEdit := .T.
//EndIf

@ 74,aPosGet[1,1]+nCol SAY Alltrim(GetSx3Cache("A2_CGC" , "X3_TITULO"))+" Forn." OF oDlg PIXEL SIZE 060,009 											
@ 73,aPosGet[1,1]+nCol+nPulo-5 MSGET __oCnpjFor VAR __cCnpjFor Picture(IIf(Len(Alltrim(GetAdvFVal("SA2","A2_CGC",xFilial("SA2")+cA120Forn+cA120Loj,1,"")))==11,"@R 999.999.999-99","@R 99.999.999/9999-99")) WHEN lEdit OF oDlg PIXEL SIZE 055,010

@ 74,aPosGet[1,1]+nCol+(nPulo*2)+10 SAY Alltrim(GetSx3Cache("A2_CGC" , "X3_TITULO"))+" Marfrig" OF oDlg PIXEL SIZE 060,009 											
@ 73,aPosGet[1,1]+nCol+(nPulo*3)+10 MSGET oCnpjMar VAR cCnpjMar Picture("@R 99.999.999/9999-99") WHEN lEdit OF oDlg PIXEL SIZE 055,010

@ 74,aPosGet[1,1]+nCol+(nPulo*5)-20 SAY Alltrim(GetSx3Cache("A2_CONTATO" , "X3_TITULO"))+" Forn" OF oDlg PIXEL SIZE 060,009 											
@ 73,aPosGet[1,1]+nCol+(nPulo*6)-30 MSGET __oContFor VAR __cContFor Picture("@!") WHEN lEdit OF oDlg PIXEL SIZE 060,010

@ 74,aPosGet[1,1]+nCol+(nPulo*7)-10 SAY Alltrim(GetSx3Cache("C1_SOLICIT" , "X3_TITULO")) OF oDlg PIXEL SIZE 060,009 											
@ 73,aPosGet[1,1]+nCol+(nPulo*8)-25 MSGET oSolic VAR cSolic Picture("@!") WHEN lEdit OF oDlg PIXEL SIZE 060,010

@ 74,aPosGet[1,1]+nCol+(nPulo*9) SAY "Comprador " OF oDlg PIXEL SIZE 060,009 //*Alltrim(GetSx3Cache("Y1_NOME" , "X3_TITULO")) 											
@ 73,aPosGet[1,1]+nCol+(nPulo*9.9)-10 MSGET oCompr VAR nCompr Picture("@!") WHEN lEdit OF oDlg PIXEL SIZE 020,010 //era 10 em 10.5
@ 73,aPosGet[1,1]+nCol+(nPulo*10.3)-10 MSGET oCompra VAR cCompra Picture("@!") WHEN lEdit OF oDlg PIXEL SIZE 060,010

aEval(aArea,{|x| RestArea(x)})

Return
