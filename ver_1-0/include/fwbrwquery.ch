#ifdef SPANISH
	#define STR0001 "Índice "
	#define STR0002 " não definido para a Query !!!"
	#define STR0003 "A quantidade de registros é superior ao limite definido para abertura da QUERY no Browse."
#else
	#ifdef ENGLISH
		#define STR0001 "Índice "
		#define STR0002 " não definido para a Query !!!"
		#define STR0003 "A quantidade de registros é superior ao limite definido para abertura da QUERY no Browse."
	#else
		Static STR0001 := "Índice "
		Static STR0002 := " não definido para a Query !!!"
		Static STR0003 := "A quantidade de registros é superior ao limite definido para abertura da QUERY no Browse."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Índice "
			STR0002 := " não definido para a Query !!!"
			STR0003 := "A quantidade de registros é superior ao limite definido para abertura da QUERY no Browse."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
