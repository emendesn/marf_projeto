#ifdef SPANISH
	#define STR0001 "Terminar"
	#define STR0002 "Usuario:  "
	#define STR0003 "Fecha de Logon:  "
	#define STR0004 "&Anular"
	#define STR0005 "&Log Off..."
	#define STR0006 "&Terminar"
	#define STR0007 "Estacion Bloqueada"
	#define STR0008 "Esta estacion esta en uso y ha estado bloqueada por"
	#define STR0009 "&Desbloquear"
	#define STR0010 "Clave:"
	#define STR0011 "Anular"
	#define STR0012 "&Bloquear..."
#else
	#ifdef ENGLISH
		#define STR0001 "Finish"
		#define STR0002 "User:  "
		#define STR0003 "Logon Date:  "
		#define STR0004 "&Cancel"
		#define STR0005 "&Log Off..."
		#define STR0006 "&Finish"
		#define STR0007 "Station Locked"
		#define STR0008 "This station is in use and has been locked by"
		#define STR0009 "&UnLock"
		#define STR0010 "Password:"
		#define STR0011 "Cancel"
		#define STR0012 "&Lock..."
	#else
		#define STR0001  "Finalizar"
		Static STR0002 := "Usuário:  "
		Static STR0003 := "Data do Logon:  "
		Static STR0004 := "&Cancelar"
		Static STR0005 := "&Log Off..."
		Static STR0006 := "&Finalizar"
		#define STR0007  "Estação Bloqueada"
		Static STR0008 := "Esta estação esta em uso e foi bloqueada por "
		Static STR0009 := "&Desbloquear"
		Static STR0010 := "Senha:"
		#define STR0011  "Cancelar"
		Static STR0012 := "&Bloquear..."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0002 := "Utilizador:  "
			STR0003 := "Data do logon:  "
			STR0004 := "&cancelar"
			STR0005 := "&log Off..."
			STR0006 := "&finalizar"
			STR0008 := "Esta estação está em utilização e foi bloqueada por "
			STR0009 := "&desbloquear"
			STR0010 := "Palavra-passe:"
			STR0012 := "&bloquear..."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
