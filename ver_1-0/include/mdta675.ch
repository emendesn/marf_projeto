#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Investigacion"
	#define STR0004 "Acto Inseguro"
	#define STR0005 "Cond. Inseg."
	#define STR0006 "Plan Accion"
	#define STR0007 "Plan de Accion vs Accidente"
	#define STR0008 "Incluir"
	#define STR0010 "Borrar"
	#define STR0011 "Condicion insegura"
	#define STR0012 "Plan de accion por accidente"
	#define STR0013 "Alterar"
	#define STR0014 "Participantes"
	#define STR0015 "Clientes"
	#define STR0016 "Acidentes"
	#define STR0017 "ATENCION"
	#define STR0018 "Ya existe una causa con este codigo."
	#define STR0019 "Por favor, informe un otro codigo."
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Investigation"
		#define STR0004 "Unsafe Act"
		#define STR0005 "Unsafe Cond."
		#define STR0006 "Action Plan"
		#define STR0007 "Action Plan X Accident"
		#define STR0008 "Add"
		#define STR0010 "Delete"
		#define STR0011 "Unsafe Condition"
		#define STR0012 "Action Plan by Accident"
		#define STR0013 "Edit"
		#define STR0014 "Participants"
		#define STR0015 "Customers"
		#define STR0016 "Accidents"
		#define STR0017 "ATTENTION"
		#define STR0018 "There is already a Cause with this code."
		#define STR0019 "Please enter another code."
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Investiga��o", "Investigacao" )
		#define STR0004 "Ato Inseguro"
		#define STR0005 "Cond. Inseg."
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Plano Ac��o", "Plano Acao" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Plano De Ac��o X Acidente", "Plano de Acao X Acidente" )
		#define STR0008 "Incluir"
		#define STR0010 "Excluir"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Condi��o Insegura", "Condicao Insegura" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Plano De Ac��o  Por Acidente", "Plano de Acao por Acidente" )
		#define STR0013 "Alterar"
		#define STR0014 "Participantes"
		#define STR0015 "Clientes"
		#define STR0016 "Acidentes"
		#define STR0017 "ATEN��O"
		#define STR0018 "J� existe uma Causa com este c�digo."
		#define STR0019 "Favor informar um outro c�digo."
	#endif
#endif