#ifdef SPANISH
	#define STR0001 "Bienvenido..."
	#define STR0002 "<< &Volver"
	#define STR0003 "&Avanzar >>"
	#define STR0004 "&Anular"
	#define STR0005 "&Finalizar"
	#define STR0006 "Titulo"
	#define STR0007 "Mensaje"
#else
	#ifdef ENGLISH
		#define STR0001 "Welcome..."
		#define STR0002 "<< &Back"
		#define STR0003 "&Next >>"
		#define STR0004 "&Cancel"
		#define STR0005 "&Finish"
		#define STR0006 "Header"
		#define STR0007 "Message"
	#else
		#define STR0001  "Bem-vindo..."
		Static STR0002 := "<< &Voltar"
		#define STR0003  "&Avançar >>"
		Static STR0004 := "&Cancelar"
		Static STR0005 := "&Finalizar"
		#define STR0006  "Título"
		#define STR0007  "Mensagem"
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
			STR0004 := "&cancelar"
			STR0005 := "&finalizar"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
