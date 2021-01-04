#ifdef SPANISH
	#define STR0001 "Consulta de Boletos"
	#define STR0002 "Boletos"
	#define STR0003 "Forma pago"
	#define STR0004 "Título cobrar"
	#define STR0005 "Título pagar"
#else
	#ifdef ENGLISH
		#define STR0001 "Ticket Search"
		#define STR0002 "Tickets"
		#define STR0003 "Payment Method"
		#define STR0004 "Receivable Bills"
		#define STR0005 "Payable Bills"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Consulta de Bilhetes" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Bilhetes" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Forma Pagamento" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Titulos Receber" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Titulos Pagar" )
	#endif
#endif
