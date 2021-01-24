#Include 'Protheus.ch'

/*
=====================================================================================
Programa.:              MGFCOM46
Autor....:              TOTVS
Data.....:              19/10/2017
Descricao / Objetivo:   Tratamento para o não envio da solicitação para grade na 
alteração dos campos Observação, comprador e Cod Cl Val
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/

User Function MGFCOM46()

	Local lGrava   := .T.
	Local nI       := 0
	Local nJ       := 0 
	Local lAlterou := .F.
	Local cFil     := SC1->C1_FILIAL
	Local cSol	   := SC1->C1_NUM
	Local aAreaSC1 := GetArea()
	Local cCampos  := GetMV("MGF_COM13")
	
	For nI := 1 to Len(Acols)

		For nJ := 1 to len(AHEADER)

			//If AHEADER[nJ,2] <> "C1_CODCOMP" .AND. AHEADER[nJ,2] <> 'C1_OBS' .AND. AHEADER[nJ,2] <> 'C1_CLVL' .AND. AHEADER[nJ,10] <> 'V'  
	
            If AHEADER[nJ,2] $ cCampos 
            
             If AHEADER[nJ,10] <> "V"
                                                                                                          
				POSICIONE('SC1' ,2, XFILIAL('SC1') + Acols[nI,2] + SC1->C1_NUM + Acols[nI,1] + SC1->C1_FORNECE + SC1->C1_LOJA, "C1_ITEM")
			    				     
					If &(alltrim('SC1->' + AHEADER[nJ,2])) <> Acols[nI, nJ]

							lAlterou := .T. 
							
						Exit 

					EndIf
			 EndIf			
			EndIf

		Next
	If lAlterou
		Exit
	EndIf	
	Next
		
//Grava campo de status
		
			DbGotop('SC1')
			SC1->(dBsetorder(1))//C1_FILIAL+C1_NUM+C1_ITEM
			If SC1->(DbSeek(xFilial('SC1') + cSol))

				If lAlterou
			
					While SC1->(!EOF()) .AND. XFILIAL('SC1') == cFil .AND. SC1->C1_NUM == cSol
						Reclock('SC1',.F.)
						SC1->C1_APROV := 'B'
						SC1->(MsUnlock())
						SC1->(dbskip())
					Enddo	
				Else
					While SC1->(!EOF()) .AND. XFILIAL('SC1') == cFil .AND. SC1->C1_NUM == cSol
					    Reclock('SC1',.F.)
						SC1->C1_APROV := 'L' 
					    SC1->(MsUnlock())
						SC1->(dbskip())
					Enddo
				EndIf
			EndIf		
		
	
RestArea(aAreaSC1)

Return ( lGrava )