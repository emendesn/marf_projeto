#ifdef SPANISH
	#define STR0001 "Filtro do CRM"
	#define STR0002 "Poss�veis Negocia��es"
	#define STR0003 "Poss�veis Negocia��es com o Feeling maior que 30%"
	#define STR0004 "Poss�veis Negocia��es com Feeling maior que 30%"
	#define STR0005 "2"
	#define STR0006 "Poss�veis negocia��es por Feeling"
	#define STR0007 "Poss�veis negocia��es por Feeling"
	#define STR0008 "Visualizar"
	#define STR0009 "Excluir"
	#define STR0010 "Poss�veis Negocia��es"
	#define STR0011 "Poss�veis Negocia��es"
	#define STR0012 "Poss�veis Negocia��es"
#else
	#ifdef ENGLISH
		#define STR0001 "CRM Filter"
		#define STR0002 "Possible Negotiations"
		#define STR0003 "Possible Negotiation with Feeling higher than 30%."
		#define STR0004 "Possible Negotiation with Feeling higher than 30%."
		#define STR0005 "2"
		#define STR0006 "Possible Negotiation by Feeling"
		#define STR0007 "Possible Negotiation by Feeling"
		#define STR0008 "View"
		#define STR0009 "Delete"
		#define STR0010 "Possible Negotiations"
		#define STR0011 "Possible Negotiations"
		#define STR0012 "Possible Negotiations"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Filtro do CRM" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Poss�veis Negocia��es" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Poss�veis Negocia��es com o Feeling maior que 30%" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Poss�veis Negocia��es com Feeling maior que 30%" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "2" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Poss�veis negocia��es por Feeling" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Poss�veis negocia��es por Feeling" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Visualizar" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Excluir" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Poss�veis Negocia��es" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Poss�veis Negocia��es" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Poss�veis Negocia��es" )
	#endif
#endif
