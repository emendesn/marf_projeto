#ifdef SPANISH
	#define STR0001 "Falla en la obtencion del comprobante"
#else
	#ifdef ENGLISH
		#define STR0001 "Failure to get ticket"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Falha na obtenção do cupão", "Falha na obtenção do cupom" )
	#endif
#endif
