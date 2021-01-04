#ifdef SPANISH
	#define STR0001 "Actualizacion del campo F2_CLIENTE, anexo de consulta estandar SA1 en el diccionario de datos."
	#define STR0002 "Creacion de campo"
	#define STR0003 "Configuración  de NF, NCC, NCA Electronico"
#else
	#ifdef ENGLISH
		#define STR0001 "Updating field F2_CLIENTE, annex of standard query SA1 in the database."
		#define STR0002 "Field creation"
		#define STR0003 "Electronic NF, NCC, NCA configuration "
	#else
		#define STR0001 "Atualizacao do campo F2_CLIENTE, anexo da consulta padrão SA1 no  dicionario de dados."
		#define STR0002 "Criacao de campo"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Configuración  de NF, NCC, NCA Electronico", "Configuração de NF, NCC, NCA eletrônico" )
	#endif
#endif
