#ifdef SPANISH
	#define STR0001 "Archivo - SXG"
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Incluir"
	#define STR0005 "Modificar"
	#define STR0006 "Borrar"
	#define STR0007 "Paises"
	#define STR0008 "Paises"
#else
	#ifdef ENGLISH
		#define STR0001 "Register - SXG"
		#define STR0002 "Search"
		#define STR0003 "View"
		#define STR0004 "Add"
		#define STR0005 "Edit"
		#define STR0006 "Delete"
		#define STR0007 "Countries"
		#define STR0008 "Countries"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Registo - SXG", "Cadastro - SXG" )
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Incluir"
		#define STR0005 "Alterar"
		#define STR0006 "Excluir"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Pa�ses", "Paises" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Pa�ses", "Paises" )
	#endif
#endif
