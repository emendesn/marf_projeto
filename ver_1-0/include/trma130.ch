#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Archivo de planificacion de entrenamientos"
	#define STR0007 "Cod. planificacion: "
	#define STR0008 "Parametros"
	#define STR0009 "Generar autom."
	#define STR0010 "Cod. planificacion: "
	#define STR0011 "Fecha inicial: "
	#define STR0012 "Fecha final: "
	#define STR0013 "Responsable: "
	#define STR0014 "Sol.Compra"
	#define STR0015 "Solicitud grabada con exito - "
	#define STR0016 "Atencion"
	#define STR0017 "�Error en inclusion automatica!"
	#define STR0018 "Ya se genero Solicitud para esta Planificacion - "
	#define STR0019 "Codigo de Planeamiento se debe llenar correctamente o Codigo de Planeamiento no puede estar en blanco."
	#define STR0020 "Parametro"
	#define STR0021 "Generar"
	#define STR0022 "Sobrepaso el numero maximo de lineas, suprima lineas o pida al Adminsitrador del Sistema que aumente el tama�o del campo RA8_SEQ."
	#define STR0023 "�Cuando la Integracion con el Modulo SIGAPCO esta activada, los Centros de Costo y Fecha Planificacion son obligatorios!"
	#define STR0024 "�Descripcion!"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Insert"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Trainings Planning File"
		#define STR0007 "Planning Code: "
		#define STR0008 "Parameters"
		#define STR0009 "Autom. Ganer."
		#define STR0010 "Planning Code:"
		#define STR0011 "Initial Date: "
		#define STR0012 "Final Date: "
		#define STR0013 "Responsible: "
		#define STR0014 "Purchase Req."
		#define STR0015 "Request saved successfully - "
		#define STR0016 "Warning"
		#define STR0017 "Error during automatic insertion!"
		#define STR0018 "Requisition for this Planning has already been generated - "
		#define STR0019 "Planning Code must be filled in correctly or Planning Code cannot be blank."
		#define STR0020 "Parameter"
		#define STR0021 "Generate"
		#define STR0022 "Exceeded the maximum number of rows, delete rows or ask the System Administrator to increase the size of field RA8_SEQ."
		#define STR0023 "When integration with the SIGAPCO module is enabled, Cost Centers and Planning Date are mandatory!"
		#define STR0024 "Description!"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Registo De Planeamento Das Forma��es", "Cadastro de Planejamento dos Treinamentos" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "C�d. de planeamento: ", "C�d. Planejamento: " )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Par�metros", "Parametros" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Criar Autom.", "Gerar Autom." )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "C�d. de planeamento: ", "Cod. Planejamento: " )
		#define STR0011 "Data inicial: "
		#define STR0012 "Data final: "
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Respons�vel: ", "Responsavel: " )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Sol.compra", "Sol.Compra" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Solicita��o guardada com sucesso - ", "Solicitacao gravada com sucesso - " )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Aten��o", "Atencao" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Erro na introdu��o automatica!", "Erro na inclusao automatica!" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "J� foi criada solicita��o para este planeamento - ", "Ja foi gerada Solicitacao para este Planejamento - " )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "C�digo do planeamento deve ser preeenchido correctamente ou c�digo do planeamento n�o pode estar em branco.", "Codigo do Planejamento deve ser preeenchido corretamente ou Codigo do Planejamento nao pode estar em branco." )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Par�metros", "Parametro" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Criar", "Gerar" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Excedeu O N�mero M�ximo De Linhas, Elimine Linhas Ou Pe�a Para O Administrador Do Sistema Aumentar O Tamanho Do Campo Ra8_seq.", "Excedeu o numero m�ximo de linhas, elimine linhas ou pe�a para o Administrador do Sistema aumentar o tamanho do campo RA8_SEQ." )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Quando a Integra��o com o M�dulo SIGAPCO est� activada, os Centros de Custo e Data Planeamento s�o obrigat�rios.", "Quando a Integra��o com o M�dulo SIGAPCO est� ativada, os Centros de Custo e Data Planejamento s�o obrigatorios!" )
		#define STR0024 "Descri��o!"
	#endif
#endif
