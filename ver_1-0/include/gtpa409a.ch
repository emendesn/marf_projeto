#ifdef SPANISH
	#define STR0001 "Mantenimientos"
	#define STR0002 "Mantenimientos"
#else
	#ifdef ENGLISH
		#define STR0001 "Maintenances"
		#define STR0002 "Maintenances"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Manuten��es" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Manuten��es" )
	#endif
#endif
