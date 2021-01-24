#ifdef SPANISH
	#define STR0001 "Bienvenido..."
	#define STR0002 "<< &Regresar"
	#define STR0003 "&Avanzar >>"
	#define STR0004 "&Anular"
	#define STR0005 "&Finalizar"
#else
	#ifdef ENGLISH
		#define STR0001 "Welcome..."
		#define STR0002 "<< &Back"
		#define STR0003 "&Forward >>"
		#define STR0004 "&Cancel"
		#define STR0005 "&Conclude"
	#else
		#define STR0001  "Bem-vindo..."
		Static STR0002 := "<< &Voltar"
		Static STR0003 := "&Avancar >>"
		Static STR0004 := "&Cancelar"
		Static STR0005 := "&Finalizar"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0002 := "<< Voltar"
			STR0003 := "&avançar >>"
			STR0004 := "&cancelar"
			STR0005 := "&finalizar"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
