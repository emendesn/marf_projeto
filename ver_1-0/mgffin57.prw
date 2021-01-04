#include 'Protheus.ch'

/*
=====================================================================================
Programa............: MGFFIN57
Autor...............: Mauricio Gresele
Data................: Agosto/2017
Descricao / Objetivo: Rotina chamada pelo ponto de entrada F050ALT
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/     
User Function MGFFIN57()

Local nOpca := ParamIxb[1]
Local nValCod := 0
Local nValDif := 0
Local nToler := 0.05

If nOpca == 1 // confirmou a gravacao
	If (!Empty(SE2->E2_CODBAR) .and. Len(Alltrim(SE2->E2_CODBAR)) == 44) .or. (!Empty(SE2->E2_LINDIG) .and. Len(Alltrim(SE2->E2_LINDIG)) > 44)
		If !Empty(SE2->E2_CODBAR)
			nValCod := Val(Subs(SE2->E2_CODBAR,10,10))/100
		Else
			nValCod := Val(Right(SE2->E2_LINDIG,10))/100
		Endif
		
		// se valor do codigo de barras estah zerado, grava titulo como contra-apresentacao
		If nValCod == 0 .and. SE2->E2_ZCONTRA != "2"
			SE2->(RecLock("SE2",.F.))
			SE2->E2_ZCONTRA := "2"
			SE2->(MsUnLock())
		Endif
		
		// se valor do codigo de barras nao estah zerado, retira titulo de contra-apresentacao
		If nValCod != 0 .and. SE2->E2_ZCONTRA == "2"
			SE2->(RecLock("SE2",.F.))
			SE2->E2_ZCONTRA := ""
			SE2->(MsUnLock())
		Endif
		
		If nValCod != 0					
			If nValCod < SE2->E2_SALDO
				nValDif	:= nValCod-SE2->E2_SALDO
				If nValDif != 0 .and. Abs(nValDif) <= nToler
					SE2->(RecLock("SE2",.F.)) 
					SE2->E2_DECRESC := IIf(SE2->E2_DECRESC <= nToler,Abs(nValDif),SE2->E2_DECRESC + Abs(nValDif))
					SE2->E2_SDDECRE := SE2->E2_DECRESC
					SE2->(MsUnLock())
				Endif	
			Elseif nValCod > SE2->E2_SALDO
				nValDif	:= nValCod-SE2->E2_SALDO
				If nValDif != 0 .and. Abs(nValDif) <= nToler
					SE2->(RecLock("SE2",.F.)) 
					SE2->E2_ACRESC := IIf(SE2->E2_ACRESC <= nToler,Abs(nValDif),SE2->E2_ACRESC + Abs(nValDif))
					SE2->E2_SDACRES := SE2->E2_ACRESC
					SE2->(MsUnLock())
				Endif	
			Endif
		Endif
	Endif
	
	/*
	// se excluir o codigo de barras e tiver algum acres/descres proveniente deste ajuste, limpa este acres/descres
	If Empty(SE2->E2_CODBAR) .and. Empty(SE2->E2_LINDIG)
		If (!Empty(SE2->E2_DECRESC) .and. SE2->E2_DECRESC <= nToler) .or. (!Empty(SE2->E2_ACRESC) .and. SE2->E2_ACRESC <= nToler) 
			SE2->(RecLock("SE2",.F.)) 
			If (!Empty(SE2->E2_DECRESC) .and. SE2->E2_DECRESC <= nToler)
				SE2->E2_DECRESC := 0
				SE2->E2_SDDECRE := SE2->E2_DECRESC
			Endif	
			If (!Empty(SE2->E2_ACRESC) .and. SE2->E2_ACRESC <= nToler)
				SE2->E2_ACRESC := 0
				SE2->E2_SDACRES := SE2->E2_ACRESC
			Endif	
			SE2->(MsUnLock())
		Endif
	Endif
	*/
Endif			
	
Return()