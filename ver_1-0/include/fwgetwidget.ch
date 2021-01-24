#ifdef SPANISH
	#define STR0001 "Monitoreo"
	#define STR0002 "Proceso"
	#define STR0003 "Menu de monitoreo"
	#define STR0004 "Menu de proceso"
	#define STR0005 "Funcion no esta disponible. Por favor entre en contacto con el administrador del sistema."
	#define STR0006 "Acceso negado"
#else
	#ifdef ENGLISH
		#define STR0001 "Monitoring"
		#define STR0002 "Process"
		#define STR0003 "Monitoring Menu"
		#define STR0004 "Process Menu"
		#define STR0005 "Feature not available. Contact the system administrator."
		#define STR0006 "Access Denied"
	#else
		#define STR0001 "Monitoramento"
		#define STR0002 "Processo"
		#define STR0003 "Menu de Monitoramento"
		#define STR0004 "Menu de Processo"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "A funcionalidade não está disponível. Por favor, entre em contacto com o Administrador do Sistema.", "Funcionalidade não está disponível. Favor entrar em contato com o Administrador do Sistema." )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Acesso negado", "Acesso Negado" )
	#endif
#endif
