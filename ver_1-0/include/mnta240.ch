#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Tarea Generica"
	#define STR0007 "Conocimiento"
	#define STR0008 "SIN ESPECIFICACION DE TAREA"
	#define STR0009 "Espere, modificando la Descripcion de la Tarea en los Mantenimientos..."
	#define STR0010 "De acuerdo con el parametro MV_NGTARGE, la Empresa/Sucursal no utiliza concepto de Tarea Generica."
	#define STR0011 "No se permite Modificar o Excluir la Tarea 0"
	#define STR0012 "Atencion"
	#define STR0013 "Existen mantenimientos que utilizan esta Tarea Generica. Todos los mantenimientos se modificaran."
	#define STR0014 "Dependiendo de la cantidad de registro este proceso podra demorar. �Confirmar?"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Add"
		#define STR0004 "Change"
		#define STR0005 "Delete"
		#define STR0006 "Overall Task"
		#define STR0007 "Knowledge"
		#define STR0008 "TASK NOT SPECIFIED"
		#define STR0009 "Wait, editing Task Description in Maintenances..."
		#define STR0010 "According to parameter MV_NGTARGE, the Company/Branch does not use concept of Generic Task."
		#define STR0011 "Task 0 cannot be edited or deleted."
		#define STR0012 "Attention"
		#define STR0013 "There are maintenances that use this Generic Task. All maintenances will be edited."
		#define STR0014 "Depending on the record amount, this process may take long. Confirm?"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 "Tarefa Gen�rica"
		#define STR0007 "Conhecimento"
		#define STR0008 "SEM ESPECIFICA��O DE TAREFA"
		#define STR0009 "Aguarde, alterando a Descri�ao da Tarefa nas Manuten��es..."
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "De acordo com o par�metro MV_NGTARGE, a Empresa/Filial n�o utiliza conceito de Tarefa Gen�rica.", "De acordo com o parametro MV_NGTARGE, a Empresa/Filial n�o utiliza conceito de Tarefa Gen�rica." )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "N�o � permitido Alterar ou Eliminar a Tarefa 0", "N�o � permitido Alterar ou Excluir a Tarefa 0" )
		#define STR0012 "Aten��o"
		#define STR0013 "Existem manuten��es que utilizam esta Tarefa Gen�rica. Todas as manuten��es ser�o alteradas."
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Dependendo da quantidade de registo este processo poder� demorar. Confirmar?", "Dependendo da quantidade de registro este processo poder� demorar. Confirmar?" )
	#endif
#endif
