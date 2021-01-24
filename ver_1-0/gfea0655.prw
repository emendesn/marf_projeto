#include 'protheus.ch'
#include 'parmtype.ch'


User Function GFEA0655()

	Local aArea 	:= GetArea()
	Local aAreaGW3  := GW3->(Getarea())

    Local aDocFrete := ParamIXB[1]
    Local aItemDoc := ParamIXB[2]
    Local aRet := {}
    Local cNatur := GETMV("MV_NTFGFE")

 	Local nPosConta  :=	aScan(aItemDoc[1], {|x| Alltrim(x[1]) == 'D1_CONTA' 	})
	Local nPosItemC  := aScan(aItemDoc[1], {|x| Alltrim(x[1]) == 'D1_ITEMCTA' 	})

	Local ni := 1
   // cContaX:= ""
	For ni := 1 to Len(aItemDoc)
		//aDocFrete[21][2] := cNatur
		If !Empty(cContaX) //.and. nPosConta > 0// <> ' ' .OR. NIL
			aItemDoc[ni][nPosConta][2] := cContaX
		EndIf

		If !Empty(cItemx)  //.and. nPosItemC > 0// <> ' ' .OR. NIL
			aItemDoc[ni][nPosItemC][2] := cItemx
		EndIf
	Next ni

    Aadd(aRet, {aDocFrete, aItemDoc})

	Restarea(aAreaGW3)
	Restarea(aArea)

Return aRet
