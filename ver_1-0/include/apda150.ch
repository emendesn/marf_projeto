#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Registro de Periodos"
	#define STR0007 "Otro usuario esta utilizando el Registro"
	#define STR0008 "¿Intenta nuevamente?"
	#define STR0009 "¿Intenta nuevamente?"
	#define STR0010 "Intentando acceder al registro."
	#define STR0011 "Mayor que Fecha Final."
	#define STR0012 "Menor que Fecha Inicial."
	#define STR0013 "Fecha Invalida"
	#define STR0014 "Mapa de Conocimiento"
	#define STR0015 "Plan de Desarrollo"
	#define STR0016 "Plan de Metas"
	#define STR0017 "Evaluacion"
	#define STR0018 "Proyecto"
#else
	#ifdef ENGLISH
		#define STR0001 "Search   "
		#define STR0002 "Search   "
		#define STR0003 "View      "
		#define STR0004 "Insert "
		#define STR0005 "Edit   "
		#define STR0006 "Delete "
		#define STR0007 "The record is being used by another user.        "
		#define STR0008 "Please, try again"
		#define STR0009 "Trying to access the record."
		#define STR0010 "Date cannot be blank or   "
		#define STR0011 "Higher than Final Dt."
		#define STR0012 "Lower than Initial Dt.."
		#define STR0013 "Invalid Date "
		#define STR0014 "Knowledge Map "
		#define STR0015 "Development Plan "
		#define STR0016 "Target plan "
		#define STR0017 "Evaluation"
		#define STR0018 "Project"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Registo De Períodos", "Cadastro de Periodos" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "O registo está a ser utilizado por outro utilizador", "O Registro esta sendo utilizado por outro usuario" )
		#define STR0008 "Tentar novamente?"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "A tentar aceder ao registo.", "Tentando acessar o registro." )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Data não pode ser nula ou", "Data Näo Pode Ser Vazia ou" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Maior Que A Data Final.", "Maior que Data Final." )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Inferior à Data Inicial.", "Menor que Data Inicial." )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Data Inválida", "Data Invalida" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Mapa De Conhecimento", "Mapa do Conhecimento" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Plano De Desenvolvimento", "Plano de Desenvolvimento" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Plano De Objectivos", "Plano de Metas" )
		#define STR0017 "Avaliação"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Projecto", "Projeto" )
	#endif
#endif
