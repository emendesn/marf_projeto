#ifdef SPANISH
	#define STR0001 "Consulta historial del vehiculo en el taller."
	#define STR0002 "Identificaci�n del Veh�culo"
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
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Consulta hist�rico do ve�culo na oficina", "Consulta Hist�rico do Ve�culo na Oficina" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Identifica��o do ve�culo", "Identifica��o do Ve�culo" )
		#define STR0003 "Pesquisar"
		#define STR0004 "Consulta"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Pesq.avan�ada", "Pesq.Avan�ada" )
	#endif
#endif
