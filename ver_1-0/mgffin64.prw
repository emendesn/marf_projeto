#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

user function MGFFIN64()
	local aArea		:= getArea()
	local aAreaSA2	:= SA2->(getArea())
	local cA2Tipo	:= ""

	cA2Tipo := POSICIONE("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_TIPO")

	restArea(aAreaSA2)
	restArea(aArea)
return PICPES(cA2Tipo)