#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Transf."
	#define STR0007 "Base Instalada"
	#define STR0008 "Conocimiento"
	#define STR0009 "Genera Base"
	#define STR0010 "Generador automatico de la base instalada"
	#define STR0011 "     Este Programa genera automaticamente la base instalada, segun los"
	#define STR0012 "parametros solicitados."
	#define STR0013 "Atencion"
	#define STR0014 "El proceso de generacion automatico de la base instalada, utilizara como registro maestro el registro indicado."
	#define STR0015 "Confirma"
	#define STR0016 "Salir"
	#define STR0017 "Resumen"
	#define STR0018 "Resumen de la generacion automatica de la base instalada "
	#define STR0019 "Clientes que generaron base instalada: "
	#define STR0020 "Registros de base instalada generados: "
	#define STR0021 "Registros de accesorios generados: "
	#define STR0022 "El equipo no puede transferirse porque es un item para alquiler de equipos"
	#define STR0023 "Es obligatorio completar cliente y tienda"
	#define STR0024 "No es posible realizar transferencia en items de alquiler"
	#define STR0025 'No se permite borrar un equipo para alquiler ya vinculado a una asignacion'
	#define STR0026 'No se ingreso contenido valido en el parametro'
	#define STR0027 'Ingrese un codigo de ocurrencia para la apertura de las O.S. de mantenimiento preventivo.'
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Insert"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Transfer"
		#define STR0007 "Install Base"
		#define STR0008 "Knowledge"
		#define STR0009 "Generate Basis"
		#define STR0010 "Installed basis automatic generation"
		#define STR0011 "    This program accomplishes installed basis automatic generation, according to "
		#define STR0012 "requested parameters."
		#define STR0013 "Attention"
		#define STR0014 "The installed basis automatic generation process, will use the positioned record as the main one."
		#define STR0015 "Confirm"
		#define STR0016 "Abort"
		#define STR0017 "Summary"
		#define STR0018 "Summary of the installed basis automatic generation"
		#define STR0019 "Customers that generated installed basis:"
		#define STR0020 "Installed basis records generated: "
		#define STR0021 "Accesory Record generated: "
		#define STR0022 "Equipment cannot be transfer - it is an Equipment Allocation item"
		#define STR0023 "Enter customer and store"
		#define STR0024 "You cannot transfer in location items"
		#define STR0025 'It is not allowed to delete a piece of equipment for rent already linked to an allocation'
		#define STR0026 'A valid content was not entered in the parameter'
		#define STR0027 'Enter an occurrence code for the preventive maintenance WO opening.'
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Modificar", "Alterar" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Eliminar", "Excluir" )
		#define STR0006 "Transfer."
		#define STR0007 "Base de Atendimento"
		#define STR0008 "Conhecimento"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Gera base", "Gera Base" )
		#define STR0010 "Gerador automático da base de atendimento"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "     este programa efectua a criação automática da base instalada, conforme os", "     Este programa efetua a geração automática da base de atendimento, conforme os" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "parâmetros solicitados.", "parametros solicitados." )
		#define STR0013 "Atenção"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "O processo de criação automática da base instalada, utilizará como registo principal o registo posicionado.", "O processo de geração automático da base de atendimento, utilizará como registro mestre o registro posicionado." )
		#define STR0015 "Confirma"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Abandonar", "Abandona" )
		#define STR0017 "Resumo"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Resumo da criação automática da base instalada ", "Resumo da geração automática da base de atendimento " )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Clientes que criaram base instalada: ", "Clientes que geraram base de atendimento: " )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Registos da base instalada criados: ", "Registros de base de atendimento gerados: " )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Registos de acessórios criados: ", "Registros de acessórios gerados: " )
		#define STR0022 "Equipamento não pode ser transferido por é um item para Locação de Equipamentos"
		#define STR0023 "É obrigatório preenchimento de cliente e loja"
		#define STR0024 "Não é possível realizar transferência em itens de locação"
		#define STR0025 'Não é permitido excluir um equipamento para locaçaõ já vinculado a uma alocação'
		#define STR0026 'Não foi inserido conteúdo válido no parâmetro'
		#define STR0027 'Insira um código de ocorrência para a abertura das O.S. de manutenção preventiva.'
	#endif
#endif
