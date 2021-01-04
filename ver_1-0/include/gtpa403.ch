#ifdef SPANISH
	#define STR0001 "Tipos de seguro de vehiculo"
	#define STR0002 "Tipos de seguro de vehiculo"
	#define STR0003 "Buscar"
	#define STR0004 "Visualizar"
	#define STR0005 "Incluir"
	#define STR0006 "Modificar"
	#define STR0007 "Borrar"
#else
	#ifdef ENGLISH
		#define STR0001 "Types Vehicle Insurance"
		#define STR0002 "Types Vehicle Insurance"
		#define STR0003 "Query"
		#define STR0004 "View"
		#define STR0005 "Add"
		#define STR0006 "Edit"
		#define STR0007 "Delete"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Tipos de Seguro de Veículo" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Tipos de Seguro de Veículo" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Pesquisar" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Visualizar" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Incluir" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Alterar" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Excluir" )
	#endif
#endif
