#ifdef SPANISH
	#define STR0001 "TESTE DEL CH"
	#define STR0002 "TESTE DEL CH2"
#else
	#ifdef ENGLISH
		#define STR0001 "TEST CH"
		#define STR0002 "TEST CH2"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "TESTE DO CH" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "TESTE DO CH2" )
	#endif
#endif
