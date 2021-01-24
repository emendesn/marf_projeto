#ifdef SPANISH
	#define STR0001 "Plazo de Antic. Solicitud de Viaje"
#else
	#ifdef ENGLISH
		#define STR0001 "Term in Advance Trip Request"
	#else
		Static STR0001 := "Prazo de Antec. Solicitação de Viagem"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0001 := "Prazo de antec.solicitação de viagem"
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Prazo de antec.solicitação de viagem"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
