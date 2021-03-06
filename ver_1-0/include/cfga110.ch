#ifdef SPANISH
	#define STR0001 "Sucursal"
	#define STR0002 "Rutina del menu"
	#define STR0003 "Alias de la tabla"
	#define STR0004 "Buscar"
	#define STR0005 "Visualizar"
	#define STR0006 "Incluir"
	#define STR0007 "Modificar"
	#define STR0008 "Borrar"
	#define STR0009 "Copiar"
	#define STR0010 "Imprimir"
	#define STR0011 "Reglas del WorkFlow ECM"
	#define STR0012 "Rutina o programa del menu del sistema"
	#define STR0013 "Alias de la tabla del sistema"
	#define STR0014 "Item"
	#define STR0015 "Id del proceso en el ECM"
	#define STR0016 "Codigo de identificacion del proceso en el ECM"
	#define STR0017 "Id de la tarea en el ECM"
	#define STR0018 "Codigo de identificacion de la tarea en el ECM"
	#define STR0019 "Regla de ejecucion"
	#define STR0020 "Indica cuando el workflow debe ejecutarse"
	#define STR0021 "Regla de inicializacion/movimiento"
	#define STR0022 "Indica cuando el workflow debe iniciarse o moverse"
	#define STR0023 "�Posee formulario?"
	#define STR0024 "Indica cuando el workflow debe iniciarse con formulario de datos"
	#define STR0025 "Alias de posicionamiento"
	#define STR0026 "Informe el alias de origen del workflow"
	#define STR0027 "Orden de posicionamiento"
	#define STR0028 "Informe la orden de posicionamiento - clave primaria"
	#define STR0029 "Clave de posicionamiento"
	#define STR0030 "Informe la clave de posicionamiento - clave primaria"
	#define STR0031 "Reglas de Workflow"
	#define STR0032 "Expresion invalida."
	#define STR0033 "No se permite el uso de parentesis y de caracteres especiales."
	#define STR0034 "Alias invalido."
	#define STR0035 "Informe un alias valido."
	#define STR0036 "Id del proceso invalido."
	#define STR0037 "Informe un Id de Proceso valido en el ECM o configure la integracion ECM antes de usar esta rutina"
	#define STR0038 "1=Inicia"
	#define STR0039 "2=Mueve"
	#define STR0040 "1=Formulario"
	#define STR0041 "2=Sin Formulario"
	#define STR0042 "Informe los datos para busqueda de la tarea de inicio. (Alias, Orden y Clave de posicionamiento)."
#else
	#ifdef ENGLISH
		#define STR0001 "Branch"
		#define STR0002 "Menu routine"
		#define STR0003 "Table Alias"
		#define STR0004 "Search"
		#define STR0005 "View"
		#define STR0006 "Add"
		#define STR0007 "Edit"
		#define STR0008 "Delete"
		#define STR0009 "Copy"
		#define STR0010 "Print"
		#define STR0011 "ECM Workflow Rules"
		#define STR0012 "System menu program or routine"
		#define STR0013 "System table alias"
		#define STR0014 "Item"
		#define STR0015 "ID of process in ECM"
		#define STR0016 "Identification code of process in ECM"
		#define STR0017 "ID of task in ECM"
		#define STR0018 "Identification code of task in ECM"
		#define STR0019 "Execution rule"
		#define STR0020 "Indicates when workflow must be executed"
		#define STR0021 "Rule of initialization/movement"
		#define STR0022 "Indicates when workflow must be started or moved"
		#define STR0023 "Is there a form?"
		#define STR0024 "Indicated when the workflow must be started with a data form"
		#define STR0025 "Positioning alias"
		#define STR0026 "Enter workflow alias of origin"
		#define STR0027 "Positioning order"
		#define STR0028 "Enter the order of positioning - primary key"
		#define STR0029 "Positioning key"
		#define STR0030 "Enter positioning key - primary key"
		#define STR0031 "Workflow Rules"
		#define STR0032 "Invalid expression. "
		#define STR0033 "It is not allowed to use parenthesis and special characters."
		#define STR0034 "Alias void."
		#define STR0035 "Enter a valid alias"
		#define STR0036 "ID of void process."
		#define STR0037 "Enter an ID of a Process valid in the ECM or configure the ECM integration prior to using this routine"
		#define STR0038 "1=Starts"
		#define STR0039 "2=Moves"
		#define STR0040 "1=Form"
		#define STR0041 "2=No Form"
		#define STR0042 "Enter data to seek starting task. (Alias, Order and Positioning Key)."
	#else
		#define STR0001 "Filial"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Procedimento do menu", "Rotina do menu" )
		#define STR0003 "Alias da tabela"
		#define STR0004 "Pesquisar"
		#define STR0005 "Visualizar"
		#define STR0006 "Incluir"
		#define STR0007 "Alterar"
		#define STR0008 "Excluir"
		#define STR0009 "Copiar"
		#define STR0010 "Imprimir"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Regras do Workflow ECM", "Regras do WorkFlow ECM" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Procedimento ou programa do menu do sistema", "Rotina ou programa do menu do sistema" )
		#define STR0013 "Alias da tabela do sistema"
		#define STR0014 "Item"
		#define STR0015 "Id do processo no ECM"
		#define STR0016 "C�digo de identifica��o do processo no ECM"
		#define STR0017 "Id da tarefa no ECM"
		#define STR0018 "C�digo de identifica��o da tarefa no ECM"
		#define STR0019 "Regra de execu��o"
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Indica quando o Workflow deve ser executado", "Indica quando o workflow deve ser executado" )
		#define STR0021 "Regra de inicializa��o/movimenta��o"
		#define STR0022 "Indica quando o workflow deve ser iniciado ou movimentado"
		#define STR0023 "Possui formul�rio?"
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Indica quando o Workflow deve ser iniciado com formul�rio de dados", "Indica quando o workflow deve ser iniciado com formul�rio de dados" )
		#define STR0025 "Alias de posicionamento"
		#define STR0026 "Informe o alias de origem do workflow"
		#define STR0027 "Ordem de posicionamento"
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Informe a ordem de posicionamento - chave prim�ria", "Informe a ordem de posicionamento - chave primaria" )
		#define STR0029 "Chave de posicionamento"
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Informe a chave de posicionamento - chave prim�ria", "Informe a chave de posicionamento - chave primaria" )
		#define STR0031 "Regras de Workflow"
		#define STR0032 "Express�o inv�lida."
		#define STR0033 "N�o � permitido o uso de par�nteses e de caracteres especiais."
		#define STR0034 "Alias inv�lido."
		#define STR0035 "Informe um alias v�lido"
		#define STR0036 "Id do processo inv�lido."
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Informe um Id de Processo v�lido no ECM, ou configure a integra��o ECM antes de usar este procedimento", "Informe um Id de Processo valido no ECM ou configure a integra��o ECM antes de usar esta rotina" )
		#define STR0038 "1=Inicia"
		#define STR0039 "2=Movimenta"
		#define STR0040 "1=Formul�rio"
		#define STR0041 "2=Sem Formul�rio"
		#define STR0042 If( cPaisLoc $ "ANG|PTG", "Informe os dados para busca da tarefa de in�cio. (Alias, ordem e chave de posicionamento).", "Informe os dados para busca da tarefa de inicio. (Alias, Ordem e Chave de posicionamento)." )
	#endif
#endif
