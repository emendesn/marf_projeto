#ifdef SPANISH
	#define STR0001 "Empresa"
	#define STR0002 "Sucursal"
	#define STR0003 "Configuracion invalida de Sucursal"
	#define STR0004 "Verificar Empresa/Sucursal en los Jobs"
	#define STR0005 "Iniciando el Workflow"
	#define STR0006 "Fecha"
	#define STR0007 "Hora"
	#define STR0008 "No se encontro el archivo"
	#define STR0009 "Documentos Vencidos/Por Vencer"
	#define STR0010 "(INICIO)Proceso: "
	#define STR0011 "Matricula"
	#define STR0012 "Bien"
	#define STR0013 "Descripcion"
	#define STR0014 "Documento"
	#define STR0015 "Fch. Vencimiento"
	#define STR0016 "Cuota"
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
		#define STR0009 "Past due/To be due Documents"
		#define STR0010 "(START)Process: "
		#define STR0011 "License Plate"
		#define STR0012 "Asset"
		#define STR0013 "Description"
		#define STR0014 "Document"
		#define STR0015 "Due Date"
		#define STR0016 "Installment"
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
		#define STR0009 "Documentos Vencidos/A Vencer"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "(INÍCIO)Processo: ", "(INICIO)Processo: " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Matrícula", "Placa" )
		#define STR0012 "Bem"
		#define STR0013 "Descrição"
		#define STR0014 "Documento"
		#define STR0015 "Dt. Vencimento"
		#define STR0016 "Parcela"
		#define STR0017 "Valor"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Workflow enviado.", "Workflow enviado!" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Não existem dados para enviar o workflow.", "Não existem dados para enviar o workflow!" )
	#endif
#endif
