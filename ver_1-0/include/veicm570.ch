#ifdef SPANISH
	#define STR0001 "Registro para corredoras"
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Incluir"
	#define STR0005 "Modificar"
	#define STR0006 "Borrar"
#else
	#ifdef ENGLISH
		#define STR0001 "File for brokers        "
		#define STR0002 "Search   "
		#define STR0003 "View      "
		#define STR0004 "Insert "
		#define STR0005 "Edit   "
		#define STR0006 "Delete "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Registo para correctoras", "Cadastro para corretoras" )
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Incluir"
		#define STR0005 "Alterar"
		#define STR0006 "Excluir"
	#endif
#endif
