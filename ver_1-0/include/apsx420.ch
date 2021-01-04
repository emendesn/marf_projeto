#ifdef SPANISH
	#define STR0001 "Archivo de Proyectos"
	#define STR0002 "Archivo de Proyectos"
	#define STR0003 "Archivo de Proyectos"
	#define STR0004 "Archivo de Proyectos"
	#define STR0005 "Archivo de Proyectos"
	#define STR0006 "El modo de acceso de los items no puede ser igual al modo de acceso del encabezado"
	#define STR0007 "Existen owners duplicados en los items"
	#define STR0008 "Este proyecto no puede borrarse pues esta en uso en la estructura de version codigo "
	#define STR0009 "Salir"
	#define STR0010 "Atencion"
	#define STR0011 "Este proyecto no puede borrarse pues esta en uso en las tablas de movimiento"
	#define STR0012 "Salir"
	#define STR0013 "Atencion"
	#define STR0014 "Este proyecto no puede retirarse de la estructura pues esta en uso en las tablas de movimiento"
	#define STR0015 "Salir"
	#define STR0016 "Copia proyectos"
	#define STR0017 "Proyecto origen"
	#define STR0018 "Proyecto destino"
	#define STR0019 "Abierto"
	#define STR0020 "Situacion"
	#define STR0021 "Incorporado"
	#define STR0022 "Cerrado"
	#define STR0023 "En mantenimiento"
	#define STR0024 "Bloqueado"
	#define STR0025 "Buscar"
	#define STR0026 "Visualizar"
	#define STR0027 "Incluir"
	#define STR0028 "Modificar"
	#define STR0029 "Copiar"
	#define STR0030 "Borrar"
	#define STR0031 "Leyenda"
	#define STR0032 "Atencion"
	#define STR0033 "Solo aprobacion"
	#define STR0034 "Solo .CH"
	#define STR0035 "Abierto sin incl. de tabla"
#else
	#ifdef ENGLISH
		#define STR0001 "Project Registration"
		#define STR0002 "Project Registration"
		#define STR0003 "Project Registration"
		#define STR0004 "Project Registration"
		#define STR0005 "Project Registration"
		#define STR0006 "The access mode of the items cannot be equal to the access mode of the header"
		#define STR0007 "There are duplicated owners in the items"
		#define STR0008 "This project cannot be deleted because it is being used in the structure of the code version "
		#define STR0009 "Exit"
		#define STR0010 "Attention"
		#define STR0011 "This project cannot be deleted because it is being used in movement tables"
		#define STR0012 "Exit"
		#define STR0013 "Attention"
		#define STR0014 "This project cannot be removed from structure because it is being used in movement tables"
		#define STR0015 "Exit"
		#define STR0016 "Copy projects"
		#define STR0017 "Origin project"
		#define STR0018 "Destination project"
		#define STR0019 "Open"
		#define STR0020 "Status"
		#define STR0021 "Incorporated"
		#define STR0022 "Closed"
		#define STR0023 "Under Maintenance"
		#define STR0024 "Blocked"
		#define STR0025 "Search"
		#define STR0026 "View"
		#define STR0027 "Add"
		#define STR0028 "Edit"
		#define STR0029 "Copy"
		#define STR0030 "Delete"
		#define STR0031 "Caption"
		#define STR0032 "Attention"
		#define STR0033 "Only approval"
		#define STR0034 "Only .CH"
		#define STR0035 "Open without table addition"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Registo de projectos", "Cadastro de Projetos" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Registo de projectos", "Cadastro de Projetos" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Registo de projectos", "Cadastro de Projetos" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Registo de projectos", "Cadastro de Projetos" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Registo de projectos", "Cadastro de Projetos" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "O modo de acesso dos itens n�o pode ser igual ao modo de acesso do cabe�alho", "O modo de acesso dos itens n�o pode ser igual ao modo de acesso do cabecalho" )
		#define STR0007 "Existem owners duplicados nos itens"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Este projecto n�o pode ser exclu�do, pois est� em uso em na estrutura da vers�o c�digo ", "Este projeto n�o pode ser exclu�do pois est� em uso em na estrutura da versao codigo " )
		#define STR0009 "Sair"
		#define STR0010 "Aten��o"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Este projecto n�o pode ser exclu�do, pois est� em uso nas tabelas de movimento", "Este projeto n�o pode ser exclu�do pois est� em uso nas tabelas de movimento" )
		#define STR0012 "Sair"
		#define STR0013 "Aten��o"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Este projecto n�o pode ser retirado da estrutura, pois est� em uso nas tabelas de movimento", "Este projeto n�o pode ser retirado da estrutura pois est� em uso nas tabelas de movimento" )
		#define STR0015 "Sair"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Copia projectos", "Copia projetos" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Projecto origem", "Projeto origem" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Projecto destino", "Projeto destino" )
		#define STR0019 "Aberto"
		#define STR0020 "Situa��o"
		#define STR0021 "Incorporado"
		#define STR0022 "Fechado"
		#define STR0023 "Em manuten��o"
		#define STR0024 "Bloqueado"
		#define STR0025 "Pesquisar"
		#define STR0026 "Visualizar"
		#define STR0027 "Incluir"
		#define STR0028 "Alterar"
		#define STR0029 "Copiar"
		#define STR0030 "Excluir"
		#define STR0031 "Legenda"
		#define STR0032 "Aten��o"
		#define STR0033 "S� aprova��o"
		#define STR0034 "Apenas .CH"
		#define STR0035 "Aberto sem incl. de tabela"
	#endif
#endif
