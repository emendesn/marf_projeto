#ifdef SPANISH
	#define STR0001 "Ese usuario no posee acceso para ejecutar esa operacion."
	#define STR0002 "Atencion"
#else
	#ifdef ENGLISH
		#define STR0001 "This user has no access to perform this operation."
		#define STR0002 "Attention"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Este utilizador n�o possui acesso para executar essa opera��o.", "Esse usu�rio n�o possui acesso para executar essa opera��o." )
		#define STR0002 "Aten��o"
	#endif
#endif
