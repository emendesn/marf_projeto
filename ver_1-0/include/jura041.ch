#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Imprimir"
	#define STR0007 "Lista de Servicios"
	#define STR0008 "Modelo de Datos de Lista de Servicios"
	#define STR0009 "Encabezado de la Lista de Servicios"
	#define STR0010 "Detalles de la Lista de Servicios"
	#define STR0011 "Historial de las Listas de Servicios"
	#define STR0012 "Historial de los Detalles de la lista de Servicios"
	#define STR0013 "Tab. Servicios"
	#define STR0014 "Historial"
	#define STR0015 "Error al grabar el historial de la lista de servicios"
	#define STR0016 "Error al grabar Historial de los Valores"
	#define STR0017 "O servi�o n�o est� associado a este tipo de tabela"
	#define STR0018 "Incluir valores para los servicios"
	#define STR0019 "El ano-mes final debe ser mayor que el final"
	#define STR0020 "No se permite grabar historiales futuros"
	#define STR0021 "Periodos sobrepuestos en el historial de las participaciones"
	#define STR0022 "Es preciso rellenar el ano-mes final de este historial"
	#define STR0023 "Es preciso incluir Valor para los servicios en el historial con ano-mes inicial: "
	#define STR0024 "Error al grabar el historial de la tabla de servicios"
	#define STR0025 "Error al grabar el historial del Valor  por servicio"
	#define STR0026 "No se puede incluir servicio por tabla inactivo en este registro."
	#define STR0027 "Debe rellenarse el campo "
	#define STR0028 " de la Solapa "
	#define STR0029 "El tipo de tabla esta diferente del tipo de servicio: "
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Add"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Print"
		#define STR0007 "Service Table"
		#define STR0008 "Data Model of Service Table"
		#define STR0009 "Letterhead of Service Table"
		#define STR0010 "Details of Service Table"
		#define STR0011 "History of Service Table"
		#define STR0012 "History of Details of Service Table"
		#define STR0013 "Tab. Services"
		#define STR0014 "History"
		#define STR0015 "Error saving history of service tab"
		#define STR0016 "Error saving History of Values"
		#define STR0017 "Este servi�o n�o est� associado ao tipo da tabela"
		#define STR0018 "Add values for services"
		#define STR0019 "Final year-month must be after initial year-month."
		#define STR0020 "Future histories cannot be saved."
		#define STR0021 "Periods overwritten in participation history"
		#define STR0022 "Final year-month of this history must be filled out."
		#define STR0023 "It is necessary to add Value per category in the history with initial year-month:  "
		#define STR0024 "Error saving history of service table"
		#define STR0025 "Error when saving history of value per service"
		#define STR0026 "You cannot add an inactive service from a table to this register."
		#define STR0027 "The field must be completed "
		#define STR0028 " from the tab "
		#define STR0029 "The type of table is different from type of service: "
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Eliminar", "Excluir" )
		#define STR0006 "Imprimir"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Tabela de servi�os", "Tabela de Servi�os" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Modelo de dados de tabela de servi�os", "Modelo de Dados de Tabela de Servi�os" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Cabe�alho da tabela de servi�os", "Cabecalho da Tabela de Servi�os" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Detalhes da tabela de servi�os", "Detalhes da tabela de Servi�os" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Hist�rico das tabelas de servi�os", "Hist�rico das Tabelas de Servi�os" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Hist�rico dos detalhes da tabela de servi�os", "Hist�rico dos Detalhes da tabela de Servi�os" )
		#define STR0013 "Tab. Servi�os"
		#define STR0014 "Hist�rico"
		#define STR0015 "Erro ao gravar o hist�rico da tab de servi�os"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Erro ao gravar hist�rico dos valores", "Erro ao gravar Hist�rico dos Valores" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Este servi�o n�o est� assocciado a este tipo de tabela", "Este servi�o n�o est� associado a este tipo de tabela" )
		#define STR0018 "Incluir valores para os servi�os"
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "O ano-m�s final deve ser maior do que o inicial", "O ano-m�s final deve ser maior do que o final" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "N�o � permitido gravar hist�ricos futuros", "N�o � permitido gravar hist�rico futuros" )
		#define STR0021 "Per�odos sobrepostos no hist�rico das participa��es"
		#define STR0022 "� preciso preencher o ano-n�s final deste hist�rico"
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "� preciso incluir valor para os servi�os no hist�rico com ano-m�s inicial: ", "� preciso incluir Valor para os servi�os no hist�rico com ano-m�s inicial: " )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Erro ao gravar o hist�rico da tabela de servi�os", "Erro ao Gravar o hist�rico da tabela de servi�os" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Erro ao gravar o hist�rico do valor por servi�o", "Erro ao Gravar o hist�rico do valor por servi�o" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "N�o � permitido incluir servi�o tabelado inactivo neste registo.", "N�o � permitido incluir servico tabelado inativo neste cadastro." )
		#define STR0027 "Deve ser preenchido o campo "
		#define STR0028 If( cPaisLoc $ "ANG|PTG", " da aba ", " da Aba " )
		#define STR0029 "O tipo da tabela est� diferente do tipo do servi�o: "
	#endif
#endif
