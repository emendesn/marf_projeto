#ifdef SPANISH
	#define STR0001 "Servidor MASTER"
	#define STR0002 "Nombre o IP del Servidor (Server)"
	#define STR0003 "Puerto TCP del Servidor (Port)"
	#define STR0004 "Numero maximo de Conexiones (Connections)"
	#define STR0005 "Editar Configuracion"
	#define STR0006 "Borrar Configuracion"
#else
	#ifdef ENGLISH
		#define STR0001 "MASTER Server  "
		#define STR0002 "Server IP or Name              "
		#define STR0003 "Server TCP Drawer (Port)    "
		#define STR0004 "Maximum number of connections (Connections)"
		#define STR0005 "Edit Configuration "
		#define STR0006 "Delete Configuration"
	#else
		Static STR0001 := "Servidor MASTER"
		Static STR0002 := "Nome ou IP do Servidor (Server)"
		Static STR0003 := "Porta TCP do Servidor (Port)"
		Static STR0004 := "Número máximo de Conexões (Connections)"
		#define STR0005  "Editar Configuração"
		Static STR0006 := "Deletar Configuração"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Servidor Master"
			STR0002 := "Nome ou ip do servidor (server)"
			STR0003 := "Porta tcp do servidor (port)"
			STR0004 := "Número máximo de ligações (connections)"
			STR0006 := "Eliminar Configuração"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
