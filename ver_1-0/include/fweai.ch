#ifdef SPANISH
	#define STR0001 "Nao � uma transa��o EAI v�lida"
#else
	#ifdef ENGLISH
		#define STR0001 "Nao � uma transa��o EAI v�lida"
	#else
		Static STR0001 := "Nao � uma transa��o EAI v�lida"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Nao � uma transa��o EAI v�lida"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
