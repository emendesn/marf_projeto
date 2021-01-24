#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"  

/*              
+-----------------------------------------------------------------------+
¦Programa  ¦MGFEST74    ¦ Autor ¦ WAGNER NEVES         ¦ Data ¦20.04.20 ¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦Programa para visualização dos logs de envio e retorno      ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA MARFRIG			                        ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR      ¦ DATA       ¦ MOTIVO DA ALTERACAO                    ¦
+-----------------------------------------------------------------------¦
¦                 ¦            ¦ 				                        ¦
+-----------------------------------------------------------------------+
*/

User Function  MGFES74A()

Local lRet := .T.                    
Local aAreaApr := GetArea()
Local cQuery   := ""      
Local _cGrupoInd := GetMv("MGF_EPIIND",,"0321")  // Grupo de Produto EPI Individual
Local _cGrupoCol := GetMv("MGF_EPICOL",,"0322")  // Grupo de Produto EPI Coletivo
Local aheader := {"Filial","Numero SA","Produto","Data Envio","Hora","Tempo","Envio","Retorno","Mensagen"}
Private _aCols   := {}

If !cFilAnt $GetMv("MGF_EPIFIL") // Verifica se a filial está autorizada ao tratamento de EPI
		MsgAlert("Esta filial não está habilitada para executar essa rotina-MGFES74A","MGF_EPIFIL")
		Return
ENDIF
If Select("TZG7") # 0
	TZG7->(dbCloseArea())
EndIf
#IFDEF TOP
	cQuery := "SELECT * "
	cQuery += " FROM "+RetSQLName("ZG7")+" ZG7 "
    cQuery += " INNER JOIN SB1010 SB1 ON SB1.B1_COD = ZG7.ZG7_PROD"
	cQuery += " WHERE "
    cQuery += " ZG7.D_E_L_E_T_ = ' ' "
    cQuery += " AND SB1.D_E_L_E_T_ = ' '"
	cQuery += " AND ZG7.ZG7_FILIAL = '"+xFilial("ZG7")+"'"
    cQuery += " AND ZG7.ZG7_NUMSA='"+SCP->CP_NUM+"'"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TZG7", .F., .T.)
#ENDIF	
COUNT TO nRegs
IF nRegs < 1
    MsgStop("Não existem registros para visualização !!!","Atenção !!!")
    RETURN
EndIf 
dbSelectArea("TZG7")
DbGoTop("TZG7")
While ! TZG7->(Eof())
	Aadd(_aCols,{TZG7->ZG7_FILIAL ,ALLTRIM(TZG7->ZG7_NUMSA) ,TZG7->ZG7_PROD,DTOC(STOD(TZG7->ZG7_DATA)),TZG7->ZG7_HORA,TZG7->ZG7_TEMPO,TZG7->ZG7_USUENV,TZG7->ZG7_JASRET,TZG7->ZG7_STARET})
	TZG7->(DbSkip())	
EndDo
If ! Len(_ACOLS) > 0
	RETURN
EndIf
U_MGListBox( "Log de Envio Ref SA No. "+SCP->CP_NUM , aHeader , _ACOLS , .T. , 1 )
TZG7->(DBCLOSEAREA())
Return lRet
//----------------------------------------------------------------------------------------------------

User Function  MGFES74B()
Local lRet := .T.                    
Local aAreaApr := GetArea()
Local cQuery   := ""      
Local _cGrupoInd := GetMv("MGF_EPIIND",,"0321")  // Grupo de Produto EPI Individual
Local _cGrupoCol := GetMv("MGF_EPICOL",,"0322")  // Grupo de Produto EPI Coletivo
Local aheader := {"Filial","Numero SA","Produto","Data Envio","Hora","Tempo","Envio","Retorno","Mensagen"}
Private _aCols   := {}

If !cFilAnt $GetMv("MGF_EPIFIL") // Verifica se a filial está autorizada ao tratamento de EPI
		MsgAlert("Esta filial não está habilitada para executar essa rotina-MGFES74B","MGF_EPIFIL")
		Return
ENDIF
If Select("TZG8") # 0
	TZG8->(dbCloseArea())
EndIf
#IFDEF TOP
	cQuery := "SELECT * "
	cQuery += " FROM "+RetSQLName("ZG8")+" ZG8 "
    cQuery += " INNER JOIN SB1010 SB1 ON SB1.B1_COD = ZG8.ZG8_PROD"
	cQuery += " WHERE "
    cQuery += " ZG8.D_E_L_E_T_ = ' ' "
    cQuery += " AND SB1.D_E_L_E_T_ = ' '"
	cQuery += " AND ZG8.ZG8_FILIAL = '"+xFilial("ZG8")+"'"
    cQuery += " AND ZG8.ZG8_NUMSA='"+SCP->CP_NUM+"'"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TZG8", .F., .T.)
#ENDIF	
COUNT TO nRegs
IF nRegs < 1
    MsgStop("Não existem registros para visualização !!!","Atenção !!!")
    RETURN
EndIf 
dbSelectArea("TZG8")
DbGoTop("TZG8")
While ! TZG8->(Eof())
	Aadd(_aCols,{TZG8->ZG8_FILIAL ,ALLTRIM(TZG8->ZG8_NUMSA) ,TZG8->ZG8_PROD,DTOC(STOD(TZG8->ZG8_DATA)),TZG8->ZG8_HORA,TZG8->ZG8_TEMPO,TZG8->ZG8_USUENV,TZG8->ZG8_JASRET,TZG8->ZG8_STARET})
	TZG8->(DbSkip())	
EndDo
If ! Len(_ACOLS) > 0
	RETURN
EndIf
U_MGListBox( "Log de Envio Ref SA No. "+SCP->CP_NUM , aHeader , _ACOLS , .T. , 1 )
TZG8->(DBCLOSEAREA())
Return lRet