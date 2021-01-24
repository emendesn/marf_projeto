#ifdef SPANISH
	#define STR0001 "Detalle de la factura"
	#define STR0002 "Periodo"
	#define STR0003 "Medición"
	#define STR0004 "Vlr. Dia"
	#define STR0005 "Dias Util."
	#define STR0006 "Sld. a Fact."
	#define STR0007 "Titulo"
	#define STR0008 "Estatus"
	#define STR0009 "Informe el contrato"
	#define STR0010 "¿Contrato?"
	#define STR0011 "Informe la revision"
	#define STR0012 "¿Revision?"
	#define STR0013 "Informe la medicion"
	#define STR0014 "¿Medicion?"
	#define STR0015 "ANULADO"
	#define STR0016 "SUSTITUIDO"
	#define STR0017 "FINALIZADA"
	#define STR0018 "EN EJECUCION"
#else
	#ifdef ENGLISH
		#define STR0001 "Invoice Detail"
		#define STR0002 "Period"
		#define STR0003 "Measurement"
		#define STR0004 "Day Val."
		#define STR0005 "Days Used"
		#define STR0006 "Bal. to Inv."
		#define STR0007 "Bill"
		#define STR0008 "Status"
		#define STR0009 "Enter the contract"
		#define STR0010 "Contract?"
		#define STR0011 "Enter the revision"
		#define STR0012 "Review?"
		#define STR0013 "Enter measurement"
		#define STR0014 "Measurement?"
		#define STR0015 "CANCELED"
		#define STR0016 "REPLACED"
		#define STR0017 "CONCLUDED"
		#define STR0018 "IN PROGRESS"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Detalhamento da Fatura" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Período" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Medição" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Vlr. Dia" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Dias Util." )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Sld. a Fat." )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Título" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Status" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Informe o contrato" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Contrato?" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Informe a revisão" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Revisão?" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Informe a medição" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Medição?" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "CANCELADO" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "SUBSTITUIDO" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "ENCERRADO" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "EM ANDAMENTO" )
	#endif
#endif
