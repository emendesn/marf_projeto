#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Renombrar"
	#define STR0003 "Ningun registro encontrado"
	#define STR0004 "Es necesario seleccionar un item"
	#define STR0005 "Digite un titulo para renombrar el item"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "Rename"
		#define STR0003 "No record found."
		#define STR0004 "Select an item"
		#define STR0005 "Enter a title to rename the item"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Renomear"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Nenhum registo encontrado", "Nenhum registro encontrado" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "� necess�rio seleccionar um item", "� necess�rio selecionar um item" )
		#define STR0005 "Digite um t�tulo para renomear o item"
	#endif
#endif
