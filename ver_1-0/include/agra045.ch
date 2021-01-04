#ifdef SPANISH
	#define STR0001 "Archivo de Almacenes de Stock"
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Incluir"
	#define STR0005 "Modificar"
	#define STR0006 "Borrar"
	#define STR0007 "Autorizaciones por almacenes"
	#define STR0008 "Lineas duplicadas"
	#define STR0009 "Registro duplicado, verifique el contenido digitado"
	#define STR0010 "Todos"
	#define STR0011 "Linea en blanco"
	#define STR0012 "Registro en blanco, necesita un contenido para proseguir"
	#define STR0013 "Codigo Alm."
	#define STR0014 "Descripcion"
	#define STR0015 "Usuário"
	#define STR0016 "Produto"
	#define STR0017 "Permissões"
	#define STR0018 "Permisos por Producto"
#else
	#ifdef ENGLISH
		#define STR0001 "Inventory Warehouses"
		#define STR0002 "Search "
		#define STR0003 "View "
		#define STR0004 "Add "
		#define STR0005 "Edit "
		#define STR0006 "Delete "
		#define STR0007 "Permissions by warehouses"
		#define STR0008 "Duplicated Lines"
		#define STR0009 "Duplicated record, check entered content"
		#define STR0010 "All"
		#define STR0011 "Blank line"
		#define STR0012 "Blank record. Content is needed to proceed"
		#define STR0013 "Warehs. Code"
		#define STR0014 "Description"
		#define STR0015 "User"
		#define STR0016 "Product"
		#define STR0017 "Permissions"
		#define STR0018 "Permissions per Product"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Armazéns De Stock", "Armazens de Estoque" )
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Incluir"
		#define STR0005 "Alterar"
		#define STR0006 "Excluir"
		#define STR0007 "Permissões por armazéns"
		#define STR0008 "Linhas duplicadas"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Registo duplicado. Verifique o conteúdo digitado", "Registro duplicado, verifique o conteúdo digitado" )
		#define STR0010 "Todos"
		#define STR0011 "Linha em branco"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Registo em branco. É necessário um conteúdo para prosseguir", "Registro em branco, é necessário um conteúdo para prosseguir" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Código Arm.", "Codigo Arm." )
		#define STR0014 "Descrição"
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Utilizador", "Usuário" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Artigo", "Produto" )
		#define STR0017 "Permissões"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Permissões por artigo", "Permissões por Produto" )
	#endif
#endif
