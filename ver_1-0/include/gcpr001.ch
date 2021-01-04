#ifdef SPANISH
	#define STR0001 "Anulacion del Edital"
	#define STR0002 "Este informe solo esta disponible a partir de la Release 4."
	#define STR0003 "Este programa tiene el objetivo de imprimir la  "
	#define STR0004 "lista de los editales y su posicion actual "
	#define STR0005 "Licitacion:"
	#define STR0006 "Etapa"
#else
	#ifdef ENGLISH
		#define STR0001 "Notice Status"
		#define STR0002 "This report is only available as of Release 4."
		#define STR0003 "This program aims at printing the"
		#define STR0004 "list of notices and their current status"
		#define STR0005 "Biding"
		#define STR0006 "Stage"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Posição do Edital", "Posicao do Edital" )
		#define STR0002 "Este relatório só está disponível a partir da Release 4."
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Este programa imprime a  ", "Este programa tem como objetivo imprimir a  " )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "listagem dos editais e sua posição actual ", "listagem dos editais e sua posição atual " )
		#define STR0005 "Licitação"
		#define STR0006 "Etapa"
	#endif
#endif
