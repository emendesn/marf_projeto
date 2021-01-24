#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Imprimir"
	#define STR0007 "Rectificacion de Time Sheet"
	#define STR0008 "Modelo de Datos de Rectificacion de Time Sheet"
	#define STR0009 "Datos de Rectificacion de Time Sheet"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Add"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Print"
		#define STR0007 "Correction of Time Sheet"
		#define STR0008 "Model of Data of Correction of Time Sheet"
		#define STR0009 "Data of Correction of Time Sheet"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Eliminar", "Excluir" )
		#define STR0006 "Imprimir"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Rectificação de Time Sheet", "Retificacao de Time Sheet" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Modelo de Dados de Rectificação de Time Sheet", "Modelo de Dados de Retificacao de Time Sheet" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Dados de Rectificação de Time Sheet", "Dados de Retificacao de Time Sheet" )
	#endif
#endif
