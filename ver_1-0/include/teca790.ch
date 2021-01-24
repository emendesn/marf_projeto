#ifdef SPANISH
	#define STR0001 "Archivo de feriados"
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Incluir"
	#define STR0005 "Modificar"
	#define STR0006 "Borrar"
	#define STR0007 "Archivo de feriados"
#else
	#ifdef ENGLISH
		#define STR0001 "Holiday Register"
		#define STR0002 "Search"
		#define STR0003 "View"
		#define STR0004 "Add"
		#define STR0005 "Edit"
		#define STR0006 "Delete"
		#define STR0007 "Holiday Register"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Cadastro de Feriados" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Pesquisar" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Visualizar" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Incluir" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Alterar" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Excluir" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Cadastro de Feriados" )
	#endif
#endif
