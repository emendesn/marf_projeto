#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"


/*
=====================================================================================
Programa............: MGFCOMA2
Autor...............: Tarcisio Galeano
Data................: 11/2018
Descrição / Objetivo: Não permitir solicitar ao armazem durante o inventario
Doc. Origem.........:
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
user function MGFEST46()

 Local nProd := GDFieldGet("CP_PRODUTO") 
 Local lRet  := nProd
 Local dInv  := .T.


 dInv		:= GetAdvFVal("SB2","B2_DTINV",xFilial("SB2")+nProd,1,"")

 if !empty(dInv)
 	msgalert("O PRODUTO ESTÁ EM INVENTÁRIO, AGUARDAR O DESBLOQUEIO !!!! ")
	lRet := " "
 endif
 
 
Return lRet 


