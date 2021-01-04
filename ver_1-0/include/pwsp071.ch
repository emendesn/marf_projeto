#ifdef SPANISH
	#define STR0001 "Asignacion de Equipos"
	#define STR0002 "Filtro Avanzado"
	#define STR0003 "equipo"
	#define STR0004 "volver a filtro"
	#define STR0005 "De fecha :"
	#define STR0006 "A fecha:"
	#define STR0007 "Mostrar tareas :    "
	#define STR0008 "Todas                   "
	#define STR0009 "Finalizadas             "
	#define STR0010 "Pendientes           "
	#define STR0011 "Consultar"
	#define STR0012 "¡Seleccione por lo menos 1 equipo para consultar!"
	#define STR0013 "Ver grafico Gantt"
#else
	#ifdef ENGLISH
		#define STR0001 "Alocacao de Equipes"
		#define STR0002 "Filtro Avancado"
		#define STR0003 "equipe"
		#define STR0004 "voltar para filtro"
		#define STR0005 "Data de :"
		#define STR0006 "Data Ate:"
		#define STR0007 "Mostrar as tarefas :    "
		#define STR0008 "Todas                   "
		#define STR0009 "Finalizadas             "
		#define STR0010 "Pendentes           "
		#define STR0011 "Consultar"
		#define STR0012 "Select at least 1 team for query!"
		#define STR0013 "Display Gantt graph"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Alocação De Equipas", "Alocacao de Equipes" )
		#define STR0002 "Filtro Avancado"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Equipa", "equipe" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Voltar para filtro", "voltar para filtro" )
		#define STR0005 "Data de :"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Data Até:", "Data Ate:" )
		#define STR0007 "Mostrar as tarefas :    "
		#define STR0008 "Todas                   "
		#define STR0009 "Finalizadas             "
		#define STR0010 "Pendentes           "
		#define STR0011 "Consultar"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Seleccione pelo menos 1 equipa para consultar!", "Selecione pelo menos 1 equipe para consultar!" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Ver Gráfico Gantt", "Ver grafico Gantt" )
	#endif
#endif
