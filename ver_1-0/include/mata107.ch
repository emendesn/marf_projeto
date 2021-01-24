#ifdef SPANISH
	#define STR0001 "Autorizacion de Solicitud al Almacen"
	#define STR0002 "No existe el control de saldo de solicitud previa."
	#define STR0003 "ATENCION"
	#define STR0004 "Confirma Autorizacion"
	#define STR0005 "Buscar"
	#define STR0006 "Visualizar"
	#define STR0007 "Liberar"
	#define STR0008 "Leyenda"
	#define STR0009 "SA Liberada"
	#define STR0010 "SA para liberar"
	#define STR0011 "SA Bloqueada"
	#define STR0012 "Solicitud al almacen"
	#define STR0013 "Generar Termino de retiro de material"
#else
	#ifdef ENGLISH
		#define STR0001 "Request Release to the Warehouse"
		#define STR0002 "No pre-requisition balance control."
		#define STR0003 "WARNING"
		#define STR0004 "Confirm Release"
		#define STR0005 "Search"
		#define STR0006 "View"
		#define STR0007 "Release"
		#define STR0008 "Caption"
		#define STR0009 "WO Released"
		#define STR0010 "WO to Release"
		#define STR0011 "WO Blocked"
		#define STR0012 "Warehouse Order"
		#define STR0013 "Generate Material Withdraw Disclaimer"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Autorização De Solicitação Ao Armazém", "Liberacäo de Solicitacäo ao Armazem" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Não  existe o controle de saldo de pré-requisição.", "Näo existe o controle de saldo de pre-requisicäo." )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Atenção", "ATENCÄO" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Confirmar Autorização", "Confirma Liberacäo" )
		#define STR0005 "Pesquisar"
		#define STR0006 "Visualizar"
		#define STR0007 "Liberar"
		#define STR0008 "Legenda"
		#define STR0009 "SA Liberada"
		#define STR0010 "SA para Liberar"
		#define STR0011 "SA Bloqueada"
		#define STR0012 "Solicitação Armazém"
		#define STR0013 "Gerar Termo de Retirada de Material"
	#endif
#endif
