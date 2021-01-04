#ifdef SPANISH
	#define STR0001 "Archivo de ocupaciones"
#else
	#ifdef ENGLISH
		#define STR0001 "Cadastro de ocupações"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Registo de ocupações", "Cadastro de ocupações" )
	#endif
#endif
