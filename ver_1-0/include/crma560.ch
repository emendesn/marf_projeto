#ifdef SPANISH
	#define STR0001 "Tipo de Neg�cio"
	#define STR0002 "Tipo de Neg�cio"
	#define STR0003 "Tipo de Neg�cio"
	#define STR0004 "Tipo de Neg�cio"
#else
	#ifdef ENGLISH
		#define STR0001 "Business Type"
		#define STR0002 "Business Type"
		#define STR0003 "Business Type"
		#define STR0004 "Business Type"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Tipo de Neg�cio" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Tipo de Neg�cio" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Tipo de Neg�cio" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Tipo de Neg�cio" )
	#endif
#endif
