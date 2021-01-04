#ifdef SPANISH
	#define STR0001 "Resultado del Cantero"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Imprime"
	#define STR0007 "Copia"
	#define STR0008 "Modelo de datos del Resultado de Cantero"
	#define STR0009 "Resultado del Cantero"
#else
	#ifdef ENGLISH
		#define STR0001 "Seedbed Results"
		#define STR0002 "View"
		#define STR0003 "Add"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Print"
		#define STR0007 "Copy"
		#define STR0008 "Seedbed Result data model"
		#define STR0009 "Seedbed Results"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Resultado de canteiro", "Resultado de Canteiro" )
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Eliminar", "Excluir" )
		#define STR0006 "Imprime"
		#define STR0007 "Copia"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Modelo de dados do resultado de canteiro", "Modelo de dados do Resultado de Canteiro" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Resultado de canteiro", "Resultado de Canteiro" )
	#endif
#endif
