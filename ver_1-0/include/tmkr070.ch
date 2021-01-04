#ifdef SPANISH
	#define STR0001 "Llamados vinculados"
	#define STR0002 "Telemarketing"
	#define STR0003 "Items - Atencion"
	#define STR0004 "Items compartidos"
	#define STR0005 "Informe el llamado inicial               "
	#define STR0006 "De llamado"
	#define STR0007 "Informe el llamado final                 "
	#define STR0008 "A llamado"
	#define STR0009 "Fecha inicial para la consulta            "
	#define STR0010 "De fecha"
	#define STR0011 "Fecha final para la consulta              "
	#define STR0012 "A fecha"
	#define STR0013 "Lista de operadores por considerar      "
	#define STR0014 "Operadores"
	#define STR0015 "Codigo del cliente inicial por conside-"
	#define STR0016 "rarse en el informe.                      "
	#define STR0017 "Cliente inicial"
	#define STR0018 "Tienda del cliente inicial por considera-"
	#define STR0019 "rse en el informe.                        "
	#define STR0020 "Tienda inicial"
	#define STR0021 "Codigo del cliente final por considerarse"
	#define STR0022 "Cliente final"
	#define STR0023 "Tiendaa del cliente final por considerarse "
	#define STR0024 " en el informe.                          "
	#define STR0025 "Tienda final"
	#define STR0026 "Ejecute el compatibilizador U_UPDTMK45 antes de utilizar este informe"
#else
	#ifdef ENGLISH
		#define STR0001 "Related calls"
		#define STR0002 "Telemarketing"
		#define STR0003 "Items - Service"
		#define STR0004 "Shared Items"
		#define STR0005 "Enter initial call               "
		#define STR0006 "From call"
		#define STR0007 "Enter final call                 "
		#define STR0008 "To call"
		#define STR0009 "Initial date for query            "
		#define STR0010 "From date"
		#define STR0011 "Final date for query              "
		#define STR0012 "To date"
		#define STR0013 "List of operators to consider      "
		#define STR0014 "Operators"
		#define STR0015 "Code of initial customer to consider"
		#define STR0016 "in the report.                      "
		#define STR0017 "Initial customer"
		#define STR0018 "Initial customer unit to consider"
		#define STR0019 "in the report.                        "
		#define STR0020 "Initial unit"
		#define STR0021 "Code of final customer to consider"
		#define STR0022 "Final customer"
		#define STR0023 "Final customer unit to consider "
		#define STR0024 " in the report.                          "
		#define STR0025 "Final unit"
		#define STR0026 "Run compatibility program U_UPDTMK45 before using this report"
	#else
		#define STR0001 "Chamados relacionados"
		#define STR0002 "Telemarketing"
		#define STR0003 "Itens - Atendimento"
		#define STR0004 "Itens compartilhados"
		#define STR0005 "Informe o chamado inicial               "
		#define STR0006 "Do chamado"
		#define STR0007 "Informe o chamado final                 "
		#define STR0008 "At� o chamado"
		#define STR0009 "Data inicial para a consulta            "
		#define STR0010 "Da data"
		#define STR0011 "Data final para a consulta              "
		#define STR0012 "At� a data"
		#define STR0013 "Rela��o de operadores a considerar      "
		#define STR0014 "Operadores"
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "C�digo do cliente inicial a ser conside-", "Codigo do cliente inicial a ser conside-" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "rado no relat�rio.                      ", "rado no relatorio.                      " )
		#define STR0017 "Cliente inicial"
		#define STR0018 "Loja do cliente inicial a ser considera-"
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "do no relat�rio.                        ", "do no relatorio.                        " )
		#define STR0020 "Loja inicial"
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "C�digo do cliente final a ser considera-", "Codigo do cliente final a ser considera-" )
		#define STR0022 "Cliente final"
		#define STR0023 "Loja do cliente final a ser considerado "
		#define STR0024 If( cPaisLoc $ "ANG|PTG", " no relat�rio.                          ", " no relatorio.                          " )
		#define STR0025 "Loja final"
		#define STR0026 "Execute o compatibilizador U_UPDTMK45 antes de utilizar este relat�rio"
	#endif
#endif
