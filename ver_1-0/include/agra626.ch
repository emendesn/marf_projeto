#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Seleccionar"
	#define STR0004 "Elección de los Ítems de la Lista de Embarque"
	#define STR0005 "Lista de Embarque:"
	#define STR0006 "Tipo:"
	#define STR0007 "Clasificador:"
	#define STR0008 "Marcar/Desmarcar Todos"
	#define STR0009 "Filtra por Bloque:"
	#define STR0010 "Para filtrar los Volúmenes, informe el número del BLOQUE o deje blanco para todos."
	#define STR0011 "¡Atención!"
	#define STR0012 "No existen datos para seleccionar."
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Select"
		#define STR0004 "Selection of Packing List Items"
		#define STR0005 "Packing List:"
		#define STR0006 "Type:"
		#define STR0007 "Classifier:"
		#define STR0008 "Mark/Unmark All"
		#define STR0009 "Filter per Block:"
		#define STR0010 "To filter packages, enter block number or leave it blank for all of them."
		#define STR0011 "Attention!"
		#define STR0012 "There are no selectable data."
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Seleccionar", "Selecionar" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Selecção dos Itens de Romaneio", "Seleção dos Itens de Romaneio" )
		#define STR0005 "Romaneio:"
		#define STR0006 "Tipo:"
		#define STR0007 "Classificador:"
		#define STR0008 "Marcar/Desmarcar Todos"
		#define STR0009 "Filtra por Bloco:"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Para filtrar os fardos, informe o número do BLOCO ou deixe em branco para todos.", "Para filtrar os Fardos, informe o numero do BLOCO ou deixe em Branco para todos." )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Atenção!", "Atencao!" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Não há dados para seleccionar.", "Não há dados para selecionar." )
	#endif
#endif
