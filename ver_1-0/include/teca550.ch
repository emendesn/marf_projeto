#ifdef SPANISH
	#define STR0001 'Mantenimiento de la Agenda'
	#define STR0002 "Modificar"
	#define STR0003 "Borrar"
	#define STR0004 "Visualizar"
	#define STR0005 "Sel. Sustituto"
	#define STR0006 "Motivo no encontrado."
	#define STR0007 "Informe la fecha y hora inicial de la atencion o el tiempo de atraso."
	#define STR0008 "Informe la fecha y hora final de la atencion o el tiempo da salida anticipada."
	#define STR0009 "Informe la fecha y hora inicial o la fecha y hora final de la atencion para registrar la hora extra."
	#define STR0010 "Informe el item de la OS para donde se transfirio al operador."
	#define STR0011 "La agenda del dia "
	#define STR0012 " ya tiene mantenimiento por motivo del mismo tipo. Utilice la opcion Detalles para modificar este mantenimiento."
	#define STR0013 "La fecha y hora inicial debe ser superior al original."
	#define STR0014 "La fecha y hora inicial debe ser inferior a la hora final de la agenda."
	#define STR0015 "El tiempo de atraso no puede ser mayor que el tiempo de atencion."
	#define STR0016 "La hora final debe ser inferior a la hora final de la agenda y superior a la hora inicial."
	#define STR0017 "Tipo de motivo seleccionado no permite sustitucion."
	#define STR0018 "Horas contratadas"
	#define STR0019 "Horas asignadas"
	#define STR0020 "Saldo de horas"
	#define STR0021 "Falla al subir la rutina. Alias invalido."
	#define STR0022 "Item seleccionado no tiene configuracion de Orden de servicio."
	#define STR0023 "Configuracion del contrato"
	#define STR0024 "No se selecciono ninguna configuracion de contrato. Active la consulta del Item de la OS, seleccione un item y confirme para mostrar las configuraciones del contrato y seleccione una para la transferencia."
	#define STR0025 " se desactivo y no se puede realizar mantenimiento."
	#define STR0026 " ya se atendio y no se puede realizar mantenimiento."
	#define STR0027 "Limpiar subtitulo"
	#define STR0028 "No es posible registrar el atraso. "
	#define STR0029 " tiene hora extra antes del horario inicial."
	#define STR0030 "No es posible registrar la salida anticipada. "
	#define STR0031 " tiene hora extra despues del horario final."
	#define STR0032 "El tiempo total de hora extra debe ser mayor que Cero."
	#define STR0033 " tiene atraso y salida anticipada registrada."
	#define STR0034 "Para incluir la hora extra borre el atraso o la salida anticipada."
	#define STR0035 " tiene atraso registrado."
	#define STR0036 "No es posible incluir hora extra anterior al horario inicial y atraso al mismo tiempo."
	#define STR0037 " tiene salida anticipada registrada."
	#define STR0038 "No es posible incluir hora extra superior al horario final y salida anticipada al mismo tiempo."
	#define STR0039 "No se permiten transferencias de operadores que tengan turno con intervalo. Utilice la asignacion para cambiar la agenda."
	#define STR0040 "Los mantenimientos pueden replicarse para otros periodo del mismo dia."
	#define STR0041 "�Desea replicar?"
	#define STR0042 "Atencion"
	#define STR0043 "Si"
	#define STR0044 "No"
	#define STR0045 "Para borrar este mantenimiento, excluya antes el ultimo mantenimiento."
	#define STR0046 "Registro no encontrado para exclusion."
	#define STR0047 "La transferencia no puede ocurrir para la misma Orden de Servicio e Item"
	#define STR0048 "No se permite la modificacion en masa para agendas con horarios de entrada y salida diferentes"
	#define STR0049 "Solamente se permite la atribucion de faltas"
	#define STR0050 "�Desea realmente generar el memorandum?"
	#define STR0051 "Memorandum"
