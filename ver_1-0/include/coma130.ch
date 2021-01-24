#ifdef SPANISH
	#define STR0001 "Certificado de Facturas"
	#define STR0002 "�Filtrar por solicitante?"
	#define STR0003 "�Considerar Facturas?"
	#define STR0004 "Esta factura ya se encuentra liberada."
	#define STR0005 "ATENCION"
	#define STR0006 "Esta factura ya se encuentra bloqueada."
	#define STR0007 "Esta nota ya se clasifico y no puede ser revertida."
#else
	#ifdef ENGLISH
		#define STR0001 "Atesto de Notas"
		#define STR0002 "Filtrar por solicitante?"
		#define STR0003 "Considerar Notas?"
		#define STR0004 "Essa nota j� encontra-se liberada."
		#define STR0005 "ATENCAO"
		#define STR0006 "Essa nota j� encontra-se bloqueada."
		#define STR0007 "Essa nota j� foi classificada e nao pode ser estornada."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Atesto de Facturas", "Atesto de Notas" )
		#define STR0002 "Filtrar por solicitante?"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Considerar facturas?", "Considerar Notas?" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Essa factura j� encontra-se liberada.", "Essa nota j� encontra-se liberada." )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "ATEN��O", "ATENCAO" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Essa factura j� encontra-se bloqueada.", "Essa nota j� encontra-se bloqueada." )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Essa factura j� foi classificada e n�o pode ser estornada.", "Essa nota j� foi classificada e nao pode ser estornada." )
	#endif
#endif
