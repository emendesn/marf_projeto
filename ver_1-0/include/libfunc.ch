#ifdef SPANISH
	#define STR0001 "Ocurrio un error en el retorno "
	#define STR0002 " de la Consulta "
	#define STR0003 "Contacte el Administrador para verificar la consulta"
	#define STR0004 "Error: "
#else
	#ifdef ENGLISH
		#define STR0001 "Error while returning "
		#define STR0002 " the Query "
		#define STR0003 "Get in touch with the Administrator to check the query"
		#define STR0004 "Error: "
	#else
		#define STR0001  "Ocorreu um erro no retorno "
		Static STR0002 := " da Consulta "
		Static STR0003 := "Contate o Administrador para verificar a consulta"
		#define STR0004  "Erro: "
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0002 := " da consulta "
			STR0003 := "Contacte o administrador para verificar a consulta"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
