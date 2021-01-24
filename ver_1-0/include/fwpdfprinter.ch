#ifdef SPANISH
	#define STR0001 " no puede ser generado"
#else
	#ifdef ENGLISH
		#define STR0001 " can't be created"
	#else
		Static STR0001 := " não pôde ser criado"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := " não pôde ser criado"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
