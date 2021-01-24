#ifdef SPANISH
	#define STR0001 "Creacion del parametro MV_TCFSDOC - Generacion de contrasenas p/ RH OnLine"
	#define STR0002 "Creacion del parametro MV_TCFCXFX - Muestra de datos de archivo"
	#define STR0003 "Creacion del parametro MV_TCFFIL - Utiliza archivo de diccionario del TCF por sucursal"
	#define STR0004 "Creacion del parametro MV_TCFVREN - Visualiza Informe de rendimiento para usarios despedidos del Portal."
	#define STR0005 "Criação do índice de rotina na tabela AI8."
#else
	#ifdef ENGLISH
		#define STR0001 "Creation of parameter MV_TCFSDOC - Generation of passwords for HR Online"
		#define STR0002 "Creation of MV_TCFCXFX parameter - Display registration data"
		#define STR0003 "Creation of parameter MV_TCFFIL - Use TCF dictionary file per branch"
		#define STR0004 "Creation of parameter MV_TCFVREN - View Income Report for dismissed users of Portal."
		#define STR0005 "Routine index creation in table AI8."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Criação do parâmetro MV_TCFSDOC - Geração de palavras-passe p/ RH OnLine", "Criação do parâmetro MV_TCFSDOC - Geração de senhas p/ RH OnLine" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Criação do parâmetro MV_TCFCXFX - Exibiçao de dados de registo", "Criação do parâmetro MV_TCFCXFX - Exibiçao de dados cadastrais" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Criação do parâmetro MV_TCFFIL - Utiliza ficheiro de dicionário do TCF por filial", "Criação do parâmetro MV_TCFFIL - Utiliza arquivo de dicionário do TCF por filial" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Criação do parâmetro MV_TCFVREN - Visualiza Informe de rendimento para utilizadores despedidos do Portal.", "Criação do parametro MV_TCFVREN - Visualiza Informe de Rendimento para usarios demitidos do Portal." )
		#define STR0005 "Criação do índice de rotina na tabela AI8."
	#endif
#endif
