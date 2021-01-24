#ifdef SPANISH
	#define STR0001 "Direcciones desocupadas"
	#define STR0002 "Direcciones ocupadas"
	#define STR0003 "Direcciones bloqueadas"
	#define STR0004 "No se encontraron direcciones resgistradas."
	#define STR0005 "Ocupacion almacen"
	#define STR0006 "Direcciones"
#else
	#ifdef ENGLISH
		#define STR0001 "Addresses free"
		#define STR0002 "Addresses occupied"
		#define STR0003 "Addresses blocked"
		#define STR0004 "No addresses registered."
		#define STR0005 "Warehouse occupation"
		#define STR0006 "Address"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Moradas Desocupadas", "Enderecos Desocupados" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Moradas Ocupadas", "Enderecos Ocupados" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Moradas Bloqueadas", "Enderecos Bloqueados" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Não foram encotrados moradas registados.", "Nao foram encotrados Enderecos cadastrados." )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Ocupação Do Armazém", "Ocupacao Armazem" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Moradas", "Enderecos" )
	#endif
#endif
