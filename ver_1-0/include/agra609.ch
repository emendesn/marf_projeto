#ifdef SPANISH
	#define STR0001 "Archivo de tabla de Porcentajes de Separación"
	#define STR0002 "PROHIBIDO"
	#define STR0003 "Imposible excluir la tabla de porcentaje, pues esta en so."
	#define STR0004 "Espere..."
	#define STR0005 "Salvando alteraciones"
	#define STR0006 "Buscar"
	#define STR0007 "Visualizar"
	#define STR0008 "Incluir"
	#define STR0009 "Alterar"
	#define STR0010 "Excluir"
	#define STR0011 "Atención"
	#define STR0012 "Es necesario informar el código de la tabla de separación"
	#define STR0013 "OK"
#else
	#ifdef ENGLISH
		#define STR0001 "Separation Percentage Register Table"
		#define STR0002 "FORBIDDEN"
		#define STR0003 "The percentage table cannot be deleted because it is already in use."
		#define STR0004 "Wait..."
		#define STR0005 "Saving changes"
		#define STR0006 "Search"
		#define STR0007 "View"
		#define STR0008 "Add"
		#define STR0009 "Modify"
		#define STR0010 "Delete"
		#define STR0011 "Attention"
		#define STR0012 "You must enter the separation table code."
		#define STR0013 "OK"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Registo de Tabela de Percentagens de Separação", "Cadastro de Tabela de Percentuais de Separação" )
		#define STR0002 "PROIBIDO"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "A tabela de percentagem não pode ser excluída pois já está em uso.", "A tabela de percentual não pode ser excluída pois já está em uso." )
		#define STR0004 "Aguarde..."
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "A gravar alterações", "Salvando alterações" )
		#define STR0006 "Pesquisar"
		#define STR0007 "Visualizar"
		#define STR0008 "Incluir"
		#define STR0009 "Alterar"
		#define STR0010 "Excluir"
		#define STR0011 "Atenção"
		#define STR0012 "É necessário informar o código da tabela de separação."
		#define STR0013 "OK"
	#endif
#endif
