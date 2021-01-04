#ifdef SPANISH
	#define STR0001 "Resumen diario"
	#define STR0002 "Este informe solo esta disponible a partir de la Release 4."
	#define STR0003 "Este programa tiene el objetivo de imprimir el  "
	#define STR0004 "Resumen diario "
	#define STR0005 "Tipo de documento"
	#define STR0006 "Entradas"
	#define STR0007 "Salidas"
	#define STR0008 "Totalizadores"
	#define STR0009 "Diferencia:  "
	#define STR0010 "__________________________________________________________"
#else
	#ifdef ENGLISH
		#define STR0001 "Daily Summary"
		#define STR0002 "This report is only available as of Release 4."
		#define STR0003 "This program intends to print  "
		#define STR0004 "Daily Summary "
		#define STR0005 "Document Type"
		#define STR0006 "Inflows"
		#define STR0007 "Outflows"
		#define STR0008 "Totalizers"
		#define STR0009 "Difference:  "
		#define STR0010 "__________________________________________________________"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Resumo Diário" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Este relatório só está disponível a partir da Release 4." )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Este programa tem como objetivo imprimir o  " )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Resumo Diário " )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Tipo de Documento" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Entradas" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Saídas" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Totalizadores" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Diferença:  " )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "__________________________________________________________" )
	#endif
#endif
