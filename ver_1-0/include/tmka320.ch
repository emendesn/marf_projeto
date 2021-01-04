#ifdef SPANISH
	#define STR0001 "Cierre Mensual"
	#define STR0002 "Objetivo del Programa"
	#define STR0003 "Este programa consiste en bloquear las grabaciones de Atencion del Telemercadeo con fecha retroactiva al cierre informado."
	#define STR0004 "Ultimo cierre :"
	#define STR0005 "Nuevo cierre   :"
#else
	#ifdef ENGLISH
		#define STR0001 "Monthly Closing"
		#define STR0002 "Purpose of program"
		#define STR0003 "This program will lock saving of TeleMarketing Services with date prior to the closing date entered below."
		#define STR0004 "Last Closing :"
		#define STR0005 "New Closing  :"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Encerramento Mensal", "Fechamento Mensal" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Objectivo Do Programa", "Objetivo do Programa" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Este programa consiste em bloquear as grava��es de Atendimentos TeleMarketing com data retroactiva � data de fechamento informada abaixo.", "Este programa consiste em bloquear as grava��es de Atendimentos TeleMarketing com data retroativa � data de fechamento informada abaixo." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "�ltimo encerramento :", "�ltimo fechamento :" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Novo encerramento   :", "Novo fechamento   :" )
	#endif
#endif
