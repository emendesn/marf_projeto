#ifdef SPANISH
	#define STR0001 "Numero del digito no valido"
	#define STR0002 "Compruebe "
	#define STR0003 "Numero de NIT no valido"
#else
	#ifdef ENGLISH
		#define STR0001 "Invalid Control Digit"
		#define STR0002 "Check it"
		#define STR0003 "Invalid NIT Number"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "N�mero De Digito Inv�lido", "Numero de Digito Invalido" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Verificar ", "Verifique " )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "N�mero De Nit Inv�lido", "Numero de NIT Invalido" )
	#endif
#endif
