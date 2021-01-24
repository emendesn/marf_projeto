#ifdef SPANISH
	#define STR0001 "Reduccion del costo de procedimientos"
	#define STR0002 "Aplicacion de reduccion de costo en las cuentas medicas"
	#define STR0003 "Ningun procedimiento parametrizado para este grupo."
	#define STR0004 "Ningun movimiento encontrado por procesarse."
	#define STR0005 "Grupos Reductores"
	#define STR0006 "Seleccione el grupo que desea procesar"
	#define STR0007 "Codigo"
	#define STR0008 "Descripcion"
#else
	#ifdef ENGLISH
		#define STR0001 "Reduction of procedures cost"
		#define STR0002 "Application of cost reduction in medical expenses"
		#define STR0003 "No parameterized procedure for this group."
		#define STR0004 "No transaction was found to be processed."
		#define STR0005 "Reducing Groups"
		#define STR0006 "Select groups to be processed"
		#define STR0007 "Code"
		#define STR0008 "Description"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Reducção do custo de procedimentos", "Reducao do custo de procedimentos" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Aplicação de reducção de custo nas contas médicas", "Aplicação de redução de custo nas contas médicas" )
		#define STR0003 "Nenhum procedimento parametrizado para este grupo."
		#define STR0004 "Nenhuma movimentação encontrada para ser processada."
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Grupos Reductores", "Grupos Redutores" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Seleccione o(s) grupo(s) que deseja processar", "Selecione o(s) grupo(s) que deseja processar" )
		#define STR0007 "Código"
		#define STR0008 "Descrição"
	#endif
#endif
