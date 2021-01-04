#ifdef SPANISH
	#define STR0001 "Segmentos de negocio"
	#define STR0002 "Segmentos"
	#define STR0003 "Subsegmentos"
	#define STR0004 "Segmentos"
	#define STR0005 "Buscar"
	#define STR0006 "Visualizar"
	#define STR0007 "Incluir"
	#define STR0008 "Modificar"
	#define STR0009 "Borrar"
#else
	#ifdef ENGLISH
		#define STR0001 "Business Segments"
		#define STR0002 "Segments"
		#define STR0003 "Subsegments"
		#define STR0004 "Segments"
		#define STR0005 "Search"
		#define STR0006 "View"
		#define STR0007 "Add"
		#define STR0008 "Edit"
		#define STR0009 "Delete"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Segmentos de Negócio" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Segmentos" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Subsegmentos" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Segmentos" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Pesquisar" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Visualizar" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Incluir" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Alterar" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Excluir" )
	#endif
#endif
