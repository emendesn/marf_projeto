#ifdef SPANISH
	#define STR0001 "Preparacion de carga para terceros"
	#define STR0002 "Buscar"
	#define STR0003 "Generar"
	#define STR0004 "Esta rutina generara las cargas para terceros de los pedidos que utilizan transportista"
	#define STR0005 "y ubicaciones informadas."
	#define STR0006 "Visualizar"
#else
	#ifdef ENGLISH
		#define STR0001 "Load assembly for third parties"
		#define STR0002 "Search"
		#define STR0003 "Generate"
		#define STR0004 "This routine will generate loads for third parties of orders that need carrier"
		#define STR0005 "and informed addressing."
		#define STR0006 "View"
	#else
		#define STR0001 "Montagem de carga para terceiros"
		#define STR0002 "Pesquisar"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Criar", "Gerar" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Esto procedimento ir� gerar as cargas para terceiros dos pedidos que utilizam transportadora", "Esta rotina ira gerar as cargas para terceiros dos pedidos que utilizam transportadora" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "E endere�amentos introduzidos.", "e enderecamentos informados." )
		#define STR0006 "Visualizar"
	#endif
#endif
