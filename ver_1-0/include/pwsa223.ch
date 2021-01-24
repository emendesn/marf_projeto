#ifdef SPANISH
	#define STR0001 "Error"
	#define STR0002 "Matricula:"
	#define STR0003 "Nombre:"
	#define STR0004 "Solicitud de capacitacion"
	#define STR0005 "Existe una solicitud de capacitacion pendiente para este empleado."
	#define STR0006 "Espere que se haga efectiva la solicitud."
	#define STR0007 "Reserva de capacitacion"
	#define STR0008 "Codigo"
	#define STR0009 "Estatus:"
	#define STR0010 "Calendario:"
	#define STR0011 "Curso:"
	#define STR0012 "Grupo:"
	#define STR0013 "Vacantes:"
	#define STR0014 "Inicio:"
	#define STR0015 "Final:"
	#define STR0016 "Horario:"
	#define STR0017 "Duracion:"
	#define STR0018 "Observacion:"
	#define STR0019 "Volver"
	#define STR0020 "Reprobar"
	#define STR0021 "Aprobar"
	#define STR0022 "Grabar"
	#define STR0023 "¡Digite las observaciones de la solicitud!"
	#define STR0024 "Instructor"
	#define STR0025 "¡No existen vacantes disponibles en esta capacitacion!"
	#define STR0026 "Periodo:"
	#define STR0027 "Materias:"
	#define STR0028 "Carga horaria:"
	#define STR0029 "Su solicitud quedara en la lista de espera."
	#define STR0030 "Interes por capacitacion"
	#define STR0031 'Solicitar participacion en futura capacitacion'
	#define STR0032 "Espere la formacion de nuevos grupos para este curso,<br>apenas esten disponibles usted sera informado por email."
	#define STR0033 "Hay reserva de capacitacion para este empleado."
	#define STR0034 'Espere el inicio de esta capacitacion.'
#else
	#ifdef ENGLISH
		#define STR0001 "Error"
		#define STR0002 "Registration:"
		#define STR0003 "Name:"
		#define STR0004 "Training Request"
		#define STR0005 "There are pending training requests for this employee."
		#define STR0006 "Await request confirmation."
		#define STR0007 "Training Reservation"
		#define STR0008 "Code:"
		#define STR0009 "Status:"
		#define STR0010 "Schedule:"
		#define STR0011 "Course:"
		#define STR0012 "Class:"
		#define STR0013 "Places:"
		#define STR0014 "Start:"
		#define STR0015 "End:"
		#define STR0016 "Time:"
		#define STR0017 "Duration:"
		#define STR0018 "Observation:"
		#define STR0019 "Back"
		#define STR0020 "Refuse"
		#define STR0021 "Approve"
		#define STR0022 "Save"
		#define STR0023 "Enter request notes!"
		#define STR0024 "Instructor"
		#define STR0025 "There is no available places in this training!"
		#define STR0026 "Period:"
		#define STR0027 "Subjects:"
		#define STR0028 "Hours of instruction:"
		#define STR0029 "Your request will be placed on a waiting list."
		#define STR0030 "Interest for Training"
		#define STR0031 'Request participation in future training'
		#define STR0032 "Please wait when new groups for this course are prepared, <br>you will be notified by email when this happens."
		#define STR0033 "There are training reservations for this employee."
		#define STR0034 'Wait starting this training.'
	#else
		#define STR0001 "Erro"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Matrícula:", "Matricula:" )
		#define STR0003 "Nome:"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Solicitação de capacitação", "Solicitacao de Treinamento" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Há solicitação de capacitação pendente para este colaborador.", "Existe solicitacao de treinamento pendente para este funcionario." )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Aguarde a efectivação da solicitação.", "Aguarde a efetivacao da solicitacao." )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Reserva de capacitação", "Reserva de Treinamento" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Código:", "Codigo:" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Estado:", "Status:" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Calendário:", "Calendario:" )
		#define STR0011 "Curso:"
		#define STR0012 "Turma:"
		#define STR0013 "Vagas:"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Início:", "Inicio:" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Término:", "Termino:" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Horário:", "Horario:" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Duração:", "Duracao:" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Observação:", "Observacao:" )
		#define STR0019 "Voltar"
		#define STR0020 "Reprovar"
		#define STR0021 "Aprovar"
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Gravar", "Salvar" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Digite as observações da solicitação.", "Digite as observacoes da solicitacao!" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Instructor", "Instrutor" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Não existem vagas disponíveis nesta capacitação.", "Nao existem vagas disponíveis neste treinamento!" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Período:", "Periodo:" )
		#define STR0027 "Disciplinas:"
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Carga Horária:", "Carga Horaria:" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Sua solicitação ficará na lista de espera.", "Sua solicitacao ficara em lista de espera." )
		#define STR0030 "Interesse por Treinamento"
		#define STR0031 'Solicitar participação em futuro treinamento'
		#define STR0032 "Aguarde a formação de novas turmas para este curso,<br>assim que estiver disponível você será informado via email."
		#define STR0033 "Existe reserva de treinamento para este funcionário."
		#define STR0034 'Aguarde o início deste treinamento.'
	#endif
#endif
