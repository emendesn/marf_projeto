#ifdef SPANISH
	#define STR0001 "Informe de Recauchutador"
	#define STR0002 "A rayas"
	#define STR0003 "Administracion"
	#define STR0004 "                                                              -----------R1-----------    -----------R2-----------    -----------R3-----------    -----------R4-----------    ---------TOTAL----------"
	#define STR0005 "Recauchutador/Medida/Diseno     bien                             KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK"
	#define STR0006 "                                     -----------R1-----------    -----------R2-----------    -----------R3-----------    -----------R4-----------    ---------TOTAL----------"
	#define STR0007 "Recauchutador/Medida/Diseno                                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK"
	#define STR0008 "Totales:"
	#define STR0009 "Media/Ctd:"
#else
	#ifdef ENGLISH
		#define STR0001 "Report of Retreading Shop"
		#define STR0002 "Z-form"
		#define STR0003 "Management"
		#define STR0004 "                                                              -----------R1-----------    -----------R2-----------    -----------R3-----------    -----------R4-----------    ---------TOTAL----------"
		#define STR0005 "Retread./Measure/Design   Asset                                            KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK"
		#define STR0006 "                                     -----------R1-----------    -----------R2-----------    -----------R3-----------    -----------R4-----------    ---------TOTAL----------"
		#define STR0007 "Retread./Measure/Design                           KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK"
		#define STR0008 "Totals:"
		#define STR0009 "Aver./Amt:"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Relatório de Oficina de Recauchutagem", "Relatório de Recapador" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Código de Barras", "Zebrado" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Administração", "Administracao" )
		#define STR0004 "                                                              -----------R1-----------    -----------R2-----------    -----------R3-----------    -----------R4-----------    ---------TOTAL----------"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Recauchutagem/Medida/Desenho  Bem                                              KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK", "Recapador/Medida/Desenho  Bem                                              KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK" )
		#define STR0006 "                                     -----------R1-----------    -----------R2-----------    -----------R3-----------    -----------R4-----------    ---------TOTAL----------"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Recauchutagem/Medida/Desenho                          KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK", "Recapador/Medida/Desenho                          KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK                 KM      CPK" )
		#define STR0008 "Totais:"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Média/Qtd.:", "Média/Qtd:" )
	#endif
#endif
