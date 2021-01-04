#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Imprimir"
	#define STR0007 "Gasto Juridico"
	#define STR0008 "Modelo de Datos de Gasto Juridico"
	#define STR0009 "Datos de Gasto Juridico"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Add"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Print"
		#define STR0007 "Legal Expense"
		#define STR0008 "Data Model of Legal Expense"
		#define STR0009 "Legal Expense Data"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Eliminar", "Excluir" )
		#define STR0006 "Imprimir"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Despesa Jurídica", "Despesa Juridica" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Modelo de Dados de Despesa Jurídica", "Modelo de Dados de Despesa Juridica" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Dados de Despesa Jurídica", "Dados de Despesa Juridica" )
	#endif
#endif
