#ifdef SPANISH
	#define STR0001 "Orden de servicio : "
	#define STR0002 "CONSISTENCIA EN EL COMPROBANTE REVISION Y REVISION VOLKSTOTAL CAMIONES"
	#define STR0003 "O.S.      CODIGOS DE CONSISTENCIA"
#else
	#ifdef ENGLISH
		#define STR0001 "Service Order: "
		#define STR0002 "CONSISTENCY ON COUPON REVISION AND VOLKSTOTAL TRUCKS REVISION"
		#define STR0003 "S.O.      CONSISTENCY CODES"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Ordem de servi�o: ", "Ordem de Servi�o : " )
		#define STR0002 "CONSISTENCIA NO CUPOM REVIS�O E REVIS�O VOLKSTOTAL CAMINH�ES"
		#define STR0003 "O.S.      C�DIGOS DE CONSIST�NCIA"
	#endif
#endif
