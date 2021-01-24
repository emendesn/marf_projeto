#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'COLORS.CH'
  
#define CRLF chr(13) + chr(10)             
/*
=====================================================================================
Programa............: MGFINT40
Autor...............: Marcelo Carneiro
Data................: 28/03/2017
Descricao / Objetivo: Integração De Cadastros
Doc. Origem.........: Contrato GAPS - MIT044- BLOQUEIO DE CADASTROS
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Setores
=====================================================================================
*/
User Function MGFINT40 

ChkFile('ZAZ')
ChkFile('ZB1')
ChkFile('ZB2')
ChkFile('ZB3')
ChkFile('ZB4')
ChkFile('ZB5')
ChkFile('ZB6')
dbSelectArea('ZB6')
ZB6->(dbSetOrder(1))

axCadastro('ZB6', "Setores",    'U_Vld_ZB6()',  ".T.")

Return
******************************************************************************************
User Function Vld_ZB6
Local bRet  := .T.      
Local cArea := GetArea()

dbSelectArea('ZAZ')
ZAZ->(dbSetOrder(3))
IF ZAZ->(dbSeek(ZB6->ZB6_ID))
     MsgAlert('Não é possivel Excluir pois o Setor está cadastrado para um Usuário!!! ')
     bRet  := .F.
Else
	dbSelectArea('ZB4')
	ZB4->(dbSetOrder(2))
	IF ZB4->(dbSeek(ZB6->ZB6_ID))
	     MsgAlert('Não é possivel Excluir pois o Setor está cadastrado para um Roteiro!!!')
	     bRet  := .F.
	Else
		dbSelectArea('ZB2')
		ZB2->(dbSetOrder(2))
		IF ZB2->(dbSeek(ZB6->ZB6_ID))
		     MsgAlert('Não é possivel Excluir pois o Setor já foi usado em uma aprovação !!!')
		     bRet  := .F.
		EndIF
	EndIF
EndIF
RestArea(cArea)
Return bRet                           

******************************************************************************************
User Function INT40ID()
Local cRet   := '01'
Local cQuery := ''

cQuery  := " SELECT Max(ZB6_ID) MAXID "
cQuery  += " FROM "+RetSqlName("ZB6")
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
