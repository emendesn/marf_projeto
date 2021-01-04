#ifdef SPANISH
	#define STR0001 "Seleccione archivo "
	#define STR0002 "No existe archivo seleccionado"
	#define STR0003 "Archivo esta siendo usado"
	#define STR0004 "Este archivo no pertenece a la busqueda"
#else
	#ifdef ENGLISH
		#define STR0001 "Select file"
		#define STR0002 "File selected not found"
		#define STR0003 "File is in Use"
		#define STR0004 "File does not belong to the Search"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Seleccionar ficheiro ", "Selecione arquivo " )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Não existe ficheiro seleccionado", "Nao existe arquivo selecionado" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Ficheiro a ser usado", "Arquivo esta sendo usado" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Este ficheiro não pertence à pesquisa", "Este arquivo nao pertence a pesquisa" )
	#endif
#endif
