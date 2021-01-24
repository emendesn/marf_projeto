#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "No Permite Modificacion "
	#define STR0007 "Permite Modificacion"
	#define STR0008 "Agrupamientos de Campos de Rutinas"
	#define STR0009 "Modelo de Datos de Agrupamientos de Campos de Rutinas."
	#define STR0010 "Encabezado Agrupamientos de Campos de Rutinas"
	#define STR0011 "Campos de los Agrupamientos de Campos de Rutinas"
	#define STR0012 "Campo no pertenece a tabla seleccionada."
	#define STR0013 "Campo ya utilizado en el agrupamiento "
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Add"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Changes not allowed"
		#define STR0007 "Changes allowed"
		#define STR0008 "Groupings of Routine Fields"
		#define STR0009 "Data Model of Groupings of Routine Fields"
		#define STR0010 "Header of Groupings of Routine Fields"
		#define STR0011 "Fields of Groupings of Routine Fields"
		#define STR0012 "Field does not belong to table selected."
		#define STR0013 "Field already used in grouping. "
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Eliminar", "Excluir" )
		#define STR0006 "N�o Permite Altera��o"
		#define STR0007 "Permite Altera��o"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Agrupamentos de Campos de Procedimentos", "Agrupamentos de Campos de Rotinas" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Modelo de Dados de Agrupamentos de Campos de Procedimentos", "Modelo de Dados de Agrupamentos de Campos de Rotinas" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Cabe�alho Agrupamentos de Campos de Procedimentos", "Cabecalho Agrupamentos de Campos de Rotinas" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Campos dos Agrupamentos de Campos de Procedimentos", "Campos dos Agrupamentos de Campos de Rotinas" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Campo n�o pertence a tabela seleccionada.", "Campo n�o pertence a tabela selecionada." )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Campo j� utilizado no agrupamento ", "Campo ja utilizado no agrupamento " )
	#endif
#endif
