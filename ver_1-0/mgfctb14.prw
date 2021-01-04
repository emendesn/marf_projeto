#INCLUDE 'PROTHEUS.CH'

/*
===========================================================================================
Programa.:              MGFCTB14
Autor....:              Mauricio Gresele
Data.....:              Fev/2018
Descricao / Objetivo:   Rotina chamada pelo ponto de entrada CTSETFIL
Doc. Origem:            MIT044
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
User Function MGFCTB14()

Local aFil := aClone(ParamIxb[1])
Local nCnt := 0
Local aFilNew := aClone(aFil) // garante retorno do array integro, no caso de nao ser a rotina U_MGFCTB06

If IsInCallStack("U_MGFCTB06")
	aFilNew := {}
	// somente filiais da empresa parametrizada na rotina 
	For nCnt:=1 To Len(aFil)
		If Subs(aFil[nCnt][1],1,2) == Alltrim(mv_par03)
			aAdd(aFilNew,aFil[nCnt])
		Endif
	Next		
Endif
	
Return(aFilNew)