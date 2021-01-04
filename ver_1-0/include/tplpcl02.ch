#ifdef SPANISH
	#define STR0001 "Archivo de Mangueras de Abastecimiento"
	#define STR0002 "Chave : Tanque + Bomba + Bico ,já cadastrado. Verifique"
#else
	#ifdef ENGLISH
		#define STR0001 "Refueling Nozzle Registration"
		#define STR0002 "Chave : Tanque + Bomba + Bico ,já cadastrado. Verifique"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Registo de bicos de abastecimento", "Cadastro de Bicos de Abastecimento" )
		#define STR0002 "Chave : Tanque + Bomba + Bico ,já cadastrado. Verifique"
	#endif
#endif
