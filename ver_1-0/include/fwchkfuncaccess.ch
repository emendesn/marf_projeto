#ifdef SPANISH
	#define STR0001 "Ese usuario no posee acceso para ejecutar esa operacion."
	#define STR0002 "Atencion"
#else
	#ifdef ENGLISH
		#define STR0001 "This user has no access to perform this operation."
		#define STR0002 "Attention"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Este utilizador não possui acesso para executar essa operação.", "Esse usuário não possui acesso para executar essa operação." )
		#define STR0002 "Atenção"
	#endif
#endif
