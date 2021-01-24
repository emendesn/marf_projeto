#ifdef SPANISH
	#define STR0001 " actualizado con exito"
	#define STR0002 "Carpeta "
	#define STR0003 " iniciado con exito"
	#define STR0004 "Proceso "
	#define STR0005 " anulado con exito"
	#define STR0006 "Proceso "
	#define STR0007 "¡Proceso finalizado!"
	#define STR0008 "¡Proceso finalizado!"
	#define STR0009 "¡Proceso finalizado!"
	#define STR0010 "¡Proceso finalizado!"
#else
	#ifdef ENGLISH
		#define STR0001 " was successfully updated"
		#define STR0002 "Binder "
		#define STR0003 " successfully started"
		#define STR0004 "Process "
		#define STR0005 " successfully canceled"
		#define STR0006 "Process "
		#define STR0007 "Process finished!"
		#define STR0008 "Process finished!"
		#define STR0009 "Process finished!"
		#define STR0010 "Process finished!"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , " atualizado com sucesso" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Fichário " )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , " iniciado com sucesso" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Processo " )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , " cancelado com sucesso" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Processo " )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Processo finalizado!" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Processo finalizado!" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Processo finalizado!" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Processo finalizado!" )
	#endif
#endif
