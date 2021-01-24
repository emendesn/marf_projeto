#ifdef SPANISH
	#define STR0001 "Previdência Social"
#else
	#ifdef ENGLISH
		#define STR0001 "Previdência Social"
	#else
		Static STR0001 := "Previdência Social"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0001 := "Previdência Social"
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Previdência Social"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
