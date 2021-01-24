#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Imprimir"
	#define STR0007 "Reg. Funcion P/ Uso Cliente"
	#define STR0008 "Modelo de Datos de Reg. Funcion P/ Uso Cliente"
	#define STR0009 "Datos de Reg. Funcion P/ Uso Cliente"
	#define STR0010 "Items de Cad Funcion P/ Uso Cliente"
	#define STR0011 "Es necesario vincular al menos un cliente"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Add"
		#define STR0004 "Change"
		#define STR0005 "Delete"
		#define STR0006 "Print"
		#define STR0007 "Reg. of function for Customer use"
		#define STR0008 "Data model of function reg for customer use"
		#define STR0009 "Data of Function registration for customer use"
		#define STR0010 "Items of Function Reg for Customer Use"
		#define STR0011 "A customer must be related"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Eliminar", "Excluir" )
		#define STR0006 "Imprimir"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Reg.função p/ uso cliente", "Cad Funcao P/ Uso Cliente" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Modelo de dados de reg.função p/ uso cliente", "Modelo de Dados de Cad Funcao P/ Uso Cliente" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Dados de reg.função p/ uso cliente", "Dados de Cad Funcao P/ Uso Cliente" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Itens de reg.função p/ uso cliente", "Itens de Cad Funcao P/ Uso Cliente" )
		#define STR0011 "É necessário vincular ao menos um cliente"
	#endif
#endif
