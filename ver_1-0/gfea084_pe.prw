#Include "Protheus.ch"
#include "totvs.ch"
#include "FWMVCDEF.ch"

User function GFEA084() 

Local lRet       := .T.
Local aParam     := PARAMIXB
Local oModel     := ''
Local cIdPonto   := ''
Local cIdModel   := ''     
Local nValor	 := 0  
Local nOperation := 0
Local aAreaZBO   := ZBO->(GetArea()) 
	 
	If aParam <> NIL .and. ALLTRIM(GWF->GWF_OBS)<>"INTEGRACAO MULTIEMBARCADOR"
	      oModel     := aParam[1] // Retorno do Model
	      cIdPonto   := aParam[2] // Nome do id de execução do ponto de entrada
	      cIdModel   := aParam[3] // Id do Modelo que esta sendo executado
		If cIdPonto == "MODELVLDACTIVE" // Verifica se pode ativação do modelo
		    nOperation := aParam[1]:NOPERATION   
		EndIf
		
		 If cIdPonto == "MODELCOMMITNTTS"
        
         	If !nOperation = 5
         	
			    DbSelectArea('GWI')
			    DbSetOrder(1)
			    GWI->(Msseek(xFilial('GWI')+GWF->GWF_NRCALC))
				
				While(!eof()) .AND. XFILIAL('GWI') == GWI->GWI_FILIAL .AND. GWF->GWF_NRCALC == GWI->GWI_NRCALC
				        	    
					RecLock("GWI",.F.)
			        nValor += GWI->GWI_VLFRET
			        GWI->GWI_XVLAPR := GWI->GWI_VLFRET
			        //GWI->GWI_QTCALC := GWI->GWI_VLFRET
					GWI->GWI_VLFRET := 0 	 
			        MsUnlock()

			        lRet := .T.
		        	GWI->(DbSkip())
	            Enddo
	            
				///Grava registro na tabela ZBO para ser aprovado.
        	
	        	DbSelectArea("ZBO")
				RecLock("ZBO",.T.)			
				ZBO->ZBO_FILIAL := XFILIAL("GWI")
				ZBO->ZBO_STAUS  := "1"			
				ZBO->ZBO_NRCALC := GWF->GWF_NRCALC
				ZBO->ZBO_VLFRE  := nValor
				ZBO->ZBO_OBS    := GWF->GWF_OBS
				MsUnlock()			                            
				
	            MsgInfo("Frete combinado enviado para aprovação!")
		    
		   
		     Return lRet
		 
		 	EndIf 	
		 //tratamento realizado na exclusão
		 ElseIf cIdPonto == "MODELPOS"
            
			nOperation := aParam[1]:NOPERATION
			
			If nOperation = 5
			
				DbSelectArea('ZBO')
				DbSetOrder(1)
				ZBO->(Msseek(xFilial('ZBO')+GWF->GWF_NRCALC))
	
				RecLock('ZBO', .F.)
				ZBO->(dbDelete())
				ZBO->(MsUnLock())

			EndIf 	               
		 	
		 EndIf  
	
	EndIf	
RestArea(aAreaZBO)	

Return lRet      

