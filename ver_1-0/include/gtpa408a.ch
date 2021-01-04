#ifdef SPANISH
	#define STR0001 "Vehículos por escala"
	#define STR0002 "Vehículos por escala"
#else
	#ifdef ENGLISH
		#define STR0001 "Vehicles by Scale"
		#define STR0002 "Vehicles by Scale"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Veículos por Escala" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Veículos por Escala" )
	#endif
#endif
