#ifdef SPANISH
	#define STR0001 "Comprob de Votacion CIPA"
	#define STR0002 "Imprimiendo.."
	#define STR0003 "HOJA DE VOTACION - CIPA GESTION"
	#define STR0004 "Empleado"
	#define STR0005 "Firma"
	#define STR0006 "�Cliente?"
	#define STR0007 "Tda."
	#define STR0008 "�Tipo de impresion?"
	#define STR0009 "�Cant. lineas para firma ?"
	#define STR0010 "�Listar formulario?"
	#define STR0011 "�Mandato CIPA?"
#else
	#ifdef ENGLISH
		#define STR0001 "CIPA votation proof        "
		#define STR0002 "Printing ... "
		#define STR0003 "VOTATION PAGE - MANAGEMENT CIPA"
		#define STR0004 "Employee   "
		#define STR0005 "Signature "
		#define STR0006 "Customer ?"
		#define STR0007 "Unit"
		#define STR0008 "Print Type?"
		#define STR0009 "Qty rows for sig. ?"
		#define STR0010 "List form?"
		#define STR0011 "CIPA Term?"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Comprovativo De Vota��o Chsst", "Comprovante de Votacao CIPA" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "A imprimir...", "Imprimindo..." )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Folha de vota��o - chsst gest�o ", "FOLHA DE VOTA��O - CIPA GEST�O " )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Empregado", "Funcion�rio" )
		#define STR0005 "Assinatura"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Cliente?", "Cliente ?" )
		#define STR0007 "Loja"
		#define STR0008 "Tipo de Impress�o ?"
		#define STR0009 "Quant. linhas para ass. ?"
		#define STR0010 "Listar formul�rio ?"
		#define STR0011 "Mandato CIPA ?"
	#endif
#endif