#else
	#ifdef ENGLISH
		#define STR0001 'Agenda maintenance'
		#define STR0002 "Edit"
		#define STR0003 "Delete"
		#define STR0004 "View"
		#define STR0005 "Sel. Substitute"
		#define STR0006 "Reason not found."
		#define STR0007 "Enter initial date and time or delay time."
		#define STR0008 "Enter final date and time or anticipated outflow time."
		#define STR0009 "Enter initial date and time or final date and time of the service to register the overtime."
		#define STR0010 "Enter the SO item to where the operator will be transfered."
		#define STR0011 "The schedule of  "
		#define STR0012 " already have maintenance by reason of the same type. Use the option Details to change this maintenance."
		#define STR0013 "The initial date and time must be later than the original."
		#define STR0014 "The initial date and time must be earlier than the schedule final time."
		#define STR0015 "Delay time cannot be longer than the service time."
		#define STR0016 "The final time must be earlier than the schedule final time and later than the initial time."
		#define STR0017 "Type of the selected reason does not allow replacement."
		#define STR0018 "Contracted Hours"
		#define STR0019 "Allocated Hours"
		#define STR0020 "Balance of Hours"
		#define STR0021 "Failed to load routine. Alias void."
		#define STR0022 "Selected item has no Service Order configuration."
		#define STR0023 "Contract Configuration"
		#define STR0024 "No contract configuration was selected. Run a query to a SO Item, select an item and confirm to display the contract configurations and to select one for transfer."
		#define STR0025 " was disabled and cannot have maintenance."
		#define STR0026 " was serviced and cannot have maintenance."
		#define STR0027 "Clear Substitute"
		#define STR0028 "Cannot record delay. "
		#define STR0029 " has overtime before the start time."
		#define STR0030 "Unable to register early exit. "
		#define STR0031 " has overtime before the end time."
		#define STR0032 "Overtime total must be greater than zero."
		#define STR0033 " has delay and early exit recorded."
		#define STR0034 "To add overtime delete the delay or early exit."
		#define STR0035 " has delay recorded."
		#define STR0036 "Cannot add overtime prior to the start time and delay at the same time."
		#define STR0037 " has early exit recorded."
		#define STR0038 "Cannot add overtime after to the end time and early exit at the same time."
		#define STR0039 "Transferring operators that have shifts with interval are not allowed. Use the allocation to change the schedule."
		#define STR0040 "The maintenances can be duplicated for other periods in the same day."
		#define STR0041 "Do you wish to duplicate?"
		#define STR0042 "Warning"
		#define STR0043 "Yes"
		#define STR0044 "No"
		#define STR0045 "To delete this maintenance, delete the latest maintenance first."
		#define STR0046 "Record not found for deletion."
		#define STR0047 "The transfer cannot occur for the same Service Order and Item"
		#define STR0048 "You cannot bulk edit schedules with different inflow and outflow times"
		#define STR0049 "Only the attribution of absences is allowed"
		#define STR0050 "Do you really wish to create the memorandum?"
		#define STR0051 "Memorandum"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", 'Manuten��o da agenda', 'Manuten��o da Agenda' )
		#define STR0002 "Alterar"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Eliminar", "Excluir" )
		#define STR0004 "Visualizar"
		#define STR0005 "Sel. Substituto"
		#define STR0006 "Motivo n�o encontrado."
		#define STR0007 "Informe a data e hora de in�cio do atendimento ou o tempo de atraso."
		#define STR0008 "Informe a data e hora de fim do atendimento ou o tempo da sa�da antecipada."
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Informe a data e hora de in�cio ou a data e hora de fim do atendimento para registar a hora extra.", "Informe a data e hora de in�cio ou a data e hora de fim do atendimento para registrar a hora extra." )
		#define STR0010 "Informe o item da OS para onde o atendente ser� transferido."
		#define STR0011 "A agenda do dia "
		#define STR0012 " j� possui manuten��o por motivo do mesmo tipo. Utilize a op��o Detalhes para alterar essa manuten��o."
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "A data e hora inicial devem ser superiores �s originais.", "A data e hora inicial deve ser superior � original." )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "A data e hora inicial devem ser inferiores � hora final da agenda.", "A data e hora inicial deve ser inferior � hora final da agenda." )
		#define STR0015 "O tempo de atraso n�o pode ser maior que o tempo de atendimento."
		#define STR0016 "A hora final deve ser inferior � hora final da agenda e superior � hora inicial."
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "O tipo do motivo seleccionado n�o permite substitui��o.", "Tipo do motivo selecionado n�o permite substitui��o." )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Horas contratadas", "Horas Contratadas" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Horas alocadas", "Horas Alocadas" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Saldo de horas", "Saldo de Horas" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Falha no carregamento do procedimento. Alias inv�lido.", "Falha no carregamento da rotina. Alias inv�lido." )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "O item seleccionado n�o possui configura��o de Ordem de servi�o.", "Item selecionado n�o possui configura��o de Ordem de Servi�o." )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Configura��o do contrato", "Configura��o do Contrato" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Nenhuma configura��o de contrato foi seleccionada. Accione a consulta do Item da OS, seleccione um item e confirme para mostrar as configura��es do contrato e seleccionar uma para a transfer�ncia.", "Nenhuma configura��o de contrato foi selecionada. Acione a consulta do Item da OS, selecione um item e confirme para mostrar as configura��es do contrato e selecionar uma para a transfer�ncia." )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", " foi desactivada e n�o pode sofer manuten��o.", " foi desativada e n�o pode sofer manuten��o." )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", " j� foi atendida e n�o pode sofrer manuten��o.", " j� foi atendida e n�o pode sofer manuten��o." )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Limpar substituto", "Limpar Substituto" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "N�o � poss�vel registar o atraso. ", "N�o � poss�vel registrar o atraso. " )
		#define STR0029 " possui hora extra antes do hor�rio inicial."
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "N�o � poss�vel registar a sa�da antecipada. ", "N�o � poss�vel registrar a sa�da antecipada. " )
		#define STR0031 " possui hora extra ap�s o hor�rio final."
		#define STR0032 "O tempo total de hora extra deve ser maior que Zero."
		#define STR0033 If( cPaisLoc $ "ANG|PTG", " possui atraso e sa�da antecipada registada.", " possui atraso e sa�da antecipada registrada." )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Para incluir a hora extra, elimine o atraso ou a sa�da antecipada.", "Para incluir a hora extra exclua o atraso ou a sa�da antecipada." )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", " possui atraso registado.", " possui atraso registrado." )
		#define STR0036 "N�o � poss�vel incluir hora extra anterior ao hor�rio inicial e atraso ao mesmo tempo."
		#define STR0037 If( cPaisLoc $ "ANG|PTG", " possui sa�da antecipada registada.", " possui sa�da antecipada registrada." )
		#define STR0038 "N�o � poss�vel incluir hora extra superior ao hor�rio final e sa�da antecipada ao mesmo tempo."
		#define STR0039 "Transfer�ncias de atendentes que tenham turno com intervalo n�o s�o permitidas. Utilize a aloca��o para mudar a agenda."
		#define STR0040 "As manuten��es podem ser replicadas para outros per�odo no mesmo dia."
		#define STR0041 "Deseja replicar?"
		#define STR0042 "Aten��o"
		#define STR0043 "Sim"
		#define STR0044 "N�o"
		#define STR0045 If( cPaisLoc $ "ANG|PTG", "Para eliminar esta manuten��o, exclua antes a �ltima manuten��o.", "Para excluir esta manuten��o exclua a �ltima manuten��o antes." )
		#define STR0046 If( cPaisLoc $ "ANG|PTG", "Registo n�o encontrado para elimina��o.", "Registro n�o encontrado para exclus�o." )
		#define STR0047 "A transfer�ncia n�o pode ocorrer para a mesma Ordem de Servi�o e Item"
		#define STR0048 "N�o � permitida altera��o em massa para agendas com hor�rios de entrada e sa�da diferentes"
		#define STR0049 "Somente � permite atribui��o de faltas"
		#define STR0050 "Deseja realmente gerar o memorando?"
		#define STR0051 "Memorando"
	#endif
#endif
