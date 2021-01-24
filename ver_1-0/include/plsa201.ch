#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Actualizar"
	#define STR0004 "Procedimientos "
	#define STR0005 "Procedimientos Incompatibles con "
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Update"
		#define STR0004 "Procedures "
		#define STR0005 "Procedures non-compatible with "
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Actualizar", "Atualizar" )
		#define STR0004 "Procedimentos "
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Procedimentos incompatíveis com ", "Procedimentos Incompativeis com " )
	#endif
#endif
