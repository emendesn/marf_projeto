#ifdef SPANISH
	#define STR0001 "Sucursal"
	#define STR0002 "Wizard para creacion de vision"
	#define STR0003 "Seleccion de tabla que se utilizara en la vision "
	#define STR0004 "Seleccione la tabla que se utilizara para la creacion de la vision (si esta vision esta creandose dentro de una rutina, se utilizara la tabla (alias) de la rutina)."
	#define STR0005 "Nombre de la vision"
	#define STR0006 "Vision publica"
	#define STR0007 "Tabla de vision"
	#define STR0008 "Escriba el nombre de la vision en el campo a continuacion:"
	#define STR0009 "¿Tornar este grafico publico?"
	#define STR0010 "Usted esta creando una vision basada en una tabla definida anteriormente, "
	#define STR0011 "tal vez porque la esta creando a traves de un browser. La tabla en cuestion no podra modificarse y, "
	#define STR0012 "de este modo, su vision se creara basada en la tabla "
	#define STR0013 "Definicion de filtro"
	#define STR0014 "En esta etapa, usted debera definir como sera el filtro que estara presente dentro de su vision."
	#define STR0015 "Configuraciones de vision"
	#define STR0016 "Filtro de vision"
	#define STR0017 "Definicion de Campos"
	#define STR0018 "Seleccione cuales campos que deberan estar presentes en su browser, cuando se utiliza su vision."
	#define STR0019 "Configuraciones de vision"
	#define STR0020 "Campos de vision"
	#define STR0021 "Seleccionar Columnas"
	#define STR0022 "Campos de la tabla:"
	#define STR0023 "Campos seleccionados:"
	#define STR0024 "Seleccione un item"
	#define STR0025 "Selecciona un item"
	#define STR0026 "Definicion de Orden"
	#define STR0027 "Seleccione cual sera el orden de los registros que se presentaran en el browser."
	#define STR0028 "Configuraciones de vision"
	#define STR0029 "Campos de vision"
	#define STR0030 "Ordenes (Indices) disponibles para utilizacion:"
	#define STR0031 "Nombre de la vision:"
	#define STR0032 "Alias actual de la vision:"
	#define STR0033 "Digite un nombre para su vision"
	#define STR0034 "Seleccione, por lo menos, un campo para constituir su vision."
	#define STR0035 "Seleccione uno de los indices para constituir su vision."
	#define STR0036 "Cree una vision para su filtro."
#else
	#ifdef ENGLISH
		#define STR0001 "Branch"
		#define STR0002 "View Creation Wizard"
		#define STR0003 "Selection of table to be used in the view"
		#define STR0004 "Select the table to be used to create the view. If this view has been created in a routine, the routine table (alias) is used."
		#define STR0005 "View Name"
		#define STR0006 "Public View"
		#define STR0007 "View Table"
		#define STR0008 "Enter the view name in the field below:"
		#define STR0009 "Make this chart public?"
		#define STR0010 "You are creating a view based on a table previously defined, "
		#define STR0011 "maybe because it is being created through a browser. This table cannot be changed and, "
		#define STR0012 "thus, your view is created based on the table "
		#define STR0013 "Filter Setting"
		#define STR0014 "In this stage, set the filter to be in your view."
		#define STR0015 "View Configurations"
		#define STR0016 "View Filter"
		#define STR0017 "Field Definition"
		#define STR0018 "Select the fields to be on your browser when your view is used."
		#define STR0019 "View Configurations"
		#define STR0020 "View Fields"
		#define STR0021 "Select Columns"
		#define STR0022 "Table fields:"
		#define STR0023 "Fields selected:"
		#define STR0024 "Select an item"
		#define STR0025 "Select an item"
		#define STR0026 "Order Definition"
		#define STR0027 "Select the order of the records to be displayed on the browser."
		#define STR0028 "View Configurations"
		#define STR0029 "View Fields"
		#define STR0030 "Orders (Indexes) available to be used:"
		#define STR0031 "View name:"
		#define STR0032 "Current alias of the view:"
		#define STR0033 "Enter a name for your view"
		#define STR0034 "Select at least one field to be in your view."
		#define STR0035 "Select one of the indexes to be in your view."
		#define STR0036 "Create a view for your filter."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Filial" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Wizard para criação de visão" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Seleção de tabela a ser utilizada na visão" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Selecione a tabela que será utilizada para criação da visão (Caso esta visão esteja sendo criada dentro de uma rotina, será utilizado a tabela(alias) da rotina)." )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Nome da visão" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Visão publica" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Tabela da visão" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Escreva o nome da visão no campo abaixo:" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Tornar este gráfico publico?" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Você está criando uma visão baseada em uma tabela definida anteriormente, " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "talvez por estar criando ela através de um browser. A tabela em questão não poderá ser alterada e, " )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "desta forma, sua visão será criada baseado na tabela " )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Definição de filtro" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Nesta etapa, você deverá definir como será o filtro que estará presente dentro de sua visão." )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Configurações da visão" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Filtro da visão" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Definição de Campos" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Selecione quais os campos que deverão estar presentes no seu browser, quando utilizada a sua visão." )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Configurações da visão" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Campos da visão" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Selecionar Colunas" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "Campos da tabela:" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Campos selecionados:" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "Selecione um item" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "Seleciona um item" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "Definição de Ordem" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "Selecione qual será a ordem dos registros que serão apresentados no browser." )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "Configurações da visão" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", , "Campos da visão" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "Ordens(Índices) disponíveis para serem utilizados:" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", , "Nome da visão:" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", , "Alias atual da visão:" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", , "Digite um nome para sua visão" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", , "Selecione, pelo menos, um campo para constituir sua visão." )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", , "Selecione um dos índices para constituir sua visão." )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", , "Crie uma visão para seu filtro." )
	#endif
#endif
