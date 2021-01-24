#ifdef SPANISH
	#define STR0001 "Comprovante de Entrega"
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Incluir"
	#define STR0005 "Revertir"
	#define STR0006 "Imprimir"
#else
	#ifdef ENGLISH
		#define STR0001 "Proof of Delivery"
		#define STR0002 "Search"
		#define STR0003 "View "
		#define STR0004 "Add"
		#define STR0005 "Reverse"
		#define STR0006 "Print"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Comprovativo De Entrega", "Comprovante de Entrega" )
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Incluir"
		#define STR0005 "Estornar"
		#define STR0006 "Imprimir"
	#endif
#endif
