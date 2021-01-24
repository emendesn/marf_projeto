#ifdef SPANISH
	#define STR0001 "Transação não executada"
	#define STR0002 "Adapter EAI"
	#define STR0003 "Parametro nType invalido!!!"
	#define STR0004 "encontrada referência na tabela:"
	#define STR0005 "Modelo não autorizado"
#else
	#ifdef ENGLISH
		#define STR0001 "Transação não executada"
		#define STR0002 "Adapter EAI"
		#define STR0003 "Parametro nType invalido!!!"
		#define STR0004 "encontrada referência na tabela:"
		#define STR0005 "Modelo não autorizado"
	#else
		Static STR0001 := "Transação não executada"
		Static STR0002 := "Adapter EAI"
		Static STR0003 := "Parametro nType invalido!!!"
		Static STR0004 := "encontrada referência na tabela:"
		Static STR0005 := "Modelo não autorizado"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Transação não executada"
			STR0002 := "Adapter EAI"
			STR0003 := "Parametro nType invalido!!!"
			STR0004 := "encontrada referência na tabela:"
			STR0005 := "Modelo não autorizado"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
