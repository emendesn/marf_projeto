#ifdef SPANISH
	#define STR0001 "Fecha base invalida"
	#define STR0002 "Empresa invalida"
#else
	#ifdef ENGLISH
		#define STR0001 "Invalid DataBase"
		#define STR0002 "Invalid Company"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Database inv�lida", "DataBase Inv�lida" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Empresa inv�lida", "Empresa Inv�lida" )
	#endif
#endif
