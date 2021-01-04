#ifdef SPANISH
	#define STR0001 "Demostrativo de Programacion"
	#define STR0002 "Entregada"
	#define STR0003 "Entr.c/Atraso"
	#define STR0004 "No Entregado"
	#define STR0005 "Pendiente"
	#define STR0006 "Programacion"
	#define STR0007 "Tempo Promedio"
	#define STR0008 "Sin Programacion"
	#define STR0009 "Dicionário de dados desatualizado, favor executar o update TMS11R126"
#else
	#ifdef ENGLISH
		#define STR0001 "Scheduling Statement"
		#define STR0002 "Delivered"
		#define STR0003 "Late Deliv."
		#define STR0004 "Not delivered"
		#define STR0005 "Pending"
		#define STR0006 "Scheduling"
		#define STR0007 "Average Time"
		#define STR0008 "No Scheduling"
		#define STR0009 "Data dictionary outdated, run update TMS11R126"
	#else
		#define STR0001 "Demonstrativo de Agendamento"
		#define STR0002 "Entregue"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Entr.c/atraso", "Entr.c/Atraso" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Não entregue", "Não Entregue" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Em aberto", "Em Aberto" )
		#define STR0006 "Agendamento"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Tempo médio", "Tempo Médio" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Sem agendamento", "Sem Agendamento" )
		#define STR0009 "Dicionário de dados desatualizado, favor executar o update TMS11R126"
	#endif
#endif
