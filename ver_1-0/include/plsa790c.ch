#ifdef SPANISH
	#define STR0001 "¡No es posible utilizar esta rutina!"
	#define STR0002 "Acceso negado al proceso"
	#define STR0003 "Conocimiento"
	#define STR0004 "Control"
	#define STR0005 "Opcion BOX del campo invalida"
	#define STR0006 "No existe formulario para analisis"
	#define STR0007 "¡Su perfil no esta autorizado para analisar este formulario!"
	#define STR0008 "Solamente formulario Autorizado y Participativo"
	#define STR0009 "Esta formulario ya se analizo, utilice la opcion Inconsistencia"
	#define STR0010 "Formulario reservado para otro Operador"
	#define STR0011 "Clave informada para registro del banco de conocimiento invalido"
	#define STR0012 "Informe clave unica para registro del banco de conocimiento"
	#define STR0013 "No fue posible borrar archivo de la lista"
	#define STR0014 "Rutina disponible unicamente para el operador autorizado"
	#define STR0015 "Solo el operador de este departamente posee acceso"
	#define STR0016 "Solo el operador de este formulario tiene acceso"
	#define STR0017 "El formulario debe estar en analisis"
	#define STR0018 "Solo para formulario con inconsistencia"
	#define STR0019 "Este formulario ya esta autorizado"
	#define STR0020 "Imposible borrar archivo generado en la base de conocimiento ["
	#define STR0021 "E-MAIL no informado para el Remitente"
	#define STR0022 "E-MAIL no informado para el Destinatario"
	#define STR0023 "Agendamiento de Visita"
	#define STR0024 "E-MAIL no encontrado"
	#define STR0025 "Este procedimiento no posee critica para auditoria."
	#define STR0026 "Este formulario ya se analizo."
	#define STR0027 "Este procedimiento tiene un agendamiento de analisis participativo."
	#define STR0028 "El formulario está bloqueado para: "
	#define STR0029 ". ¿Realmente desea liberar este formulario?"
	#define STR0030 "Forzar la liberación de usuario del formulario"
#else
	#ifdef ENGLISH
		#define STR0001 "This routine cannot be used!"
		#define STR0002 "Process access denied"
		#define STR0003 "Knowledge"
		#define STR0004 "Control"
		#define STR0005 "Invalid field BOX option"
		#define STR0006 "There is no form for this analysis"
		#define STR0007 "Your profile is not authorized to analyze this form!"
		#define STR0008 "Only Authorized and Participative form"
		#define STR0009 "This form was already analyzed. Use the Inconsistency option."
		#define STR0010 "Form reserved for another operator"
		#define STR0011 "Key entered to register knowledge base is invalid"
		#define STR0012 "Enter single key to register knowledge base"
		#define STR0013 "File could not be deleted from the list"
		#define STR0014 "Routine only available for the operator authorized"
		#define STR0015 "Only the operator of this department has access"
		#define STR0016 "Only the operator of this form has access"
		#define STR0017 "Form must be in analysis"
		#define STR0018 "Only for form with inconsistency!"
		#define STR0019 "This form is already authorized!"
		#define STR0020 "File generated in the knowledge base cannot be deleted ["
		#define STR0021 "E-MAIL not informed to sender"
		#define STR0022 "E-MAIL not informed to receiver"
		#define STR0023 "Scheduling visit"
		#define STR0024 "E-MAIL not found."
		#define STR0025 "This procedure does not have warning message for audit."
		#define STR0026 "This form has been analyzed."
		#define STR0027 "This procedure has a participatory analysis schedule."
		#define STR0028 "Form is blocked for: "
		#define STR0029 ". Do you really want to release this Form?"
		#define STR0030 "Force release of Form user"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Não é possível utilizar este procedimento", "Não é possível utilizar esta rotina!" )
		#define STR0002 "Acesso negado ao processo"
		#define STR0003 "Conhecimento"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Controlo", "Controle" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Opção BOX do campo inválida", "Opção BOX do campo invalida" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Não existe guia para análise", "Não existe guia para analise" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "O seu perfil não está autorizado a analisar esta guia.", "O seu perfil não esta autorizado a analisar esta guia!" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Somente guia autorizada e participativa", "Somente guia Autorizada e Participativa" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Esta guia já foi analisada. Utilize a opção inconsistência", "Esta guia já foi analisada, utilize a opção Inconsistência" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Guia reservada para outro operador", "Guia reservada para outro Operador" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Chave informada para registo do banco de conhecimento inválida", "Chave informada para registro do banco de conhecimento invalida" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Informe chave única para registo do banco de conhecimento", "Informe chave unica para registro do banco de conhecimento" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Não foi possível excluir ficheiro da lista", "Não foi possivel excluir arquivo da lista" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Procedimento disponível apenas para operador autorizado", "Rotina disponível apenas para operador autorizado" )
		#define STR0015 "Somente o operador deste departamento tem acesso"
		#define STR0016 "Somente o operador desta guia tem acesso"
		#define STR0017 "A guia deve estar em analise"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Somente para guia com inconsistência.", "Somente para guia com inconsistência!" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Esta guia já está autorizada.", "Esta guia já esta autorizada!" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Impossível excluir ficheiro gerado no banco de conhecimento [", "Impossivel deletar arquivo gerado no banco de conhecimento [" )
		#define STR0021 "E-MAIL não informado para o Remetente"
		#define STR0022 "E-MAIL não informado para o Destinatário"
		#define STR0023 "Agendamento de Visita"
		#define STR0024 "E-MAIL não encontrado"
		#define STR0025 "Este procedimento não possui crítica para auditoria."
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Esta guia já foi analisada.", "Esta guia ja foi analisada." )
		#define STR0027 "Este procedimento possui um agendamento de análise participativa."
		#define STR0028 "A guia esta bloqueada para: "
		#define STR0029 ". Deseja mesmo liberar esta Guia?"
		#define STR0030 "Forçar liberação de usuário da Guia"
	#endif
#endif
