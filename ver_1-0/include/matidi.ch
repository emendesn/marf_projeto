#ifdef SPANISH
	#define STR0001 "Error de grabacion del archivo:"
#else
	#ifdef ENGLISH
		#define STR0001 "Error when saving file."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Erro de Gravacao do Arquivo :" )
	#endif
#endif
