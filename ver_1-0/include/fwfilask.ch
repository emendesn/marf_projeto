#ifdef SPANISH
	#define STR0001 "Filtro através de perguntas"
	#define STR0002 "Confirmar"
	#define STR0003 "Cancelar"
	#define STR0004 "Avançar"
#else
	#ifdef ENGLISH
		#define STR0001 "Filtro através de perguntas"
		#define STR0002 "Confirm"
		#define STR0003 "Cancel"
		#define STR0004 "Avançar"
	#else
		Static STR0001 := "Filtro através de perguntas"
		Static STR0002 := "Confirmar"
		Static STR0003 := "Cancelar"
		Static STR0004 := "Avançar"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Filtro através de perguntas"
			STR0002 := "Confirmar"
			STR0003 := "Cancelar"
			STR0004 := "Avançar"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
