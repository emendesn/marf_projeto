#ifdef SPANISH
	#define STR0001 "Elija Estandares"
	#define STR0002 "Marca Todos"
	#define STR0003 "Desmarca Todos"
	#define STR0004 "Invierte Seleccion"
		#define STR0005  "Composicao ja existente na estrutura"
		#define STR0006	 "Aten��o"
#else
	#ifdef ENGLISH
		#define STR0001 "Select Standards"
		#define STR0002 "Mark All"
		#define STR0003 "Unmark All"
		#define STR0004 "Invert Selection"
		#define STR0005  "Composicao ja existente na estrutura"
		#define STR0006	 "Aten��o"
	#else
		Static STR0001 := "Escolha Padr�es"
		#define STR0002  "Marca Todos"
		#define STR0003  "Desmarca Todos"
		Static STR0004 := "Inverte Sele��o"
		#define STR0005  "Composicao ja existente na estrutura"
		#define STR0006	 "Aten��o"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0001 := "Escolher Padr�es"
			STR0004 := "Inverter Selec��o"
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Escolher Padr�es"
			STR0004 := "Inverter Selec��o"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
