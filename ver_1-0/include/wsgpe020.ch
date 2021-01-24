#ifdef SPANISH
	#define STR0001 "Participante no encontrado en el registro de empleado"
	#define STR0002 "Inscripcion para o proceso selectivo para el cupo "
	#define STR0003 "Registro no encontrado"
	#define STR0004 "1=Documentos; 2=Mod.Registro; 3=Puestos; 4=Transferencia; 5=Admision; 6=Despido; 7=Accion Salarial; 8=Justif. Horario; 9=Inscripcion Cupo"
	#define STR0005 "Empleado no encontrado."
	#define STR0006 "Codigo de la solicitud obligatorio"
	#define STR0007 "Solicitud no tiene historial"
	#define STR0008 "Nombre"
	#define STR0009 "PORTAL"
	#define STR0010 "Metodo que Incluye una solicitud de aumento de puestos a RRHH"
	#define STR0011 "Metodo que Incluye una solicitud de accion salarial"
	#define STR0012 "Metodo que Incluye una solicitud de desvinculacion"
	#define STR0013 "Metodo que Incluye una solicitud de nueva contratacion o reemplazo"
	#define STR0014 "Metodo que Incluye una solicitud de transferencia"
	#define STR0015 "Metodo que Incluye una solicitud de justificacion de horario"
	#define STR0016 "Metodo que Incluye una solicitud de participacion del proceso selectivo (Inscripcion a una vacante disponible)"
	#define STR0017 "Metodo que Incluye una solicitud de un candidato externo al proceso selectivo (Inscripcion a una vacante disponible)"
	#define STR0018 "Metodo que Incluye una solicitud de reserva para una capacitacion"
	#define STR0019 "Metodo que Incluye una solicitud de vacaciones"
	#define STR0020 "Metodo que aprueba la solicitud a RRHH"
	#define STR0021 "Metodo que reprueba la solicitud a RRHH"
	#define STR0022 "Metodo que actualiza el ID del workflow de las solicitudes via portal "
	#define STR0023 "Metodo que busca solicitudes"
	#define STR0024 "Metodo que busca historial de las solicitudes"
	#define STR0025 "Metodo que busca descripcion de objetos"
	#define STR0026 "Metodo que incluye una solicitud de modificacion de jornada"
	#define STR0027 "Pendiente"
	#define STR0028 "RR.HH."
	#define STR0029 "Esperando concreci�n de RR.HH."
	#define STR0030 "Metodo que incluye una solicitud de subsidio academico"
	#define STR0031 "Metodo para grabar el interes por una capacitacion sin nuevos grupos abiertos."
	#define STR0032 "Metodo responsable por evaluar si ya hay solicitud para esta capacitacion."
	#define STR0033 "Metodo para anular el interes por una capacitacion sin nuevos grupos abiertos."
	#define STR0034 "M�todo que incluye una marcaci�n del reloj registrador"
	#define STR0035 "M�todo para borrar una requisici�n de marcaci�n del reloj registrador"
	#define STR0036 "Solicitud aprobada. No podr� borrarse."
	#define STR0037 "Existen licencias registradas en el sistema en esta fecha. Solicitud no se incluy�."
	#define STR0038 "Solicita��o n�o encontrada para este usu�rio"
