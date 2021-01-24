#ifdef SPANISH
	#define STR0001 "Variables Utilizadas en las Formulas"
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Incluir"
	#define STR0005 "Modificar"
	#define STR0006 "Borrar"
	#define STR0007 "Los campos Cod. Paramet y Orden son obligatorios."
	#define STR0008 "Problema en la linea "
	#define STR0009 "Los siguientes parametros no pueden borrarse, "
	#define STR0010 "pues se estan utilizando en el archivo Parametros Por Indicador (TZ7)."
	#define STR0011 "Parametros: "
	#define STR0012 "Atencion"
	#define STR0013 "Informe solamente el nombre de la funcion, sin parentesis."
	#define STR0014 "La funcion no existe en el repositorio."
#else
	#ifdef ENGLISH
		#define STR0001 "Variables Used in Formulas"
		#define STR0002 "Search"
		#define STR0003 "View"
		#define STR0004 "Add"
		#define STR0005 "Edit"
		#define STR0006 "Delete"
		#define STR0007 "Fields Cod. Paramet and Order are mandatory."
		#define STR0008 "Problem in line "
		#define STR0009 "The following parameters cannot be excluded "
		#define STR0010 "because they are used in the file Parameters by Indicator (TZ7)."
		#define STR0011 "Parameters: "
		#define STR0012 "Attention"
		#define STR0013 "Indicate only function name, without parenthesis."
		#define STR0014 "Function does not exist in repository."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Vari�veis utilizadas nas f�rmulas", "Vari�veis Utilizadas nas F�rmulas" )
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Incluir"
		#define STR0005 "Alterar"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Eliminar", "Excluir" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Os campos C�d. Par�met. e Ordem s�o obrigat�rios.", "Os campos Cod. Paramet e Ordem s�o obrigat�rios." )
		#define STR0008 "Problema na linha "
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Os seguintes par�metros n�o poder�o ser eliminados, ", "Os seguintes par�metros n�o poder�o ser exclu�dos, " )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "pois est�o a ser utilizados no ficheiro Par�metros Por Indicador (TZ7).", "pois est�o sendo utilizados no arquivo Par�metros Por Indicador (TZ7)." )
		#define STR0011 "Par�metros: "
		#define STR0012 "Aten��o"
		#define STR0013 "Informe apenas o nome da fun��o, sem os par�nteses."
		#define STR0014 "Fun��o n�o existe no reposit�rio."
	#endif
#endif
