#ifdef SPANISH
	#define STR0001 "Confirma"
	#define STR0002 "Reescribe"
	#define STR0003 "Salir"
	#define STR0004 "Buscar"
	#define STR0005 "Visualizar"
	#define STR0006 "Incluir"
	#define STR0007 "Modificar"
	#define STR0008 "Borrar"
	#define STR0009 "Tipos transporte"
	#define STR0010 "¿Cuanto al borrado?"
	#define STR0011 "Imprimir"
#else
	#ifdef ENGLISH
		#define STR0001 "OK     "
		#define STR0002 "Retype "
		#define STR0003 "Quit   "
		#define STR0004 "Search "
		#define STR0005 "View   "
		#define STR0006 "Add"
		#define STR0007 "Edit"
		#define STR0008 "Delete "
		#define STR0009 "Means of Transp."
		#define STR0010 "About deleting?"
		#define STR0011 "Print"
	#else
		#define STR0001 "Confirma"
		#define STR0002 "Redigita"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Abandonar", "Abandona" )
		#define STR0004 "Pesquisar"
		#define STR0005 "Visualizar"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "I&ncluir", "Incluir" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Al&terar", "Alterar" )
		#define STR0008 "Excluir"
		#define STR0009 "Meios Transporte"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Quanto à exclusão?", "Quanto à exclusäo?" )
		#define STR0011 "Imprimir"
	#endif
#endif
