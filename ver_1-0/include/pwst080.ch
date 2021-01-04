#ifdef SPANISH
	#define STR0001 "Administracion de informaciones - Actualizacion de datos"
	#define STR0002 "�Informaciones enviadas con EXITO!"
	#define STR0003 "Datos de registro"
	#define STR0004 "�Informaciones registradas con EXITO!"
	#define STR0005 "Administracion de informaciones de registro - CONTACTOS"
	#define STR0006 "Datos de registro: "
	#define STR0007 "Datos de registro - CONTACTO"
	#define STR0008 "�Informaciones registradas con EXITO!"
	#define STR0009 "Error"
	#define STR0010 "Administracion de informaciones de registro"
	#define STR0011 "Datos de registro"
	#define STR0012 "Datos de registro: "
	#define STR0013 "ERROR PWST080#001 : Cliente no valido"
	#define STR0014 "ERROR PWST080#001 : Cliente no valido"
#else
	#ifdef ENGLISH
		#define STR0001 "Information Management - Data Update"
		#define STR0002 "Information SUCCESSFULLY generated!"
		#define STR0003 "Registration Data"
		#define STR0004 "Information SUCCESSFULLY generated!"
		#define STR0005 "Register Information Management - CONTACTS"
		#define STR0006 "Registration Data: "
		#define STR0007 "Registration Data - CONTACT"
		#define STR0008 "Information SUCCESSFULLY generated!"
		#define STR0009 "Error"
		#define STR0010 "Register Information Management"
		#define STR0011 "Registration Data"
		#define STR0012 "Registration Data: "
		#define STR0013 "ERRO PWST080#001 : Invalid Customer"
		#define STR0014 "ERRO PWST080#002 : Invalid Access"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Gerenciamento de Informa��es - Atualiza��o de Dados" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Informa��es enviadas com SUCESSO!" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Dados Cadastrais" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Informa��es cadastradas com SUCESSO!" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Gerenciamento de Informa��es Cadastrais - CONTATOS" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Dados Cadastrais : " )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Dados Cadastrais - CONTATO" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Informa��es cadastradas com SUCESSO!" )
		#define STR0009 "Erro"
		#define STR0010 "Gerenciamento de Informa��es Cadastrais"
		#define STR0011 "Dados Cadastrais"
		#define STR0012 "Dados Cadastrais : "
		#define STR0013 "ERRO PWST080#001 : Cliente Inv�lido"
		#define STR0014 "ERRO PWST080#002 : Acesso Inv�lido"
	#endif
#endif