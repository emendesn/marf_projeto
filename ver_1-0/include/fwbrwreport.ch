#ifdef SPANISH
	#define STR0001 "Listagem do Browse"
	#define STR0002 "Imprime a listagem dos itens disponíveis no Browse"
	#define STR0003 "Total "
#else
	#ifdef ENGLISH
		#define STR0001 "Listagem do Browse"
		#define STR0002 "Imprime a listagem dos itens disponíveis no Browse"
		#define STR0003 "Total "
	#else
		Static STR0001 := "Listagem do Browse"
		Static STR0002 := "Imprime a listagem dos itens disponíveis no Browse"
		Static STR0003 := "Total "
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Listagem do Browse"
			STR0002 := "Imprime a listagem dos itens disponíveis no Browse"
			STR0003 := "Total "
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
