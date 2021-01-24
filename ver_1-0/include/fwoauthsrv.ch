#ifdef SPANISH
	#define STR0001 "Token no valido"
	#define STR0002 "Consumer Key no valida"
	#define STR0003 "NONCE no valido"
	#define STR0004 "Estampa de tiempo no valida"
	#define STR0005 "Firma no valida"
	#define STR0006 "Metodo de firma no valida"
	#define STR0007 "Metodo de firma no soportado"
	#define STR0008 "Consumer Key o firma no valida"
#else
	#ifdef ENGLISH
		#define STR0001 "Token Not Valid"
		#define STR0002 "Consumer Key Not Valid"
		#define STR0003 "NONCE Not Valid"
		#define STR0004 "Time Imprint Not Valid"
		#define STR0005 "Signature Not Valid"
		#define STR0006 "Signature Method Not Valid"
		#define STR0007 "Signature Method not supported"
		#define STR0008 "Consumer Key or Signature Not Valid"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Token inválido", "Token Inválido" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Consumer key inválida", "Consumer Key Inválida" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "NONCE inválido", "NONCE Inválido" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Estampa de tempo inválida", "Estampa de Tempo Inválida" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Assinatura inválida", "Assinatura Inválida" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Método de assinatura inválido", "Método de Assinatura Inválido" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Método de assinatura não suportado", "Método de Assinatura nao suportado" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Consumer key ou assinatura inválida", "Consumer Key ou Assinatura Inválida" )
	#endif
#endif
