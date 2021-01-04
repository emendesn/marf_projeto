#ifdef SPANISH
	#define STR0001 "Titulos en proceso de AVP"
	#define STR0002 "Proceso disponible solo para entorno TOPCONNECT / TOTVSDBACCESS"
	#define STR0003 "Este informe tiene el objetivo de listar los titulos por pagar en proceso de ajuste de valor presente, mostrando el valor presente del titulo y sus movimientos"
	#define STR0004 "Titulo en AVP"
	#define STR0005 "Movim. de AVP"
#else
	#ifdef ENGLISH
		#define STR0001 "Bills in AVP process"
		#define STR0002 "Process available for environment TOPCONNECT / TOTVSDBACCESS"
		#define STR0003 "This report aims at listing bills payable under adjustment, presenting current value of the bill and its transactions"
		#define STR0004 "AVP Bill"
		#define STR0005 "AVP Transactions"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "T�tulos em proccesso de AVP", "T�tulos em processo de AVP" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Proccesso dispon�vel apenas para ambiente TOPCONNECT / TOTVSDBACCESS", "Processo dispon�vel apenas para ambiente TOPCONNECT / TOTVSDBACCESS" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Esse relat�rio lista os t�tulos a pagar em proccesso de ajuste de valor presente, a demonstrar o valor presente do t�tulo e suas movimenta��es", "Esse relat�rio tem o objetivo de listar os t�tulos a pagar em processo de ajuste de valor presente, demonstrando o valor presente do titulo e suas movimenta��es" )
		#define STR0004 "T�tulo em AVP"
		#define STR0005 "Movimentos de AVP"
	#endif
#endif
