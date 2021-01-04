#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Transferir"
	#define STR0004 "Transferencia de Cobranza"
	#define STR0005 "Transferencia de cobranza de cliente"
	#define STR0006 "Codigo"
	#define STR0007 "Tienda"
	#define STR0008 "Nombre"
	#define STR0009 "CNPJ/CPF"
	#define STR0010 "Operador destino"
	#define STR0011 "Marca y Desmarca Todos"
	#define STR0012 "Invierte y Devuelve Seleccion"
	#define STR0013 "La transferencia no podra realizarse pues la regla de seleccion del operador de destino no es compatible con la regla del operador de origen"
	#define STR0014 "Buscar cliente"
	#define STR0015 "�Confirma la transferencia de cuenta(s) seleccionada(s) a un operador de un grupo superior?"
	#define STR0016 "Para transferir cuenta(s) a un grupo superior, este debe tener el mayor plazo (dias) entre todas las regras registradas."
	#define STR0017 " Todas las transferencias de cobranza ya se efectuaron o no existen mas cobranzas para este operador."
	#define STR0018 "Operador de destino no participa de un grupo de atencion con regla de seleccion definida."
#else
	#ifdef ENGLISH
		#define STR0001 "Search "
		#define STR0002 "View "
		#define STR0003 "Transfer"
		#define STR0004 "Transfer of Collection   "
		#define STR0005 "Transfer of customer collection "
		#define STR0006 "Code "
		#define STR0007 "Store"
		#define STR0008 "Name"
		#define STR0009 "CNPJ/CPF"
		#define STR0010 "Destination operator"
		#define STR0011 "Check and uncheck all"
		#define STR0012 "Invert and Return Selection"
		#define STR0013 "The transfer cannot be made due to the rule of selection of target operator being uncompatible with the rule of source operator                 "
		#define STR0014 "Search Customer  "
		#define STR0015 "Confirm transfer of the account(s) selected for an operator of a higher group? "
		#define STR0016 "To transfer account(s) to a higher group, there must be a longer term (days) between the registered rules. "
		#define STR0017 " Transfer successfully completed."
		#define STR0018 "Destination operator does not take part of an attendance group with a defined selection rule."
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Transferir"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Transfer�ncia De Cobran�a", "Transferencia de Cobranca" )
		#define STR0005 "Transfer�ncia de cobran�a de cliente"
		#define STR0006 "C�digo"
		#define STR0007 "Loja"
		#define STR0008 "Nome"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Nr. contribuinte", "CNPJ/CPF" )
		#define STR0010 "Operador destino"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Marca E Desmarca Todos", "Marca e Desmarca Todos" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Inverter E Retornar Selec��o", "Inverte e Retorna Selec�o" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "A transfer�ncia n�o poder� ser realizada pois a regra de selec��o do operador de destino n�o est� compat�vel com a do regra do operador de origem", "A transferencia n�o podera ser realizada pois a regra de selec�o do operador de destino nao esta compativel com a do regra do operador de origem" )
		#define STR0014 "Pesquisar Cliente"
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Confirma a transfer�ncia da(s) conta(s) seleccionada(s) para um operador de um grupo superior?", "Confirma a transfer�ncia da(s) conta(s) selecionada(s) para um operador de um grupo superior?" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Para transferir conta(s) para um grupo superior, o mesmo deve possuir o maior prazo (dias) entre todas as regras registadas.", "Para transferir conta(s) para um grupo superior, o mesmo deve possuir o maior prazo (dias) entre todas as regras cadastradas." )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", " todas as transfer�ncias de cobran�a j� foram efectuadas ou n�o h� mais cobran�as para este operador.", " Todas as transferencias de cobran�a j� foram efetuadas ou n�o h� mais cobran�as para esse operador." )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Operador de destino n�o participa num grupo de atendimento com regra de selec��o definida.", "Operador de destino n�o participa de um grupo de atendimento com regra de sele��o definida." )
	#endif
#endif
