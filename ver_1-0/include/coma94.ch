#ifdef SPANISH
	#define STR0001 "Inicio Workflow PC Empresa: "
	#define STR0002 "PEDIDO"
	#define STR0003 "Pedido de Compras"
	#define STR0004 "Pedido de Compra Nr. "
#else
	#ifdef ENGLISH
		#define STR0001 "Inicio Workflow PC Empresa: "
		#define STR0002 "PEDIDO"
		#define STR0003 "Pedido de Compras"
		#define STR0004 "Pedido de Compra Nr. "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Início Workflow PC Empresa: ", "Inicio Workflow PC Empresa: " )
		#define STR0002 "PEDIDO"
		#define STR0003 "Pedido de Compras"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Pedido de Compra No. ", "Pedido de Compra Nr. " )
	#endif
#endif
