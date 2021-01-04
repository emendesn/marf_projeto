#ifdef SPANISH
	#define STR0001 "Seleccionando Registros..."
	#define STR0002 "Ordenes de Recoleccion generadas con exito ..."
	#define STR0003 "No se genero ninguna Orden de Recoleccion ..."
	#define STR0004 "Atencion"
	#define STR0005 "Recoleccion Automatica"
	#define STR0006 "Este programa tiene como objetivo generar ordenes de recoleccion basandose en el Tipo de"
	#define STR0007 "Recoleccion y en los dias informados en la carpeta ( Recoleccion ) en el archivo de Solicitantes."
	#define STR0008 "Espere..."
#else
	#ifdef ENGLISH
		#define STR0001 "Selecting records...     "
		#define STR0002 "Collection orders generated successfully"
		#define STR0003 "No collection order generated...          "
		#define STR0004 "Note"
		#define STR0005 "Automatic collec."
		#define STR0006 "This program's objective is to generate collection orders based on the Type of"
		#define STR0007 "type and on the days entered in the folder(Coleta) in the requesters file.   "
		#define STR0008 "Wait...   "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "A Seleccionar Registos...", "Selecionando Registros..." )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Ordens de coleta criadas com sucesso ...", "Ordens de Coleta geradas com sucesso ..." )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Não foi criada nenhuma ordem de coleta ...", "Nao foi gerada nenhuma Ordem de Coleta ..." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Atenção", "Atencao" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Recolha Automática", "Coleta Automatica" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Este programa tem como objetivo, criar ordens de coleta baseando-se no tipo de", "Este programa tem como objetivo, gerar ordens de coleta baseando-se no Tipo de" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Coleta E Nos Dias Informados Na Pasta ( Coleta ) No Registo De Solicitantes.", "Coleta e nos dias informados na pasta ( Coleta ) no cadastro de Solicitantes." )
		#define STR0008 "Aguarde..."
	#endif
#endif
