#include "protheus.ch"
#include "parmtype.ch"

/*
=====================================================================================
Programa............: CUSTOMERVENDOR
Autor...............: Leandro Brutus
Data................: 30/07/2020 
Descricao / Objetivo: Ponto de Entrada em MVC
Doc. Origem.........: Protheus-Taura Cadastro
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ticket 9420799
=====================================================================================
*/

User Function CUSTOMERVENDOR()
    Local aParam := PARAMIXB
    Local lRet := .T.
    Local oObj := ""
    Local cIdPonto := ""
    Local cIdModel := ""
    Local npCod
    Local npLoj
    Local cCodInial := M->A2_COD

    If aParam <> NIL
        oObj := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]
 
        If cIdPonto == "FORMPOS" .AND.  CIDMODEL = "SA2MASTER"
 
            // valida campos para integracao do Taura
            If FindFunction("U_TAC01MA020TDOK")
                lRet := U_TAC01MA020TDOK()
            Endif		

            If lRet .And. FindFunction("U_INT39_EMAIL")
                lRet := U_INT39_EMAIL()
            Endif		

            // Executa funçóo para definiçóo do Codigo/Loja
            //Esta funçóo deverá ser executada por ultimo
            If lRet .And. FindFunction("U_MGFINT45")
                lRet := U_MGFINT45()
            Endif	

        	IF INCLUI .and. lRet

				npCod := aScan(oobj:aDatamodel[1],{|x| x[1] == "A2_COD"})
				npLoj := aScan(oobj:aDatamodel[1],{|x| x[1] == "A2_LOJA"})
				
				IF npCod > 0
					oobj:aDatamodel[1,npCod,2]	:= M->A2_COD
				Endif                                  
				
				IF npLoj > 0
					oobj:aDatamodel[1,npLoj,2]  := M->A2_LOJA
				Endif                      

                // Valida se o códi­go do cliente foi atualizado com sucesso a fim de evitar novos registro com o inicializador padrão ("XXXXXX") - PRB0041187
                If (M->A2_COD = cCodInial)
                    lRet := .F.
                    u_mgfmsg("Problema na geração do código e loja",,"Entre em contato com o suporte")
                EndIf
            EndIf

        ElseIf cIdPonto == "MODELCOMMITTTS"
            
            If existblock("MT20FOPOS")
                execblock("MT20FOPOS",.F.,.F.,{ oObj:getOperation() } )
            EndIf
       
        EndIf
    
    EndIf

Return lRet
