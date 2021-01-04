#ifdef SPANISH
	#define STR0001 "Consulta historial del vehiculo en el taller."
	#define STR0002 "Identificación del Vehículo"
	#define STR0003 "Buscar"
	#define STR0004 "Consulta"
	#define STR0005 "Busqueda avanzada."
#else
	#ifdef ENGLISH
		#define STR0001 "Query History of the Vehicle in the Repair Shop"
		#define STR0002 "Vehicle Identification"
		#define STR0003 "Search"
		#define STR0004 "Query"
		#define STR0005 "Advanced Search"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Consulta histórico do veículo na oficina", "Consulta Histórico do Veículo na Oficina" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Identificação do veículo", "Identificação do Veículo" )
		#define STR0003 "Pesquisar"
		#define STR0004 "Consulta"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Pesq.avançada", "Pesq.Avançada" )
	#endif
#endif
