#ifdef SPANISH
	#define STR0001 "Actividades abiertas"
	#define STR0002 "Tipo"
	#define STR0003 "Tarea"
	#define STR0004 "Compromiso"
	#define STR0005 "Email"
	#define STR0006 "Tipo"
	#define STR0007 "No iniciado"
	#define STR0008 "En ejecucion"
	#define STR0009 "Espera de otros"
	#define STR0010 "Adiada"
	#define STR0011 "Pendiente"
	#define STR0012 "Estatus"
	#define STR0013 "Alta"
	#define STR0014 "Normal"
	#define STR0015 "Baja"
	#define STR0016 "Prioridad"
	#define STR0017 "Visualizar actividad"
	#define STR0018 "Hoy"
	#define STR0019 "Proximos 7 dias"
	#define STR0020 "Proximos 30 dias"
	#define STR0021 "Proximos 60 dias"
#else
	#ifdef ENGLISH
		#define STR0001 "Open Activities"
		#define STR0002 "Type"
		#define STR0003 "Task"
		#define STR0004 "Commitment"
		#define STR0005 "E-mail"
		#define STR0006 "Type"
		#define STR0007 "Not started"
		#define STR0008 "In progress"
		#define STR0009 "Waiting others"
		#define STR0010 "Postponed"
		#define STR0011 "Pending"
		#define STR0012 "Status"
		#define STR0013 "High"
		#define STR0014 "Normal"
		#define STR0015 "Write-off"
		#define STR0016 "Priority"
		#define STR0017 "View Activity"
		#define STR0018 "Today"
		#define STR0019 "Next 7 days"
		#define STR0020 "Next 30 days"
		#define STR0021 "Next 60 days"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Atividades Abertas" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Tipo" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Tarefa" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Compromisso" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "E-mail" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Tipo" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Não iniciado" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Em andamento" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Aguardando outros" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Adiada" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Pendente" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Status" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Alta" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Normal" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Baixa" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Prioridade" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Visualizar Atividade" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Hoje" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Próximos 7 dias" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Próximos 30 dias" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Próximos 60 dias" )
	#endif
#endif
