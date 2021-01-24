#ifdef SPANISH
	#define STR0001 "Miembros de la campana"
#else
	#ifdef ENGLISH
		#define STR0001 "Campaign Members"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Membros da Campanha" )
	#endif
#endif
