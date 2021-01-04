#ifdef SPANISH
	#define STR0001 "Archivo de Municipios"
	#define STR0002 "Este municipio no podra borrarse por estar relacionado a solicitudes de viajes."
#else
	#ifdef ENGLISH
		#define STR0001 "Municipalities File"
		#define STR0002 "This municipality can not be excluded as it is related to trip request."
	#else
		Static STR0001 := "Cadastro de Municipios"
		Static STR0002 := "Este municipio n�o poder� ser excluido por estar relacionado a solicita��es de viagens."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0001 := "Cadastro de Concelhos"
			STR0002 := "Este concelho n�o poder� ser exclu�do por estar relacionado a solicita��es de viagens."
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Cadastro de Concelhos"
			STR0002 := "Este concelho n�o poder� ser exclu�do por estar relacionado a solicita��es de viagens."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
