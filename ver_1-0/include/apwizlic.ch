#ifdef SPANISH
	#define STR0001 "Servidor de Licencias Habilitado"
	#define STR0002 "Puerto del Servidor de Licencias (Port)"
	#define STR0003 "Servidor de Licencias no configurado."
	#define STR0004 "No es posible borrar esta configuracion."
	#define STR0005 "Nombre o IP del Servidor de Licencias (Server)"
	#define STR0006 "Puerto del Servidor de Licencias  (Port)"
	#define STR0007 "Client del Servidor de Licencias no configurado."
	#define STR0008 "Editar Configuracion"
	#define STR0009 "Deletar Configuracion"
	#define STR0010 'Mostrar mensajes de control'
#else
	#ifdef ENGLISH
		#define STR0001 "Enabled Licences Server        "
		#define STR0002 "Licenses Server Drawer (Port)       "
		#define STR0003 "License Server is not configured.    "
		#define STR0004 "It is not possible to delete this configuration."
		#define STR0005 "License Server IP or Name (Server)         "
		#define STR0006 "License Server Drawer (Port)         "
		#define STR0007 "License Server Customer is not configured.     "
		#define STR0008 "Edit Configuration "
		#define STR0009 "Delete Configuration"
		#define STR0010 'Display control messages'
	#else
		Static STR0001 := "Servidor de Licencas Habilitado"
		Static STR0002 := "Porta do Servidor de Licensas (Port)"
		Static STR0003 := "Servidor de Licenças não configurado."
		Static STR0004 := "Não é possível deletar esta configuração."
		Static STR0005 := "Nome ou IP do Servidor de Licensas (Server)"
		Static STR0006 := "Porta do Servidor de Licensas  (Port)"
		Static STR0007 := "Client do Servidor de Licenças não configurado."
		#define STR0008  "Editar Configuração"
		Static STR0009 := "Deletar Configuração"
		#define STR0010  'Mostrar mensagens de controle'
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Servidor De Licenças Instalado"
			STR0002 := "Porta do servidor de licenças (port)"
			STR0003 := "Servidor de licenças não configurado."
			STR0004 := "Não é possível eliminar esta configuração."
			STR0005 := "Nome ou ip do servidor de licenças (server)"
			STR0006 := "Porta do servidor de licenças  (port)"
			STR0007 := "Cliente do servidor de licenças não configurado."
			STR0009 := "Eliminar Configuração"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
