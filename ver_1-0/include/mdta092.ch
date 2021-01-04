#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Tareas"
	#define STR0004 "Tareas del Candidato"
	#define STR0005 "Atencion"
	#define STR0006 "Existen tareas relacionadas a este candidato."
	#define STR0007 "¿Que desea hacer?"
	#define STR0008 "Copiar"
	#define STR0009 "Finalizar"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Tasks"
		#define STR0004 "Candidate Tasks"
		#define STR0005 "Attention"
		#define STR0006 "Tasks are related to this candidate."
		#define STR0007 "What do you want to do?"
		#define STR0008 "Copy"
		#define STR0009 "Finish"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Tarefas"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Tarefas do candidato", "Tarefas do Candidato" )
		#define STR0005 "Atenção"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Existem tarefas relacionadas a este candidato.", "Existem tarefas relacionadas á este candidato." )
		#define STR0007 "O que deseja fazer?"
		#define STR0008 "Copiar"
		#define STR0009 "Finalizar"
	#endif
#endif
