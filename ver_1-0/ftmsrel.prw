#Include "Protheus.ch"

/*/{Protheus.doc} FTMSREL
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function FTMSREL()

	Local aRet	:= {}
	If FindFunction("u_MGFGCT07")
		U_MGFGCT07(@aRet)
	Endif
	If FindFunction("u_CRE24MSD")
		U_CRE24MSD(@aRet)
	Endif

	If FindFunction("u_MGFCRM07")
		U_MGFCRM07(@aRet)
	Endif
	If FindFunction("u_x1FTMSREL")
		u_x1FTMSREL(@aRet)
	Endif
	If FindFunction("u_MGEEC19")
		u_MGEEC19(@aRet)
	Endif

Return aRet
