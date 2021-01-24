#include 'totvs.ch'   
#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} MGFFATC2
//TODO Bloqueio dos faturistas à PV's para vendas e transferências entre CD's e unidades Marfrig
@author Paulo da Mata
@since 04/09/2020
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MGFFATC2

Local cBlqFtv := SuperGetMv("MGF_BLQFTV",,"VA/VB/VE/VF/VP/VS")
Local cGrpFat := SuperGetMv("MGF_BLQGRP",,"100958/100967/100969/000685/001065/001124/001290/102541/001064/001123/100865/100874/000061")
Local cFilExc := SuperGetMv("MGF_FILEXC",,"010003/010015")
Local aCdUsr  := UsrRetGrp(RetCodUsr())
Local cTipPed := M->C5_ZTIPPED
Local cFilAtu := cFilAnt

If !(cFilAtu $ cFilExc) .and. !(isblind())
    
    If INCLUI .Or. ALTERA

        If AllTrim(M->C5_ZTIPPED) $ AllTrim(cBlqFtv)

            If AllTrim(aCdUsr[1]) $ AllTrim(cGrpFat)
                ApMsgInfo(OemToAnsi("Você não tem permissão para acessar esta funcionalidade. Entre em contato com o adminstrador do sistema"))
                cTipPed := Space(02)
            EndIf   
       
         EndIf
    
    EndIf

EndIf    

Return(cTipPed)
