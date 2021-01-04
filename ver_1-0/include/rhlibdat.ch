#ifdef SPANISH
	#define STR0001 "Domingo"
	#define STR0002 "Lunes"
	#define STR0003 "Martes"
	#define STR0004 "Miercoles"
	#define STR0005 "Jueves"
	#define STR0006 "Viernes"
	#define STR0007 "Sabado"
#else
	#ifdef ENGLISH
		#define STR0001 "Sunday"
		#define STR0002 "Monday"
		#define STR0003 "Tuesday"
		#define STR0004 "Wednesday"
		#define STR0005 "Thursday"
		#define STR0006 "Friday"
		#define STR0007 "Saturday"
	#else
		#define STR0001 "Domingo"
		#define STR0002 "Segunda"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Terça", "Terca" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Quarta-feira", "Quarta" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Quinta-feira", "Quinta" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Sexta-feira", "Sexta" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Sábado", "Sabado" )
	#endif
#endif
