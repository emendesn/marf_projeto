#ifdef SPANISH
	#define STR0001 "Actualizacion del campo F2_CLIENTE, anexo de consulta estandar SA1 en el diccionario de datos."
	#define STR0002 "Creacion de campo"
	#define STR0003 "Configuraci�n  de NF, NCC, NCA Electronico"
#else
	#ifdef ENGLISH
		#define STR0001 "Updating field F2_CLIENTE, annex of standard query SA1 in the database."
		#define STR0002 "Field creation"
		#define STR0003 "Electronic NF, NCC, NCA configuration "
	#else
		#define STR0001 "Atualizacao do campo F2_CLIENTE, anexo da consulta padr�o SA1 no  dicionario de dados."
		#define STR0002 "Criacao de campo"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Configuraci�n  de NF, NCC, NCA Electronico", "Configura��o de NF, NCC, NCA eletr�nico" )
	#endif
#endif
