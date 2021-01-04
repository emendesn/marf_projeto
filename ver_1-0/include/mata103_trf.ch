#ifdef SPANISH
	#define STR0001 "Actualizar"
	#define STR0002 "Actualizar"
	#define STR0003 "Devolucion de Documentos en transito"
#else
	#ifdef ENGLISH
		#define STR0001 "Update"
		#define STR0002 "Update"
		#define STR0003 "Return of Documents in Transit"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Atualizar" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Atualizar" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Retorno de Documentos em Transito" )
	#endif
#endif
