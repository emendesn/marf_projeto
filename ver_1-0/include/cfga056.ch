#ifdef SPANISH
	#define STR0001 "10 Minutos"
	#define STR0002 "15 Minutos"
	#define STR0003 "30 Minutos"
	#define STR0004 "5 Minutos"
	#define STR0005 "La informacion se actualizara a cada:"
	#define STR0006 "Se hizo la ultima actualizacion a las:"
	#define STR0007 "Proxima actualizacion prevista para las:"
	#define STR0008 "Actualizar"
#else
	#ifdef ENGLISH
		#define STR0001 "10 Minutes"
		#define STR0002 "15 Minutes"
		#define STR0003 "30 Minutes"
		#define STR0004 "5 Minutes"
		#define STR0005 "Information is updated to each:"
		#define STR0006 "Last update at:"
		#define STR0007 "Next update planned to:"
		#define STR0008 "Update"
	#else
		#define STR0001 "10 Minutos"
		#define STR0002 "15 Minutos"
		#define STR0003 "30 Minutos"
		#define STR0004 "5 Minutos"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "As informações serão actualizadas a cada:", "As informações serão atualizadas a cada:" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Última actualização feita às:", "Última atualização feita às:" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Próxima actualização prevista para:", "Próxima atualização prevista para às:" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Actualizar", "Atualizar" )
	#endif
#endif
