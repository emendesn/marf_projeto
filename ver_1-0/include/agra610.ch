#ifdef SPANISH
	#define STR0001 "Archivo de Bloques"
	#define STR0002 "PROHIBIDO"
	#define STR0003 "Imposible excluir el bloque pues se est� usando."
	#define STR0004 "Buscar"
	#define STR0005 "Visualizar"
	#define STR0006 "Incluir"
	#define STR0007 "Alterar"
	#define STR0008 "Excluir"
#else
	#ifdef ENGLISH
		#define STR0001 "Block Register"
		#define STR0002 "FORBIDDEN"
		#define STR0003 "Cannot delete block because it is already in use"
		#define STR0004 "Search"
		#define STR0005 "View"
		#define STR0006 "Add"
		#define STR0007 "Modify"
		#define STR0008 "Delete"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Registo de Blocos", "Cadastro de Blocos" )
		#define STR0002 "PROIBIDO"
		#define STR0003 "O bloco n�o pode ser exclu�do pois j� est� em uso."
		#define STR0004 "Pesquisar"
		#define STR0005 "Visualizar"
		#define STR0006 "Incluir"
		#define STR0007 "Alterar"
		#define STR0008 "Excluir"
	#endif
#endif