#else
	#ifdef ENGLISH
		#define STR0001 "Participante n�o encontrado no cadastro de funcion�rio"
		#define STR0002 "Inscri��o para o processo seletivo para a vaga "
		#define STR0003 "Registro nao encontrado"
		#define STR0004 "1=Documentos;2=Alt.Cadastral;3=Postos;4=Transferencia;5=Admissao;6=Demissao;7=Acao Salarial;8=Justif. Horario;9=Inscricao Vaga"
		#define STR0005 "Employee not found."
		#define STR0006 "Request code is mandatory"
		#define STR0007 "Request has no history"
		#define STR0008 "Name"
		#define STR0009 "PORTAL"
		#define STR0010 "Method that adds a request for station increase to HR"
		#define STR0011 "Method that adds a request for salary adjustment"
		#define STR0012 "Method that adds a request for job termination"
		#define STR0013 "Method that adds a request for new hiring or replacement"
		#define STR0014 "Method that adds a request for transfer"
		#define STR0015 "Method that adds a request for schedule justification"
		#define STR0016 "Method that adds a request for participation in the selection process (application for an available vacancy)"
		#define STR0017 "Method that adds a request for an external applicant to participate in the selection process (application for an available vacancy)"
		#define STR0018 "Method that adds a request for training reservation"
		#define STR0019 "Method that adds a request for vacation"
		#define STR0020 "Method that approves requests to HR"
		#define STR0021 "Method that rejects requests to HR"
		#define STR0022 "Method that updates the workflow ID of requests via portal"
		#define STR0023 "Method that searches for requests"
		#define STR0024 "Method that searches for request history"
		#define STR0025 "Method that searches for object description"
		#define STR0026 "Method that adds a request for edit work time"
		#define STR0027 "Pending"
		#define STR0028 "HR"
		#define STR0029 "Waiting HR Effectiveness"
		#define STR0030 "Method that Adds a request for academic subsidy"
		#define STR0031 "Method do save interest for a training without new open groups."
		#define STR0032 "Method responsible for evaluating if there is a request for this training."
		#define STR0033 "Method do cancel interest for a training without new open groups."
		#define STR0034 "Method adding time clock punches"
		#define STR0035 "Method deleting request of time clock punches"
		#define STR0036 "Request was already approved. It cannot be deleted."
		#define STR0037 "Leaves registered in the system on this date. Request not added."
		#define STR0038 "Solicita��o n�o encontrada para este usu�rio"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Participante n�o encontrado no registo de empregado", "Participante n�o encontrado no cadastro de funcion�rio" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Inscri��o para o proccesso selectivo para a vaga ", "Inscri��o para o processo seletivo para a vaga " )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Registo n�o encontrado", "Registro nao encontrado" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "1=Documentos;2=Alt.Cadastral;3=Postos;4=Transfer�ncia;5=Admiss�o;6=Demiss�o;7=Ac��o Salarial;8=Justif. Hor�rio;9=Inscri��o Vaga", "1=Documentos;2=Alt.Cadastral;3=Postos;4=Transferencia;5=Admissao;6=Demissao;7=Acao Salarial;8=Justif. Horario;9=Inscricao Vaga;A=Reserva de Treinamento;B=Ferias" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Colaborador n�o encontrado.", "Funcion�rio n�o encontrado." )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "C�digo da solicita��o obrigat�rio", "Codigo da solicita��o obrigat�rio" )
		#define STR0007 "Solicita��o n�o possui hist�rico"
		#define STR0008 "Nome"
		#define STR0009 "PORTAL"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "M�todo que inclui uma solicita��o de aumento de postos ao RH", "M�todo que Inclui uma solicita��o de aumento de postos ao RH" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "M�todo que inclui uma solicita��o de ac��o salarial", "M�todo que Inclui uma solicita��o de a��o salarial" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "M�todo que inclui uma solicita��o de desligamento", "M�todo que Inclui uma solicita��o de desligamento" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "M�todo que inclui uma solicita��o de nova contrata��o ou substitui��o", "M�todo que Inclui uma solicita��o de nova contrata��o ou substitui��o" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "M�todo que inclui uma solicita��o de transfer�ncia", "M�todo que Inclui uma solicita��o de transfer�ncia" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "M�todo que inclui uma solicita��o de justificativa de hor�rio", "M�todo que Inclui uma solicita��o de justificativa de hor�rio" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "M�todo que inclui uma solicita��o de participa��o do processo de selec��o (Inscri��o a uma vaga dispon�vel)", "M�todo que Inclui uma solicita��o de participa��o do processo seletivo (Inscri��o � uma vaga dispon�vel)" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "M�todo que inclui uma solicita��o de um candidato externo ao processo de selec��o (Inscri��o a uma vaga dispon�vel)", "M�todo que Inclui uma solicita��o de um candidato externo ao processo seletivo (Inscri��o � uma vaga dispon�vel)" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "M�todo que inclui uma solicita��o de reserva para uma capacita��o.", "M�todo que Inclui uma solicita��o de reserva para um treinamento." )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "M�todo que inclui uma solicita��o de f�rias", "M�todo que Inclui uma solicita��o de f�rias" )
		#define STR0020 "M�todo que aprova a solicita��o ao RH"
		#define STR0021 "M�todo que reprova a solicita��o ao RH"
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "M�todo que actualiza o ID do workflow das solicita��es via portal", "M�todo que atualiza o ID do workflow das solicita��es via portal" )
		#define STR0023 "M�todo que busca solicita��es"
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "M�todo que busca o hist�rico das solicita��es", "M�todo que busca hist�rico das solicita��es" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "M�todo que busca descri��o de objectos", "M�todo que busca descri��o de objetos" )
		#define STR0026 "M�todo que inclui uma solicita��o de altera��o de jornada"
		#define STR0027 "Pendente"
		#define STR0028 "RH"
		#define STR0029 "Aguardando Efetiva��o do RH"
		#define STR0030 "M�todo que Inclui uma solicitacao de subsidio academico"
		#define STR0031 "M�todo para gravar o interesse por um treinamento sem novas turmas abertas."
		#define STR0032 "M�todo respons�vel por avaliar se j� h� solicita��o para este treinamento."
		#define STR0033 "M�todo para cancelar o interesse por um treinamento sem novas turmas abertas."
		#define STR0034 "M�todo que inclui uma marca��o de ponto"
		#define STR0035 "M�todo para excluir uma requisi�ao de marca�ao de ponto"
		#define STR0036 "Solicita��o j� foi aprovada. N�o poder� ser exclu�da."
		#define STR0037 "Existem afastamentos registrados no sistema nesta data. Solicita��o n�o foi inclu�da."
		#define STR0038 "Solicita��o n�o encontrada para este usu�rio"
	#endif
#endif
