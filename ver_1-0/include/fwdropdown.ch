#ifdef SPANISH
	#define STR0001 "Mostrar todos"
#else
	#ifdef ENGLISH
		#define STR0001 "Show All"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Exibir Todos" )
	#endif
#endif
