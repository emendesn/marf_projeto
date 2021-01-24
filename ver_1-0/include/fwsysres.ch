#ifdef SPANISH
	#define STR0001 "Recursos del sistema"
	#define STR0002 "Menu funcional"
	#define STR0003 "Panel Online"
	#define STR0004 "Browser de Internet"
	#define STR0005 "Detalles del Browse"
	#define STR0006 "Panel transparente"
	#define STR0007 "Refresh en el Browse"
#else
	#ifdef ENGLISH
		#define STR0001 "System Resources"
		#define STR0002 "Functional Menu"
		#define STR0003 "OnLine Panel"
		#define STR0004 "Internet Browser"
		#define STR0005 "Browser Details"
		#define STR0006 "Transparent Panel"
		#define STR0007 "Refresh in Browse"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Recursos do sistema", "Recursos do Sistema" )
		#define STR0002 "Menu Funcional"
		#define STR0003 "Painel Online"
		#define STR0004 "Browser de Internet"
		#define STR0005 "Detalhes do Browse"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Painel transparente", "Painel Transparente" )
		#define STR0007 "Refresh no Browse"
	#endif
#endif
