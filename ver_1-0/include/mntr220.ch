#ifdef SPANISH
	#define STR0001 "Actividades del equipo de mantenimiento. El equipo de mantenimiento"
	#define STR0002 "es identificada por el Centro de Costo al que pertenece. Las ocurrencias"
	#define STR0003 "deseadas podran seleccionarse por medio de la opcion de parametros."
	#define STR0004 "A rayas"
	#define STR0005 "Administracion"
	#define STR0006 "Actividades del equipo de mantenimiento."
	#define STR0007 "O.S.   Seguro Tipo          Bien/Ubicacion   Nombre                    Servic. Descripcion         Cant.  Unid.   ......Inicio.....    .......Final...."
	#define STR0008 "ANULADO POR EL OPERADOR"
	#define STR0009 "Centro de Costo..:"
	#define STR0010 "Empleado.........:"
	#define STR0011 "Bien Princ.."
	#define STR0012 "Etapa  descripcion de la etapa"
	#define STR0013 "Procesando Archivo..."
	#define STR0014 "¿De Centro Trabajo ?"
	#define STR0015 "¿De Periodo        ?"
	#define STR0016 "¿A  Periodo        ?"
	#define STR0017 "¿De Centro Costos  ?"
	#define STR0018 "¿A  Centro Costos  ?"
	#define STR0019 "¿A  Centro Trabajo ?"
	#define STR0020 "¿De Bien           ?"
	#define STR0021 "¿A  Bien           ?"
	#define STR0022 "¿De Familia de Bien?"
	#define STR0023 "¿A  Familia de Bien?"
	#define STR0024 "¿De Etapa          ?"
	#define STR0025 "¿A  Etapa          ?"
	#define STR0026 "¿De Empleado       ?"
	#define STR0027 "¿A  Empleado       ?"
	#define STR0028 "Total..:"
	#define STR0029 "Selecionando Registros..."
	#define STR0030 "Informe a partir de que ubicacion debe constar en el informe. Pulse las teclas [F3]+[Enter] para seleccionar una ubicacion."
	#define STR0031 "Informe hasta que Localizacion debe constar en el informe. Presione las teclas [F3]+[Enter] para seleccionar la Localizacion deseada o escriba ZZZ en este campo y deje el anterior en blanco para considerar todas las Localizaciones."
	#define STR0032 "¿De ubicacion?"
	#define STR0033 "¿A ubicacion?"
	#define STR0034 "Atencion"
	#define STR0035 "Localizacion inicial mayor a la localizacion final."
	#define STR0036 "Informe una localizacion menor."
	#define STR0037 "Localizacion final menor a localizacion inicial."
	#define STR0038 "Informe una localizacion mayor."
	#define STR0039 "¡No existe datos para elaborar el informe!"
	#define STR0040 "ATENCION"
