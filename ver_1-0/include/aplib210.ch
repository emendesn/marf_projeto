#ifdef SPANISH
	#define STR0001 "Problemas con archivo de LOG"
#else
	#ifdef ENGLISH
		#define STR0001 "Problems with Log File"
	#else
		Static STR0001 := "Problemas com arquivo de LOG"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Problemas Com Ficheiro De Diário"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
