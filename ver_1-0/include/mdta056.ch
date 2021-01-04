#ifdef SPANISH
	#define STR0001 "Archivo de Cuestionario Quimico"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Buscar"
	#define STR0007 "Campo Codigo Grupo debe rellenarse."
	#define STR0008 "ATENCION"
	#define STR0009 "Campo Orden debe rellenarse."
	#define STR0010 "Ya existe una pregunta con esta Orden y Grupo."
#else
	#ifdef ENGLISH
		#define STR0001 "Chemical Questionnaire Register"
		#define STR0002 "View"
		#define STR0003 "Add"
		#define STR0004 "Change"
		#define STR0005 "Delete"
		#define STR0006 "Search"
		#define STR0007 "Group Code field must be filled out."
		#define STR0008 "ATTENTION"
		#define STR0009 "Order field must be filled out."
		#define STR0010 "There is already a question with this Order and Group."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Registo de Questionário Químico", "Cadastro de Questionário Químico" )
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Eliminar", "Excluir" )
		#define STR0006 "Pesquisar"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Campo cóodigo grupo deve ser preenchido.", "Campo Codigo Grupo deve ser preenchido." )
		#define STR0008 "ATENÇÃO"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "O campo Ordem deve ser preenchido.", "Campo Ordem deve ser preenchido." )
		#define STR0010 "Já existe uma pergunta com esta Ordem e Grupo."
	#endif
#endif
