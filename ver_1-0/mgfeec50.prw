#include 'protheus.ch'

user function MGFEEC50()
	Local cParam 	:= If(Type("ParamIxb") = "A",ParamIxb[1],If(Type("ParamIxb") = "C",ParamIxb,""))
	Local cAliasSD2 := GetNextAlias()
	Local cPreemb	:= ""
	
	If 	IsInCallStack("EECAE100") .and. cParam ==  "PE_EXC"
	
		cPreemb := Alltrim(EEC->EEC_PREEMB)
	
		BeginSQl Alias cAliasSD2
			SELECT R_E_C_N_O_ RECSD2
			FROM %Table:SD2%
			WHERE 	%NotDel% AND
					D2_FILIAL = %xFilial:SD2% AND
					D2_DOC <> ' ' AND
					D2_SERIE <> ' ' AND
					D2_PREEMB = %Exp:cPreemb%
		EndSQL
		
		While !(cAliasSD2)->(Eof())
			DbSelectArea("SD2")
			SD2->(DbGoto((cAliasSD2)->RECSD2))
			RecLock("SD2",.F.)
			SD2->D2_PREEMB	:= " "
			SD2->(MsUnlock())
			(cAliasSD2)->(DbSkip())
		EndDo
	
	EndIf
return