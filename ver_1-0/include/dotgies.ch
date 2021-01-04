#ifdef SPANISH
	#define STR0001 "1 - Normal, en el plazo reglamentario"
	#define STR0002 "2 - Normal, fuera del plazo reglamentar"
	#define STR0003 "3 - Por Sustitucion"
	#define STR0004 "4 - Por Pedido de Baja de Inscripcion"
	#define STR0005 "5 - Por Tranferencia de Municipio"
	#define STR0006 "1 - Si"
	#define STR0007 "2 - No"
	#define STR0008 "DOT-GI / ICMS"
	#define STR0009 "Atencion"
	#define STR0010 "Rellene correctamente las informaciones solicitadas."
	#define STR0011 "Esta rutina generara las informaciones referentes a DOT-GI/ICMS "
	#define STR0012 "DOT: Declaracion de operaciones tributables"
	#define STR0013 "GI/ICMS: Formulario de informacion de las operaciones y prestaciones interestatales - Espirito Santo"
	#define STR0014 "Asistente de parametrizacion"
	#define STR0015 "Forma de presentacion:"
	#define STR0016 "�Procesa valores en stock?"
	#define STR0017 "Asistente de parametrizacion"
	#define STR0018 "Configuracion de los CFOPs:"
	#define STR0019 "Energia electrica/Generacion:"
	#define STR0020 "Energia electrica/Distribucion:"
	#define STR0021 "Servicios de transporte:"
	#define STR0022 "Servicios de comunicacion:"
	#define STR0023 "Extraccion de petroleo:"
	#define STR0024 "Agua potable:"
	#define STR0025 "Otras actividades:"
	#define STR0026 "Otras actividades transporte:"
	#define STR0027 "Informaciones complementarias:"
	#define STR0028 "Parametro no existe"
	#define STR0029 "El parametro MV_DOTMNA1 no esta definido en el diccionario de datos o su contenido es invalido."
	#define STR0030 "Para que la rutina siga correctamente,"
	#define STR0031 "sera necesario respetar la solucion propuesta a continuacion."
	#define STR0032 "Incluye el parametro MV_DOTMNA1 en la tabla SX6."
	#define STR0033 "Para mayores referencias, consulte la documentacion que acompana la rutina."
	#define STR0034 "Parametro/Campo inconsistente"
	#define STR0035 "Para determinar el codigo del municipio del contribuyente, es necesario que el "
	#define STR0036 "campo M0_CODMUN este rellenado o exista el parametro MV_DOTMNEM con "
	#define STR0037 "contenido valido. Para solucionar el problema, sera necesario respetar la solucion a continuacion:"
	#define STR0038 "Rellene el campo M0_CODMUN o cree el parametro MV_DOTMNEM en la tabla SX6"
	#define STR0039 "Para mayores referencias, consulte la documentacion que acompana la rutina."
	#define STR0040 "�Realiza operaciones con generacion y distribucion"
	#define STR0041 "de energia electrica, prestacion de servicios de "
	#define STR0042 "transporte,servicios de comunicacion, "
	#define STR0043 "extraccion de petroleo o servicio de tratamiento y "
	#define STR0044 "distribucion de agua potable?"
	#define STR0045 "Otros servicios de transportes."
	#define STR0046 "Observaciones:"
