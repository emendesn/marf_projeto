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
		Static STR0004 := "Não é possível deletar esta configuração."
		#define STR0005  "LockServer não configurado."
		#define STR0006  "Editar Configuração"
		Static STR0007 := "Deletar Configuração"
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
			STR0004 := "Não é possível eliminar esta configuração."
			STR0007 := "Eliminar Configuração"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
