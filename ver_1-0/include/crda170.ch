#ifdef SPANISH
	#define STR0001 "Archivo de ocupaciones"
#else
	#ifdef ENGLISH
		#define STR0001 "Cadastro de ocupa��es"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Registo de ocupa��es", "Cadastro de ocupa��es" )
	#endif
#endif
