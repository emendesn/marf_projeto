#ifdef SPANISH
	#define STR0001 "Informe de Analisis de Carcasa"
	#define STR0002 "A rayas"
	#define STR0003 "Administracion"
	#define STR0004 "Medida/Fabricante/Modelo        Neumatico                            KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK"
	#define STR0005 "                                --------ORIGINAL--------    -----------R1-----------    -----------R2-----------    -----------R3-----------    -----------R4-----------    ---------TOTAL----------"
	#define STR0006 "Medida/Fabricante/Modelo                             KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK"
	#define STR0007 "Totales:"
	#define STR0008 "Media/Ctd:"
	#define STR0009 "                                                    --------ORIGINAL--------    -----------R1-----------    -----------R2-----------    -----------R3-----------    -----------R4-----------    ---------TOTAL----------"
#else
	#ifdef ENGLISH
		#define STR0001 "Report of Body Analysis"
		#define STR0002 "Z-form"
		#define STR0003 "Management"
		#define STR0004 "Measur./Manufact./Model         Tire                             KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK"
		#define STR0005 "                                --------ORIGINAL--------    -----------R1-----------    -----------R2-----------    -----------R3-----------    -----------R4-----------    ---------TOTAL----------"
		#define STR0006 "Measur./Manufact./Model                      KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK"
		#define STR0007 "Totals:"
		#define STR0008 "Aver./Amt:"
		#define STR0009 "                                                    --------ORIGINAL--------    -----------R1-----------    -----------R2-----------    -----------R3-----------    -----------R4-----------    ---------TOTAL----------"
	#else
		#define STR0001 "Relatório de Análise de Carcaça"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Código de Barras", "Zebrado" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Administração", "Administracao" )
		#define STR0004 "Medida/Fabricante/Modelo        Pneu                             KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK"
		#define STR0005 "                                --------ORIGINAL--------    -----------R1-----------    -----------R2-----------    -----------R3-----------    -----------R4-----------    ---------TOTAL----------"
		#define STR0006 "Medida/Fabricante/Modelo                     KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK"
		#define STR0007 "Totais:"
		#define STR0008 "Média/Qtd:"
		#define STR0009 "                                                    --------ORIGINAL--------    -----------R1-----------    -----------R2-----------    -----------R3-----------    -----------R4-----------    ---------TOTAL----------"
	#endif
#endif
