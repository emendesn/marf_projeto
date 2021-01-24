#ifdef SPANISH
	#define STR0001 "Beneficios del contrato"
	#define STR0002 "¿Desea procesar el envio de beneficios al RR.HH.?"
	#define STR0003 "Espere..."
	#define STR0004 "Enviando beneficios de contrato al RR.HH. Espere..."
	#define STR0005 "Beneficios del contrato"
	#define STR0006 "No hay beneficio por enviar"
	#define STR0007 " - Concepto: "
	#define STR0008 "Matricula: "
	#define STR0009 "beneficio"
	#define STR0010 "¡Registros enviados al RR.HH. con exito!"
	#define STR0011 "Procesamiento concluido"
	#define STR0012 "Ocurrieron errores en el procesamiento. "
	#define STR0013 "Ocuerrieron errores"
#else
	#ifdef ENGLISH
		#define STR0001 "Contract Benefits"
		#define STR0002 "Process sending benefits to HR?"
		#define STR0003 "Wait..."
		#define STR0004 "Sending contract benefits to HR. Wait..."
		#define STR0005 "Contract Benefits"
		#define STR0006 "There are no benefits to send"
		#define STR0007 " - Payroll item: "
		#define STR0008 "Registration: "
		#define STR0009 "benefit"
		#define STR0010 "Records sent to the HR successfully!"
		#define STR0011 "Processing completed"
		#define STR0012 "Errors occurred in processing. "
		#define STR0013 "Errors occurred"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Benefícios do contrato", "Benefícios do Contrato" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Deseja processar o envio de benefícios ao RH?", "Deseja processar o envio de beneficios ao RH?" )
		#define STR0003 "Aguarde..."
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "A enviar benefícios de contrato ao RH. Aguarde...", "Enviando benefícios de contrato ao RH. Aguarde..." )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Benefícios do contrato", "Benefícios do Contrato" )
		#define STR0006 "Não há benefício a enviar"
		#define STR0007 " - Verba: "
		#define STR0008 "Matrícula: "
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "benefício", "beneficio" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Registos enviados para o RH com sucesso.", "Registros enviados para o RH com sucesso!" )
		#define STR0011 "Processamento concluído"
		#define STR0012 "Ocorreram erros no processamento. "
		#define STR0013 "Ocorreram erros"
	#endif
#endif
