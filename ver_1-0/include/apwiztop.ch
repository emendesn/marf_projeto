#ifdef SPANISH
	#define STR0001 "Nombre o IP del Servidor de TOTVSDBACESS(Server)"
	#define STR0002 "Base de Datos utilizada (Database)"
	#define STR0003 "Alias de la Base de Datos (Alias)"
	#define STR0004 "Version de la DLL de Conexion (TopApi)"
	#define STR0005 "Utiliza mapa en TOTVSDBAcess (Mapper)"
	#define STR0006 "Editar Configuracion"
	#define STR0007 "Borrar Configuracion"
	#define STR0008 'Nombre o IP de TOTVSbAccess'
	#define STR0009 'Base de Datos utilizada'
	#define STR0010 'Alias de la Base / Conexion'
	#define STR0011 'Drive de Conexion'
#else
	#ifdef ENGLISH
		#define STR0001 "TOTVSDBACESS(Server) Server Name or IP"
		#define STR0002 "Database under use (Database)"
		#define STR0003 "Database Alias (Alias)         "
		#define STR0004 "Connection DLL Version (TopApi)"
		#define STR0005 "Use Map in TOTVSDBAcess (Mapper)"
		#define STR0006 "Edit Configuration "
		#define STR0007 "Delete Configuration"
		#define STR0008 'TOTVSDbAccess Name or IP '
		#define STR0009 'Database used'
		#define STR0010 'Database / Connection Alias'
		#define STR0011 'Connection Driver'
	#else
		Static STR0001 := "Nome ou IP do Servidor do TOTVSDBACESS(Server)"
		Static STR0002 := "Banco de Dados utilizado (Database)"
		Static STR0003 := "Alias do Banco de Dados (Alias)"
		Static STR0004 := "Versão da DLL de Conexão (TopApi)"
		Static STR0005 := "Utiliza Mapa no TOTVSDBAcess (Mapper)"
		#define STR0006  "Editar Configuração"
		Static STR0007 := "Deletar Configuração"
		Static STR0008 := 'Nome ou IP do TOTVSDbAccess '
		Static STR0009 := 'Banco de Dados utilizado'
		Static STR0010 := 'Alias do Banco / Conexão'
		Static STR0011 := 'Driver de Conexão'
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Nome Ou Tipo Do Servidor do TOTVSDBACESS (Server)"
			STR0002 := "Base de dados utilizada (database)"
			STR0003 := "Aliás da base de dados (alias)"
			STR0004 := "Versão da dll de ligação (topapi)"
			STR0005 := "Utiliza mapa no totvsdbacess (mapper)"
			STR0007 := "Eliminar Configuração"
			STR0008 := 'Nome ou ip do totvsdbaccess '
			STR0009 := 'Banco de dados utilizado'
			STR0010 := 'Alias Do Banco / Ligação'
			STR0011 := 'Driver De Ligação'
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
