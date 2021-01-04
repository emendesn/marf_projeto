#ifdef SPANISH
	#define STR0001 "Vinculo Producto vs. Ocurrencias "
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Generar O.S."
	#define STR0005 "Plan de Mantenimiento - Generacion de OS"
	#define STR0006 "Producto"
	#define STR0007 "Num.Serie"
	#define STR0008 "Procesado"
	#define STR0009 "   Este programa efectua la generacion de Ordenes de Servicio para los"
	#define STR0010 "movimientos del plan de mantenimiento preventivo existente, de acuerdo"
	#define STR0011 "con los parametros solicitados."
#else
	#ifdef ENGLISH
		#define STR0001 "Product x Occurrences Binding"
		#define STR0002 "Search"
		#define STR0003 "View"
		#define STR0004 "Generate S.O."
		#define STR0005 "Maintenance Plans - SO Generation"
		#define STR0006 "Product"
		#define STR0007 "Serial No."
		#define STR0008 "Processing"
		#define STR0009 "     This program generates Service Orders for the existing "
		#define STR0010 "preventive maintenance plan movements, according to the "
		#define STR0011 "selected parameters."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Movimentos De Planos De Manutenção", "Movimentos de Planos de Manutencao" )
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Gerar Os", "Gerar O.S." )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Planos De Manutenção - Geração De Os", "Planos de Manutencao - Geracao de OS" )
		#define STR0006 "Produto"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Num.série", "Id.Unico" )
		#define STR0008 "Processado"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "     este programa efectua a geração das ordens de serviço para os", "     Este programa efetua a geracao das Ordens de Servico para os" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Movimentos do plano de manutenção preventiva existentes, cofacturaorme", "movimentos do plano de manutencao preventiva existentes, conforme" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Os parâmetros solicitados.", "os parametros solicitados." )
	#endif
#endif
