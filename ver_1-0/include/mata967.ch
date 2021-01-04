#ifdef SPANISH
	#define STR0001 "Archivo de procesos referenciados"
#else
	#ifdef ENGLISH
		#define STR0001 "Referred process file"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Registo de processos referenciados", "Cadastro de processos referenciados" )
	#endif
#endif
