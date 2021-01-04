#ifdef SPANISH
	#define STR0001 "Resultados de Laboratorios de los lotes de Semillas"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Imprime"
	#define STR0007 "Modelo de datos del Resultado de Laboratorio"
	#define STR0008 "Resultado de Laboratorio"
#else
	#ifdef ENGLISH
		#define STR0001 "Lab results of the seed lots"
		#define STR0002 "View"
		#define STR0003 "Add"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Print"
		#define STR0007 "Lab Result data model"
		#define STR0008 "Lab Results"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Resultados laboratoriais dos lotes de sementes", "Resultados Laboratoriais dos lotes de Sementes" )
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Eliminar", "Excluir" )
		#define STR0006 "Imprime"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Modelo de dados do Resultado laboratorial", "Modelo de dados do Resultado Laboratorial" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Resultado laboratorial", "Resultado Laboratorial" )
	#endif
#endif
