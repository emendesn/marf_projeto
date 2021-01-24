#ifdef SPANISH
	#define STR0001 "Acumulados Diarios"
	#define STR0002 "Objetivo del Programa"
	#define STR0003 " El objetivo de este programa es alimentar el archivo de "
	#define STR0004 " Resumen de Ventas por Caja en la fecha informada."
	#define STR0005 " Debera utilizarse en la rutina  de  Contabilizacion de Ventas."
	#define STR0006 "Fecha Base:"
	#define STR0007 "Procesando   "
	#define STR0008 "Registro"
	#define STR0009 "Evaluando ventas del periodo ..."
	#define STR0010 "Evaluando devoluciones del periodo ..."
#else
	#ifdef ENGLISH
		#define STR0001 "Daily Acculumated "
		#define STR0002 "Objetive of Program "
		#define STR0003 "  This program consists in feeding   "
		#define STR0004 " the Sales Summary file on the informed date.              "
		#define STR0005 " It must be used in the Sales Accounting Routine.               "
		#define STR0006 "Base Date "
		#define STR0007 "Processing   "
		#define STR0008 "Record  "
		#define STR0009 "Evaluating sales in period ..."
		#define STR0010 "Evaluating returns in period ..."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Acumulados diários", "Acumulados Diários" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Objectivo Do Programa", "Objetivo do Programa" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "  este programa consiste em alimentar ", "  Este programa consiste em alimentar " )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", " ficheiro do resumo das  vendas  por caixa na data referida.", " o arquivo de Resumo de  Vendas  por Caixa na data informada." )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", " Deverá  Ser Utilizado No Procedimento  De  Contabilização  Das Vendas.", " Deverá  ser utilizado na rotina  de  Contabilizaçao  de Vendas." )
		#define STR0006 "Data Base:"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "A processar  ", "Processando  " )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Registo", "Registro" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "A avaliar as  vendas no período ...", "Avaliando vendas no periodo ..." )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "A avaliar as devoluções no período ...", "Avaliando devoluçöes no periodo ..." )
	#endif
#endif
