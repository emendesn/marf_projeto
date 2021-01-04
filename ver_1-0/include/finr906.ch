#ifdef SPANISH
	#define STR0001 "Verificacion del Processo de AVP Cuentas por Pagar"
	#define STR0002 "Proceso disponible solamente para entorno TOPCONNECT / TOTVSDBACCESS"
	#define STR0003 "Este informe tiene el objetivo de listar los titulos ajustados en el proceso, para fines de verificacion."
	#define STR0004 "Encabezado del Procesamiento"
	#define STR0005 "Movimientos del procesamiento"
#else
	#ifdef ENGLISH
		#define STR0001 "Conference of AVP Process of Accounts Payable"
		#define STR0002 "Process available for environment TOPCONNECT / TOTVSDBACCESS"
		#define STR0003 "The purpose of this report is to list the titles adjusted in the process for conference purposes."
		#define STR0004 "Header of Processing"
		#define STR0005 "Movements of Processing:"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Confer�ncia de Proccesso de AVP Contas a Pagar", "Conferencia de Processo de AVP Contas a Pagar" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Proccesso dispon�vel apenas para ambiente TOPCONNECT / TOTVSDBACCESS", "Processo dispon�vel apenas para ambiente TOPCONNECT / TOTVSDBACCESS" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Esse relat�rio lista os t�tulos ajustados no proccesso para fins de confer�ncia.", "Esse relat�rio tem o objetivo de listar os titulos ajustados no processo, para fins de conferencia." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Cabe�alho do Proccessamento", "Cabe�alho do Processamento" )
		#define STR0005 "Movimentos do processamento"
	#endif
#endif
