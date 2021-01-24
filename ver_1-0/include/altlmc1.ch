#ifdef SPANISH
	#define STR0001 "Mantenimiento de L.M.C."
#else
	#ifdef ENGLISH
		#define STR0001 "L.C.M. Maintenance"
	#else
		Static STR0001 := "Manutencao de L.M.C."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Manutenção de L.M.C."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
