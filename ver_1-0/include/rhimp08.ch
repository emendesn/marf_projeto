#ifdef SPANISH
	#define STR0001 'Empleado'
#else
	#ifdef ENGLISH
		#define STR0001 'Employee'
	#else
		#define STR0001 'Funcionário'
	#endif
#endif
