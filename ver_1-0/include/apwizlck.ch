#ifdef SPANISH
	#define STR0001 "LockServer Habilitado"
	#define STR0002 "IP del Servidor de Locks"
	#define STR0003 "Puerto del Servidor LockServer"
	#define STR0004 "No es posible borrar esta configuracion."
	#define STR0005 "LockServer no configurado."
	#define STR0006 "Editar Configuracion"
	#define STR0007 "Borrar Configuracion"
#else
	#ifdef ENGLISH
		#define STR0001 "Enabled LockServer   "
		#define STR0002 "Locks Server IP        "
		#define STR0003 "LockServer Server Drawer    "
		#define STR0004 "It is not possible to delete this configuration."
		#define STR0005 "LockServer not configured. "
		#define STR0006 "Edit Configuration "
		#define STR0007 "Delete Configuration"
	#else
		Static STR0001 := "LockServer Habilitado"
		Static STR0002 := "IP do Servidor de Locks"
		Static STR0003 := "Porta do Servidor LockServer"
		Static STR0004 := "N�o � poss�vel deletar esta configura��o."
		#define STR0005  "LockServer n�o configurado."
		#define STR0006  "Editar Configura��o"
		Static STR0007 := "Deletar Configura��o"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "LockServer Instalado"
			STR0002 := "Ip Do Servidor De Locks"
			STR0003 := "Porta do Servidor De LockServer"
			STR0004 := "N�o � poss�vel eliminar esta configura��o."
			STR0007 := "Eliminar Configura��o"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
