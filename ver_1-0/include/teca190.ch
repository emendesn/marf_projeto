#ifdef SPANISH
	#define STR0001 "Consulta operadores"
	#define STR0002 "Fecha"
	#define STR0003 "Buscar"
	#define STR0004 "Equipo"
	#define STR0005 "Operador"
	#define STR0006 "Con Licencia"
	#define STR0007 "Licencia"
	#define STR0008 "Dia de trabajo con agenda"
	#define STR0009 "Dia de trabajo sin agenda"
	#define STR0010 'Realizando busqueda...'
	#define STR0011 "Situacion"
	#define STR0012 "Leyenda"
	#define STR0013 "Vacaciones procesada"
	#define STR0014 "Vacaciones programada"
	#define STR0015 "Franco"
	#define STR0016 "Franco con agenda"
#else
	#ifdef ENGLISH
		#define STR0001 "Query Operators"
		#define STR0002 "Date"
		#define STR0003 "Search"
		#define STR0004 "Team"
		#define STR0005 "Operator"
		#define STR0006 "Leave"
		#define STR0007 "Leave"
		#define STR0008 "Workday with Schedule"
		#define STR0009 "Workday without Schedule"
		#define STR0010 'Conducting search...'
		#define STR0011 "Status"
		#define STR0012 "Caption"
		#define STR0013 "Processed Vacations"
		#define STR0014 "Programmed Vacations"
		#define STR0015 "Day off"
		#define STR0016 "Day off with Schedule"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Consulta Atendentes" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Data" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Buscar" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Equipe" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Atendente" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Afastado" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Afastamento" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Dia de Trabalho com Agenda" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Dia de Trabalho sem Agenda" )
		#define STR0010 'Realizando pesquisa...'
		#define STR0011 "Situa��o"
		#define STR0012 "Legenda"
		#define STR0013 "F�rias Processada"
		#define STR0014 "F�rias Programada"
		#define STR0015 "Folga"
		#define STR0016 "Folga com Agenda"
	#endif
#endif
