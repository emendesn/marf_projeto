#ifdef SPANISH
	#define STR0001 "Consulta/Movimiento de Tareas"
	#define STR0002 "Todos"
	#define STR0003 "En Abierto ( Pendiente + Aprobado con restricciones )"
	#define STR0004 "Pendiente"
	#define STR0005 "Aprobado con restricciones"
	#define STR0006 "Aprobado"
	#define STR0007 "Rechazado"
	#define STR0008 "Apagado por el Usuario"
	#define STR0009 "Solicitud"
	#define STR0010 "Ejecucion"
	#define STR0011 "Atendimiento"
	#define STR0012 "Estatus"
	#define STR0013 "Periodo"
	#define STR0014 "a"
	#define STR0015 "Filtrar"
	#define STR0016 "Tarea"
	#define STR0017 "Solicitante"
	#define STR0018 "Ejecutor"
	#define STR0019 "Valor Liberado"
	#define STR0020 "Ejecutar"
	#define STR0021 "Nuevo Estatus"
	#define STR0022 "Observacion"
	#define STR0023 "Ok"
	#define STR0024 "Tarea para Ejecutar"
	#define STR0025 "SALIR"
	#define STR0026 "Valor Solicitado"
	#define STR0027 "hs"
	#define STR0028 "No seleccionada"
	#define STR0029 "Seleccionada"
	#define STR0030 "Obligatoria"
	#define STR0031 "Existe(n) tarea(s) NO Aprobada(s) para el Atendimiento. Imposible continuar!"
	#define STR0032 "Atencion"
	#define STR0033 "Refresh Pantalla"
	#define STR0034 "segundos"
	#define STR0035 "Vuelve Ejecucion"
	#define STR0036 "Imposible volver a la ejecucion de la Tarea"
	#define STR0037 "No existe tarea registrada para el usuario!"
	#define STR0038 "Esta tarea no permite volver a la ejecucion"
	#define STR0039 "Esta tarea bloquea la Finalizacion de una Atencion que ja Finalizo"
	#define STR0040 "Esta tarea bloquea lz Entrega de un Vehiculo que ya se Entrego"
	#define STR0041 "Existe(n) tarea(s) Aprobada(s), para la(s) cual(es) esta tarea es un requisito previo."
	#define STR0042 "Imposible ejecutar la Tarea! Existe(n) requisito(s) previo(s) no aprobado(s)."
	#define STR0043 "Esta tarea bloquea la aprobacion de una atencion que ya se aprobo."
	#define STR0044 "Fecha de realizacion"
	#define STR0045 "Realizacion"
	#define STR0046 "Sucursal Atenc."
