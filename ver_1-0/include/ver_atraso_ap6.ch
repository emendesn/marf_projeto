#ifdef SPANISH
	#define STR0001 "Mantenimiento"
	#define STR0002 "¡Verifica Atraso en la Rendicion de Cuentas!"
	#define STR0003 "¡Actualiza Login de Usuario!"
	#define STR0004 "Verifica Atraso."
	#define STR0005 "Actualiza Login."
	#define STR0006 "Herramientas"
	#define STR0007 "¿Desea Verificar Atraso en la Rendicion de Cuentas?"
	#define STR0008 "Atencion"
	#define STR0009 "Verificando Atraso, Espere..."
	#define STR0010 "¡Verificacion de Atraso Finalizada con Exito!"
#else
	#ifdef ENGLISH
		#define STR0001 "Maintenance"
		#define STR0002 "Check Delay in Rendering of Accounts !"
		#define STR0003 "Update User Login !"
		#define STR0004 "Check Delay."
		#define STR0005 "Update Login."
		#define STR0006 "Tools"
		#define STR0007 "Do you wish to check the Delay in the Rendering of Accounts?"
		#define STR0008 "Attention"
		#define STR0009 "Checking Delay, Wait..."
		#define STR0010 "Delay check successfully concluded!"
	#else
		#define STR0001  "Manutenção"
		Static STR0002 := "Verifica Atraso na Prestação de Contas !"
		Static STR0003 := "Atualiza Login de Usuário !"
		Static STR0004 := "Verifica Atraso."
		Static STR0005 := "Atualiza Login."
		#define STR0006  "Ferramentas"
		Static STR0007 := "Deseja Verificar Atraso na Prestação de Contas ?"
		#define STR0008  "Atenção"
		Static STR0009 := "Verificando Atraso, Aguarde..."
		Static STR0010 := "Verificação de Atraso, Concluida com Sucesso !"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0002 := "Verifica atraso na prestação de contas !"
			STR0003 := "Actualiza login de utilizador!"
			STR0004 := "Verifica atraso."
			STR0005 := "Actualiza Login."
			STR0007 := "Deseja verificar atraso na prestação de contas ?"
			STR0009 := "a verificar atraso, aguarde..."
			STR0010 := "Verificação de atraso concluída com successo !"
		ElseIf cPaisLoc == "PTG"
			STR0002 := "Verifica atraso na prestação de contas !"
			STR0003 := "Actualiza login de utilizador!"
			STR0004 := "Verifica atraso."
			STR0005 := "Actualiza Login."
			STR0007 := "Deseja verificar atraso na prestação de contas ?"
			STR0009 := "a verificar atraso, aguarde..."
			STR0010 := "Verificação de atraso concluída com successo !"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
