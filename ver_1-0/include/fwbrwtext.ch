#ifdef SPANISH
	#define STR0001 "O arquivo "
	#define STR0002 " não foi localizado !!!"
#else
	#ifdef ENGLISH
		#define STR0001 "O arquivo "
		#define STR0002 " não foi localizado !!!"
	#else
		Static STR0001 := "O arquivo "
		Static STR0002 := " não foi localizado !!!"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "O arquivo "
			STR0002 := " não foi localizado !!!"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
