#ifdef SPANISH
	#define STR0001 "N�o foi integrada nenhuma imagem para esse registro."
#else
	#ifdef ENGLISH
		#define STR0001 "No image was integrated for this register."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "N�o foi integrada nenhuma imagem para esse registro." )
	#endif
#endif
