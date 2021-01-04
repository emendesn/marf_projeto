#ifdef SPANISH
	#define STR0001 "Identificacion de tiendas"
	#define STR0002 "Caracteres no validos en el llenado del campo."
	#define STR0003 "Pesquisar"
	#define STR0004 "Visualizar"
	#define STR0005 "Incluir"
	#define STR0006 "Alterar"
	#define STR0007 "Excluir"
	#define STR0008 "Para continuar é necessário que o codigo da loja seja igual ao código de alguma filial do sistema(SM0)."
	#define STR0009 "Para integración con el sistema Synthesis el campo Categ.Imp.(LJ_IMPCAT) es obligatorio."
#else
	#ifdef ENGLISH
		#define STR0001 "Units Identification"
		#define STR0002 "Invalid Characters in field."
		#define STR0003 "Search"
		#define STR0004 "View"
		#define STR0005 "Add"
		#define STR0006 "Edit"
		#define STR0007 "Delete"
		#define STR0008 "To continue, is required that the store code is equal to the code of some system branch(SM0)."
		#define STR0009 "For integration with the Synthesis system, field Imp. Categ. (LJ1_IMPCAT) is required."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Identificação De Lojas", "Identificacao de Lojas" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Caracteres inválidos no preenchimento do campo.", "Caracteres invalidos no preenchimento do campo." )
		#define STR0003 "Pesquisar"
		#define STR0004 "Visualizar"
		#define STR0005 "Incluir"
		#define STR0006 "Alterar"
		#define STR0007 "Excluir"
		#define STR0008 "Para continuar é necessário que o codigo da loja seja igual ao código de alguma filial do sistema(SM0)."
		#define STR0009 "Para integracao com o sistema Synthesis o campo Categ.Imp.(LJ_IMPCAT) e obrigatorio."
	#endif
#endif
