#ifdef SPANISH
	#define STR0001 "Tipo de Documentos"
	#define STR0002 "El tipode documento no puede ser "
	#define STR0003 "modificado"
	#define STR0004 ", pues esta vinculado a Intervalo de Codigos"
	#define STR0005 "borrado"
	#define STR0006 "ATENCION"
	#define STR0007 "Codigo ya registrado."
#else
	#ifdef ENGLISH
		#define STR0001 "Tipo de Documentos"
		#define STR0002 "O tipo de documento nao pode ser "
		#define STR0003 "alterado"
		#define STR0004 ", pois esta vinculado a Intervalo de Codigos"
		#define STR0005 "exclu�do"
		#define STR0006 "ATENCAO"
		#define STR0007 "C�digo j� cadastrado."
	#else
		#define STR0001 "Tipo de Documentos"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "O tipo de documento n�o pode ser ", "O tipo de documento nao pode ser " )
		#define STR0003 "alterado"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", ", pois est� vinculado a Intervalo de C�digos", ", pois esta vinculado a Intervalo de Codigos" )
		#define STR0005 "exclu�do"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "ATEN��O", "ATENCAO" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "C�digo j� registado.", "C�digo j� cadastrado." )
	#endif
#endif
