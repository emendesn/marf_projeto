#ifdef SPANISH
	#define STR0001 "Agente esperando en"
	#define STR0002 "Agente sin resposta valida."
#else
	#ifdef ENGLISH
		#define STR0001 "Agent wait in"
		#define STR0002 "Agent without valid answer."
	#else
		Static STR0001 := "Agente aguardando em"
		#define STR0002  "Agente sem resposta válida."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Agente a aguardar em"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
