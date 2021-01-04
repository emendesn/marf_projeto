#include 'PROTHEUS.CH'

User Function GFEA0321()

Local cNrOcor  := GWD->GWD_NROCO
Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
Local lRet 	   := .F.
Local nFrete   := 0 
Local lMsg	   := .T.

GU6->(DbselectArea('GU6'))
GU6->(dBSetorder(1))//GU6_FILIAL+GU6_CDMOT
If GU6->(dbSeek(xFilial('GU6') + GWD->GWD_CDMOT ))
	
	If GU6->GU6_APRAUT = '2'
		
		GWF->(DbselectArea('GWF'))
		GWF->(dBSetorder(5))//GWF_FILIAL+GWF_NROCO+GWF_NRCALC
		If GWF->(dbSeek(xFilial('GWD') + cNrOcor ))
			
			While !GWF->(eof()) .AND. (GWF->GWF_FILIAL = GWD->GWD_FILIAL) .AND.  (GWF->GWF_NROCO = GWD->GWD_NROCO)
				nFrete += GWF->GWF_BAPICO
				GWF->(DBSKIP())
			Enddo
			
			dBselectArea("SZO")
			SZO->(dbSetOrder(1))//ZO_FILIAL+ZO_USUARIO
			If SZO->(dbSeek(xFilial("SZO")+cCodUser))
				While !SZO->(eof()) .AND. (SZO->ZO_USUARIO = cCodUser )	 .AND. !lRet .AND. U_GFE01VLDSUB()
					If SZO->ZO_TPAPROV $ '36'
						If nFrete >= SZO->ZO_VLMIN .AND. nFrete <= SZO->ZO_VLATE
							lRet := .T.
							lMsg := .F.
						Else
							lMsg := .T.
						EndIf
					EndIf
					SZO->(DBSKIP())
				Enddo
			Else
				lMsg := .T.
			EndIf
			
			If lMsg = .T.
				Alert("usuário sem permissão para aprovação da ocorrência! O valor não está na sua Grade de aprovação!")
				
				RecLock("GWD",.F.)
				GWD->GWD_SIT := "1"
				GWD->(MsUnlock())

				GWF->(dbSeek(xFilial('GWD') + cNrOcor ))
				
				While !GWF->(eof()) .AND. (GWF->GWF_FILIAL = GWD->GWD_FILIAL ) .AND. (GWD->GWD_NROCO = GWF->GWF_NROCO)
					
					RecLock("GWF",.F.)
					GWF->(DbDelete())
					GWF->(MsUnlock())
					
					GWF->(DbSkip())
					
				Enddo
			EndIf			
		EndIf
	EndIf
EndIf

Return
