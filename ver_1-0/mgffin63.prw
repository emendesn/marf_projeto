#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

user function MGFFIN63()
	local nRetFin63 := 0

If Type("INCLUI")<> "U" .And. !INCLUI
		if !(( ROUND(E2_SALDO,2) = 0 .AND. (EMPTY(E2_ZNEXGRD) .and. !(EMPTY(E2_ZCODGRD))) ) .or. (ROUND(E2_SALDO,2) = 0 .AND. E2_TIPO == "NDF"))
			nRetFin63 := SE2->( E2_SALDO-E2_PIS-E2_COFINS-E2_CSLL-E2_SDDECRE-E2_ZTXBOL+E2_ZJURBOL+E2_SDACRES-E2_XDESCO )
		endif
EndIf
return nRetFin63