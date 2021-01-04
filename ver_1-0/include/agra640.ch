#ifdef SPANISH
	#define STR0001 "Archivo de Layout de importacion de archivos"
	#define STR0002 'Visualizar'
	#define STR0003 'Incluir'
	#define STR0004 'Modificar'
	#define STR0005 'Borrar'
	#define STR0006 'Modelo de datos del Layout del archivo de importacion'
	#define STR0007 'Datos del Layout'
	#define STR0008 'Datos de los Items del Layout'
	#define STR0009 "Tabla DX7"
	#define STR0010 "Campo"
	#define STR0011 "Titulo"
#else
	#ifdef ENGLISH
		#define STR0001 "Files import Layout Register"
		#define STR0002 'View'
		#define STR0003 'Add'
		#define STR0004 'Edit'
		#define STR0005 'Delete'
		#define STR0006 'Import file Layout data model'
		#define STR0007 'Layout Data'
		#define STR0008 'Layout Item Data'
		#define STR0009 "DX7 Table"
		#define STR0010 "Field"
		#define STR0011 "Bill"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Registo de layout de importação de ficheiros", "Cadastro de Layout de importação de arquivos" )
		#define STR0002 'Visualizar'
		#define STR0003 'Incluir'
		#define STR0004 'Alterar'
		#define STR0005 If( cPaisLoc $ "ANG|PTG", 'Eliminar', 'Excluir' )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", 'Modelo de dados do layout do ficheiro de importação', 'Modelo de dados do Layout do arquivo de importação' )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", 'Dados do layout', 'Dados do Layout' )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", 'Dados dos itens do layout', 'Dados dos Itens do Layout' )
		#define STR0009 "Tabela DX7"
		#define STR0010 "Campo"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Título", "Titulo" )
	#endif
#endif
