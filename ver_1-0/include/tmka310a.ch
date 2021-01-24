#ifdef SPANISH
	#define STR0001 "Listas de Marketing"
	#define STR0002 "Listas de Contactos"
#else
	#ifdef ENGLISH
		#define STR0001 "Marketing Lists"
		#define STR0002 "List of Contacts"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Listas de Marketing" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Listas de Contatos" )
	#endif
#endif
