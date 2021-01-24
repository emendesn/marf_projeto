#ifdef SPANISH
	#define STR0001 "Registro de Componente Alternativo"
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Incluir"
	#define STR0005 "Modificar"
	#define STR0006 "Borrar"
	#define STR0007 "Imprimir"
	#define STR0008 "Copiar"
	#define STR0009 "Modelo de Datos de Componente Alternativo"
	#define STR0010 "Datos de Componente Alternativo"
#else
	#ifdef ENGLISH
		#define STR0001 "Alternate Component Register"
		#define STR0002 "Search"
		#define STR0003 "View"
		#define STR0004 "Add"
		#define STR0005 "Edit"
		#define STR0006 "Delete"
		#define STR0007 "Print"
		#define STR0008 "Copy"
		#define STR0009 "Data Model of Alternate Component"
		#define STR0010 "Alternate Component Data"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Registo de componente alternativo", "Cadastro de Componente Alternativo" )
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Incluir"
		#define STR0005 "Alterar"
		#define STR0006 "Excluir"
		#define STR0007 "Imprimir"
		#define STR0008 "Copiar"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Modelo de dados de componente alternativo", "Modelo de Dados de Componente Alternativo" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Dados de componente alternativo", "Dados de Componente Alternativo" )
	#endif
#endif
