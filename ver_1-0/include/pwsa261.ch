#ifdef SPANISH
	#define STR0001 "Mis Datos de Registro "
#else
	#ifdef ENGLISH
		#define STR0001 "My Registration Data "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Meus dados de registo ", "Meus Dados Cadastrais " )
	#endif
#endif
