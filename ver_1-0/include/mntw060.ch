#ifdef SPANISH
	#define STR0001 "Empresa"
	#define STR0002 "Sucursal"
	#define STR0003 "Configuracion no valida de Sucursal"
	#define STR0004 "Verificar Empresa/Sucursal en los Jobs"
	#define STR0005 "Iniciando el Workflow"
	#define STR0006 "Fecha"
	#define STR0007 "Hora"
	#define STR0008 "No se encontro el archivo"
	#define STR0009 "El conductor Sr."
	#define STR0010 "cometio la siguiente infraccion"
	#define STR0011 "Si el infractor desea reclamar por la multa, el mismo debera entrar en contacto"
	#define STR0012 "con la Gestion de Riesgos para las debidas orientaciones"
	#define STR0013 "Fecha Infraccion"
	#define STR0014 "Horario"
	#define STR0015 "Local"
	#define STR0016 "Municipio"
	#define STR0017 "UF"
	#define STR0018 "Placa/Vehiculo"
	#define STR0019 "Acto de Infraccion"
	#define STR0020 "Infraccion"
	#define STR0021 "Descripcion"
	#define STR0022 "Observacion"
	#define STR0023 "Puntos"
	#define STR0024 "Aviso de Inclusion de Multa"
	#define STR0025 "(INICIO)Proceso: "
	#define STR0026 "Aviso de Inclusion de Multa enviado para"
#else
	#ifdef ENGLISH
		#define STR0001 "Company"
		#define STR0002 "Branch"
		#define STR0003 "Branch configuration is invalid"
		#define STR0004 "Check Company/Branch in Jobs"
		#define STR0005 "Starting Workflow"
		#define STR0006 "Date"
		#define STR0007 "Time"
		#define STR0008 "File not found"
		#define STR0009 "Driver"
		#define STR0010 "committed the following violation"
		#define STR0011 "If the violator desires to appeal against the fine, it is necessary to contact "
		#define STR0012 "the Risk Management for further instructions."
		#define STR0013 "Violation Date"
		#define STR0014 "Time"
		#define STR0015 "Location"
		#define STR0016 "City"
		#define STR0017 "ST"
		#define STR0018 "Plate/Vehicle"
		#define STR0019 "Violation Report"
		#define STR0020 "Violation"
		#define STR0021 "Description"
		#define STR0022 "Notes"
		#define STR0023 "Score"
		#define STR0024 "Notice of Fine Inclusion"
		#define STR0025 "(START)Process: "
		#define STR0026 "Notice of Fine Inclusion sent to"
	#else
		#define STR0001 "Empresa"
		#define STR0002 "Filial"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Configuração inválida de filial", "Configuração invalida de Filial" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Verificar Empresa/filial Nos Jobs", "Verificar Empresa/Filial nos Jobs" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "A Iniciar O Procedimento", "Iniciando o Workflow" )
		#define STR0006 "Data"
		#define STR0007 "Hora"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Não foi encontrado o ficheiro", "Nao foi encontrado o arquivo" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "O Condutor Sr.", "O motorista Sr." )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Cometeu o seguinte acto infraccional", "cometeu o seguinte ato infracional" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Caso o infractor queira recorrer da multa, o mesmo deverá entrar em contacto", "Caso o infrator queira recorrer da multa, o mesmo deverá entrar em contato" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Com a gestão de riscos para as devidas orientações", "com a Gestão de Riscos para as devidas orientações" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Data Da Infracção", "Data Infração" )
		#define STR0014 "Horário"
		#define STR0015 "Local"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Concelho", "Município" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Uf", "UF" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Registo/veículo", "Placa/Veículo" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Auto De Infracção", "Auto de Infração" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Infracção", "Infração" )
		#define STR0021 "Descrição"
		#define STR0022 "Observação"
		#define STR0023 "Pontos"
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Aviso De Inclusão De Multa", "Aviso de Inclusão de Multa" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "(início)processo: ", "(INICIO)Processo: " )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Aviso de inclusão de multa enviado para", "Aviso de Inclusão de Multa enviado para" )
	#endif
#endif
