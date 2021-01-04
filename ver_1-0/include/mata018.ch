#ifdef SPANISH
	#define STR0001 "Buscar "
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar "
	#define STR0006 "Indicadores de Productos"
	#define STR0007 "Historial"
#else
	#ifdef ENGLISH
		#define STR0001 "Search   "
		#define STR0002 "View      "
		#define STR0003 "Add    "
		#define STR0004 "Edit   "
		#define STR0005 "Delete "
		#define STR0006 "Product indicators     "
		#define STR0007 "History"
	#else
		#define STR0001 "Pesquisar "
		#define STR0002 "Visualizar "
		#define STR0003 "Incluir "
		#define STR0004 "Alterar "
		#define STR0005 "Excluir "
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Indicadores de Artigos", "Indicadores de Produtos" )
		#define STR0007 "Histórico"
	#endif
#endif
