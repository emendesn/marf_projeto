#ifdef SPANISH
	#define STR0001 "Procesando..."
	#define STR0002 "Espere"
#else
	#ifdef ENGLISH
		#define STR0001 "Processing..."
		#define STR0002 "Please, wait"
	#else
		Static STR0001 := "Processando..."
		#define STR0002  "Aguarde"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "A processar..."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
