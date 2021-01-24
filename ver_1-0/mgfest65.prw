#INCLUDE "rwMake.ch"                        
#INCLUDE "PROTHEUS.CH" 
#Include "TopConn.ch"  
#INCLUDE "Totvs.CH" 

/*/{Protheus.doc} MGFEST65
@author Henrique Vidal Santos
@since 15/01/2020
@version P12.1.017
@country Brasil
@language Português

@type Function  
	Validação via gatilho - Rotina servirá como validação. 
	Chamada inicial a partir do campo X3_VLDUSER.
@table 
	SB1 - Cadastro de produtos
@param
@return
@menu
/*/

User Function MGFEST65()  

	Local lRet := .T.

	If Empty(M->B1_ZLINHA)
	
		If M->B1_XENVECO == '1' 
			MsgAlert("O campo linha não pode ser vazio se o campo 'Envia E-Commerce' estiver igual a 'Sim'. ")
			lRet := .F.
		EndIf
	
	Else
	
		If B1_XENVECO <> M->B1_XENVECO
			If !(ExistCpo("ZC4",M->B1_ZLINHA))
				MsgAlert("Campo 'Envia E-Commerce' só poder ser alterado se o campo 'Linha' estiver preenchido com conteúdo existente na ZC4!" )
				lRet := .F.
			EndIf 
		EndIf 
	
	EndIf

Return lRet


