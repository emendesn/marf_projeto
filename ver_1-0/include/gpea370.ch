#ifdef SPANISH
	#define STR0001 "Cargo"
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Incluir"
	#define STR0005 "Modificar"
	#define STR0006 "Borrar"
	#define STR0007 "Salir"
	#define STR0008 "Confirma"
	#define STR0009 "Cuanto al borrado"
	#define STR0010 "Copiar"
#else
	#ifdef ENGLISH
		#define STR0001 "Function"
		#define STR0002 "Search"
		#define STR0003 "View"
		#define STR0004 "Insert"
		#define STR0005 "Edit"
		#define STR0006 "Delete"
		#define STR0007 "Abandon"
		#define STR0008 "Confirm"
		#define STR0009 "As to Deletion"
		#define STR0010 "Copy"
	#else
		#define STR0001 "Cargo"
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Incluir"
		#define STR0005 "Alterar"
		#define STR0006 "Excluir"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Abandonar", "Abandona" )
		#define STR0008 "Confirma"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Quanto a exclusão", "Quanto a exclusao" )
		#define STR0010 "Copiar"
	#endif
#endif
