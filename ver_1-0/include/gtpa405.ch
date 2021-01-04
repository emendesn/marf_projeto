#ifdef SPANISH
	#define STR0001 "Complementos de vehiculo"
	#define STR0002 "Complementos de vehiculo"
	#define STR0003 "Accesorios de vehiculo"
	#define STR0004 "Buscar"
	#define STR0005 "Visualizar"
	#define STR0006 "Incluir"
	#define STR0007 "Modificar"
	#define STR0008 "Borrar"
#else
	#ifdef ENGLISH
		#define STR0001 "Vehicle Complements"
		#define STR0002 "Vehicle Complement"
		#define STR0003 "Vehicle accessories"
		#define STR0004 "Query"
		#define STR0005 "View"
		#define STR0006 "Add"
		#define STR0007 "Edit"
		#define STR0008 "Delete"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Complementos de Veículo" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Complementos de Veículo" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Acessórios de Veículo" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Pesquisar" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Visualizar" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Incluir" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Alterar" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Excluir" )
	#endif
#endif
