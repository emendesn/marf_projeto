#ifdef SPANISH
	#define STR0001 "Total de Registros Impresos"
	#define STR0002 "¿Imprimir informe Personalizable ?"
#else
	#ifdef ENGLISH
		#define STR0001 "Total records printed "
		#define STR0002 "Print customizable report?"
	#else
		Static STR0001 := "Total de Registros Impressos"
		Static STR0002 := "Imprimir relatório Personalizável ?"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Total De Registos Impressos"
			STR0002 := "Imprimir relatório personalizável ?"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
