#ifdef SPANISH
	#define STR0001 "Fecha base invalida"
	#define STR0002 "Empresa invalida"
#else
	#ifdef ENGLISH
		#define STR0001 "Invalid DataBase"
		#define STR0002 "Invalid Company"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Database inválida", "DataBase Inválida" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Empresa inválida", "Empresa Inválida" )
	#endif
#endif
