#ifdef SPANISH
	#define STR0001 "No fue posible imprimir el memo"
	#define STR0002 "Sin autorizacion"
#else
	#ifdef ENGLISH
		#define STR0001 "Unable to print memo            "
		#define STR0002 "Without permission"
	#else
		Static STR0001 := "Nao foi possivel imprimir o memo"
		Static STR0002 := "Sem permissao"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "N�o foi poss�vel imprimir o memo"
			STR0002 := "Sem permiss�o"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
