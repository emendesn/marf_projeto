#ifdef SPANISH
	#define STR0001 "Retorno Opciones Check-List"
	#define STR0002 "Varias "
	#define STR0003 "Descripcion"
	#define STR0004 "Respuesta"
	#define STR0005 "Exclusiva"
	#define STR0006 "Orden"
	#define STR0007 "Plan"
	#define STR0008 "Opcion"
	#define STR0009 "Check-List"
	#define STR0010 "Nombre"
	#define STR0011 "Informe la respuesta del item "
	#define STR0012 "Atencion"
	#define STR0013 "Buscar"
	#define STR0014 "Visualizar"
	#define STR0015 "Incluir"
#else
	#ifdef ENGLISH
		#define STR0001 "Checklist Return Options"
		#define STR0002 "Several "
		#define STR0003 "Description"
		#define STR0004 "Answer"
		#define STR0005 "Exclusive"
		#define STR0006 "Order"
		#define STR0007 "Plan"
		#define STR0008 "Option"
		#define STR0009 "Check-List"
		#define STR0010 "Name"
		#define STR0011 "Enter item answer. "
		#define STR0012 "Attention"
		#define STR0013 "Search"
		#define STR0014 "View"
		#define STR0015 "Add"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Retorno op��es check-list", "Retorno Op��es Check-List" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "V�rias ", "Varias " )
		#define STR0003 "Descri��o"
		#define STR0004 "Resposta"
		#define STR0005 "Exclusiva"
		#define STR0006 "Ordem"
		#define STR0007 "Plano"
		#define STR0008 "Op��o"
		#define STR0009 "Check-List"
		#define STR0010 "Nome"
		#define STR0011 "Informe a resposta do item "
		#define STR0012 "Aten��o"
		#define STR0013 "Pesquisar"
		#define STR0014 "Visualizar"
		#define STR0015 "Incluir"
	#endif
#endif
