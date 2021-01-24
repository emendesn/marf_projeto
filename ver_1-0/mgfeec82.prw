#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#DEFINE cEOL Chr(13)+Chr(10)

/*/{Protheus.doc} MGFEEC82

Gatilhos para valida��o dos campos novos criados
RTASK0011075-Unifica��o-SKU

@type function
@author Paulo da Mata
@since 06/04/2020
@version P12.1.17
@return Nil
/*/

User Function MGFEEC82

Local cGrpUsr := ""
Local cQryUsr := ""
Local cQryGrp := ""
Local lRet    := .F.
Local cGrupos := SuperGetMv("MGF_EEC82A",,"EXP_TRADER")

Local cUsrAtu := __cUserId

// Query para carregar o grupo do usu�rio atual
If Select("TMPUSR") > 0
	dbSelectArea("TMPUSR")
	dbCloseArea()
EndIf

cQryUsr := "SELECT USR_ID,USR_GRUPO "+cEOL
cQryUsr += "FROM SYS_USR_GROUPS "+cEOL
cQryUsr += "WHERE D_E_L_E_T_ = ' ' "+cEOL
cQryUsr += "AND USR_ID = '"+cUsrAtu+"' "+cEOL

cQryUsr := ChangeQuery(cQryUsr)

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQryUsr),"TMPUSR", .F., .T.)

If TMPUSR->(!Eof())
   cGrpUsr := TMPUSR->USR_GRUPO
EndIf   

// Query para carregar os grupos aos quais os usu�rio pertencem
If Select("TMPGRP") > 0
   dbSelectArea("TMPGRP")
   dbCloseArea()
EndIf

cQryGrp := "SELECT GR__ID,GR__CODIGO "+cEOL
cQryGrp += "FROM SYS_GRP_GROUP "+cEOL
cQryGrp += "WHERE D_E_L_E_T_ = ' '"+cEOL
cQryGrp += "AND GR__ID ='"+cGrpUsr+"'"+cEOL

cQryGrp := ChangeQuery(cQryGrp)

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQryGrp),"TMPGRP", .F., .T.)

// Verifica se o grupo contem a frase do par�metro MGF_EEC82A
If TMPGRP->(!Eof())
   If cGrupos $ TMPGRP->GR__CODIGO
      lRet := .T.
   EndIf  
EndIf   

Return lRet