#ifdef SPANISH
	#define STR0001 "Elija Estandares"
	#define STR0002 "Marca Todos"
	#define STR0003 "Desmarca Todos"
	#define STR0004 "Invierte Seleccion"
		#define STR0005  "Composicao ja existente na estrutura"
		#define STR0006	 "Atenção"
#else
	#ifdef ENGLISH
		#define STR0001 "Select Standards"
		#define STR0002 "Mark All"
		#define STR0003 "Unmark All"
		#define STR0004 "Invert Selection"
		#define STR0005  "Composicao ja existente na estrutura"
		#define STR0006	 "Atenção"
	#else
		Static STR0001 := "Escolha Padröes"
		#define STR0002  "Marca Todos"
		#define STR0003  "Desmarca Todos"
		Static STR0004 := "Inverte Seleçäo"
		#define STR0005  "Composicao ja existente na estrutura"
		#define STR0006	 "Atenção"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0001 := "Escolher Padrões"
			STR0004 := "Inverter Selecção"
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Escolher Padrões"
			STR0004 := "Inverter Selecção"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
