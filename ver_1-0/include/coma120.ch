#ifdef SPANISH
	#define STR0001 "Existe pedido sin vinculacion con solicitud."
	#define STR0002 "ATENCION"
	#define STR0003 "Existe solicitud sin solicitante."
	#define STR0004 "Existe solicitud de solicitante diferente"
	#define STR0005 "Existe item sin vinculacion con solicitud."
	#define STR0006 "La nota previa no se guardo. Existe item sin vinculacion con solicitud."
	#define STR0007 "La nota previa no se guardo. Existe Item sin vinculacion con solicitud."
#else
	#ifdef ENGLISH
		#define STR0001 "Existe pedido sem amarracao com solicitacao."
		#define STR0002 "ATENCAO"
		#define STR0003 "Existe solicitacao sem requisitante."
		#define STR0004 "Existe solicitacao de requisitante diferente"
		#define STR0005 "Existe Item sem amarracao com pedido."
		#define STR0006 "A pre-nota nao foi salva. Existe Item sem amarracao com pedido."
		#define STR0007 "A pre-nota nao foi salva. Existe Item sem amarracao com solicitacao."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Existe pedido sem amarração com solicitação.", "Existe pedido sem amarracao com solicitacao." )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "ATENÇÃO", "ATENCAO" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Existe solicitação sem requisitante.", "Existe solicitacao sem requisitante." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Existe solicitação de requisitante diferente", "Existe solicitacao de requisitante diferente" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Existe Item sem amarração com pedido.", "Existe Item sem amarracao com pedido." )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "A pré-fact. não foi gravada. Existe Item sem amarração com pedido.", "A pre-nota nao foi salva. Existe Item sem amarracao com pedido." )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "A pré-factura não foi gravada. Existe Item sem amarração com solicitação.", "A pre-nota nao foi salva. Existe Item sem amarracao com solicitacao." )
	#endif
#endif