#else
	#ifdef ENGLISH
		#define STR0001 "Query/Movement of Tasks"
		#define STR0002 "All"
		#define STR0003 "Open (Pending + Approved with restrictions)"
		#define STR0004 "Pending"
		#define STR0005 "Approved with restrictions"
		#define STR0006 "Approved"
		#define STR0007 "Rejected"
		#define STR0008 "Deleted by the user"
		#define STR0009 "Request"
		#define STR0010 "Execution"
		#define STR0011 "Attendance"
		#define STR0012 "Status"
		#define STR0013 "Period"
		#define STR0014 "to"
		#define STR0015 "Filter"
		#define STR0016 "Task"
		#define STR0017 "Requestor"
		#define STR0018 "Executer"
		#define STR0019 "Value Approved"
		#define STR0020 "Execute"
		#define STR0021 "New Status"
		#define STR0022 "Observation"
		#define STR0023 "OK"
		#define STR0024 "Task to Execute"
		#define STR0025 "EXIT"
		#define STR0026 "Requested Value"
		#define STR0027 "h"
		#define STR0028 "Not selected"
		#define STR0029 "Selected"
		#define STR0030 "Mandatory"
		#define STR0031 "There is(are) task(s) NOT Approved for this Service. Continuing is not possible."
		#define STR0032 "Attention"
		#define STR0033 "Refresh Screen"
		#define STR0034 "seconds"
		#define STR0035 "Return Execution"
		#define STR0036 "Cannot return task execution!"
		#define STR0037 "There is no task registered for the user!"
		#define STR0038 "This task does not allow execution returning!"
		#define STR0039 "This task blocks the Closing of a service already Closed!"
		#define STR0040 "This task blocks the Delivering of a vehicle already Delivered!"
		#define STR0041 "There are Approved tasks for which this task is a requirement."
		#define STR0042 "Cannot execute task! There are unapproved requirements."
		#define STR0043 "This task blocks the approval of a service already approved."
		#define STR0044 "Performance Date"
		#define STR0045 "Performance"
		#define STR0046 "Oper. Branch"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Consulta/Movimentação de Tarefas", "Consulta/Movimentacao de Tarefas" )
		#define STR0002 "Todos"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Em Aberto ( Pendente + Aprovado com restrições )", "Em Aberto ( Pendente + Aprovado com restricoes )" )
		#define STR0004 "Pendente"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Aprovado com restrições", "Aprovado com restricoes" )
		#define STR0006 "Aprovado"
		#define STR0007 "Rejeitado"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Deletado pelo utilizador", "Deletado pelo Usuario" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Solicitação", "Solicitacao" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Execução", "Execucao" )
		#define STR0011 "Atendimento"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Estado", "Status" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Período", "Periodo" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "até", "ate" )
		#define STR0015 "Filtrar"
		#define STR0016 "Tarefa"
		#define STR0017 "Solicitante"
		#define STR0018 "Executor"
		#define STR0019 "Valor Liberado"
		#define STR0020 "Executar"
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Novo Estado", "Novo Status" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Observação", "Observacao" )
		#define STR0023 "OK"
		#define STR0024 "Tarefa a Executar"
		#define STR0025 "SAIR"
		#define STR0026 "Valor Solicitado"
		#define STR0027 "hs"
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Não seleccionada", "Nao selecionada" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Seleccionada", "Selecionada" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Obrigatória", "Obrigatoria" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Existe(m) tarefa(s) NÃO Aprovada(s) para o Atendimento. Impossível continuar!", "Existe(m) tarefa(s) NAO Aprovada(s) para o Atendimento. Impossivel continuar!" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "Atenção", "Atencao" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Refresh Ecrã", "Refresh Tela" )
		#define STR0034 "segundos"
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "Volta execução", "Volta Execucao" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "Impossível voltar à execução da tarefa.", "Impossivel voltar a execucao da Tarefa!" )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Não existe tarefa registada para o utilizador.", "Não existe tarefa cadastrada para o usuario!" )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "Esta tarefa não permite voltar à execução.", "Esta tarefa não permite voltar a execucao!" )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "Esta tarefa bloqueia a finalização de um atendimento que já foi finalizado.", "Esta tarefa bloqueia a Finalizacao de um Atendimento que ja foi Finalizado!" )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", "Esta tarefa bloqueia a entrega de um veículo que já foi entregue.", "Esta tarefa bloqueia a Entrega de um Veiculo que ja foi Entregue!" )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "Existe(m) tarefa(s) aprovada(s), da(s) qual(is) esta tarefa é pré-requisito.", "Existe(m) tarefa(s) Aprovada(s), a(s) qual(is) esta tarefa é pre-requisito." )
		#define STR0042 If( cPaisLoc $ "ANG|PTG", "Impossível executar a tarefa. Existe(m) pré-requisito(s) não aprovado(s).", "Impossivel executar a Tarefa! Existe(m) pre-requisito(s) nao aprovado(s)." )
		#define STR0043 "Esta tarefa bloqueia a aprovação de um atendimento que já foi aprovado."
		#define STR0044 "Data da Realização"
		#define STR0045 "Realização"
		#define STR0046 "Filial Atend."
	#endif
#endif
