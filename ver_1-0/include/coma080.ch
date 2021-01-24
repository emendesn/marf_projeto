#ifdef SPANISH
	#define STR0001 "No se grabara el log de referencia, pues el campo de referencia no existe: "
	#define STR0002 "No se grabara el log de referencia, pues la Solicitud/Item no existe: "
#else
	#ifdef ENGLISH
		#define STR0001 "Não será gravado log de referência, pois o campo de referência não existe: "
		#define STR0002 "Não será gravado log de referência, pois a Solicitacao/Item não existe: "
	#else
		#define STR0001 "Não será gravado log de referência, pois o campo de referência não existe: "
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Não será gravado log de referência, pois a Solicitação/Item não existe: ", "Não será gravado log de referência, pois a Solicitacao/Item não existe: " )
	#endif
#endif
