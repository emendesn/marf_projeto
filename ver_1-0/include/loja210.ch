#ifdef SPANISH
	#define STR0001 "Codigos de barra por producto"
	#define STR0002 "No se permite modificar el codigo."
	#define STR0003 "Buscar"
	#define STR0004 "Visualizar"
	#define STR0005 "Incluir"
	#define STR0006 "Modificar"
	#define STR0007 "Borrar"
#else
	#ifdef ENGLISH
		#define STR0001 "Barcode by product"
		#define STR0002 "It is not allowed to edit code"
		#define STR0003 "Search"
		#define STR0004 "View"
		#define STR0005 "Add"
		#define STR0006 "Change"
		#define STR0007 "Delete"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Códigos de barra por produto", "Codigos de barra por produto" )
		#define STR0002 "Não é permitido alterar o código."
		#define STR0003 "Pesquisar"
		#define STR0004 "Visualizar"
		#define STR0005 "Incluir"
		#define STR0006 "Alterar"
		#define STR0007 "Excluir"
	#endif
#endif
