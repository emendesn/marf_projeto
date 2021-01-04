#ifdef SPANISH
	#define STR0001 "Agendamiento"
	#define STR0002 "Agendamientos"
	#define STR0003 "Accion"
	#define STR0004 "Fecha Inicio"
	#define STR0005 "Fecha Final"
	#define STR0006 "Hora Inicio"
	#define STR0007 "Hora Final"
	#define STR0008 "Frecuencia"
	#define STR0009 "Entorno"
	#define STR0010 "Ultima ejecucion"
	#define STR0011 "Hora ultima ejecucion"
	#define STR0012 "Notificar Reuniones"
	#define STR0013 "Importar Fuente de Datos"
	#define STR0014 "Otros"
	#define STR0015 "Notificar plazo de Iniciativas"
	#define STR0016 "Notificar plazo de Tareas"
#else
	#ifdef ENGLISH
		#define STR0001 "Schedule"
		#define STR0002 "Schedules"
		#define STR0003 "Actn"
		#define STR0004 "Start Date"
		#define STR0005 "End Date"
		#define STR0006 "Beg. time  "
		#define STR0007 "End time"
		#define STR0008 "Frequency"
		#define STR0009 "Environm"
		#define STR0010 "Last execution"
		#define STR0011 "Last execution time "
		#define STR0012 "Notify Meetings"
		#define STR0013 "Import Data source"
		#define STR0014 "Other "
		#define STR0015 "Notify initiatives deadline "
		#define STR0016 "Notify Task validity"
	#else
		#define STR0001 "Agendamento"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Marcaçãos", "Agendamentos" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Acção", "Acäo" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Data De Início", "Data Inicio" )
		#define STR0005 "Data Fim"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Hora De Início", "Hora Inicio" )
		#define STR0007 "Hora Fim"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Frequência", "Frequencia" )
		#define STR0009 "Ambiente"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Ultima execução", "Ultima execucäo" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Hora última execução", "Hora ultima execucäo" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Notificar Reuniões", "Notificar Reuniöes" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Importar Fonte De Dados", "Importar Fonte de Dados" )
		#define STR0014 "Outros"
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Notificar Prazo De Iniciativas", "Notificar prazo de Iniciativas" )
		#define STR0016 "Notificar prazo de Tarefas"
	#endif
#endif
