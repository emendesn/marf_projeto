#ifdef SPANISH
	#define STR0001 "Registro está sendo utilizado pelo usuário: "
#else
	#ifdef ENGLISH
		#define STR0001 "Registro está sendo utilizado pelo usuário: "
	#else
		Static STR0001 := "Registro está sendo utilizado pelo usuário: "
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Registro está sendo utilizado pelo usuário: "
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
