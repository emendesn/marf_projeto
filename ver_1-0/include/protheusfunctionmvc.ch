#ifdef SPANISH
	#define STR0001 "Transa��o n�o executada"
	#define STR0002 "Adapter EAI"
	#define STR0003 "Parametro nType invalido!!!"
	#define STR0004 "encontrada refer�ncia na tabela:"
	#define STR0005 "Modelo n�o autorizado"
#else
	#ifdef ENGLISH
		#define STR0001 "Transa��o n�o executada"
		#define STR0002 "Adapter EAI"
		#define STR0003 "Parametro nType invalido!!!"
		#define STR0004 "encontrada refer�ncia na tabela:"
		#define STR0005 "Modelo n�o autorizado"
	#else
		Static STR0001 := "Transa��o n�o executada"
		Static STR0002 := "Adapter EAI"
		Static STR0003 := "Parametro nType invalido!!!"
		Static STR0004 := "encontrada refer�ncia na tabela:"
		Static STR0005 := "Modelo n�o autorizado"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Transa��o n�o executada"
			STR0002 := "Adapter EAI"
			STR0003 := "Parametro nType invalido!!!"
			STR0004 := "encontrada refer�ncia na tabela:"
			STR0005 := "Modelo n�o autorizado"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
