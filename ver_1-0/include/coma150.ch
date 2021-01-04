#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Inserir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Archivo de Almacen"
	#define STR0007 "Permisos por Usuario"
	#define STR0008 "Permisos por Producto"
	#define STR0009 "TODOS"
#else
	#ifdef ENGLISH
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Inserir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 "Cadastro de Armaz�m"
		#define STR0007 "Permiss�es por Usu�rio"
		#define STR0008 "Permiss�es por Produto"
		#define STR0009 "TODOS"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Inserir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Registo de Armaz�m", "Cadastro de Armaz�m" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Permiss�es por Utilizador", "Permiss�es por Usu�rio" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Permiss�es por Artigo", "Permiss�es por Produto" )
		#define STR0009 "TODOS"
	#endif
#endif
