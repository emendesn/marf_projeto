#ifdef SPANISH
	#define STR0001 "Asistente para selecci�n de recursos"
	#define STR0002 "Recursos para asignaci�n"
	#define STR0003 "Este asistente auxilia en la creaci�n de filtros, posibilitando la selecci�n de recursos para asignaci�n."
	#define STR0004 "Configuraci�n del asistente"
	#define STR0005 "1- Veh�culo"
	#define STR0006 "1 - S�"
	#define STR0007 "1 - S�"
	#define STR0008 "C�digo"
	#define STR0009 "Descripci�n"
	#define STR0010 "Modelo"
	#define STR0011 "Observaci�n"
	#define STR0012 "C�digo"
	#define STR0013 "Descripci�n"
	#define STR0014 "Asistente"
	#define STR0015 "Tipo de recurso: "
	#define STR0016 "De a�o: "
	#define STR0017 "A a�o: "
	#define STR0018 "Tipo: "
	#define STR0020 "Capacidad"
	#define STR0021 "De en pie: "
	#define STR0022 "A en pie: "
	#define STR0023 "De sentado: "
	#define STR0024 "A sentado: "
	#define STR0025 "Accesibilidad: "
	#define STR0026 "Ba�o: "
	#define STR0028 "Veh�culo"
	#define STR0029 "Atenci�n"
	#define STR0030 "Veh�culo con las caracter�sticas informadas no encontrado o ya posee asignaci�n. Verifique los campos del filtro."
	#define STR0031 "Veh�culos disponibles"
	#define STR0032 "No fue posible iniciar la inclusi�n del veh�culo. Complete los campos obligatorios de la Asignaci�n e intente nuevamente."
	#define STR0033 "Seleccione un veh�culo para finalizar el asistente."
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
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , 'Assistente de Sele��o de Recursos' )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , 'Recursos para Aloca��o' )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Esse assistente auxilia na parametriza��o dos filtros necess�rios para a sele��o de recursos para aloca��o." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Configura��o do Assistente" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "1- Ve�culo" )
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
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Ano At�: " )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Tipo: " )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Capacidade" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Em P� De: " )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "Em P� At�: " )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Sentado De: " )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "Sentado At�: " )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "Acessibilidade: " )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "Banheiro: " )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "Ve�culo" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", , "Aten��o" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "N�o foram encontrados ve�culos sem aloca��o com as caracter�sticas informadas. Verifique a parametriza��o do filtro e os ve�culos pertencentes ao Setor de Escala e tente novamente." )
		#define STR0031 "Ve�culos Dispon�veis"
		#define STR0032 "N�o foi poss�vel iniciar a inclus�o do ve�culo. Preencha os campos obrigat�rios da Aloca��o e tente novamente."
		#define STR0033 "Selecione um ve�culo para finalizar o Assistente."
	#endif
#endif
