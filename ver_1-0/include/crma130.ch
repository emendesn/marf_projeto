#ifdef SPANISH
	#define STR0001 "Archivo de especificaciones"
	#define STR0002 "Filtro especificacion X Entidades"
	#define STR0003 "Archivo de especificaciones"
	#define STR0004 "Especificaciones"
	#define STR0005 "Buscar"
	#define STR0007 "Visualizar"
	#define STR0008 "Incluir"
	#define STR0009 "Modificar"
	#define STR0010 "Borrar"
	#define STR0011 "Adjuntar"
	#define STR0012 "Total de registros"
	#define STR0013 "Especificaciones activas"
	#define STR0014 "Especificaciones inactivas"
#else
	#ifdef ENGLISH
		#define STR0001 "Specifications Register"
		#define STR0002 "Specification x Entity Filter"
		#define STR0003 "Specifications Register"
		#define STR0004 "Specifications"
		#define STR0005 "Search"
		#define STR0007 "View"
		#define STR0008 "Add"
		#define STR0009 "Change"
		#define STR0010 "Delete"
		#define STR0011 "Attach"
		#define STR0012 "Total of Records"
		#define STR0013 "Active Specifications"
		#define STR0014 "Inactive Specifications"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Cadastro de Especificações" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Filtro Especificação X Entidades" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Cadastro de Especificações" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Especificações" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Pesquisar" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Visualizar" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Incluir" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Alterar" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Excluir" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Anexar" )
		#define STR0012 "Total de Registros"
		#define STR0013 "Especificações Ativas"
		#define STR0014 "Especificações Inativas"
	#endif
#endif
