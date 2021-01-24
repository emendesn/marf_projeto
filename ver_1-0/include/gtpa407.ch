#ifdef SPANISH
	#define STR0001 "Asistente para selección de recursos"
	#define STR0002 "Recursos para asignación"
	#define STR0003 "Este asistente auxilia en la creación de filtros, posibilitando la selección de recursos para asignación."
	#define STR0004 "Configuración del asistente"
	#define STR0005 "1- Vehículo"
	#define STR0006 "1 - Sí"
	#define STR0007 "1 - Sí"
	#define STR0008 "Código"
	#define STR0009 "Descripción"
	#define STR0010 "Modelo"
	#define STR0011 "Observación"
	#define STR0012 "Código"
	#define STR0013 "Descripción"
	#define STR0014 "Asistente"
	#define STR0015 "Tipo de recurso: "
	#define STR0016 "De año: "
	#define STR0017 "A año: "
	#define STR0018 "Tipo: "
	#define STR0020 "Capacidad"
	#define STR0021 "De en pie: "
	#define STR0022 "A en pie: "
	#define STR0023 "De sentado: "
	#define STR0024 "A sentado: "
	#define STR0025 "Accesibilidad: "
	#define STR0026 "Baño: "
	#define STR0028 "Vehículo"
	#define STR0029 "Atención"
	#define STR0030 "Vehículo con las características informadas no encontrado o ya posee asignación. Verifique los campos del filtro."
	#define STR0031 "Vehículos disponibles"
	#define STR0032 "No fue posible iniciar la inclusión del vehículo. Complete los campos obligatorios de la Asignación e intente nuevamente."
	#define STR0033 "Seleccione un vehículo para finalizar el asistente."
#else
	#ifdef ENGLISH
		#define STR0001 "Wizard for resources selection"
		#define STR0002 "Resources for Allocation"
		#define STR0003 "This wizard helps the creation of filters, enabling the selection of resources for allocation."
		#define STR0004 "Wizard Configuration"
		#define STR0005 "1- Vehicle"
		#define STR0006 "1- Yes"
		#define STR0007 "1- Yes"
		#define STR0008 "Code"
		#define STR0009 "Description"
		#define STR0010 "Model"
		#define STR0011 "Note"
		#define STR0012 "Code"
		#define STR0013 "Description"
		#define STR0014 "Wizard"
		#define STR0015 "Resource Type: "
		#define STR0016 "Year from: "
		#define STR0017 "Year to: "
		#define STR0018 "Type: "
		#define STR0020 "Capacity"
		#define STR0021 "Stand up From: "
		#define STR0022 "Stand up To: "
		#define STR0023 "Sit down From: "
		#define STR0024 "Sit down To: "
		#define STR0025 "Accessibility: "
		#define STR0026 "Bathroom: "
		#define STR0028 "Vehicle"
		#define STR0029 "Attention"
		#define STR0030 "Vehicle with the characteristics indicated not entered or already with allocation. Check the fields of the filter."
		#define STR0031 "Vehicles Available"
		#define STR0032 "Unable to start the vehicle addition. Complete the Allocation mandatory fields and try again."
		#define STR0033 "Select a vehicle to end the Wizard."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , 'Assistente de Seleção de Recursos' )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , 'Recursos para Alocação' )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Esse assistente auxilia na parametrização dos filtros necessários para a seleção de recursos para alocação." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Configuração do Assistente" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "1- Veículo" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "1- Sim" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "1- Sim" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Codigo" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Descricao" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Modelo" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Observacao" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Codigo" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Descricao" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Assistente" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Tipo de Recurso: " )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Ano De: " )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Ano Até: " )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Tipo: " )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Capacidade" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Em Pé De: " )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "Em Pé Até: " )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Sentado De: " )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "Sentado Até: " )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "Acessibilidade: " )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "Banheiro: " )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "Veículo" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", , "Atenção" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "Não foram encontrados veículos sem alocação com as características informadas. Verifique a parametrização do filtro e os veículos pertencentes ao Setor de Escala e tente novamente." )
		#define STR0031 "Veículos Disponíveis"
		#define STR0032 "Não foi possível iniciar a inclusão do veículo. Preencha os campos obrigatórios da Alocação e tente novamente."
		#define STR0033 "Selecione um veículo para finalizar o Assistente."
	#endif
#endif
