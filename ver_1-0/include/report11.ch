#ifdef SPANISH
	#define STR0001 "Usuario:"
	#define STR0002 "Nombre Completo:"
	#define STR0003 "Departamento:"
	#define STR0004 "Cargo:"
	#define STR0005 "E-mail:"
	#define STR0006 "Extension:"
	#define STR0007 "Observacion:"
	#define STR0008 "Filtro de Usuario"
#else
	#ifdef ENGLISH
		#define STR0001 "User:   "
		#define STR0002 "Full name:    "
		#define STR0003 "Department:  "
		#define STR0004 "Position:"
		#define STR0005 "E-mail:"
		#define STR0006 "Extension:"
		#define STR0007 "Remarks:   "
		#define STR0008 "User filter      "
	#else
		Static STR0001 := "Usuario:"
		#define STR0002  "Nome Completo:"
		#define STR0003  "Departamento:"
		#define STR0004  "Cargo:"
		#define STR0005  "E-mail:"
		#define STR0006  "Ramal:"
		Static STR0007 := "Observacao:"
		Static STR0008 := "Filtro de Usuário"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Utilizador:"
			STR0007 := "Observação:"
			STR0008 := "Filtro De Utilizador"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
