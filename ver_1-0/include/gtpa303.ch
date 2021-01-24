#ifdef SPANISH
	#define STR0001 "Asignaci�n"
	#define STR0002 "GTPA303"
	#define STR0003 "Asignaci�n - Colaborador"
	#define STR0006 "Modificar"
	#define STR0009 "Seleccione escala"
	#define STR0010 "Tipo recurso."
	#define STR0011 "El local del �ltimo servicio de la escala no es compatible con el local est�ndar del colaborador. �No se podr� definir este d�a como descanso!"
	#define STR0012 "El colaborador no consta como disponible en este d�a. �No se podr� definir el tipo de d�a como trabajado!"
	#define STR0013 "No es posible definir el estatus como disponible. �El colaborador est� de vacaciones!"
	#define STR0014 "No es posible definir el estatus como disponible. �El colaborador est� de licencia!"
	#define STR0015 "La fecha inicial no puede ser mayor que la fecha final. �Incluya una fecha v�lida!"
	#define STR0017 "Help"
	#define STR0023 "Consulta colaborador"
	#define STR0025 "Espere..."
	#define STR0026 "Ejecutando consulta"
	#define STR0027 "C�d Colaborador."
	#define STR0029 "Datos del diccionario"
	#define STR0030 "Completando la cuadr�cula"
	#define STR0031 "�Complete el c�digo del colaborador en el encabezado antes de efectuar la consulta!"
	#define STR0032 "Atenci�n"
	#define STR0033 "�Este colaborador no est� registrado en el grupo de colaboradores, tabla GYI!"
	#define STR0034 "La fecha inicial no puede ser mayor que la fecha final. �Incluya una fecha v�lida!"
	#define STR0035 "Este d�a no est� disponible para esta escala, �favor verifique!"
	#define STR0038 "El local de destino del trecho de la �ltima escala no es compatible con el local est�ndar del colaborador. �No se podr� definir este d�a como no trabajado!"
	#define STR0039 "Hay trechos que no poseen viajes relacionados, �desea crear estos viajes?"
	#define STR0040 "Crear viajes"
	#define STR0041 "�La escala seleccionada excedi� la cantidad de recursos!"
#else
	#ifdef ENGLISH
		#define STR0001 "Allocation"
		#define STR0002 "GTPA303"
		#define STR0003 "Allocation - Employee"
		#define STR0006 "Allocation Maintenance"
		#define STR0009 "Select Scale"
		#define STR0010 "Resource Type."
		#define STR0011 "The location of the last scale service is not compatible to the employee default location, unable to define this day as a day off!"
		#define STR0012 "The employee is not available in this day, unable to define the day type as worked!"
		#define STR0013 "Unable to define status as available, the employee is on vacations!"
		#define STR0014 "Unable to define status as available, the employee is on leave!"
		#define STR0015 "The start date cannot be greater than the end date,enter a valid date!"
		#define STR0017 "Help"
		#define STR0023 "Query Employee"
		#define STR0025 "Wait..."
		#define STR0026 "Running Query"
		#define STR0027 "Employee Code."
		#define STR0029 "Dictionary Data"
		#define STR0030 "Completing grid"
		#define STR0031 "Complete the employee code on the header before searching!"
		#define STR0032 "Warning"
		#define STR0033 "This employee is not registered on the employees group, table GYI!"
		#define STR0034 "The start time cannot be greater than the end time,enter a valid time!"
		#define STR0035 "This day is not available for this scale , please check!"
		#define STR0038 "The destination location of the excerpt of the last scale is not compatible to the employee default location, unable to define this day as not worked!"
		#define STR0039 "There are excerpts that has no travels related, create such travels?"
		#define STR0040 "Create Travels"
		#define STR0041 "The Scale selected exceeded the amount of resources!"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Aloca��o" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "GTPA303" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Aloca��o - Colaborador" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Manuten��o da Aloca��o" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Selecione Escala" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Tipo Recurso." )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "O local do �ltimo servi�o da escala n�o � compat�vel com o local padr�o do colaborador,n�o ser� poss�vel definir esse dia como folga!" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "O colaborador n�o consta como dispon�vel nesse dia, n�o ser� poss�vel definir o tipo do dia como trabalhado!" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "N�o � poss�vel definir o status como dispon�vel, o colaborador est� de f�rias!" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "N�o � poss�vel definir o status como dispon�vel, o colaborador consta afastado!" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "A data inicial n�o pode ser maior que a data final,insira uma data v�lida!" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Help" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Consulta Colaborador" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "Aguarde..." )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "Executando Consulta" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "Cod Colaborador." )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", , "Dados do Dicion�rio" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "Preenchendo a grade" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", , "Preencha o c�digo do colaborador no cabe�alho antes de efetuar a consulta!" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", , "Aten��o" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", , "Este colaborador n�o consta cadastrado no grupo de colaboradores, tabela GYI!" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", , "A hora inicial n�o pode ser maior que a hora final,insira uma hora v�lida!" )
		#define STR0035 "Esse dia n�o est� dispon�vel para essa escala , favor verificar!"
		#define STR0038 "O local de destino do trecho da �ltima escala n�o � compat�vel com o local padr�o do colaborador,n�o ser� poss�vel definir esse dia como n�o trabalhado!"
		#define STR0039 "H� trechos que n�o possuem viagens relacionadas,deseja criar estas viagens?"
		#define STR0040 "Criar Viagens"
		#define STR0041 "A Escala selecionada excedeu a quantidade de recursos!"
	#endif
#endif
