#ifdef SPANISH
	#define STR0001 "El valor minimo es de "
	#define STR0002 "Tablas y campos informados fuera del estandar."
	#define STR0003 "Campo invalido: "
	#define STR0004 "Tabla invalida: "
#else
	#ifdef ENGLISH
		#define STR0001 "The minimum value is  "
		#define STR0002 "Nonstandard tables and fields."
		#define STR0003 "Invalid field: "
		#define STR0004 "Invalid table: "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "O valor mínimo é de " )
		#define STR0002 "Tabelas e campos informados fora do padrão."
		#define STR0003 "Campo invalido: "
		#define STR0004 "Tabela invalida: "
	#endif
#endif
