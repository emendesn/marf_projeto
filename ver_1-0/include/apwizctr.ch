#ifdef SPANISH
	#define STR0001 "Ctree operando en modo SERVER"
	#define STR0002 "Ctree operando en modo LOCAL"
	#define STR0003 "Nombre del Usuario para Login"
	#define STR0004 "Contrasena del usuario para Login"
	#define STR0005 "Nombre del Servidor CTREE"
	#define STR0006 "Nombre o IP del Server"
	#define STR0007 "No es posible borrar esta configuracion."
	#define STR0008 "Servidor CTREE no configurado."
	#define STR0009 "Editar Configuracion"
	#define STR0010 "Borrar Configuracion"
#else
	#ifdef ENGLISH
		#define STR0001 "Ctree operating in SERVER mode"
		#define STR0002 "Ctree operating in LOCAL mode"
		#define STR0003 "User's Name for Login     "
		#define STR0004 "User Password for Login    "
		#define STR0005 "CTREE Server Name     "
		#define STR0006 "Server Name or IP   "
		#define STR0007 "It is not possible to delete this configuration."
		#define STR0008 "CTREE Server not configured.   "
		#define STR0009 "Edit Configuration "
		#define STR0010 "Delete Configuration"
	#else
		Static STR0001 := "Ctree operando em modo SERVER"
		Static STR0002 := "Ctree operando em modo LOCAL"
		Static STR0003 := "Nome do Usuário para Login"
		Static STR0004 := "Senha do Usuário para Login"
		Static STR0005 := "Nome do Servidor CTREE"
		Static STR0006 := "Nome ou IP do Server"
		Static STR0007 := "Não é possível deletar esta configuração."
		Static STR0008 := "Servidor CTREE não configurado."
		#define STR0009  "Editar Configuração"
		Static STR0010 := "Deletar Configuração"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Ctree A Operar Em Modo Server"
			STR0002 := "Ctree A Operar Em Modo Local"
			STR0003 := "Nome Do Utilizador Para Login"
			STR0004 := "Palavra-passe Do Utilizador Para Login"
			STR0005 := "Nome Do Servidor Ctree"
			STR0006 := "Nome Ou Ip Do Server"
			STR0007 := "Não é possível eliminar esta configuração."
			STR0008 := "Servidor ctree não configurado."
			STR0010 := "Eliminar Configuração"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
