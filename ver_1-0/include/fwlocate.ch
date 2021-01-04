#ifdef SPANISH
	#define STR0001 "Localizar"
	#define STR0002 "Localizador"
	#define STR0003 "Opções"
	#define STR0004 "Considera Maiúsculas/minúsculas"
	#define STR0005 "A partir deste ponto"
#else
	#ifdef ENGLISH
		#define STR0001 "Localizar"
		#define STR0002 "Localizador"
		#define STR0003 "Opções"
		#define STR0004 "Considera Maiúsculas/minúsculas"
		#define STR0005 "A partir deste ponto"
	#else
		Static STR0001 := "Localizar"
		Static STR0002 := "Localizador"
		Static STR0003 := "Opções"
		Static STR0004 := "Considera Maiúsculas/minúsculas"
		Static STR0005 := "A partir deste ponto"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Localizar"
			STR0002 := "Localizador"
			STR0003 := "Opções"
			STR0004 := "Considera Maiúsculas/minúsculas"
			STR0005 := "A partir deste ponto"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
