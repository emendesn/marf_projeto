#ifdef SPANISH
	#define STR0001 "Actualice EAI"
	#define STR0002 " Erro IntegDef() - Mata410 "
#else
	#ifdef ENGLISH
		#define STR0001 "Update EAI"
		#define STR0002 " Error IntegDef() – Mata410 "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Actualize EAI", "Atualize EAI" )
		#define STR0002 " Erro IntegDef() - Mata410 "
	#endif
#endif
