#ifdef SPANISH
	#define STR0001 "TERMINO DEL PROCESO"
#else
	#ifdef ENGLISH
		#define STR0001 "END OF PROCESS"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Fim Do Processo", "TERMINO DO PROCESSO" )
	#endif
#endif
