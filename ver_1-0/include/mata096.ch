#ifdef SPANISH
	#define STR0001 "B&uscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Grupos de aprobacion"
	#define STR0007 "Número"
	#define STR0008 "Descripcion"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Insert"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Approvation Groups"
		#define STR0007 "Number"
		#define STR0008 "Description"
	#else
		#define STR0001 "&Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Grupos De Autorização", "Grupos de Aprovacao" )
		#define STR0007 "Número"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Descrição", "Descricao" )
	#endif
#endif
