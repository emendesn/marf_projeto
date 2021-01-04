#ifdef SPANISH
	#define STR0001 "Envio de Movimientos Contables por Lote"
	#define STR0002 "Generacion movimientos contables."
	#define STR0003 "Lotes enviados"
	#define STR0004 "Lote"
	#define STR0005 "Fecha"
	#define STR0006 "Asientos"
#else
	#ifdef ENGLISH
		#define STR0001 "Sending Accounting Transactions by Lot"
		#define STR0002 "Generation of accounting transactions."
		#define STR0003 "Lots sent"
		#define STR0004 "Lot"
		#define STR0005 "Date"
		#define STR0006 "Entries"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Envio de movimentos contabil�sticos por lote", "Envio de Movimentos Cont�beis por Lote" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Gera��o movimentos contabil�sticos.", "Gera��o movimentos cont�beis." )
		#define STR0003 "Lotes enviados"
		#define STR0004 "Lote"
		#define STR0005 "Data"
		#define STR0006 "Lan�amentos"
	#endif
#endif
