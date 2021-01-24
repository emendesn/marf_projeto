#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "VKEY.CH"
#INCLUDE "FONT.CH"
#INCLUDE "FWMVCDEF.CH"

User Function MGFOMS02()

Local   aArea  	 := GetArea()
Local 	cMsgnota := Space(60)
Local	Odlg
Local 	cDescrC  := ""
Local 	aRetorno := {}
Private lOk,lCancel

If DAK->DAK_FEZNF == '2'                                                                                                     

	DEFINE DIALOG oDlg TITLE "Incluindo Mensagem para Nota" FROM 180,180 TO 350,500 PIXEL 

	@ 25,58 MSGET cMsgnota  F3 " " SIZE 90,10 OF oDlg PIXEL PICTURE '@!'     
	@ 26,08 SAY "Mensagem Fat:" SIZE  50,10 OF oDlg PIXEL
                                                                        
	oTButton := TButton():New( 70, 120, "&OK",oDlg	,{|| lOk:= .T., oDlg:End() },40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	
	ACTIVATE DIALOG oDlg CENTERED
	
///   	aAdd (aRetorno, {cMsgnota})
   	       
 	If lOk             
		DAI->(DBGoTop())
		DAI->(DBSetOrder(1))
		DAI->(DBSeek( xFilial("DAI") + DAK->DAK_COD ) )
	   
	   	While !DAI->(EOF()) .AND. DAI->(DAI_COD+DAI_SEQCAR) == DAK->(DAK_COD+DAK_SEQCAR) 
	    	
	    	dBselectArea('SC5')
			dbSetOrder(1) //C5_FILIAL+C5_NUM                                                                                                                     
			If DbSeek(xFilial('SC5')+DAI->DAI_PEDIDO)
	             
				RecLock("SC5",.F.)
				SC5->C5_XMSGFT  := cMsgnota
				MsUnlock()
	
	        EndIf
		    	
			DAI->(DbSkip())
		Enddo
	EndIf
Else

MsgAlert("Apenas é possível incluir mensagens para cargas não faturadas.")
EndIf
RestArea(aArea)	         
	                                                                  
Return // aRetorno                                                    
                                   
      
      
      
      