#ifdef SPANISH
	#define STR0001 "Visualizador de Grafico de Gantt"
	#define STR0002 "Abrir"
	#define STR0003 "Grabar"
#else
	#ifdef ENGLISH
		#define STR0001 "Visualizador de Grafico de Gantt"
		#define STR0002 "Abrir"
		#define STR0003 "Salvar"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Visualizador De Diagrama De Gantt", "Visualizador de Grafico de Gantt" )
		#define STR0002 "Abrir"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Guardar", "Salvar" )
	#endif
#endif
