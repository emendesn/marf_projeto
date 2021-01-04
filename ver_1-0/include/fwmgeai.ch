#ifdef SPANISH
	#define STR0001 "Esta transação não pode ser processada novamente."
	#define STR0002 "Atencion"
	#define STR0003 "Esta transação não pode ser bloqueada."
#else
	#ifdef ENGLISH
		#define STR0001 "Esta transação não pode ser processada novamente."
		#define STR0002 "Attention"
		#define STR0003 "Esta transação não pode ser bloqueada."
	#else
		Static STR0001 := "Esta transação não pode ser processada novamente."
		Static STR0002 := "Atenção"
		Static STR0003 := "Esta transação não pode ser bloqueada."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Esta transação não pode ser processada novamente."
			STR0002 := "Atenção"
			STR0003 := "Esta transação não pode ser bloqueada."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
