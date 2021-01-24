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
		Static STR0003 := "Servidor de Licen�as n�o configurado."
		Static STR0004 := "N�o � poss�vel deletar esta configura��o."
		Static STR0005 := "Nome ou IP do Servidor de Licensas (Server)"
		Static STR0006 := "Porta do Servidor de Licensas  (Port)"
		Static STR0007 := "Client do Servidor de Licen�as n�o configurado."
		#define STR0008  "Editar Configura��o"
		Static STR0009 := "Deletar Configura��o"
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
			STR0001 := "Servidor De Licen�as Instalado"
			STR0002 := "Porta do servidor de licen�as (port)"
			STR0003 := "Servidor de licen�as n�o configurado."
			STR0004 := "N�o � poss�vel eliminar esta configura��o."
			STR0005 := "Nome ou ip do servidor de licen�as (server)"
			STR0006 := "Porta do servidor de licen�as  (port)"
			STR0007 := "Cliente do servidor de licen�as n�o configurado."
			STR0009 := "Eliminar Configura��o"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
