#ifdef SPANISH
	#define STR0001 "Falha na abertura do arquivo!"
	#define STR0002 "Cancelamento do Compromisso"
#else
	#ifdef ENGLISH
		#define STR0001 "Failure opening file!"
		#define STR0002 "Commitment Cancellation"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Falha na abertura do arquivo!" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Cancelamento do Compromisso" )
	#endif
#endif
