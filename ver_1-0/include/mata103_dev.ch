#ifdef SPANISH
	#define STR0001 "Devolver"
	#define STR0002 "Devolucion de Doctos. de salida"
	#define STR0003 "Devolucion de Doctos. de salida"
#else
	#ifdef ENGLISH
		#define STR0001 "Return"
		#define STR0002 "Outbound Invoice Return"
		#define STR0003 "Outbound Invoice Return"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Retornar" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Retorno de Doctos. de Saida" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Retorno de Doctos. de Saida" )
	#endif
#endif
