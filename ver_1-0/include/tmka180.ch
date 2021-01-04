#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Generar"
	#define STR0004 "Borrar"
	#define STR0005 "Actualizacion de los Titulos para Cobranza"
	#define STR0006 "Evaluando Titulos para cobranza..."
	#define STR0007 "La ultima actualizacion se ejecuto el dia "
	#define STR0008 " a las "
	#define STR0009 " horas. ¿Desea realizar la actualizacion ahora?"
	#define STR0010 "Excepcion"
	#define STR0011 "Titulos en Excepcion de Cobranza"
	#define STR0012 "Marca y Desmarca Todos"
	#define STR0013 "Invierte y Devuelve Seleccion"
	#define STR0014 "Bloquea y Aprueba Titulos"
	#define STR0015 "Cuentas por Cobrar - SE1 esta en modo exclusivo y los campos para compatibilizacion de cobranza entre sucursales no se crearon. Si se ejecutara la rutina,  podran existir titulos que no se cargaran en la atencion para cobrarse. ¿Realmente desea ejecutar la rutina?"
	#define STR0016 "Sucursal Inicial"
	#define STR0017 "Sucursal Final"
	#define STR0018 "Informe sucursal inicial para seleccion "
	#define STR0019 "de datos. "
	#define STR0020 "Informe sucursal final para seleccion de  "
	#define STR0021 " datos."
	#define STR0022 " TK180ATU 1- Inicio de la query para filtrar los titulos que se incluiran en el SK1"
	#define STR0023 " TK180ATU 2- Termino de la query para filtrar los titulos que se incluiran en el SK1"
	#define STR0024 " TK180ATU 3- Inicio de la query para filtrar los titulos que se modificaran en el SK1"
	#define STR0025 " TK180ATU 4- Termino de la query para filtrar los titulos que se modificaran en el SK1"
	#define STR0026 " TK180ATU 5- Inicio del procesamiento para "
	#define STR0027 " TK180ATU 6- Termino del procesamiento para "
	#define STR0028 " Total de titulos procesados = "
	#define STR0029 "Sucursal inicial"
	#define STR0030 "Informe la sucursal inicial a"
	#define STR0031 "Seleccion de los datos"
	#define STR0032 "Sucursal final"
	#define STR0033 "Informe la sucursal final a"
#else
	#ifdef ENGLISH
		#define STR0001 "Search "
		#define STR0002 "View "
		#define STR0003 "Generate"
		#define STR0004 "Delete"
		#define STR0005 "Update Bill for Collection "
		#define STR0006 "Analyzing bills for collection ..."
		#define STR0007 "Last update executed on "
		#define STR0008 " at "
		#define STR0009 " . Will you update now? "
		#define STR0010 "Exception"
		#define STR0011 "Bill in Collection Exception"
		#define STR0012 "Check and uncheck all"
		#define STR0013 "Invert and Return Selection"
		#define STR0014 "Lock and Release the Bills"
		#define STR0015 "Accounts Receivable- SE1 is in exclusive mode and the fields for collection compatibilization between branches not created. If the routine is executed cannot exist bills that will not be loaded in servicing to be collected. Are you sure that you want to execute the routine?     "
		#define STR0016 "Initial branch"
		#define STR0017 "Final branch"
		#define STR0018 "Enter initial branch for selection    "
		#define STR0019 "of data.  "
		#define STR0020 "Enter a final branch for selection of  "
		#define STR0021 " data. "
		#define STR0022 " TK180ATU 1- Starting query to filter bills to be added to SK1"
		#define STR0023 " TK180ATU 2- Finishing query to filter bills to be added to SK1"
		#define STR0024 " TK180ATU 3- Starting query to filter bills to be edited in SK1"
		#define STR0025 " TK180ATU 4- Finishing query to filter bills to be edited in SK1"
		#define STR0026 " TK180ATU 5- Start processing for"
		#define STR0027 " TK180ATU 6- Finishing processing for"
		#define STR0028 " Total bills processed = "
		#define STR0029 "Initial branch"
		#define STR0030 "Enter initial branch for"
		#define STR0031 "Data selection"
		#define STR0032 "Final Branch"
		#define STR0033 "Enter final branch for"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Criar", "Gerar" )
		#define STR0004 "Excluir"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Actualização dos títulos para cobrança", "Atualização dos Títulos para Cobrança" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "A avaliar títulos para cobrança...", "Avaliando Títulos para cobrança..." )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "A última actualização foi executada no dia ", "A ultima atualização foi executada no dia " )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", " as ", " ás " )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", " horas. deseja realizar a actualização agora?", " horas. Deseja realizar a atualização agora?" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Excepção", "Excecäo" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Títulos Em Excepção De Cobrança", "Titulos em Excecäo de Cobranca" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Marca E Desmarca Todos", "Marca e Desmarca Todos" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Inverter E Retornar Selecção", "Inverte e Retorna Selecäo" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Bloqueia E Libera Os Títulos", "Bloqueia e Libera os Titulos" )
		#define STR0015 "O Contas a Receber - SE1 esta em modo exclusivo e os campos para compatibilizacao da cobranca entre filiais nao foram criados. Se a rotina for executada poderäo existir titulos que nao serao carregados no atendimento para serem cobrados. Tem certeza que deseja executar a rotina?"
		#define STR0016 "Filial Inicial"
		#define STR0017 "Filial Final"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Indique a filial inicial para selecção ", "Informe a filial inicial para selecäo " )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Dos dados.", "dos dados." )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Indique a filial final para selecção dos", "Informe a filial final para selecäo dos" )
		#define STR0021 " dados."
		#define STR0022 If( cPaisLoc $ "ANG|PTG", " Tk180atu 1- Início Da Consulta Para Filtrar Os Títulos Que Serão Incluídos No Sk1", " TK180ATU 1- Inicio da query para filtrar os titulos que serão incluidos no SK1" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", " Tk180atu 2- Término Da Consulta Para Filtrar Os Títulos Que Serão Incluídos No Sk1", " TK180ATU 2- Termino da query para filtrar os titulos que serão incluidos no SK1" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", " Tk180atu 3- Início Da Consulta Para Filtrar Os Títulos Que Serão Alterados  No Sk1", " TK180ATU 3- Inicio da query para filtrar os titulos que serão alterados  no SK1" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", " Tk180atu 4- Término Da Consulta Para Filtrar Os Títulos Que Serão Alterados  No Sk1", " TK180ATU 4- Termino da query para filtrar os titulos que serão alterados  no SK1" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", " tk180atu 5- início do processamento para ", " TK180ATU 5- Inicio do processamento para " )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", " tk180atu 6- término do processamento para ", " TK180ATU 6- Termino do processamento para " )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", " total de títulos processados = ", " Total de titulos processados = " )
		#define STR0029 "Filial Inicial"
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Indique a filial inicial para", "Informe a filial inicial para" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Cria expressões de filtros para seleção dos dados", "Seleçâo dos dados" )
		#define STR0032 "Filial Final"
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Indique a filial final para", "Informe a filial final para" )
	#endif
#endif
