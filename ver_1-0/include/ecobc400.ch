#ifdef SPANISH
	#define STR0001 "Bancos"
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Incluir"
	#define STR0005 "Modificar"
	#define STR0006 "Borrar"
	#define STR0007 "¿Esta seguro que desea borrar banco? Codigo:"
#else
	#ifdef ENGLISH
		#define STR0001 "Banks "
		#define STR0002 "Search "
		#define STR0003 "View "
		#define STR0004 "Add "
		#define STR0005 "Edit "
		#define STR0006 "Delete "
		#define STR0007 "Are you sure that you want to delete bank?Code:"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Bases de dados", "Bancos" )
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Incluir"
		#define STR0005 "Alterar"
		#define STR0006 "Excluir"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Tem a certeza que deseja excluir banco ? código: ", "Tem certeza que deseja excluir banco ? Código: " )
	#endif
#endif
