#ifdef SPANISH
	#define STR0001 "Registro est� sendo utilizado pelo usu�rio: "
#else
	#ifdef ENGLISH
		#define STR0001 "Registro est� sendo utilizado pelo usu�rio: "
	#else
		Static STR0001 := "Registro est� sendo utilizado pelo usu�rio: "
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Registro est� sendo utilizado pelo usu�rio: "
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
