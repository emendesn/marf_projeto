#ifdef SPANISH
	#define STR0001 "Legenda"
#else
	#ifdef ENGLISH
		#define STR0001 "Legenda"
	#else
		Static STR0001 := "Legenda"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Legenda"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
