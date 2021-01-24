#ifdef SPANISH
	#define STR0001 "Empresa"
	#define STR0002 "Sucursal"
	#define STR0003 "Configuracion invalida de Sucursal"
	#define STR0004 "Verificar Empresa/Sucursal en los Jobs"
	#define STR0005 "Iniciando el Workflow"
	#define STR0006 "Fecha"
	#define STR0007 "Hora"
	#define STR0008 "No se encontro el archivo"
	#define STR0009 "Numero SS"
	#define STR0010 "Fch. Apertura"
	#define STR0011 "Servicio"
	#define STR0012 "Solicitante"
	#define STR0013 "Solicitud"
	#define STR0014 "Exclusion de Solicitud de Servicio"
	#define STR0015 "SS"
	#define STR0016 "Exclusion realizada el "
	#define STR0017 ", a las "
	#define STR0018 " por el usuario: "
	#define STR0019 "Aviso de Exclusion de SS enviado para el solicitante"
#else
	#ifdef ENGLISH
		#define STR0001 "Company"
		#define STR0002 "Branch"
		#define STR0003 "Invalid Configuration of Branch"
		#define STR0004 "Check Company/Branch in Jobs"
		#define STR0005 "Starting Workflow"
		#define STR0006 "Date"
		#define STR0007 "Time"
		#define STR0008 "File not found"
		#define STR0009 "SR Number"
		#define STR0010 " Opening Dt."
		#define STR0011 "Service"
		#define STR0012 "Requestor"
		#define STR0013 "Request"
		#define STR0014 "Exclusion of Service Request"
		#define STR0015 "SR"
		#define STR0016 "Excluded in "
		#define STR0017 ", at "
		#define STR0018 " by the user: "
		#define STR0019 "Note of SR exclusion sent to the requestor"
	#else
		#define STR0001 "Empresa"
		#define STR0002 "Filial"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Configura��o inv�lida de Filial", "Configura��o invalida de Filial" )
		#define STR0004 "Verificar Empresa/Filial nos Jobs"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "A Iniciar o Workflow", "Iniciando o Workflow" )
		#define STR0006 "Data"
		#define STR0007 "Hora"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "N�o foi encontrado o ficheiro", "Nao foi encontrado o arquivo" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "N�mero SS", "Numero SS" )
		#define STR0010 "Dt. Abertura"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Servi�o", "Servico" )
		#define STR0012 "Solicitante"
		#define STR0013 "Solicita��o"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Elimina��o de Solicita��o de Servi�o", "Exclus�o de Solicita��o de Servi�o" )
		#define STR0015 "SS"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Elimina��o relizada em ", "Exclus�o relizada em " )
		#define STR0017 ", �s "
		#define STR0018 " pelo usu�rio: "
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Aviso de Elimina��o de SS enviado para o solicitante", "Aviso de Exclus�o de SS enviado para o solicitante" )
	#endif
#endif
