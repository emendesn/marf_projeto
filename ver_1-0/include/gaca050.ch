#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "'Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Colecciones"
	#define STR0007 "Operacion invalida. El codigo de esta coleccion se esta utilizando en la tabla de publicaciones."
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Insert"
		#define STR0004 "Edit"
		#define STR0005 "Delete'"
		#define STR0006 "Collections"
		#define STR0007 "Invalid operation. This collection code is being used in the publishing table."
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Colec��es", "Cole��es" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Opera��o inv�lida. o c�digo desta colec��o est� a ser utilizado na tabela de publica��es.", "Opera��o inv�lida. O c�digo desta cole��o est� sendo utilizado na tabela de publica��es." )
	#endif
#endif
