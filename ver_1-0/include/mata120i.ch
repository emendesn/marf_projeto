#ifdef SPANISH
	#define STR0001 "Aguarde, estableciendo comunicacion con TSS..."
	#define STR0002 "Procesando"
#else
	#ifdef ENGLISH
		#define STR0001 "Wait, establishing communication with TSS..."
		#define STR0002 "Processing"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Aguarde, a estabelecer comunica��o com TSS...", "Aguarde, estabelecendo comunica��o com TSS..." )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "A processar", "Processando" )
	#endif
#endif
