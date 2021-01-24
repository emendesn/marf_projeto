#ifdef SPANISH
	#define STR0001 "Informe para imprimir los EPI relacionados a los riesgos."
	#define STR0002 "Estos riesgos se filtraran por medio de los parametros informados por el"
	#define STR0003 "usuario."
	#define STR0004 "A rayas"
	#define STR0005 "Administracion"
	#define STR0006 "Epi por Riesgo"
	#define STR0007 "Num.Riego  Agente                       Centro de Costo                      Funcion                     Tarea"
	#define STR0008 "Epi....:"
	#define STR0009 "N� Ries."
	#define STR0010 "Agente"
	#define STR0011 "Centro de Costo"
	#define STR0012 "Func."
	#define STR0013 "Tarea"
	#define STR0014 "EPI"
	#define STR0015 "Descripc."
	#define STR0016 "�De Cliente?"
	#define STR0017 "Tda."
	#define STR0018 "�A Cliente  ?"
	#define STR0019 "Cliente"
	#define STR0020 "Tda."
	#define STR0021 "Nomb"
	#define STR0022 "Todos"
	#define STR0023 "Todas"
	#define STR0024 "Cliente/Tda.: "
	#define STR0025 "            Nomb: "
	#define STR0026 "�A  Epi ?"
	#define STR0027 "�De Epi?"
	#define STR0028 "�A Riesgo?"
	#define STR0029 "�De Riesgo ?"
#else
	#ifdef ENGLISH
		#define STR0001 "Report to print the Epi's related to the risks."
		#define STR0002 "These risks will be filtered through the parameters informed by"
		#define STR0003 "The User."
		#define STR0004 "Z-Form"
		#define STR0005 "Administration"
		#define STR0006 "Epi's per Risk"
		#define STR0007 "No. Risk   Agent                        Cost Center                          Function                    Task  "
		#define STR0008 "Epi's..:"
		#define STR0009 "RiskName"
		#define STR0010 "Agent "
		#define STR0011 "Cost center    "
		#define STR0012 "Role  "
		#define STR0013 "Task  "
		#define STR0014 "EPI"
		#define STR0015 "Descript."
		#define STR0016 "From Customer?"
		#define STR0017 "Unit"
		#define STR0018 "To Customer?"
		#define STR0019 "Customer"
		#define STR0020 "Unit"
		#define STR0021 "Name"
		#define STR0022 "All"
		#define STR0023 "All"
		#define STR0024 "Customer/Unit: "
		#define STR0025 "            Name: "
		#define STR0026 "To IPE?"
		#define STR0027 "From IPE?"
		#define STR0028 "To Risk?"
		#define STR0029 "From Risk?"
	#else
		#define STR0001 "Relatorio para imprimir os Epi's relacionados aos riscos."
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Os riscos ser�o filtrados atrav�s dos par�metros indicados pelo", "Esses riscos serao filtrados atraves dos parametros informados pelo" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Utilizador.", "Usuario." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "C�digo de barras", "Zebrado" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Administra��o", "Administracao" )
		#define STR0006 "Epi's por Risco"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "No. Risco  Agente                       Centro De Custo                      Fun��o                      Tarefa", "No. Risco  Agente                       Centro de Custo                      Funcao                      Tarefa" )
		#define STR0008 "Epi's..:"
		#define STR0009 "N� Risco"
		#define STR0010 "Agente"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Centro De Custo", "Centro de Custo" )
		#define STR0012 "Fun��o"
		#define STR0013 "Tarefa"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Epi", "EPI" )
		#define STR0015 "Descri��o"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "De cliente ?", "De Cliente ?" )
		#define STR0017 "Loja"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "At� cliente ?", "At� Cliente ?" )
		#define STR0019 "Cliente"
		#define STR0020 "Loja"
		#define STR0021 "Nome"
		#define STR0022 "Todos"
		#define STR0023 "Todas"
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Cliente/loja: ", "Cliente/Loja: " )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "            nome: ", "            Nome: " )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "At� Epi ?", "Ate Epi ?" )
		#define STR0027 "De Epi ?"
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "At� Risco ?", "Ate Risco ?" )
		#define STR0029 "De Risco ?"
	#endif
#endif
