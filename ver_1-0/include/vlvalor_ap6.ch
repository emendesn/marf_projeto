#ifdef SPANISH
	#define STR0001 "¡Gasto no Registrado!"
	#define STR0002 "Atencion"
#else
	#ifdef ENGLISH
		#define STR0001 "Expense not registered !"
		#define STR0002 "Attention"
	#else
		Static STR0001 := "Despesa não Cadastrada !"
		#define STR0002  "Atenção"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0001 := "Despesa não registada !"
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Despesa não registada !"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
