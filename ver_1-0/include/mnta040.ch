#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Servicios"
	#define STR0007 "Mantenim."
	#define STR0008 "Ord. Servicio"
	#define STR0009 "Relacionar documento"
	#define STR0010 "Atencion"
	#define STR0011 "�Que desea hacer ?"
	#define STR0012 "Relacionar un documento"
	#define STR0013 "Visualizar documento relacionado"
	#define STR0014 "Borrar documento relacionado"
	#define STR0015 "No existe documento asociado a esta demanda."
	#define STR0016 "NO CONFORMIDAD"
	#define STR0017 "Rel.Doc."
	#define STR0018 "Conocimiento"
	#define STR0019 "Existe(n)"
	#define STR0020 "Pendientes"
	#define STR0021 "Autorizadas y no terminadas"
	#define STR0022 "Si"
	#define STR0023 "No"
	#define STR0024 "Registradas"
	#define STR0025 "activa(s)"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Add"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Services"
		#define STR0007 "Maintenance"
		#define STR0008 "Service Orders"
		#define STR0009 "Link document       "
		#define STR0010 "Attention"
		#define STR0011 "What to do?         "
		#define STR0012 "Link document          "
		#define STR0013 "View linked document            "
		#define STR0014 "Delete linked document      "
		#define STR0015 "No document linked to this demand.            "
		#define STR0016 "NON CONFORMANCE "
		#define STR0017 "Lst.Doc."
		#define STR0018 "Knowledge"
		#define STR0019 "There is/are"
		#define STR0020 "Pending"
		#define STR0021 "Cleared and not finished"
		#define STR0022 "Yes"
		#define STR0023 "No"
		#define STR0024 "registered"
		#define STR0025 "actives"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 "Servi�os"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Manuten��es", "Manutencoes" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Ordens Servi�o  ", "Ordens Servico" )
		#define STR0009 "Relacionar documento"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Aten��o", "Atencao" )
		#define STR0011 "O que deseja fazer ?"
		#define STR0012 "Relacionar um documento"
		#define STR0013 "Visualizar documento relacionado"
		#define STR0014 "Apagar documento relacionado"
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "N�o existe documento associado a esta procura.", "Nao existe documento associado a esta demanda." )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "N�o Conformidade", "NAO CONFORMIDADE" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Rel.doc.", "Rel.Doc." )
		#define STR0018 "Conhecimento"
		#define STR0019 "Existe(m)"
		#define STR0020 "Pendentes"
		#define STR0021 "Liberadas e n�o terminadas"
		#define STR0022 "Sim"
		#define STR0023 "N�o"
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "registadas", "cadastradas" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "activa(s)", "ativa(s)" )
	#endif
#endif
