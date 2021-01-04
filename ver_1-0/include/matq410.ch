#ifdef SPANISH
	#define STR0001 "Pedido de venta por cliente"
	#define STR0002 "Cliente"
	#define STR0003 "Abierto"
	#define STR0004 "Finalizado"
	#define STR0005 "Estatus"
	#define STR0006 "Ultimos 30 dias"
	#define STR0007 "Ultimos 60 dias"
	#define STR0008 "Ultimos 90 dias"
	#define STR0009 "Ultimos 120 dias"
	#define STR0010 "Ultimos 360 dias"
#else
	#ifdef ENGLISH
		#define STR0001 "Sales Order by Customer"
		#define STR0002 "Customer"
		#define STR0003 "Outstanding"
		#define STR0004 "Closed"
		#define STR0005 "Status"
		#define STR0006 "Last 30 days"
		#define STR0007 "Last 60 days"
		#define STR0008 "Last 90 days"
		#define STR0009 "Last 120 days"
		#define STR0010 "Last 360 days"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Pedido de Venda por Cliente" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Cliente" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Aberto" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Encerrado" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Status" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Últimos 30 dias" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Últimos 60 dias" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Últimos 90 dias" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Últimos 120 dias" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Últimos 360 dias" )
	#endif
#endif
