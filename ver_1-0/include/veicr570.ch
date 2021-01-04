#ifdef SPANISH
	#define STR0001 "Clientes/Contactos CEV por Fch.Anivers. o Fch.Mto."
	#define STR0002 "A Rayas"
	#define STR0003 "Administracion"
	#define STR0004 "Codigo    Nombre             Fch. Mov Direccion                       Barrio        Ciudad                Pr CP       Telef.        "
	#define STR0005 "Codigo    Nombre             Fch Nac. Direccion                       Barrio        Ciudad                Pr CP       Telef         "
	#define STR0006 "a"
	#define STR0007 "m"
	#define STR0008 "d"
#else
	#ifdef ENGLISH
		#define STR0001 "Customers/Contacts CEV by Birth Date or Mov. Date."
		#define STR0002 "Z. Form"
		#define STR0003 "Management   "
		#define STR0004 "Code   Name                       Movt.Dt. Address                             Distr.          City-Stat                    ZIP     "
		#define STR0005 "Code   Name                       Birth Dt Address                             Distr.          City-Stat                    ZIP     "
		#define STR0006 "a"
		#define STR0007 "m"
		#define STR0008 "d"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Clientes/contactos Cev Por Dt.anivers. Ou Dt.movto.", "Clientes/Contatos CEV por Dt.Anivers. ou Dt.Movto." )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Código de barras", "Zebrado" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Administração", "Administracao" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Código    nome               dt.movto endereço                        localidade        cidade                distrito código postal      telefone          ", "Codigo    Nome               Dt.Movto Endereco                        Bairro        Cidade                UF CEP      Fone          " )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Código    nome               dt.nasc. endereço                        localidade        cidade                distrito código postal      telefone          ", "Codigo    Nome               Dt.Nasc. Endereco                        Bairro        Cidade                UF CEP      Fone          " )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "A", "a" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "M", "m" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "D", "d" )
	#endif
#endif
