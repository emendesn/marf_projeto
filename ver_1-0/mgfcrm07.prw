#include "totvs.ch"
#include "protheus.ch"

// chamado pelo PE FTMSREL
user function MGFCRM07(aRet)

	aadd( aRet, { "ZAV", { "ZAV_CODIGO" }, { || ZAV->ZAV_CODIGO } } )

return aRet//a