#ifdef SPANISH
	#define STR0001 ":..::.:.:::.:.:. Gestão Acadêmica :..:..:::.:.::..:."
#else
	#ifdef ENGLISH
		#define STR0001 ":..::.:.:::.:.:. Gestão Acadêmica :..:..:::.:.::..:."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", ":..::.:.:::.:.:. gestão académica :..:..:::.:.::..:.", ":..::.:.:::.:.:. Gestão Acadêmica :..:..:::.:.::..:." )
	#endif
#endif
