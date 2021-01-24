#ifdef SPANISH
	#define STR0001 "Contactos Realizados"
	#define STR0002 "T Fc.Visit Vendedor          Cliente                           Ciudad         UF"
	#define STR0003 "Nuestro Numero"
	#define STR0004 "Codigo del Item"
	#define STR0005 "A Rayas"
	#define STR0006 "Administracion"
#else
	#ifdef ENGLISH
		#define STR0001 "Contacts made      "
		#define STR0002 "T Dt.Visit Sales R.          Customer                          City           St"
		#define STR0003 "Our Number"
		#define STR0004 "Item code     "
		#define STR0005 "Z.form "
		#define STR0006 "Management   "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Contactos Realizados", "Contatos Realizados" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "T Dt.visit Vendedor          Cliente                           Cidade         Uf", "T Dt.Visit Vendedor          Cliente                           Cidade         UF" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "O Nosso Número", "Nosso Numero" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Código Do Artigo", "Codigo do Item" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Código de barras", "Zebrado" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Administração", "Administracao" )
	#endif
#endif
