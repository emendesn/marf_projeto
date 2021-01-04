#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFEEC62
Autor...............: Rafael Garcia 	
Data................: Nov/2018
Descricao / Objetivo: Rotina chamada pelo ponto de entrada EECAE100
Doc. Origem.........: Comex
Solicitante.........: Cliente
Uso.................: 
Obs.................: Validar cancelamento de embarquet1004717
=====================================================================================
*/
User Function MGFEEC62(aParam)
	local lRet:= .t.
	Local aArea     := GetArea()
	Local aAreaEET  := EET->(GetArea())
	If IsInCallStack("EECAE100") .and. alltrim(aParam[1]) == "PE_EXC"  
		if nRadio == 1
			RECLOCK("EEC",.F.) 
				EEC->EEC_ZUCANC:= ALLTRIM(UsrFullName(RetCodUsr()))
			EEC->(MsUnlock())
		elseif nRadio ==2
			DBSELECTAREA("EET")
			DBSETORDER(1)
			IF DBSEEK(XFILIAL("EET")+alltrim(aParam[2]))
				Help( ,, 'Help',, 'Este processo possui despesas lan�adas no financeiro, nao pode ser eliminado. Favor entrar em contato com depto financeiro.', 1, 0 )
				lRet := .f.
			ELSE
				RECLOCK("EEC",.F.)
					EEC->EEC_ZUELIM:=  ALLTRIM(UsrFullName(RetCodUsr()))
				EEC->(MsUnlock())	
			ENDIF	
		endif	
	endif
	RestArea(aArea)
	RestArea(aAreaEET)
Return(lRet)