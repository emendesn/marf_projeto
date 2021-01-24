#ifdef SPANISH
	#define STR0001 "Nao é uma transação EAI válida"
#else
	#ifdef ENGLISH
		#define STR0001 "Nao é uma transação EAI válida"
	#else
		Static STR0001 := "Nao é uma transação EAI válida"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Nao é uma transação EAI válida"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
