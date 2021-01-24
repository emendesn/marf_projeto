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
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Token inv�lido", "Token Inv�lido" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Consumer key inv�lida", "Consumer Key Inv�lida" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "NONCE inv�lido", "NONCE Inv�lido" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Estampa de tempo inv�lida", "Estampa de Tempo Inv�lida" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Assinatura inv�lida", "Assinatura Inv�lida" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "M�todo de assinatura inv�lido", "M�todo de Assinatura Inv�lido" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "M�todo de assinatura n�o suportado", "M�todo de Assinatura nao suportado" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Consumer key ou assinatura inv�lida", "Consumer Key ou Assinatura Inv�lida" )
	#endif
#endif
