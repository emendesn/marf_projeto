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
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Confer�ncia de Proccesso de AVP Contas a Receber", "Conferencia de Processo de AVP Contas a Receber" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Proccesso dispon�vel apenas para ambiente TOPCONNECT / TOTVSDBACCESS", "Processo dispon�vel apenas para ambiente TOPCONNECT / TOTVSDBACCESS" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Esse relat�rio lista os t�tulos ajustados no proccesso, para fins de confer�ncia.", "Esse relat�rio tem o objetivo de listar os titulos ajustados no processo, para fins de conferencia." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Cabe�alho do Proccessamento", "Cabe�alho do Processamento" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Movimentos do proccessamento", "Movimentos do processamento" )
	#endif
#endif
