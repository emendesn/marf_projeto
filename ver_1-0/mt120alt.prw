#Include "Totvs.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"

//
/*/{Protheus.doc} MT120ALT
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MT120ALT()
	Local  aArea	:= 	GetArea ()
	Local lExecuta  := .T.

	If findfunction("U_MGFTAE03")
		lExecuta := U_MGFTAE03()
	Endif

	If lExecuta
		If findfunction("U_MGFCOM81")
			lExecuta := U_MGFCOM81()
		Endif
	EndIf


	If lExecuta
		If findfunction("U_MGFCOM89")
			lExecuta := U_MGFCOM89()
		Endif
	EndIf

	// Tratamento MERCADO ELETRONICO
	If findfunction("U_MGFALME") 
		lExecuta := U_MGFALME()
	Endif 

	RestArea (aArea)
Return lExecuta
