#ifdef SPANISH
	#define STR0001 "Vinculo"
	#define STR0002 "Vinculo"
	#define STR0003 "Atencion"
	#define STR0004 "¡Calendario actualizado con exito!"
	#define STR0005 "OK"
#else
	#ifdef ENGLISH
		#define STR0001 "Relationship"
		#define STR0002 "Relationship"
		#define STR0003 "Attention"
		#define STR0004 "Schedule successfully Updated!"
		#define STR0005 "OK"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Relacionamento" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Relacionamento" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Atenção" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Calendario Atualizado com sucesso!" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "OK" )
	#endif
#endif
