#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'COLORS.CH'     
  
#define CRLF chr(13) + chr(10)             
/*
=====================================================================================
Programa............: MGFINT34
Autor...............: Marcelo Carneiro
Data................: 28/03/2017
Descricao / Objetivo: Integração De Cadastros
Doc. Origem.........: Contrato GAPS - MIT044- BLOQUEIO DE CADASTROS
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Cadastro de Aprovadores
=====================================================================================
*/
User Function MGFINT34 

ChkFile('ZAZ')
dbSelectArea('ZAZ')
dbSetOrder(1)

axCadastro('ZAZ', "Cadastro de Aprovadores",    'U_Vld_ZAZ()',  ".T.")

Return
******************************************************************************************
User Function Vld_ZAZ
Local bRet  := .T.      
Local cArea := GetArea()

dbSelectArea('ZB2')
ZB2->(dbSetOrder(3))
IF ZB2->(dbSeek(ZAZ->ZAZ_ID))
	MsgAlert('Não é possivel excluir pois o Aprovador já foi usado em uma aprovação !!!')
	bRet  := .F.
EndIF

RestArea(cArea)
Return bRet                           

******************************************************************************************
User Function INT34ID()
Local cRet   := '000001'
Local cQuery := ''

cQuery  := " SELECT Max(ZAZ_ID)  MAXID "
cQuery  += " FROM "+RetSqlName("ZAZ")
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

******************************************************************************************
User Function Vld_ZAZ_IDSET
Local bRet  := .T.      
Local cArea := GetArea()

dbSelectArea('ZB6')
ZB6->(dbSetOrder(1))
IF ZB6->(!dbSeek(M->ZAZ_IDSET))
	MsgAlert('Setor não cadastrado !!!')
	bRet  := .F.
EndIF

RestArea(cArea)
Return bRet                           