#else
	#ifdef ENGLISH
		#define STR0001 "1 - Normal, regular deadline"
		#define STR0002 "2 - Normal, out of Regular term"
		#define STR0003 "3 - By override"
		#define STR0004 "4 - By request for posting of registration"
		#define STR0005 "5 - By change of municipality"
		#define STR0006 "1 - Yes"
		#define STR0007 "2 - No "
		#define STR0008 "DOT-GI/ICMS"
		#define STR0009 "Warning"
		#define STR0010 "Fill out correctly the information requested.    "
		#define STR0011 "This routine will generate information regarding OT-GI/ICMS "
		#define STR0012 "DOT: Taxed Operations Statements"
		#define STR0013 "GI/ICMS: Information Form of Interstate Operations and Provisions - Esp�rito Santo"
		#define STR0014 "Parameterization Wizard"
		#define STR0015 "Display Method:"
		#define STR0016 "Process Storage Values?"
		#define STR0017 "Parameterization Wizard"
		#define STR0018 "CFOPs Configuration:"
		#define STR0019 "Electricity/Generation:"
		#define STR0020 "Electricity/Distribution:"
		#define STR0021 "Transport Services:"
		#define STR0022 "Communication Services:"
		#define STR0023 "Oil Extraction.:"
		#define STR0024 "Piped Water:"
		#define STR0025 "Other Activities:"
		#define STR0026 "Other Transport Activities:"
		#define STR0027 "Supplementary Information:"
		#define STR0028 "Parameter does not exist"
		#define STR0029 "The parameter MV_DOTMNA1 is not defined in the data dictionary or its content is invalid."
		#define STR0030 "For the routine to continue correctly,"
		#define STR0031 "you must follow the solution presented below."
		#define STR0032 "Add the parameter MV_DOTMNA1 to table SX6."
		#define STR0033 "For more references, check documents attached to the routine."
		#define STR0034 "Inconsistent Parameter/Field"
		#define STR0035 "To set taxpayer city code, it is necessary the "
		#define STR0036 "field M0_CODMUN to be completed or exist the parameter MV_DOTMNEM with "
		#define STR0037 "valid content. To solve the problem the following solution must be respected:"
		#define STR0038 "Complete the field M0_CODMUN or create parameter MV_DOTMNEM on SX6 table"
		#define STR0039 "For more references, check documents attached to the routine."
		#define STR0040 "Make operations for Generation and Distribution"
		#define STR0041 "electricity, Rendering of Services "
		#define STR0042 "Transport, Communication Services, "
		#define STR0043 "Oil extraction or Treatment Service and "
		#define STR0044 "piped water distribution?"
		#define STR0045 "Other transportation services."
		#define STR0046 "Notes:"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "1 - normal, no prazo regulamentar", "1 - Normal, no prazo regulamentar" )
		#define STR0002 "2 - Normal, fora do prazo Regulamentar"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "3 - Por Substitui��o", "3 - Por Substituicao" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "4 - Por Pedido De Liquida��o De Inscri��o", "4 - Por Pedido de Baixa de Inscricao" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "5 - Por Transfer�ncia De Munic�pio", "5 - Por Tranferencia de Municipio" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "1- Sim", "1 - Sim" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "2 - N�o", "2 - Nao" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Dot-gi/iuc", "DOT-GI/ICMS" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Aten��o", "Atenc�o" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Preencher correctamente as informa��es solicitadas.", "Preencha corretamente as informac�es solicitadas." )
		#define STR0011 "Esta rotina ira gerar as informacoes referentes a DOT-GI/ICMS "
		#define STR0012 "DOT: Declaracao de Operacoes Tributaveis"
		#define STR0013 "GI/ICMS: Guia de Informacao das Operacoes e Prestacoes Interestaduais - Espirito Santo"
		#define STR0014 "Assistente de parametriza��o"
		#define STR0015 "Forma de Apresentacao:"
		#define STR0016 "Processar Valores em Estoque?"
		#define STR0017 "Assistente de parametriza��o"
		#define STR0018 "Configura��o dos CFOPs:"
		#define STR0019 "Energia El�trica/Gera��o:"
		#define STR0020 "Energia El�trica/Distribui��o:"
		#define STR0021 "Servi�os de Transporte:"
		#define STR0022 "Servi�os de Comunica��o:"
		#define STR0023 "Extra��o de Petr�leo:"
		#define STR0024 "�gua Canalizada:"
		#define STR0025 "Outras Atividades:"
		#define STR0026 "Outras Atividades Transporte:"
		#define STR0027 "Informa��es Complementares:"
		#define STR0028 "Par�metro n�o existe"
		#define STR0029 "O par�metro MV_DOTMNA1 n�o est� definido no dicion�rio de dados ou o seu conte�do � inv�lido."
		#define STR0030 "Para que a rotina continue corretamente,"
		#define STR0031 "ser� necess�rio respeitar a solu��o proposta abaixo."
		#define STR0032 "Incluir o par�metro MV_DOTMNA1 na tabela SX6."
		#define STR0033 "Para maiores refer�ncias, consultar a documenta��o que acompanha a rotina."
		#define STR0034 "Par�metro/Campo Inconsistente"
		#define STR0035 "Para determinar o c�digo do munic�pio do contribuinte, � necess�rio que o "
		#define STR0036 "campo M0_CODMUN esteja preenchido ou exista o par�metro MV_DOTMNEM com "
		#define STR0037 "conte�do v�lido. Para solucionar o problema, sera necessario respeitar a solu��o abaixo:"
		#define STR0038 "Preencha o campo M0_CODMUN ou crie o parametro MV_DOTMNEM na tabela SX6"
		#define STR0039 "Para maiores refer�ncias, consultar a documenta��o que acompanha a rotina."
		#define STR0040 "Realiza Opera��es com Gera��o e Distribui��o"
		#define STR0041 "de energia el�trica, Presta��o de Servi�os de "
		#define STR0042 "Transporte,Servi�os de Comunica��o, "
		#define STR0043 "Extra��o de petr�leo ou Servi�o de tratamento e "
		#define STR0044 "distribui��o de �gua canalizada?"
		#define STR0045 "Outros servi�os de transportes."
		#define STR0046 "Observa��es:"
	#endif
#endif
