#include 'protheus.ch'
#include 'parmtype.ch'

user function MT120RCC()

	Local aHeaerSCH := PARAMIXB[1]	
	Local aColsSCH	:= PARAMIXB[2]
	
	Local nPosValR := aScan(aHeaerSCH,{|x| Alltrim(x[2]) == "CH_ZVALRAT"})
	Local nPosPerc := aScan(aHeaerSCH,{|x| Alltrim(x[2]) == "CH_PERC"})
	
	Local nTotPed  := aScan(aHeader,{|x| Alltrim(x[2]) == "C7_TOTAL"})
	
	Local nZ 	   := 0
	
	If aCols[n][nTotPed] > 0
		If Len(aColsSCH) > 0
			For nZ := 1 to Len(aColsSCH)
				aColsSCH[nZ][nPosValR] := (aColsSCH[nZ][nPosPerc]/100) * aCols[n][nTotPed]
			Next nZ
		EndIf
	EndIf
	
return aColsSCH