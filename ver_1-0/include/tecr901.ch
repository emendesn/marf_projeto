#ifdef SPANISH
	#define STR0001 "Agenda vs. Operador"
	#define STR0002 "Por operador"
	#define STR0003 "Por fecha"
	#define STR0004 "Asignaciones"
	#define STR0005 "Dia de la semana"
	#define STR0006 "Seleccionando registros..."
	#define STR0007 "Preparando temporal..."
	#define STR0008 "¿De fecha?"
	#define STR0009 "De fecha"
	#define STR0010 "¿De fecha?"
	#define STR0011 "A fecha"
	#define STR0012 "¿Operador?"
	#define STR0013 "Informe del operador."
	#define STR0014 "¿A operador?"
	#define STR0015 "Informe A operador."
	#define STR0016 "Atendida"
	#define STR0017 "Dia de trabajo con agenda"
	#define STR0018 "Dia de trabajo con agenda"
	#define STR0019 "Programada"
	#define STR0020 "Dia de trabajo con agenda"
	#define STR0021 "Dia de trabajo con agenda"
	#define STR0022 "Programada"
	#define STR0023 "Dia de trabajo con agenda"
	#define STR0024 "Dia de trabajo con agenda"
	#define STR0025 "Programada"
	#define STR0026 "Despedido"
	#define STR0027 "Despedido"
	#define STR0028 "Sin agenda"
	#define STR0029 "Programada"
	#define STR0030 "Despedido"
	#define STR0031 "Sin agenda"
	#define STR0032 "Agenda"
	#define STR0033 "Situacion"
	#define STR0034 "Lunes"
	#define STR0035 "Martes"
	#define STR0036 "Miercoles"
	#define STR0037 "Jueves"
	#define STR0038 "Viernes"
	#define STR0039 "Sabado"
	#define STR0040 "Domingo"
	#define STR0041 "Vacaciones procesadas"
	#define STR0042 "Vacaciones programadas"
	#define STR0043 "Licencia"
	#define STR0044 "Franco"
	#define STR0045 "Dia de trabajo con agenda"
	#define STR0046 "Dia de trabajo sin agenda"
#else
	#ifdef ENGLISH
		#define STR0001 "Schedule X Operator"
		#define STR0002 "By Operator"
		#define STR0003 "By Date"
		#define STR0004 "Allocations"
		#define STR0005 "Week day"
		#define STR0006 "Selecting Records..."
		#define STR0007 "Preparing Temporary..."
		#define STR0008 "Date From?"
		#define STR0009 "Date from."
		#define STR0010 "Date From?"
		#define STR0011 "Date to."
		#define STR0012 "Operator?"
		#define STR0013 "Operator Entry."
		#define STR0014 "Operator From?"
		#define STR0015 "Enter even the Operator."
		#define STR0016 "Serviced"
		#define STR0017 "Workday with Schedule"
		#define STR0018 "Workday with Schedule"
		#define STR0019 "Scheduled"
		#define STR0020 "Workday with Schedule"
		#define STR0021 "Workday with Schedule"
		#define STR0022 "Scheduled"
		#define STR0023 "Workday with Schedule"
		#define STR0024 "Workday with Schedule"
		#define STR0025 "Scheduled"
		#define STR0026 "Dismissed"
		#define STR0027 "Dismissed"
		#define STR0028 "Without Schedule"
		#define STR0029 "Scheduled"
		#define STR0030 "Dismissed"
		#define STR0031 "Without Schedule"
		#define STR0032 "Schedule"
		#define STR0033 "Status"
		#define STR0034 "Monday"
		#define STR0035 "Tuesday"
		#define STR0036 "Wednesday"
		#define STR0037 "Thursday"
		#define STR0038 "Friday"
		#define STR0039 "Saturday"
		#define STR0040 "Sunday"
		#define STR0041 "Processed Vacations"
		#define STR0042 "Programmed Vacations"
		#define STR0043 "Leave"
		#define STR0044 "Day off"
		#define STR0045 "Workday with Schedule"
		#define STR0046 "Workday without Schedule"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Agenda X Atendente" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Por Atendente" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Por Data" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Alocações" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Dia da Semana" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Selecionando Registros..." )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Preparando Temporario..." )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Data De?" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Data de." )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Data De?" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Data ate." )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Atendente ?" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Informe do Atendente." )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Atendente Ate ?" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Informe ate o Atendente." )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Atendida" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Dia de Trabalho com Agenda" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Dia de Trabalho com Agenda" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Agendada" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Dia de Trabalho com Agenda" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Dia de Trabalho com Agenda" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "Agendada" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Dia de Trabalho com Agenda" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "Dia de Trabalho com Agenda" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "Agendada" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "Demitido" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "Demitido" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "Sem Agenda" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", , "Agendada" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "Demitido" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", , "Sem Agenda" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", , "Agenda" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", , "Situação" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", , "Segunda-Feira" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", , "Terça-Feira" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", , "Quarta-Feira" )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", , "Quinta-Feira" )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", , "Sexta-Feira" )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", , "Sábado" )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", , "Domingo" )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", , "Férias Processada" )
		#define STR0042 If( cPaisLoc $ "ANG|PTG", , "Férias Programada" )
		#define STR0043 If( cPaisLoc $ "ANG|PTG", , "Afastamento" )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", , "Folga" )
		#define STR0045 If( cPaisLoc $ "ANG|PTG", , "Dia de Trabalho com Agenda" )
		#define STR0046 If( cPaisLoc $ "ANG|PTG", , "Dia de Trabalho sem Agenda" )
	#endif
#endif
