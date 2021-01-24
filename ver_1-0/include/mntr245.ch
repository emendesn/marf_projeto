#ifdef SPANISH
	#define STR0001 "Informe de Analisis de Diseno"
	#define STR0002 "A rayas"
	#define STR0003 "Administracion"
	#define STR0004 "                                              -----------R1-----------    -----------R2-----------    -----------R3-----------    -----------R4-----------    ---------TOTAL----------"
	#define STR0005 "Medida/Diseno            neumatico                             KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK"
	#define STR0006 "                                -----------R1-----------    -----------R2-----------    -----------R3-----------    -----------R4-----------    ---------TOTAL----------"
	#define STR0007 "Medida/Diseno                                        KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK"
	#define STR0008 "Totales:"
	#define STR0009 "Media/Ctd:"
#else
	#ifdef ENGLISH
		#define STR0001 "Report of Design Analysis"
		#define STR0002 "Z-form"
		#define STR0003 "Management"
		#define STR0004 "                                              -----------R1-----------    -----------R2-----------    -----------R3-----------    -----------R4-----------    ---------TOTAL----------"
		#define STR0005 "Measure/Design            Tire                             KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK"
		#define STR0006 "                                -----------R1-----------    -----------R2-----------    -----------R3-----------    -----------R4-----------    ---------TOTAL----------"
		#define STR0007 "Measure/Design                               KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK"
		#define STR0008 "Totals:"
		#define STR0009 "Aver./Amt:"
	#else
		#define STR0001 "Relatório de Análise de Desenho"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Código de Barras", "Zebrado" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Administração", "Administracao" )
		#define STR0004 "                                              -----------R1-----------    -----------R2-----------    -----------R3-----------    -----------R4-----------    ---------TOTAL----------"
		#define STR0005 "Medida/Desenho            Pneu                             KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK"
		#define STR0006 "                                -----------R1-----------    -----------R2-----------    -----------R3-----------    -----------R4-----------    ---------TOTAL----------"
		#define STR0007 "Medida/Desenho                               KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK"
		#define STR0008 "Totais:"
		#define STR0009 "Média/Qtd:"
	#endif
#endif
