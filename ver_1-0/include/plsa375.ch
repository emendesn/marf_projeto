#ifdef SPANISH
	#define STR0001 "Vigencia de Pagos"
#else
	#ifdef ENGLISH
		#define STR0001 "Payment Reference"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Compet�ncia de pagamentos", "Competencia de Pagamentos" )
	#endif
#endif
