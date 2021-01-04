#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Imagen"
	#define STR0007 "Fuentes Generadoras de Riesgo"
	#define STR0008 "Clientes"
	#define STR0009 "Fuentes Generadoras"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Add"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Image"
		#define STR0007 "Risk Generator Sources"
		#define STR0008 "Customers"
		#define STR0009 "Generating sources: "
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 "Imagem"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Fontes Criadoras De Risco", "Fontes Geradoras de Risco" )
		#define STR0008 "Clientes"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Fontes Criadoras", "Fontes Geradoras" )
	#endif
#endif
