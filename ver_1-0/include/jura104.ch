#ifdef SPANISH
	#define STR0001 "Facturacion por Caso"
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Imprimir"
#else
	#ifdef ENGLISH
		#define STR0001 "Invoicing per Case"
		#define STR0002 "Search"
		#define STR0003 "View"
		#define STR0004 "Print"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Factura��o por caso", "Faturamento por Caso" )
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Imprimir"
	#endif
#endif
