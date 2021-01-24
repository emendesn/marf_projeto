#ifdef SPANISH
	#define STR0001 "Realizar evaluaciones de desempeno, para acompanar y auxiliar la evolucion del desempeno de participantes."
	#define STR0002 "Planificar y acompanar metas establecidas, garantizando feedbacks regulares y consistentes a los participantes, que sirvan de base para acciones de reconocimiento segun la politica de la organizacion."
#else
	#ifdef ENGLISH
		#define STR0001 "Execute the performance evaluation in order to follow up and help the employees performance evolution."
		#define STR0002 "Plan and monitor established goals, ensuring regular and consistent feedback to employees, as the basis for recognition actions according to the company's policies."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Realizar avalia��es de desempenho, para acompanhar e auxiliar a evolu��o da performance dos colaboradores.", "Realizar avalia��es de desempenho, para acompanhar e auxiliar a evolu��o da performance dos participantes." )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Planear e acompanhar metas estabelecidas, garantindo feedbacks regulares e consistentes aos participantes,  servindo de base para ac��es de reconhecimento de acordo com a pol�tica da organiza��o.", "Planejar e acompanhar metas estabelecidas, garantindo feedbacks regulares e consistentes aos participantes,  servindo de base para a��es de reconhecimento de acordo com a pol�tica da organiza��o." )
	#endif
#endif
