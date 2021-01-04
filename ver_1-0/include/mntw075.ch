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
	#define STR0011 "Placa"
	#define STR0012 "Bien"
	#define STR0013 "Descripcion"
	#define STR0014 "Tasa"
	#define STR0015 "Fc. Vencimiento"
	#define STR0016 "Cuota"
	#define STR0017 "Valor"
#else
	#ifdef ENGLISH
		#define STR0001 "Company"
		#define STR0002 "Branch"
		#define STR0003 "Invalid Branch Configuration"
		#define STR0004 "Check Company/Branch in Jobs"
		#define STR0005 "Beginning Workflow"
		#define STR0006 "Date"
		#define STR0007 "Hour"
		#define STR0008 "File not found"
		#define STR0009 "Documents Expired/To Expire"
		#define STR0010 "(BEGINNING) Process: "
		#define STR0011 "License Plate"
		#define STR0012 "Asset"
		#define STR0013 "Description"
		#define STR0014 "Rate"
		#define STR0015 "Due Date"
		#define STR0016 "Installment"
		#define STR0017 "Value"
	#else
		#define STR0001 "Empresa"
		#define STR0002 "Filial"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Configuração inválida de filial", "Configuração invalida de Filial" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Verificar empresa/filial nos jobs", "Verificar Empresa/Filial nos Jobs" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "A iniciar Workflow", "Iniciando o Workflow" )
		#define STR0006 "Data"
		#define STR0007 "Hora"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Não foi encontrado o ficheiro", "Nao foi encontrado o arquivo" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Documentos vencidos/a vencer", "Documentos Vencidos/A Vencer" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "(INÍCIO)Processo: ", "(INICIO)Processo: " )
		#define STR0011 "Placa"
		#define STR0012 "Bem"
		#define STR0013 "Descrição"
		#define STR0014 "Taxa"
		#define STR0015 "Dt. Vencimento"
		#define STR0016 "Parcela"
		#define STR0017 "Valor"
	#endif
#endif
