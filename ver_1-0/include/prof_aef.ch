#ifdef SPANISH
	#define STR0001 "Par�metros Incorretos"
#else
	#ifdef ENGLISH
		#define STR0001 "Par�metros Incorretos"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Par�metros Incorrectos", "Par�metros Incorretos" )
	#endif
#endif
