#ifdef SPANISH
	#define STR0001 "Numero de agentes enseãndo no es suficiente. Proceso cancelado."
#else
	#ifdef ENGLISH
		#define STR0001 "Number of started agents insuficcient. Grid process aborted."
	#else
		Static STR0001 := "Numero de agentes inicializados insuficiente. Grid cancelado."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Número de agentes iniciados insuficiente. grid cancelado."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
