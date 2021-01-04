#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'COLORS.CH'     
  
#define CRLF chr(13) + chr(10)             
/*
=====================================================================================
Programa............: MGFFIN86
Autor...............: Marcelo Carneiro
Data................: 07/03/2018
Descricao / Objetivo: Cadastro de Tipo de Valor
Doc. Origem.........: MIT044- CAP016 - Tipo de Valor
Solicitante.........: Cliente - Mauricio CAP
Uso.................: 
Obs.................: Colocar no Menu
=====================================================================================
*/
User Function MGFFIN86 

ChkFile('ZDR')
ChkFile('ZDS')
dbSelectArea('ZDR')
dbSetOrder(1)

axCadastro('ZDR', "Cadastro de Tipo de Valor",    'U_Vld_ZDR()',  ".T.")

Return
******************************************************************************************
User Function Vld_ZDR
Local bRet  := .T.      
Local cArea := GetArea()

dbSelectArea('ZDS')
ZDS->(dbSetOrder(2))
IF ZDS->(dbSeek(ZDR->ZDR_COD))
	MsgAlert('Nao � possivel excluir pois este tipo de valor esta relacionado a um Titulo !!!')
	bRet  := .F.
EndIF

RestArea(cArea)
Return bRet                           

******************************************************************************************
User Function FIN86ID()
Local cRet   := '001'
Local cQuery := ''

cQuery  := " SELECT Max(ZDR_COD)  MAXID "
cQuery  += " FROM "+RetSqlName("ZDR")
cQuery  += " WHERE D_E_L_E_T_  = ' ' "
If Select("QRY_ID") > 0                                                           
	QRY_ID->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_ID",.T.,.F.)
dbSelectArea("QRY_ID")
QRY_ID->(dbGoTop())
IF !QRY_ID->(EOF()) .And. !Empty(QRY_ID->MAXID)
    cRet    := SOMA1(QRY_ID->MAXID)
EndIF
Return cRet

