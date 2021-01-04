#include "protheus.ch"

/*
=====================================================================================
Programa.:              MGFFIN85
Autor....:              Totvs
Data.....:              Marco/2018
Descricao / Objetivo:   Funcao chamada pelo ponto de entrada F330AE5E
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
User Function MGFFIN85()

Local aArea := {SE5->(GetArea()),GetArea()}
//Local cHistDev := GetMv("MGF_TXTDEV",,"DEVOL - ")
Local cChave := ""
Local cSeq := ""
Local nRecnoNF := 0
Local nRecnoNCC := 0
Local nRecnoSE5 := 0
Local lNCC := .F.
Local cHist := ""
Local aTit := {}

If SE5->E5_TIPODOC == "ES"        
	cChave := SE5->E5_DOCUMEN
	cSeq := SE5->E5_SEQ

	// verifica se algum titulo envolvido na compensacao eh tipo NCC/RA 
	// verifica titulo posicionado
	If SE5->E5_TIPO == MV_CRNEG .or. SE5->E5_TIPO == MVRECANT
		If SE5->E5_TIPO == MV_CRNEG
			lNCC := .T. .AND. SE5->E5_TIPO != 'MAN' //Removido o cComplHist das NCC incluidas manualmente, conforme GAP 566
			cHist := GetMv("MGF_TXTDEV",,"DEVOL - ")
		Else
			lNCC := .F.
			cHist := GetMv("MGF_TXTADT",,"ADTO - ") 	
		Endif
				
		// verifica se NCC veio do mata100
		If IIf(lNCC,U_FIN84TitOri(SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_TIPO,SE5->E5_CLIFOR,SE5->E5_LOJA),.T.)
			If !Alltrim(cHist) $ Alltrim(SE5->E5_HISTOR) 
				SE5->(RecLock("SE5",.F.))
				SE5->E5_HISTOR := cHist+SE5->E5_HISTOR
				SE5->(MsUnLock())
			Endif	
				
			// verifica titulo compensado contra a NCC/RA
			aTit := U_FIN84BxNCC(cChave,cSeq,.F.,.T.,SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_LOJA)
			nRecnoNF := aTit[1]
			If nRecnoNF > 0
				SE5->(dbGoto(nRecnoNF))
				If SE5->(Recno()) == nRecnoNF
					If !Alltrim(cHist) $ Alltrim(SE5->E5_HISTOR) 
						SE5->(RecLock("SE5",.F.))
						SE5->E5_HISTOR := cHist+SE5->E5_HISTOR
						SE5->(MsUnLock())
					Endif	
				Endif
			Endif	
		Endif	
	// verifica o titulo NCC/RA
	Else
		aTit := U_FIN84BxNCC(cChave,cSeq,.T.,.T.,SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_LOJA)
		nRecnoNCC := aTit[1] 
		lNCC := aTit[2]
		If lNCC  .AND. SE5->E5_TIPO != 'MAN' //Removido o cComplHist das NCC incluidas manualmente, conforme GAP 566
			cHist := GetMv("MGF_TXTDEV",,"DEVOL - ")
		Else
			cHist := GetMv("MGF_TXTADT",,"ADTO - ") 	
		Endif
			If nRecnoNCC > 0	
			// guarda recno do titulo principal, para fazer a gravacao posteriormente
			nRecnoSE5 := SE5->(Recno())
			SE5->(dbGoto(nRecnoNCC))
			If SE5->(Recno()) == nRecnoNCC
				// verifica se NCC veio do mata100
				If IIf(lNCC,U_FIN84TitOri(SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_TIPO,SE5->E5_CLIFOR,SE5->E5_LOJA),.T.)
					If !Alltrim(cHist) $ Alltrim(SE5->E5_HISTOR) 
						SE5->(RecLock("SE5",.F.))
						SE5->E5_HISTOR := cHist+SE5->E5_HISTOR
						SE5->(MsUnLock())
					Endif	
                   
					// reposiciona titulo principal
					SE5->(dbGoto(nRecnoSE5))
					If SE5->(Recno()) == nRecnoSE5
						// grava o titulo atual
						If !Alltrim(cHist) $ Alltrim(SE5->E5_HISTOR) 
							SE5->(RecLock("SE5",.F.))
							SE5->E5_HISTOR := cHist+SE5->E5_HISTOR
							SE5->(MsUnLock())
						Endif	
					Endif
				Endif		
			Endif	
		Endif	
	Endif	
Endif		

aEval(aArea,{|x| RestArea(x)})

Return()