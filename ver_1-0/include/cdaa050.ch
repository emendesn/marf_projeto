#ifdef SPANISH
	#define STR0001 "Genera archivo del contrato"
	#define STR0002 "Este programa tiene como objetivo generar datos en un "
	#define STR0003 "archivo para utilizarse en la emision del contrato por"
	#define STR0004 "parte del software MS-Word o similar.                                      "
	#define STR0005 "Generacion del archivo del contrato"
	#define STR0006 "Generando archivo del contrato..."
	#define STR0007 "¿Confirma generacion del arch. texto?"
	#define STR0008 "Atencion"
	#define STR0009 "Seleccione los Campos"
	#define STR0010 "&Orden:"
	#define STR0011 "Campo en Uso:"
	#define STR0012 "Si"
	#define STR0013 "No"
#else
	#ifdef ENGLISH
		#define STR0001 "Generates contract´s file"
		#define STR0002 "This program will generate data in file to be used       "
		#define STR0003 "when issuing contracts through MS-Word software or       "
		#define STR0004 "similar.                                                 "
		#define STR0005 "Generation of contract´s file"
		#define STR0006 "Generating contract´s file..."
		#define STR0007 "Confirm generation of text file?"
		#define STR0008 "Attention"
		#define STR0009 "Select the Fields"
		#define STR0010 "&Order:"
		#define STR0011 "Field in Use:"
		#define STR0012 "Yes"
		#define STR0013 "No"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Gera ficheiro do contrato", "Gera arquivo do contrato" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Este programa tem como objectivo criar dados em ficheiro   ", "Este programa tem como objetivo gerar dados em arquivo   " )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Para ser utilizado na emissão do contrato pelo software ", "para ser utilizados na emissao do contrato pelo software " )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Ms-word ou similar.                                      ", "MS-Word ou similar.                                      " )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Criação do arquivo do contrato", "Geracao do arquivo do contrato" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "A criar arquivo do contrato...", "Gerando arquivo do contrato..." )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Confirmar criação do arq. texto ?", "Confirma geracao do arq. texto ?" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Atenção", "Atençäo" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Seleccione Os Campos", "Selecione os Campos" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "&ordem:", "&Ordem:" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Campo Em Utilização:", "Campo em Uso:" )
		#define STR0012 "Sim"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Não", "Nao" )
	#endif
#endif