#else
	#ifdef ENGLISH
		#define STR0001 "Maintenance Team Activities. The maintenance team"
		#define STR0002 "is identified by the Cost Center it belongs to. The wanted occurrences"
		#define STR0003 "can be selected through the parameters option."
		#define STR0004 "Z.Form"
		#define STR0005 "Administration"
		#define STR0006 "Maintenance Team Activities."
		#define STR0007 "S.O.   Plan   Type          Asset/Location   Name                      Service Descript.           Amoun. Unit    ......Start......    .......End......"
		#define STR0008 "CANCELLED BY THE OPERATOR"
		#define STR0009 "Cost Center..:"
		#define STR0010 "Employee......:"
		#define STR0011 "Main Asset..:"
		#define STR0012 "Stage  Stage Description"
		#define STR0013 "Processing File..."
		#define STR0014 "From Working Center?"
		#define STR0015 "From Period        ?"
		#define STR0016 "To Period          ?"
		#define STR0017 "From Cost Center   ?"
		#define STR0018 "To Cost Center     ?"
		#define STR0019 "To Working Center  ?"
		#define STR0020 "From Asset         ?"
		#define STR0021 "To Asset           ?"
		#define STR0022 "From Family Asset  ?"
		#define STR0023 "To Asset Family    ?"
		#define STR0024 "From Stage         ?"
		#define STR0025 "To Stage           ?"
		#define STR0026 "From Employee      ?"
		#define STR0027 "To Employee        ?"
		#define STR0028 "Total..:"
		#define STR0029 "Selecting records ...  "
		#define STR0030 "Enter from which Location it must be displayed in the report. Press [F3]+[Enter] to select a Location."
		#define STR0031 "Indicate up to which Location must be in the Report. Press [F3]+[Enter] to select the desired Location or type ZZZ in this field and leave the one above in blank to consider all Locations."
		#define STR0032 "From Localization?"
		#define STR0033 "To Location?"
		#define STR0034 "Attention"
		#define STR0035 "Initial location greater than final location."
		#define STR0036 "Enter a smaller location."
		#define STR0037 "Final location less than initial location."
		#define STR0038 "Enter a greater location."
		#define STR0039 "There are no data to generate the report."
		#define STR0040 "ATTENTION"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Atividades da equipe de manutenção. a equipe de manutenção", "Atividades da Equipe de Manutencao. A equipe de manutencao" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "E identificada pelo centro de custo a que pertence. as ocorrencias", "e identificada pelo Centro de Custo a que pertence. As ocorrencias" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Desejadas poderáo ser selecionadas através da opção de parâmetro s.", "desejadas poderao ser selecionadas atraves da opcao de parametros." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Código de barras", "Zebrado" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Administração", "Administracao" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Atividades Da Equipe De Manutenção.", "Atividades da Equipe de Manutencao." )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "O.S.   Plano  Tipo          Bem/Localização  Nome                      Serviço Descrição           Quant. Unid.   ......Início.....    .......Fim......", "O.S.   Plano  Tipo          Bem/Localização  Nome                      Servico Descricao           Quant. Unid.   ......Inicio.....    .......Fim......" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Cancelado Pelo Operador", "CANCELADO PELO OPERADOR" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Centro De Custo..:", "Centro de Custo..:" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Empregado......:", "Funcionario......:" )
		#define STR0011 "Bem Pai..:"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Etapa  Descrição Da Etapa", "Etapa  Descricao da Etapa" )
		#define STR0013 "Processando Arquivo..."
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "De centro de trabalho ?", "De Centro Trabalho ?" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "De período         ?", "De Periodo         ?" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Até período        ?", "Ate Periodo        ?" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "De centro custos   ?", "De Centro Custos   ?" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Até centro custos  ?", "Ate Centro Custos  ?" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Até Centro De Trabalho?", "Ate Centro Trabalho?" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "De bem             ?", "De Bem             ?" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Até bem            ?", "Ate Bem            ?" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "De família de bem  ?", "De Familia de Bem  ?" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Até família de bem ?", "Ate Familia de Bem ?" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "De etapa           ?", "De Etapa           ?" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Até etapa          ?", "Ate Etapa          ?" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "De funcionário     ?", "De Funcionario     ?" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Até funcionário    ?", "Ate Funcionario    ?" )
		#define STR0028 "Total..:"
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "A Seleccionar Registos...", "Selecionando Registros..." )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Informe a partir de qual localização deve constar no relatório. Pressione as teclas [F3]+[Enter] para seleccionar uma localização.", "Informe a partir de qual Localização deve constar no relatório. Pressione as teclas [F3]+[Enter] para selecionar uma Localização." )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Informe até qual localização deve constar no relatório. Pressione as teclas [F3]+[Enter] para seleccionar a localização desejada ou digite ZZZ neste campo e o acima em branco para considerar todas as localizações.", "Informe até qual Localização deve constar no relatório. Pressione as teclas [F3]+[Enter] para selecionar a Localização desejado ou digite ZZZ neste campo e o acima em branco para considerar todas as Localizações." )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "De localização ?", "De Localização ?" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Até localização ?", "Até Localização ?" )
		#define STR0034 "Atenção"
		#define STR0035 "Localização inicial maior que localização final."
		#define STR0036 "Informe uma localização menor."
		#define STR0037 "Localização final menor que localização inicial."
		#define STR0038 "Informe uma localização maior."
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "Não existem dados para montar o relatório.", "Não existem dados para montar o relatório!" )
		#define STR0040 "ATENÇÃO"
	#endif
#endif
