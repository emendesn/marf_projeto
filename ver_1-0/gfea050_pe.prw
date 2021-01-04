#include 'protheus.ch'
#include 'parmtype.ch'

user function GFEA050()
	
Local lRet       := .T.
Local aParam     := PARAMIXB
Local oModel     := ''
Local cIdPonto   := ''
Local cIdModel   := ''
	
	If aParam <> NIL
      oModel     := aParam[1] // Retorno do Model
      cIdPonto   := aParam[2] // Nome do id de execução do ponto de entrada
      cIdModel   := aParam[3] // Id do Modelo que esta sendo executado

		If cIdPonto == "MODELCOMMITNTTS"// .AND. cIdModel == "GFEA050" // FORMPOS do Enchoice | Validação TudoOK do Enchoice

			If !IsInCallStack("OMSA200")
		
				If oModel:GetOperation() == 4// Alteração
				
					RecLock('ZD4',.T.)
					ZD4->ZD4_FILIAL := XFILIAL("ZD4")
					ZD4->ZD4_OPER   := "2"  
					ZD4->ZD4_CARGA  := GWN->GWN_NRROM
					ZD4->ZD4_DTCAR  := GWN->GWN_DTIMPL
					ZD4->ZD4_TPOP   := GWN->GWN_CDTPOP
					IF !EMPTY(GWN->GWN_CDTPOP)
						ZD4->ZD4_GRAVA := "1"
					ENDIF
					
					dBselectArea('DAK')
					dbSetOrder(1)
					If DbSeek(xFilial('DAK')+GWN->GWN_NRROM) 
						ZD4->ZD4_TIPOC  := "2"
					Else
						ZD4->ZD4_TIPOC  := "1"	
					EndIf
					ZD4->ZD4_MANUAL := "1"
					ZD4->ZD4_DATAMV := DDATABASE
					ZD4->ZD4_USUAR  := cUserName
					ZD4->(MsUnlock())
				
				EndIf
				
				If oModel:GetOperation() == 5 // Exclusão
	
					RecLock('ZD4',.T.)
					ZD4->ZD4_FILIAL := XFILIAL("ZD4")
					ZD4->ZD4_OPER   := "3"  
					ZD4->ZD4_CARGA  := GWN->GWN_NRROM
					ZD4->ZD4_DTCAR  := GWN->GWN_DTIMPL
					ZD4->ZD4_TPOP   := GWN->GWN_CDTPOP
					IF !EMPTY(GWN->GWN_CDTPOP)
						ZD4->ZD4_GRAVA := "1"
					ENDIF
					ZD4->ZD4_MANUAL := "1"
					dBselectArea('DAK')
					dbSetOrder(1)
					If DbSeek(xFilial('DAK')+GWN->GWN_NRROM) 
						ZD4->ZD4_TIPOC  := "2"
					Else
						ZD4->ZD4_TIPOC  := "1"	
					EndIf
					ZD4->ZD4_DATAMV := DDATABASE
					ZD4->ZD4_USUAR  := cUserName
					ZD4->(MsUnlock())
							
				EndIf
				If oModel:GetOperation() == 3// Inclusão
				
					RecLock('ZD4',.T.)
					ZD4->ZD4_FILIAL := XFILIAL("ZD4")
					ZD4->ZD4_OPER   := "1"  
					ZD4->ZD4_CARGA  := GWN->GWN_NRROM
					ZD4->ZD4_DTCAR  := GWN->GWN_DTIMPL
					ZD4->ZD4_TPOP   := GWN->GWN_CDTPOP
					IF !EMPTY(GWN->GWN_CDTPOP)
						ZD4->ZD4_GRAVA := "1"
					ENDIF
					ZD4->ZD4_MANUAL := "1"
					ZD4->ZD4_TIPOC  := "1"
					ZD4->ZD4_DATAMV := DDATABASE
					ZD4->ZD4_USUAR  := cUserName
					ZD4->(MsUnlock())
				
				EndIf
			EndIf	
		EndIf		
	EndIf
Return 	.T. 
