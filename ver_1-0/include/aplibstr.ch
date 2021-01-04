#ifdef SPANISH
	#define STR0043 "Seleccione la Empresa/Sucursal:"
	#define STR0074 "Digite su usuario y contrasena para efectuar el login."
#else
	#ifdef ENGLISH
		#define STR0043 "Choose Company/Branch:"
		#define STR0074 "Enter user and password to login."
	#else
		#define STR0043  "Escolha a Empresa/Filial:"
		Static STR0074 := "Digite seu usuario e senha para efetuar o login."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0074 := "Digite seu utilizador e palavra-passe para efectuar o login."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
