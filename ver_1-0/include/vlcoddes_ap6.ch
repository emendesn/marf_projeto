#ifdef SPANISH
	#define STR0001 "Colaborador no tiene permiso para utilizar este gasto."
	#define STR0002 "Codigo de Gasto no Registrado"
	#define STR0003 "Atencion"
#else
	#ifdef ENGLISH
		#define STR0001 "Collaborator is not allowed to use this expense."
		#define STR0002 "Registered expense code"
		#define STR0003 "Attention"
	#else
		#define STR0001  "Colaborador n�o possui permiss�o para utilizar essa despesa."
		Static STR0002 := "C�digo de Despesa n�o Cadastrado"
		#define STR0003  "Aten��o"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0002 := "C�digo de despesa n�o registado"
		ElseIf cPaisLoc == "PTG"
			STR0002 := "C�digo de despesa n�o registado"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
