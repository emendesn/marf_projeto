#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

/*
=====================================================================================
Programa............: MGFCRM49
Autor...............: Flavio Dentello
Data................: 08/03/2017 
Descricao / Objetivo: Ponto de entrada Valida a inclusao de linhas no pedido de vendas Refaturamento que utiliza RAMI 
Doc. Origem.........: CRM- RAMI
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/

user function MGFCRM46()

	Local cRAMI      := ""
	Local lRet 	     := .T.
	Local lZAW 	     := .F.	
	Local lAchou     := .F.
	Local nSaldo     := 0
	Local nSaldoTot  := 0
	local nRami		 := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ZRAMI"	})
	local nPosLocal	 := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_LOCAL"	})
	local nPosItem	 := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ITEM"	})
	local nPosProdut := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
	Local nI		 := 0
	local aArea	     := getArea()
	local aAreaSC5   := SC5->(getArea())
	local aAreaZAV   := ZAV->(getArea())
	Local nPosProd   := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"	})
	Local nDel		 := len(aHeader) + 1
	Local lSaldo	 := .F.
	Local lRami		 := .F.
	local cLocalDev	 := allTrim(superGetMv("MGF_ARMDEV", .F., "99"))
	local nSuzado	 := 0
	local nSaldoCt	 := 0
	local lEstrangei := isForeign( M->C5_CLIENTE, M->C5_LOJACLI )

	If M->C5_TIPO == 'N' .AND. !lEstrangei .and. !isInCallStack("U_runFATA5") // Cliente Estrangeiro nao valida itens duplicados
		for nI := 1 to len(aCols)
			if aCols[nI, nPosItem] <> aCols[n, nPosItem]
				if aCols[nI, nPosProdut] == aCols[n, nPosProdut]
					msgAlert("Nao  permitido incluir Produtos iguais em Itens diferentes!")
					return .F.
				endif
			endif
		next
	
		cRAMI := M->C5_ZRAMI1 + ;	
		M->C5_ZRAMI2 + ;
		M->C5_ZRAMI3 + ;
		M->C5_ZRAMI4 + ;
		M->C5_ZRAMI5 + ;
		M->C5_ZRAMI6 + ;
		M->C5_ZRAMI7 + ;
		M->C5_ZRAMI8 + ;
		M->C5_ZRAMI9 + ;
		M->C5_ZRAMI10 + ;
		M->C5_ZRAMI11 + ;
		M->C5_ZRAMI12 + ;
		M->C5_ZRAMI13 + ;
		M->C5_ZRAMI14 + ;				 
		M->C5_ZRAMI15 + ;
		M->C5_ZRAMI16 + ;
		M->C5_ZRAMI17 + ;
		M->C5_ZRAMI18 + ;
		M->C5_ZRAMI19 + ;
		M->C5_ZRAMI20 + ;
		M->C5_ZRAMI21 + ;
		M->C5_ZRAMI22 + ;
		M->C5_ZRAMI23 + ;
		M->C5_ZRAMI24 + ;
		M->C5_ZRAMI25 
	
	
		If M->C5_ZREFATU = 'S' .AND. !ACOLS[n][nDel] 
	
			If !empty(cRAMI)
				If !lAchou
					If !empty(M->C5_ZRAMI1)
						cRAMI := M->C5_ZRAMI1
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
	
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami]		:= cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
							//Return .F.					
						EndIf
					EndIf
				EndIf	
	
				If !lAchou
					If !empty(M->C5_ZRAMI2)
						cRAMI := M->C5_ZRAMI2
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami]		:= cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
						EndIf
					EndIf
				EndIf			
				If !lAchou
					If !empty(M->C5_ZRAMI3)
						cRAMI := M->C5_ZRAMI3
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
	
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami]		:= cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
						EndIf
					EndIf
				EndIf			
				If !lAchou
					If !empty(M->C5_ZRAMI4)
						cRAMI := M->C5_ZRAMI4
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
	
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami]		:= cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
						EndIf
					EndIf
				EndIf			
	
	
	
				If !lAchou
					If !empty(M->C5_ZRAMI5)
						cRAMI := M->C5_ZRAMI5
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
	
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami]		:= cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
						EndIf
					EndIf
				EndIf	
				If !lAchou
					If !empty(M->C5_ZRAMI6)
						cRAMI := M->C5_ZRAMI6
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
	
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami] := cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
						EndIf
					EndIf
				EndIf						
				If !lAchou
					If !empty(M->C5_ZRAMI7)
						cRAMI := M->C5_ZRAMI7
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
	
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami] := cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
							//Return .F.			
						EndIf
					EndIf
				EndIf						
				If !lAchou
					If !empty(M->C5_ZRAMI8)
						cRAMI := M->C5_ZRAMI8
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
	
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami] := cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
						EndIf
					EndIf
				EndIf						
				If !lAchou
					If !empty(M->C5_ZRAMI9)
						cRAMI := M->C5_ZRAMI9
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
	
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami] := cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
						EndIf
					EndIf
				EndIf						
				If !lAchou
					If !empty(M->C5_ZRAMI10)
						cRAMI := M->C5_ZRAMI10
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
	
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami] := cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
							//Return .F.								
						EndIf
					EndIf
				EndIf			
				If !lAchou
					If !empty(M->C5_ZRAMI11)
						cRAMI := M->C5_ZRAMI11
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
	
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami] := cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
							//Return .F.								
						EndIf
					EndIf
				EndIf			
				If !lAchou
					If !empty(M->C5_ZRAMI12)
						cRAMI := M->C5_ZRAMI12
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
	
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami] := cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
							//Return .F.								
						EndIf
					EndIf
				EndIf			
				If !lAchou
					If !empty(M->C5_ZRAMI13)
						cRAMI := M->C5_ZRAMI13
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
	
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami] := cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
							//Return .F.			
	
						EndIf
					EndIf
				EndIf					
				If !lAchou
					If !empty(M->C5_ZRAMI14)
						cRAMI := M->C5_ZRAMI14
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
	
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami] := cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
							//Return .F.			
	
						EndIf
					EndIf
				EndIf					
				If !lAchou
					If !empty(M->C5_ZRAMI15)
						cRAMI := M->C5_ZRAMI15
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
	
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami] := cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
							//	Return .F.			
	
						EndIf
					EndIf
				EndIf					
				If !lAchou
					If !empty(M->C5_ZRAMI16)
						cRAMI := M->C5_ZRAMI16
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
	
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami] := cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
						EndIf
					EndIf
				EndIf					
				If !lAchou
					If !empty(M->C5_ZRAMI17)
						cRAMI := M->C5_ZRAMI17
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
	
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami] := cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
						EndIf
					EndIf
				EndIf	
				If !lAchou
					If !empty(M->C5_ZRAMI18)
						cRAMI := M->C5_ZRAMI18
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
	
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami] := cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
						EndIf
					EndIf
				EndIf			
				If !lAchou
					If !empty(M->C5_ZRAMI19)
						cRAMI := M->C5_ZRAMI19
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
	
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami] := cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
						EndIf
					EndIf
				EndIf			
				If !lAchou
					If !empty(M->C5_ZRAMI20)
						cRAMI := M->C5_ZRAMI20
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
	
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami] := cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
						EndIf
					EndIf
				EndIf			
				If !lAchou
					If !empty(M->C5_ZRAMI21)
						cRAMI := M->C5_ZRAMI21
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
	
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami] := cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
						EndIf
					EndIf
				EndIf			
				If !lAchou
					If !empty(M->C5_ZRAMI22)
						cRAMI := M->C5_ZRAMI22
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
	
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami] := cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
						EndIf
					EndIf
				EndIf							
				If !lAchou
					If !empty(M->C5_ZRAMI23)
						cRAMI := M->C5_ZRAMI23
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
	
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami] := cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
						EndIf
					EndIf
				EndIf	
				If !lAchou
					If !empty(M->C5_ZRAMI24)
						cRAMI := M->C5_ZRAMI24
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
	
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami] := cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
						EndIf
					EndIf
				EndIf	
				If !lAchou
					If !empty(M->C5_ZRAMI25)
						cRAMI := M->C5_ZRAMI25
	
						DbSelectArea('ZAV')
						DbSetOrder(1)//ZAV_FILIAL+ZAV_CODIGO                                                                                                                                                                                                                                                                         
						If ZAV->(MsSeek(xFilial('ZAV')+ alltrim(cRAMI) ))
	
							////QUANTIDADE J� UTILIZADA
							nSaldo := QTDITEMRAMI()		
	
							////QUANTIDADE TOTAL
							nSaldoTot := U_QTDITEMRAMIT() 				
	
							nSaldoTot := nSaldoTot - nSaldo
	
							If nSaldoTot >= ACOLS[N][5]
								ACOLS[n][nRami] := cRAMI
								if ZAV->ZAV_REVEND == "S"
									ACOLS[n][nPosLocal] := cLocalDev
								endif
								lAchou := .T.					
							Else
	
								lSaldo := .T.
	
								lRet := .F.
							EndIf			
						Else
	
							lRami := .T.	
	
						EndIf
					EndIf
				EndIf	
	
	
				If !lAchou
	
					nSuzado  := QTDRAMIT()
					nSaldoCt := QTDCONT()
					
					nSaldoCt := nSaldoCt - nSuzado
					 
					if nSaldoCt >= ACOLS[N][5]  
						lAchou := .T.
					else
						MsgAlert('Nao  foi encontrada nenhuma RAMI para esse produto ou Nao  h� saldo!!')
						lAchou := .F.
					endif	
				EndIf
			Else
	
				MsgAlert('Para o tipo de pedido Revenda � obrigat�rio informar o numero da RAMI na aba RAMI!')
				lRet := .F.
	
			EndIF	
	
		Else 
			Return .T.
		EndIf
	Else
		Return .T.
	EndIf

	RestArea(aArea)
	Restarea(aAreaSC5)
	Restarea(aAreaZAV)

return lAchou




/////Funcao que traz o saldo da RAMI

USER FUNCTION QTDITEMRAMIT()

	Local nQTDT := 0
	Local nPosProd   := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"	})
	Local cQuery 	:= ""
	Local cAliasQTD := ""

	cAliasQTDT := GetNextAlias()	

	cQuery := " SELECT SUM(ZAW_QTD)QTDT  FROM "
	cQUERY +=  RetSqlName("ZAW")+" ZAW "  
	cQuery += " WHERE ZAW_FILIAL ='" + XFILIAL("ZAW") +"'"
	cQuery += " AND ZAW_NOTA ='" + ZAV->ZAV_NOTA +"'"
	cQuery += " AND ZAW_SERIE ='" + ZAV->ZAV_SERIE +"'"
	cQuery += " AND ZAW_CDPROD ='" + acols[n][nPosProd] +"'"
	cQuery += " AND ZAW_CDRAMI ='" + ZAV->ZAV_CODIGO +"'"

	cQuery += " AND ZAW.D_E_L_E_T_<> '*' "

	cQuery := ChangeQuery(cQuery)

	conout("********** MGFFAT46 TOTAL " + cquery)

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQTDT, .F., .T.)

	If (cAliasQTDT)->(!eof())
		nQTDT := (cAliasQTDT)->QTDT
	EndIf

Return nQTDT


//Funcao que traz o saldo da RAMI Resolu��o


STATIC FUNCTION QTDITEMRAMI()

	Local nQTD := 0
	Local nPosProd   := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"	})
	Local cQuery 	:= ""
	Local cAliasQTD := ""

	cAliasQTD := GetNextAlias()	

	cQuery := " SELECT SUM(ZAX_QTD)QTD  FROM "
	cQUERY +=  RetSqlName("ZAX")+" ZAX "  
	cQuery += " WHERE ZAX_FILIAL ='" + XFILIAL("ZAV") +"'"
	cQuery += " AND ZAX_NOTA ='" + ZAV->ZAV_NOTA +"'"
	cQuery += " AND ZAX_SERIE ='" + ZAV->ZAV_SERIE +"'"
	cQuery += " AND ZAX_CODPRO ='" + acols[n][nPosProd] +"'"
	cQuery += " AND ZAX_CDRAMI ='" + ZAV->ZAV_CODIGO +"'"
	cQuery += " AND ZAX_COMERC = '1' "
	cQuery += " AND ZAX_QUALID = '1' "
	cQuery += " AND ZAX_EXPEDI = '1' "
	cQuery += " AND ZAX_PCP = '1' "
	cQuery += " AND ZAX_TRANSP = '1' "
	cQuery += " AND ZAX.D_E_L_E_T_<> '*' "

	cQuery := ChangeQuery(cQuery)

	conout("********** MGFFAT46 PARCIAL " + cquery)

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQTD, .F., .T.)

	If (cAliasQTD)->(!eof())
		nQTD := (cAliasQTD)->QTD
	EndIf

Return nQTD



Static Function QTDRAMIT()

	Local nTotal 	 := 0
	Local nPosProd   := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"	})
	Local cQuery 	 := ""
	Local cAliasRAMI := ""


	cAliasRAMI := GetNextAlias()	

	cQuery := " SELECT SUM(ZAX_QTD)QTD  FROM "
	cQUERY +=  RetSqlName("ZAX")+" ZAX " + ", " + RetSqlName("ZAV")+" ZAV " 
	cQuery += " WHERE ZAX_FILIAL ='" + XFILIAL("ZAX") +"'"
	cQuery += " AND ZAV_FILIAL ='" + XFILIAL("ZAV") +"'"
	cQuery += " AND ZAX_CDRAMI = ZAV_CODIGO "
	cQuery += " AND ZAV_TPFLAG <> '1' "
	cQuery += " AND ZAX_CDRAMI IN (" + "'" + M->C5_ZRAMI1 + "'"  

	If !empty(M->C5_ZRAMI2)
		cQuery += ", " + "'" + M->C5_ZRAMI2 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI3)
		cQuery += ", " + "'" + M->C5_ZRAMI3 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI4)
		cQuery += ", " + "'" + M->C5_ZRAMI4 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI5)
		cQuery += ", " + "'" + M->C5_ZRAMI5 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI6)
		cQuery += ", " + "'" + M->C5_ZRAMI6 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI7)
		cQuery += ", " + "'" + M->C5_ZRAMI7 + "'" 
	endif							
	If !empty(M->C5_ZRAMI8)
		cQuery += ", " + "'" + M->C5_ZRAMI8 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI9)
		cQuery += ", " + "'" + M->C5_ZRAMI9 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI10)
		cQuery += ", " + "'" + M->C5_ZRAMI10 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI11)
		cQuery += ", " + "'" + M->C5_ZRAMI11 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI12)
		cQuery += ", " + "'" + M->C5_ZRAMI12 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI13)
		cQuery += ", " + "'" + M->C5_ZRAMI13 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI14)
		cQuery += ", " + "'" + M->C5_ZRAMI14 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI15)
		cQuery += ", " + "'" + M->C5_ZRAMI15 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI16)
		cQuery += ", " + "'" + M->C5_ZRAMI16 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI17)
		cQuery += ", " + "'" + M->C5_ZRAMI17 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI18)
		cQuery += ", " + "'" + M->C5_ZRAMI18 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI19)
		cQuery += ", " + "'" + M->C5_ZRAMI19 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI20)
		cQuery += ", " + "'" + M->C5_ZRAMI20 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI21)
		cQuery += ", " + "'" + M->C5_ZRAMI21 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI22)
		cQuery += ", " + "'" + M->C5_ZRAMI22 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI23)
		cQuery += ", " + "'" + M->C5_ZRAMI23 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI24)
		cQuery += ", " + "'" + M->C5_ZRAMI24 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI25)
		cQuery += ", " + "'" + M->C5_ZRAMI25 + "'" 
	endif								 

	cQuery += ")"

	cQuery += " AND ZAX_CODPRO ='" +  acols[n][nPosProd] +"'"
	cQuery += " AND ZAX_COMERC = '1' "
	cQuery += " AND ZAX_QUALID = '1' "
	cQuery += " AND ZAX_EXPEDI = '1' "
	cQuery += " AND ZAX_PCP    = '1' "
	cQuery += " AND ZAX_TRANSP = '1' "
	cQuery += " AND ZAX.D_E_L_E_T_<> '*' "

	cQuery := ChangeQuery(cQuery)

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasRAMI, .F., .T.)


	If (cAliasRAMI)->(!EOF())
		nTotal := (cAliasRAMI)->QTD
	Endif

Return nTotal




Static Function QTDCONT()

	Local nTotal 	  := 0
	Local nPosProd    := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"	})
	Local cQuery 	  := ""
	Local cAliasTotal := ""


	cAliasTotal := GetNextAlias()	

	cQuery := " SELECT SUM(ZAW_QTD)QTD  FROM "
	cQUERY +=  RetSqlName("ZAW")+" ZAW " + ", " + RetSqlName("ZAV")+" ZAV " 
	cQuery += " WHERE ZAW_FILIAL ='" + XFILIAL("ZAX") +"'"
	cQuery += " AND ZAV_FILIAL ='" + XFILIAL("ZAV") +"'"
	cQuery += " AND ZAW_CDRAMI = ZAV_CODIGO "
	cQuery += " AND ZAV_TPFLAG <> '1' "
	cQuery += " AND ZAW_CDRAMI IN (" + "'" + M->C5_ZRAMI1 + "'"  

	If !empty(M->C5_ZRAMI2)
		cQuery += ", " + "'" + M->C5_ZRAMI2 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI3)
		cQuery += ", " + "'" + M->C5_ZRAMI3 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI4)
		cQuery += ", " + "'" + M->C5_ZRAMI4 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI5)
		cQuery += ", " + "'" + M->C5_ZRAMI5 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI6)
		cQuery += ", " + "'" + M->C5_ZRAMI6 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI7)
		cQuery += ", " + "'" + M->C5_ZRAMI7 + "'" 
	endif							
	If !empty(M->C5_ZRAMI8)
		cQuery += ", " + "'" + M->C5_ZRAMI8 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI9)
		cQuery += ", " + "'" + M->C5_ZRAMI9 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI10)
		cQuery += ", " + "'" + M->C5_ZRAMI10 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI11)
		cQuery += ", " + "'" + M->C5_ZRAMI11 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI12)
		cQuery += ", " + "'" + M->C5_ZRAMI12 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI13)
		cQuery += ", " + "'" + M->C5_ZRAMI13 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI14)
		cQuery += ", " + "'" + M->C5_ZRAMI14 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI15)
		cQuery += ", " + "'" + M->C5_ZRAMI15 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI16)
		cQuery += ", " + "'" + M->C5_ZRAMI16 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI17)
		cQuery += ", " + "'" + M->C5_ZRAMI17 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI18)
		cQuery += ", " + "'" + M->C5_ZRAMI18 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI19)
		cQuery += ", " + "'" + M->C5_ZRAMI19 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI20)
		cQuery += ", " + "'" + M->C5_ZRAMI20 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI21)
		cQuery += ", " + "'" + M->C5_ZRAMI21 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI22)
		cQuery += ", " + "'" + M->C5_ZRAMI22 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI23)
		cQuery += ", " + "'" + M->C5_ZRAMI23 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI24)
		cQuery += ", " + "'" + M->C5_ZRAMI24 + "'" 
	endif								 
	If !empty(M->C5_ZRAMI25)
		cQuery += ", " + "'" + M->C5_ZRAMI25 + "'" 
	endif								 

	cQuery += ")"

	cQuery += " AND ZAW_CDPROD ='" +  acols[n][nPosProd] +"'"
	cQuery += " AND ZAW.D_E_L_E_T_<> '*' "
	cQuery += " AND ZAV.D_E_L_E_T_<> '*' "

	cQuery := ChangeQuery(cQuery)

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasTotal, .F., .T.)


	If (cAliasTotal)->(!EOF())
		nTotal := (cAliasTotal)->QTD
	Endif

Return nTotal

//-----------------------------------------------------------
// Verifica se cliente e estrangeiro
//-----------------------------------------------------------
static function isForeign( cCodCli, cLojaCli )
	local lRet		:= .F.
	local cQrySA1	:= ""
	local aArea		:= getArea()

	cQrySA1 := "SELECT A1_COD, A1_LOJA"									+ CRLF
	cQrySA1 += " FROM " + retSQLName("SA1") + " SA1"					+ CRLF	
	cQrySA1 += " WHERE"													+ CRLF
	cQrySA1 += " 		SA1.A1_LOJA		=	'" + cLojaCli		+ "'"	+ CRLF
	cQrySA1 += " 	AND	SA1.A1_COD		=	'" + cCodCli		+ "'"	+ CRLF
	cQrySA1 += " 	AND	SA1.A1_TIPO		=	'X'"						+ CRLF
	cQrySA1 += " 	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1")	+ "'"	+ CRLF
	cQrySA1 += " 	AND	SA1.D_E_L_E_T_	<>	'*'"						+ CRLF

	TcQuery cQrySA1 New Alias "QRYSA1"

	if !QRYSA1->(EOF())
		lRet := .T.
	endif

	QRYSA1->(DBCloseArea())

	restArea( aArea )
return lRet


