#ifdef SPANISH
	#define STR0001 "Esta transa��o n�o pode ser processada novamente."
	#define STR0002 "Atencion"
	#define STR0003 "Esta transa��o n�o pode ser bloqueada."
#else
	#ifdef ENGLISH
		#define STR0001 "Esta transa��o n�o pode ser processada novamente."
		#define STR0002 "Attention"
		#define STR0003 "Esta transa��o n�o pode ser bloqueada."
	#else
		Static STR0001 := "Esta transa��o n�o pode ser processada novamente."
		Static STR0002 := "Aten��o"
		Static STR0003 := "Esta transa��o n�o pode ser bloqueada."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Esta transa��o n�o pode ser processada novamente."
			STR0002 := "Aten��o"
			STR0003 := "Esta transa��o n�o pode ser bloqueada."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
