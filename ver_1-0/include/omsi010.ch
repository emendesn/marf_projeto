#ifdef SPANISH
	#define STR0001 "¡Registro no encontrado!"
	#define STR0002 "Error en el manejo del Xml recibido "
#else
	#ifdef ENGLISH
		#define STR0001 "Record not found!"
		#define STR0002 "Error manipulating received XML. "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Registo não encontrado.", "Registro não encontrado!" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Erro na manipulação do XML recebido. ", "Erro na manipulação do Xml recebido. " )
	#endif
#endif
