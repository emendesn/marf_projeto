#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Archivo Documentos"
	#define STR0007 "Atencion"
	#define STR0008 "Documento esta relacionado a un Siniestro!"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Add"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Document File"
		#define STR0007 "Attention"
		#define STR0008 "Document is related to a Claim!"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Registo De Documentos", "Cadastro de Documentos" )
		#define STR0007 "Aten��o"
		#define STR0008 "Documento est� relacionado a um Sinistro!"
	#endif
#endif
