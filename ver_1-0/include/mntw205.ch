#ifdef SPANISH
	#define STR0001 "Empresa"
	#define STR0002 "Sucursal"
	#define STR0003 "Configuracion invalida de Sucursal"
	#define STR0004 "Verificar Empresa/Sucursal en los Jobs"
	#define STR0005 "Iniciando el Workflow"
	#define STR0006 "Fecha"
	#define STR0007 "Hora"
	#define STR0008 "No se encontro el archivo"
	#define STR0009 "Multas Vencidas/Por Vencer"
	#define STR0010 "(INICIO)Proceso: "
	#define STR0011 "Multa"
	#define STR0012 "Matricula"
	#define STR0013 "Bien"
	#define STR0014 "Descripcion"
	#define STR0015 "Infraccion"
	#define STR0016 "Fch. Vencimiento"
	#define STR0017 "Valor"
	#define STR0018 "¡Workflow enviado!"
	#define STR0019 "¡No existen datos para enviar el workflow!"
#else
	#ifdef ENGLISH
		#define STR0001 "Company"
		#define STR0002 "Branch"
		#define STR0003 "Invalid Branch Configuration"
		#define STR0004 "Check Company/Branch in Jobs"
		#define STR0005 "Starting Workflow"
		#define STR0006 "Date"
		#define STR0007 "Time"
		#define STR0008 "File not found"
		#define STR0009 "Past due/To be due Fine"
		#define STR0010 "(START)Process: "
		#define STR0011 "Fine"
		#define STR0012 "License Plate"
		#define STR0013 "Asset"
		#define STR0014 "Description"
		#define STR0015 "Violation"
		#define STR0016 "Due Date"
		#define STR0017 "Value"
		#define STR0018 "Workflow sent!"
		#define STR0019 "There are no data to send the workflow!"
	#else
		#define STR0001 "Empresa"
		#define STR0002 "Filial"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Configuração inválida de Filial", "Configuração invalida de Filial" )
		#define STR0004 "Verificar Empresa/Filial nos Jobs"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "A iniciar o Workflow", "Iniciando o Workflow" )
		#define STR0006 "Data"
		#define STR0007 "Hora"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Não foi encontrado o ficheiro", "Nao foi encontrado o arquivo" )
		#define STR0009 "Multas Vencidas/A Vencer"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "(INÍCIO)Processo: ", "(INICIO)Processo: " )
		#define STR0011 "Multa"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Matrícula", "Placa" )
		#define STR0013 "Bem"
		#define STR0014 "Descrição"
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Infracção", "Infração" )
		#define STR0016 "Dt. Vencimento"
		#define STR0017 "Valor"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Workflow enviado.", "Workflow enviado!" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Não existem dados para enviar o workflow.", "Não existem dados para enviar o workflow!" )
	#endif
#endif
