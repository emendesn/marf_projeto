#ifdef SPANISH
	#define STR0001 "Pantalla de Mantenimiento Totalizadores"
	#define STR0002 "Contrasena usuario:"
	#define STR0003 "íDebe informar la contrasena!"
	#define STR0004 "íUsted no puede tener acceso a esta rutina!"
	#define STR0005 "Mantenimiento de Totalizadores"
	#define STR0006 "íContrasena no registrada!"
#else
	#ifdef ENGLISH
		#define STR0001 "Screen of Closing Count Maintenance"
		#define STR0002 "User Password:"
		#define STR0003 "Password must be entered!"
		#define STR0004 "You have no access to this routine!"
		#define STR0005 "Closing Count Maintenance"
		#define STR0006 "Password not registered!"
	#else
		Static STR0001 := "Tela de Manutencao de Encerrantes"
		Static STR0002 := "Senha do Usuario:"
		#define STR0003  "Senha dever ser preechida!"
		Static STR0004 := "Voce nao pode ter acesso a esta rotina!"
		Static STR0005 := "Manutencao de Encerrantes"
		Static STR0006 := "Senha nao cadastrada!"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Tela de manutenção de encerr."
			STR0002 := "Senha do utilizador:"
			STR0004 := "Você não pode ter acesso a esta rotina!"
			STR0005 := "Manutenção de encerr."
			STR0006 := "Senha não cadastrada!"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
