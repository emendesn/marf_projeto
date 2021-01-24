#ifdef SPANISH
	#define STR0001 "Buscar   "
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar "
	#define STR0006 "Repair Center"
	#define STR0007 "Consulta situacion del stock"
	#define STR0008 "Requisiciones de la OS"
	#define STR0009 'Para confirmar la inclusion/modificacion es necesario tener por lo menos 1 item en la Cuadricula de datos. ¡Verifique!'
#else
	#ifdef ENGLISH
		#define STR0001 "Search   "
		#define STR0002 "View      "
		#define STR0003 "Add "
		#define STR0004 "Edit   "
		#define STR0005 "Delete "
		#define STR0006 "Repair Center"
		#define STR0007 "Search stock position"
		#define STR0008 "SO Requirements"
		#define STR0009 'To confirm addition/edition, you must have at least 1 item in Data Grid. Check it!'
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 "Repair Center"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Consulta posição de stock", "Consulta posicao de estoque" )
		#define STR0008 "Requisicoes da OS"
		#define STR0009 'Para confirmar a inclusão/alteração é necessário ter ao menos 1 item na Grade de Dados. Verifique!'
	#endif
#endif
