#ifdef SPANISH
	#define STR0001 "No existe Rutina registrada para el Alias"
	#define STR0002 "Rutina"
	#define STR0003 "no es una rutina MVC"
#else
	#ifdef ENGLISH
		#define STR0001 "There is no Routine registered for the Alias"
		#define STR0002 "Routine"
		#define STR0003 "is not a MVC routine"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Não existe procedimentot registado para a Alias", "Não existe Rotina cadastrada para a Alias" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Procedimento", "Rotina" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "não é um procedimento MVC", "não é uma rotina MVC" )
	#endif
#endif
