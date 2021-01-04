#ifdef SPANISH
	#define STR0001 "Archivo de Hoteles"
	#define STR0002 "Este Hotel no podra borrarse por estar relacionado la solicitudes de viaje."
#else
	#ifdef ENGLISH
		#define STR0001 "Hotels File"
		#define STR0002 "This Hotel can not be excluded as it is related to trip request."
	#else
		Static STR0001 := "Cadastro de Hoteis"
		Static STR0002 := "Este Hotel n�o poder� ser excluido por estar relacionado a solicita��es de viagens."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0001 := "Cadastro de Hot�is"
			STR0002 := "Este hotel n�o poder� ser exclu�do por estar relacionado a solicita��es de viagens."
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Cadastro de Hot�is"
			STR0002 := "Este hotel n�o poder� ser exclu�do por estar relacionado a solicita��es de viagens."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
