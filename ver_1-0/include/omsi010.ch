#ifdef SPANISH
	#define STR0001 "�Registro no encontrado!"
	#define STR0002 "Error en el manejo del Xml recibido "
#else
	#ifdef ENGLISH
		#define STR0001 "Record not found!"
		#define STR0002 "Error manipulating received XML. "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Registo n�o encontrado.", "Registro n�o encontrado!" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Erro na manipula��o do XML recebido. ", "Erro na manipula��o do Xml recebido. " )
	#endif
#endif
