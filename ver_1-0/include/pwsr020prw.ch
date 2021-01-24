#ifdef SPANISH
	#define STR0001 "Vacantes disponibles"
	#define STR0002 "No existen vacantes disponibles de momento."
	#define STR0003 "Error"
	#define STR0004 "Cargo no encontrado. Verifique si el codigo del cargo se informo en el archivo de funciones."
	#define STR0005 "Codigo de la vacante no encontrado."
	#define STR0006 "Cargo no encontrado."
	#define STR0007 "Operacion realizada con exito"
	#define STR0008 "RPF o contrasena invalida."
	#define STR0009 'Se debe informar el RPF'
	#define STR0010 "Existe una solicitud de inscripcion en proceso para esa vacante.<br>Aguarde a que se efectue la solicitud."
	#define STR0011 "Servidor, Cuenta o Contrasena de email no configurados."
	#define STR0012 "Inscripcion en vacante disponible"
	#define STR0013 "Retorno sobre evaluacion"
	#define STR0014 "¡Email enviado con exito."
	#define STR0015 "No fue posible enviar el email: "
#else
	#ifdef ENGLISH
		#define STR0001 "Available jobs"
		#define STR0002 "No vacancies available at the moment."
		#define STR0003 "Error"
		#define STR0004 "Position not found. Check if the position code was entered in the roles file."
		#define STR0005 "Vacancy code not found."
		#define STR0006 "Position not found."
		#define STR0007 "Operation successfully performed"
		#define STR0008 "Invalid CPF or Password."
		#define STR0009 'CPF must be entered.'
		#define STR0010 "There is an application request for this vacancy in progress.<br>Wait for its confirmation."
		#define STR0011 "E-mail server, account or password not configured."
		#define STR0012 "Application for available vacancy"
		#define STR0013 "Return about evaluation"
		#define STR0014 "E-mail successfully sent."
		#define STR0015 "E-mail could not be sent: "
	#else
		#define STR0001 "Vagas Disponíveis"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Não existem vagas disponíveis neste momento.", "Não existem vagas disponíveis no momento." )
		#define STR0003 "Erro"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Cargo não encontrado. Verifique se o código do cargo foi introduzido no registo de funções.", "Cargo nao encontrado. Verifique se o codigo do cargo foi informado no cadastro de funcoes." )
		#define STR0005 "Código da vaga não encontrado."
		#define STR0006 "Cargo não encontrado."
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Operação realizada com sucesso", "Operacao realizada com sucesso" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "No.Contrib. ou palavra-passe inválida.", "CPF ou Senha inválido." )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", 'O No. Contrib.deve ser informado.', 'CPF deve ser informado.' )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Existe uma solicitação de inscrição para essa vaga em andamento.<br>Aguarde a efectivação da solicitação.", "Existe uma solicitação de inscrição para essa vaga em andamento.<br>Aguarde a efetivação da solicitação." )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Servidor, conta ou palavra-passe de e-mail não configurados.", "Servidor, Conta ou Senha de e-mail nao configurados." )
		#define STR0012 "Inscrição em vaga disponível"
		#define STR0013 "Retorno sobre avaliação"
		#define STR0014 "E-mail enviado com sucesso."
		#define STR0015 "Não foi possível enviar o e-mail: "
	#endif
#endif
