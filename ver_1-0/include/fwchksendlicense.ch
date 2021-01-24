#ifdef SPANISH
	#define STR0001 "Autorizo el envio de uso de aplicacion TOTVS en mis instalaciones para fines de liberacion de contrasenas. "
	#define STR0002 "TOTVS no está autorizada a difundir estos datos en el mercado."
	#define STR0003 "El envio de esta informacion es sumamente importante para que TOTVS conozca el comportamiento de sus productos en sus instalaciones."
	#define STR0004 "Si usted responde no, la pregunta se mostrara de nuevo en 30 dias."
#else
	#ifdef ENGLISH
		#define STR0001 "I authorize the sending of use of the TOTVS application in my premises for purposes of password releases. "
		#define STR0002 "TOTVS is not authorized to disclose these data to the market."
		#define STR0003 "The sending of such information is extremely important for TOTVS to know how its products behave in your facilities."
		#define STR0004 "In case you answer No, the question is displayed again in 30 days."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Autorizo o envio de uso da aplicação TOTVS em minhas instalações para fins de liberação de palavras-passe. ", "Autorizo o envio de uso da aplicação TOTVS em minhas instalações para fins de liberação de senhas. " )
		#define STR0002 "A TOTVS não está autorizada a divulgar estes dados ao mercado."
		#define STR0003 "O envio destas informações é extremamente importante para que a TOTVS conheça o comportamento de seus produtos em suas instalações."
		#define STR0004 "Caso você responda não a pergunta será re-exibida daqui a 30 dias."
	#endif
#endif
