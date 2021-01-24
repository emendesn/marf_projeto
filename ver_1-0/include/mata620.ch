#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Herramientas"
	#define STR0007 "Abandonar"
	#define STR0008 "Confirmar"
	#define STR0009 "¿Cuanto al borrado?"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Add"
		#define STR0004 "Edit  "
		#define STR0005 "Delete"
		#define STR0006 "Tools"
		#define STR0007 "Exit"
		#define STR0008 "Confirm"
		#define STR0009 "About deleting?"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 "Ferramentas"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Abandonar", "Abandona" )
		#define STR0008 "Confirma"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Quanto à Exclusão?", "Quanto à Exclusäo?" )
	#endif
#endif
