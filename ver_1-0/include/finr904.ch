#ifdef SPANISH
	#define STR0001 "Verificacion del Proceso de AVP Cuentas por Cobrar"
	#define STR0002 "Proceso disponible solamente para entorno TOPCONNECT / TOTVSDBACCESS"
	#define STR0003 "Este informe tiene el objetivo de listar los titulos ajustados en el proceso, para fines de Verif."
	#define STR0004 "Encabezado del Procesam."
	#define STR0005 "Movimientos del Procesam."
#else
	#ifdef ENGLISH
		#define STR0001 "Conference of AVP Process of Accounts Receivable"
		#define STR0002 "Process available for environment TOPCONNECT / TOTVSDBACCESS"
		#define STR0003 "This report lists bills adjusted in the process, for checking purposes."
		#define STR0004 "Processing Header"
		#define STR0005 "Processing Movements"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Conferência de Proccesso de AVP Contas a Receber", "Conferencia de Processo de AVP Contas a Receber" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Proccesso disponível apenas para ambiente TOPCONNECT / TOTVSDBACCESS", "Processo disponível apenas para ambiente TOPCONNECT / TOTVSDBACCESS" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Esse relatório lista os títulos ajustados no proccesso, para fins de conferência.", "Esse relatório tem o objetivo de listar os titulos ajustados no processo, para fins de conferencia." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Cabeçalho do Proccessamento", "Cabeçalho do Processamento" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Movimentos do proccessamento", "Movimentos do processamento" )
	#endif
#endif
