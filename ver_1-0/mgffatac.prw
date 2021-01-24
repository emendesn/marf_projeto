#INCLUDE 'PROTHEUS.CH'

/*
===========================================================================================
Programa.:              MGFFATAC
Autor....:              Totvs
Data.....:              Out/2018
Descricao / Objetivo:   Rotina chamada pelo ponto de entrada CTSETFIL
Doc. Origem:            MIT044
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/
User Function MGFFATAC()

Local aFil := aClone(ParamIxb[1])
Local nCnt := 0
Local aFilNew := aClone(aFil) // garante retorno do array integro, no caso de nao ser a rotina U_MGFFATAC

If IsInCallStack('U_xMF07Vinc') .or. IsInCallStack('U_xjMF07Vinc') .or. IsInCallStack('U_xMF08Vinc')
	aFilNew := {}
	// somente filiais da empresa corrente
	For nCnt:=1 To Len(aFil)
		If Subs(aFil[nCnt][1],1,2) == Subs(cEmpAnt,1,2)
			aAdd(aFilNew,aFil[nCnt])
		Endif
	Next		
Endif
	
Return(aFilNew)