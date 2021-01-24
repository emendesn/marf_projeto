#ifdef SPANISH
	#define STR0001 "En ejecucion"
	#define STR0002 "Atrasado"
	#define STR0003 "Encerrado sin atraso"
	#define STR0004 "Encerrado con atraso"
#else
	#ifdef ENGLISH
		#define STR0001 "In progress"
		#define STR0002 "Past due"
		#define STR0003 "Terminated without Delay"
		#define STR0004 "Terminated with Delay"
	#else
		#define STR0001 "Em Andamento"
		#define STR0002 "Em Atraso"
		#define STR0003 "Encerrado sem Atraso"
		#define STR0004 "Encerrado com Atraso"
	#endif
#endif
