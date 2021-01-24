#ifdef SPANISH
	#define STR0001 "¿Mandato CIPA ?"
	#define STR0002 "Pendiente(s)"
	#define STR0003 "Finalizado(s)"
#else
	#ifdef ENGLISH
		#define STR0001 "CIPA period?"
		#define STR0002 "Pending"
		#define STR0003 "Finished"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Mandato chsst ?", "Mandato CIPA ?" )
		#define STR0002 "Aberto(s)"
		#define STR0003 "Fechado(s)"
	#endif
#endif
