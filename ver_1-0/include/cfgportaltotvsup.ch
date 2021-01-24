#ifdef SPANISH
	#define STR0001 "Archivo HTML no se pueden generar"
	#define STR0002 "Logon TOTVS up"
	#define STR0003 "Introduzca el nombre de usuario y la contrase�a del portal TOTVS UP para acceder al entorno de colaboraci�n."
	#define STR0004 "Usuario"
	#define STR0005 "Contrase�a"
	#define STR0006 "Escribe el nombre completo de correo electr�nico!"
	#define STR0007 "Cerrar"
#else
	#ifdef ENGLISH
		#define STR0001 "HTML file can not be generated"
		#define STR0002 "Logon TOTVS up"
		#define STR0003 "Enter the username and password of the portal TOTVS UP to access the environment of collaboration."
		#define STR0004 "Username"
		#define STR0005 "Password"
		#define STR0006 "Enter the full email!"
		#define STR0007 "Close"
	#else              
		Static STR0001 := "Arquivo HTML n�o pode ser gerado"
		Static STR0002 := "Logon TOTVS up"
		Static STR0003 := "Informe o usu�rio e senha do portal TOTVS UP para acessar o ambiente de colabora��o."
		Static STR0004 := "Usu�rio"
		Static STR0005 := "Senha"
		Static STR0006 := "Informe o e-mail completo!"
		Static STR0007 := "Fechar" 
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'
		If cPaisLoc == "PTG"
			STR0001 := "Arquivo HTML n�o pode ser gerado"
			STR0002 := "Logon TOTVS up"
			STR0003 := "Informe o usu�rio e senha do portal TOTVS UP para acessar o ambiente de colabora��o."
			STR0004 := "Usu�rio"
			STR0005 := "Senha"
			STR0006 := "Informe o e-mail completo!"
			STR0007 := "Fechar" 
		EndIf
	EndIf
	Return Nil
#ENDIF
#ENDIF
