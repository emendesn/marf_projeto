#ifdef SPANISH
	#define STR0001 "Total de la Pagina"
#else
	#ifdef ENGLISH
		#define STR0001 "Page total     "
	#else
		Static STR0001 := "Total da Pagina"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Total Da Página"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
