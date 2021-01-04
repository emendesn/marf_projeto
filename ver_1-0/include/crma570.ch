#ifdef SPANISH
	#define STR0001 "Filtro do CRM"
	#define STR0002 "Possíveis Negociações"
	#define STR0003 "Possíveis Negociações com o Feeling maior que 30%"
	#define STR0004 "Possíveis Negociações com Feeling maior que 30%"
	#define STR0005 "2"
	#define STR0006 "Possíveis negociações por Feeling"
	#define STR0007 "Possíveis negociações por Feeling"
	#define STR0008 "Visualizar"
	#define STR0009 "Excluir"
	#define STR0010 "Possíveis Negociações"
	#define STR0011 "Possíveis Negociações"
	#define STR0012 "Possíveis Negociações"
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
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Possíveis Negociações" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Possíveis Negociações com o Feeling maior que 30%" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Possíveis Negociações com Feeling maior que 30%" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "2" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Possíveis negociações por Feeling" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Possíveis negociações por Feeling" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Visualizar" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Excluir" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Possíveis Negociações" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Possíveis Negociações" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Possíveis Negociações" )
	#endif
#endif
