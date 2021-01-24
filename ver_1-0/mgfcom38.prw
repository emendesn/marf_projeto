/*
=====================================================================================
Programa.:              MGFCOM38
Autor....:              Atilio Amarilla
Data.....:              09/10/2017
Descricao / Objetivo:   SC e PV. Rateio por valor.
Doc. Origem:
Solicitante:            Cliente
Uso......:              Marfrig - GAP COM055
Obs......:              Chamado por gatilho, CX_PERC, CH_PERC, CX_ZVALRAT, CH_ZVALRAT
=====================================================================================
*/
User Function MGFCOM38()
	
	Local nRet		:= 0
	Local nPosPer, nPosVal, nX, nDec, nPosTot
	Local nLen		:= Len( aCols )
	Local nValTot	:= nValPar	:= 0
	Local lCalc		:= .T.
	/*
	=====================================================================================
	GAP COM055 - Atualiza??o referente a rateio por valor
	=====================================================================================
	*/
	// 26/10/2017 - Desativado rasteio em SC
	/*
	If AllTrim(ReadVar()) == "M->CX_ZVALRAT"
		
		nPosPer	:= aScan(aHeader,{|x| Alltrim(x[2])=="CX_PERC"})
		nPosVal	:= aScan(aHeader,{|x| Alltrim(x[2])=="CX_ZVALRAT"})
		nDec	:= TamSX3("CX_PERC")[2]
		
		For nX := 1 to nLen
			If !aCols[nX,Len(aHeader)+1]
				If aCols[nX,nPosVal] > 0
					nValTot += aCols[nX,nPosVal]
				Else
					lCalc	:= .F.
				EndIf
			EndIf
		Next nX
		
		If lCalc
			For nX := 1 to nLen
				If !aCols[nX,Len(aHeader)+1]
					If nX == nLen
						aCols[nX,nPosPer]	:= 100	- nValPar
					Else
						aCols[nX,nPosPer]	:= Round( 100 * aCols[nX,nPosVal] / nValTot , nDec )
					EndIf
					
					If nX == n
						nRet	:= aCols[nX,nPosPer]
					EndIf
					
					nValPar +=  aCols[nX,nPosPer]
				EndIf
			Next nX
		EndIf
		
	ElseIf AllTrim(ReadVar()) == "M->CX_PERC"
		
		nPosVal	:= aScan(aHeader,{|x| Alltrim(x[2])=="CX_ZVALRAT"})
		
		For nX := 1 to nLen
			aCols[nX,nPosVal] := 0
		Next nX
		
		nRet	:= 0
		
	ElseIf AllTrim(ReadVar()) == "M->CH_ZVALRAT"
	*/
	If AllTrim(ReadVar()) == "M->CH_ZVALRAT"
		
		nPosPer	:= aScan(aHeader,{|x| Alltrim(x[2])=="CH_PERC"})
		nPosVal	:= aScan(aHeader,{|x| Alltrim(x[2])=="CH_ZVALRAT"})
		nDec	:= TamSX3("CH_PERC")[2]
		
		nPosTot	:= aScan(aOrigHeader,{|x| Alltrim(x[2])=="C7_TOTAL"})
		nValIte := aOrigAcols[nOrigN,nPosTot]
		
		For nX := 1 to nLen
			If !aCols[nX,Len(aHeader)+1]
				If aCols[nX,nPosVal] > 0
					nValTot += aCols[nX,nPosVal]
				Else
					lCalc	:= .F.
				EndIf
			EndIf
		Next nX
		
		If lCalc
			
			For nX := 1 to nLen
				If !aCols[nX,Len(aHeader)+1]
					If nX == nLen  .And. nValIte == nValTot
						aCols[nX,nPosPer]	:= 100	- nValPar
					Else
						aCols[nX,nPosPer]	:= Round( 100 * aCols[nX,nPosVal] / nValIte , nDec )
					EndIf
					
					If nX == n
						nRet	:= aCols[nX,nPosPer]
					EndIf
					
					nValPar +=  aCols[nX,nPosPer]
				EndIf
			Next nX
		EndIf
		
	ElseIf AllTrim(ReadVar()) == "M->CH_PERC"
		
		nPosPer	:= aScan(aHeader,{|x| Alltrim(x[2])=="CH_PERC"})
		nPosVal	:= aScan(aHeader,{|x| Alltrim(x[2])=="CH_ZVALRAT"})
		nDec	:= TamSX3("CH_PERC")[2]
		
		nPosTot	:= aScan(aOrigHeader,{|x| Alltrim(x[2])=="C7_TOTAL"})
		nValIte := aOrigAcols[nOrigN,nPosTot]
		
		aCols[N,nPosVal] := Round( aCols[N,nPosPer] * nValIte / 100  , nDec )
		
		For nX := 1 to nLen
			If !aCols[nX,Len(aHeader)+1]
				If aCols[nX,nPosPer] > 0
					nValPar += aCols[nX,nPosPer]
				Else
					lCalc	:= .F.
				EndIf
			EndIf
		Next nX
		
		If lCalc .And. nValPar == 100
			nValPar := 0
			For nX := 1 to nLen
				If !aCols[nX,Len(aHeader)+1]
					If nX == nLen
						aCols[nX,nPosVal]	:= nValIte	- nValPar
					Else
						aCols[nX,nPosVal] := Round( aCols[nX,nPosPer] * nValIte / 100  , nDec )
						nValPar	+= aCols[nX,nPosVal]
					EndIf
				EndIf
			Next nX
		EndIf

		nRet	:= aCols[N,nPosVal]
		
	ElseIf AllTrim(ReadVar()) == "M->DE_ZVALRAT"
		
		nPosPer	:= aScan(aHeader,{|x| Alltrim(x[2])=="DE_PERC"})
		nPosVal	:= aScan(aHeader,{|x| Alltrim(x[2])=="DE_ZVALRAT"})
		nDec	:= TamSX3("DE_PERC")[2]
		
		nPosTot	:= aScan(aOrigHeader,{|x| Alltrim(x[2])=="D1_TOTAL"})
		nValIte := aOrigAcols[nOrigN,nPosTot]
		
		For nX := 1 to nLen
			If !aCols[nX,Len(aHeader)+1]
				If aCols[nX,nPosVal] > 0
					nValTot += aCols[nX,nPosVal]
				Else
					lCalc	:= .F.
				EndIf
			EndIf
		Next nX
		
		If lCalc
			
			For nX := 1 to nLen
				If !aCols[nX,Len(aHeader)+1]
					If nX == nLen  .And. nValIte == nValTot
						aCols[nX,nPosPer]	:= 100	- nValPar
					Else
						aCols[nX,nPosPer]	:= Round( 100 * aCols[nX,nPosVal] / nValIte , nDec )
					EndIf
					
					If nX == n
						nRet	:= aCols[nX,nPosPer]
					EndIf
					
					nValPar +=  aCols[nX,nPosPer]
				EndIf
			Next nX
		EndIf
		
	ElseIf AllTrim(ReadVar()) == "M->DE_PERC"
		
		nPosPer	:= aScan(aHeader,{|x| Alltrim(x[2])=="DE_PERC"})
		nPosVal	:= aScan(aHeader,{|x| Alltrim(x[2])=="DE_ZVALRAT"})
		nDec	:= TamSX3("DE_PERC")[2]
		
		nPosTot	:= aScan(aOrigHeader,{|x| Alltrim(x[2])=="D1_TOTAL"})
		nValIte := aOrigAcols[nOrigN,nPosTot]
		
		aCols[N,nPosVal] := Round( aCols[N,nPosPer] * nValIte / 100  , nDec )
		
		For nX := 1 to nLen
			If !aCols[nX,Len(aHeader)+1]
				If aCols[nX,nPosPer] > 0
					nValPar += aCols[nX,nPosPer]
				Else
					lCalc	:= .F.
				EndIf
			EndIf
		Next nX
		
		If lCalc .And. nValPar == 100
			nValPar := 0
			For nX := 1 to nLen
				If !aCols[nX,Len(aHeader)+1]
					If nX == nLen
						aCols[nX,nPosVal]	:= nValIte	- nValPar
					Else
						aCols[nX,nPosVal] := Round( aCols[nX,nPosPer] * nValIte / 100  , nDec )
						nValPar	+= aCols[nX,nPosVal]
					EndIf
				EndIf
			Next nX
		EndIf

		nRet	:= aCols[N,nPosVal]
		
	Else
		
		nRet	:= 0
		
	EndIf
	
Return nRet