#ifdef SPANISH
	#define STR0001 "Escala/Agenda de viajes"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Copiar"
	#define STR0007 "Tramos sin escala"
	#define STR0008 "Ejecutando consulta"
	#define STR0009 "¡Atención!"
	#define STR0010 "Hay días seleccionados que no son compatibles con "
	#define STR0011 "el registro de horarios - Tramos, ¡por favor verifique!"
	#define STR0012 "No existen datos para consulta"
	#define STR0013 "¡Complete el código de la escala en el encabezamiento! "
	#define STR0014 "Tramos sin escala"
	#define STR0015 "Espere..."
	#define STR0016 "GTPA302A"
	#define STR0017 "Datos del diccionario"
	#define STR0018 "Completando la cuadrícula"
	#define STR0019 "Línea inicial para la elaboración del intervalo de líneas "
	#define STR0020 "para consulta de sesiones que aún no se listaron en escalas."
	#define STR0021 "Línea final para elaboración del intervalo de líneas "
	#define STR0022 "para consulta de sesiones que aún no se listaron en escalas."
	#define STR0023 "La cantidad mínima de horas para Interjornada es de "
	#define STR0024 "Interjornada"
	#define STR0025 "La cantidad mínima de horas para Intrajornada es "
	#define STR0026 "Intrajornada"
	#define STR0027 "La cantidad máxima de horas para Intrajornada es "
	#define STR0028 "La cantidad mínima de horas para descanso es "
	#define STR0030 "Descanso"
	#define STR0031 "Los datos están más actuales en las tablas de Horarios (GIE), ¿realmente desea continuar? "
	#define STR0032 "Datos desactualizados"
	#define STR0033 "¡El valor del intervalo mínimo de la Intrajornada no puede ser mayor que el intervalo máximo! "
	#define STR0034 "¡El valor del intervalo máximo de la Intrajornada no puede ser menor que el intervalo mínimo! "
	#define STR0035 "Días disponibles"
	#define STR0036 "Defina los días de la semana en el encabezamiento"
	#define STR0037 "¡No se podrá recuperar la línea porque ya existe una línea con estas informaciones!"
	#define STR0038 "Help"
	#define STR0039 "Hay inconsistencia en los tramos de la escala, verifique si el lugar y Horario de origen de todos los tramos son compatibles con el Lugar y Horario de destino del tramo anterior."
#else
	#ifdef ENGLISH
		#define STR0001 "Travels Scale/Schedule"
		#define STR0002 "View"
		#define STR0003 "Add"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Copy"
		#define STR0007 "Excerpts Without Stopover"
		#define STR0008 "Running Query"
		#define STR0009 "Attention!"
		#define STR0010 "There are days selected not compatible to "
		#define STR0011 "the Time - Excerpts register, please verify!"
		#define STR0012 "There are no data to query"
		#define STR0013 "Complete the mandatory fields of the header!"
		#define STR0014 "Excerpts without Stopover"
		#define STR0015 "Wait..."
		#define STR0016 "GTPA302A"
		#define STR0017 "Dictionary Data"
		#define STR0018 "Completing grid"
		#define STR0019 "Start line to assemble the line interval "
		#define STR0020 "for search of sessions not related in scales yet."
		#define STR0021 "End line to assemble the line interval "
		#define STR0022 "for search of sessions not related in scales yet."
		#define STR0023 "The minimum amount of hours for interval between work hours is "
		#define STR0024 "Interval between workdays"
		#define STR0025 "The minimum amount of hours for interval between excerpts is "
		#define STR0026 "Break during workday"
		#define STR0027 "The maximum amount of hours for interval between excerpts is "
		#define STR0028 "The minimum amount of hours off duty are "
		#define STR0030 "Day off"
		#define STR0031 "The data on Time (GIE) tables are the latest, continue anyway? "
		#define STR0032 "Data Out-of-date"
		#define STR0033 "The value of Minimum Break during workday cannot be greater than the Maximum break! "
		#define STR0034 "The value of Maximum Break during workday cannot be lower than the Minimum break! "
		#define STR0035 "Days Available"
		#define STR0036 "Define week days on the header"
		#define STR0037 "Unable to retrieve line because there is a line with these information already!"
		#define STR0038 "Help"
		#define STR0039 "There are inconsistencies on scale excerpts, check if the source location and Time of all excerpts are compatible to the Destination Location and Time of the previous excerpt!"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Escala/Agenda de Viagens" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Visualizar" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Incluir" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Alterar" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Excluir" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Copiar" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Trechos Sem Escala" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Executando Consulta" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Atenção!" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Há dias selecionados que não são compatíveis com " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "o cadastro de Horários - Trechos, favor verificar!" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Nao existe dados a consultar" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Preencha os campos obrigatórios do cabeçalho!" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Trechos sem Escala" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Aguarde..." )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "GTPA302A" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Dados do Dicionário" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Preenchendo a grade" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Linha inicial para montagem do intervalo de linhas " )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "para consulta de sessões que ainda não foram relacionados em escalas." )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Linha final para montagem do intervalo de linhas " )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "para consulta de sessões que ainda não foram relacionados em escalas." )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "A quantidade mínima de horas para Interjornada é de " )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "InterJornada" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "A quantidade mínima de horas de intervalo entre trechos é de " )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "Intrajornada" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "A quantidade máxima de horas de intervalo entre trechos é de " )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "A quantidade mínima de horas para a folga é de " )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "Folga" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", , "Os dados estão mais atuais nas tabelas de Horários (GIE), deseja continuar assim mesmo? " )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", , "Dados Desatualizados" )
		#define STR0033 "O valor do intervalo Mínimo da Intrajornada não pode ser maior que o intervalo Máximo! "
		#define STR0034 "O valor do intervalo Máximo da Intrajornada não pode ser menor que o intervalo Mínimo! "
		#define STR0035 "Dias Disponíveis"
		#define STR0036 "Defina os dias da semana no cabeçalho"
		#define STR0037 "Não será possível recuperar a linha por já existir uma linha com estas informações!"
		#define STR0038 "Help"
		#define STR0039 "Há inconsistêcia nos trechos da escala, verifique se o local e Horário de origem de todos os trechos são compatíveis com o Local e Horário de Destino do trecho anterior!"
	#endif
#endif
