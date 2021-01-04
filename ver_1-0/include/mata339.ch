#ifdef SPANISH
	#define STR0001 "Saldos Iniciais por Ordem de Produção"
	#define STR0002 "Aplicar o update UPDEST52"
	#define STR0003 "Pesquisar"
	#define STR0004 "Visualizar"
#else
	#ifdef ENGLISH
		#define STR0001 "Start Balances per Production Order"
		#define STR0002 "Apply update UPDEST52"
		#define STR0003 "Search"
		#define STR0004 "View"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Saldos Iniciais por Ordem de Produção" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Aplicar o update UPDEST52" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Pesquisar" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Visualizar" )
	#endif
#endif
