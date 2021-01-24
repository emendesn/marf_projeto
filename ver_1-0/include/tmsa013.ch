#ifdef SPANISH
	#define STR0001 "Componentes de Flete por Destinatario"
	#define STR0002 "Items del Componente de Flete por Destinatario"
	#define STR0003 "Doc.Cobranza"
	#define STR0004 "Buscar"
	#define STR0005 "Visualizar"
	#define STR0006 "Incluir"
	#define STR0007 "Modificar"
	#define STR0008 "Borrar"
#else
	#ifdef ENGLISH
		#define STR0001 "Freight Components per Recipient"
		#define STR0002 "Items of Freight Components per Recipient"
		#define STR0003 "Collection Doc."
		#define STR0004 "Search"
		#define STR0005 "View"
		#define STR0006 "Add"
		#define STR0007 "Edit"
		#define STR0008 "Delete"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Componentes de frete por destinatário", "Componentes de Frete por Destinatário" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Itens do componente de frete por destinatário", "Itens do Componente de Frete por Destinatário" )
		#define STR0003 "Doc.Cobrança"
		#define STR0004 "Pesquisar"
		#define STR0005 "Visualizar"
		#define STR0006 "Incluir"
		#define STR0007 "Alterar"
		#define STR0008 "Excluir"
	#endif
#endif
