#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Archivo monedas contables"
	#define STR0007 "Tras incluir una nueva moneda, registre el vinculo de dicha moneda con un calendario contable. "
	#define STR0008 "El codigo de la moneda deve ser igual a la cantidad de monedas existente en el registro. "
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Insert"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Standardized Histories File"
		#define STR0007 "Afer inserting a new currency, register the currency binding with an accounting calendar.    "
		#define STR0008 "The currency code must be equal to the amount of currencies in the file.       "
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Registo De Moedas Contabilísticas", "Cadastro Moedas Contábeis" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Após a inserção de uma nova moeda, registar a associação da moeda com um calendário contabilístico. ", "Apos a inclusao de uma nova moeda,cadastrar a amarracao da moeda com um calendario contabil. " )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "O código da moeda deve ser igual a quantidade de moedas existente no registo. ", "O codigo da moeda deve ser igual a quantidade de moedas existente no cadastro. " )
	#endif
#endif
