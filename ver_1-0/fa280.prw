#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

user function FA280()
	local nRecOrig	:= PARAMIXB
	local cFatura	:= SE1->E1_NUM
	local cFatPref	:= SE1->E1_PREFIXO
	local cTipoFat	:= SE1->E1_TIPO
	local aArea		:= getArea()
	local aAreaSE1	:= SE1->(getArea())

	SE1->(DBGoTo(nRecOrig))

	recLock("SE1", .F.)
		SE1->E1_FATURA	:= cFatura
		SE1->E1_FATPREF	:= cFatPref
		SE1->E1_TIPOFAT	:= cTipoFat
	SE1->(msUnlock())

	restArea(aAreaSE1)
	restArea(aArea)
return