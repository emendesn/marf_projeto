#ifdef SPANISH
	#define STR0001 "Convertendo registros de rastreamento do CTK para o CV3..."
	#define STR0002 "Error en el borrado de la procedure: "
	#define STR0003 "Error en la creacion de la procedure: "
	#define STR0004 "Procesando ... Espere."
	#define STR0005 'Error en la activacion del proceso'
#else
	#ifdef ENGLISH
		#define STR0001 "Changing CTK trackability records to CV3..."
		#define STR0002 "Error deleting procedure: "
		#define STR0003 "Error creating procedure: "
		#define STR0004 "Processing ... Please, wait."
		#define STR0005 'Error when calling the preocess'
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "A Converter Registos De Rastreio Do Ctk Para O Cv3...", "Convertendo registros de rastreamento do CTK para o CV3..." )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Erro na eliminação da procedure: ", "Erro na exclusão da procedure: " )
		#define STR0003 "Erro na criação da procedure: "
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "A Processar ... Aguarde.", "Processando ... Aguarde." )
		#define STR0005 'Erro na chamada do processo'
	#endif
#endif
