#ifdef SPANISH
	#define STR0001 "Actualice el EAI Protheus"
	#define STR0002 "Error en el XML recibido."
#else
	#ifdef ENGLISH
		#define STR0001 "Update EAI Protheus"
		#define STR0002 "Error in XML received."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Actualize o EAI Protheus", "Atualize o EAI Protheus" )
		#define STR0002 "Erro no XML recebido."
	#endif
#endif
