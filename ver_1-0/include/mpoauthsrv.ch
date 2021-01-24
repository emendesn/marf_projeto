#ifdef SPANISH
	#define STR0001 "Token no valido"
	#define STR0002 "Usuario no autenticado"
	#define STR0003 "Pedido de login no valido"
	#define STR0004 "Usuario"
	#define STR0005 "Contraseña"
	#define STR0006 "Inicie sesion"
	#define STR0007 "Desea saber mas sobre el"
	#define STR0008 "Haga clic aqui"
	#define STR0009 "Perfil"
	#define STR0010 "Seguridad"
	#define STR0011 "Movilidad"
	#define STR0012 "Productividad"
	#define STR0013 "Integración"
	#define STR0014 "Red de Empresas"
	#define STR0015 "Contacte a nuestro soporte"
#else
	#ifdef ENGLISH
		#define STR0001 "Token Not Valid"
		#define STR0002 "User not validated."
		#define STR0003 "Login request not valid"
		#define STR0004 "User"
		#define STR0005 "Password"
		#define STR0006 "Please Login"
		#define STR0007 "For further information on"
		#define STR0008 "Click Here"
		#define STR0009 "Profile"
		#define STR0010 "Security"
		#define STR0011 "Mobility"
		#define STR0012 "Productivity"
		#define STR0013 "Integration"
		#define STR0014 "Network of Companies"
		#define STR0015 "Contact our support"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Token inválido", "Token Inválido" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Utilizador não autenticado", "Usuário nao autenticado" )
		#define STR0003 "Pedido de login inválido"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Utilizador", "Usuário" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Palavra-passe", "Senha" )
		#define STR0006 "Faça o login"
		#define STR0007 "Quer saber mais sobre o"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Clique aqui", "Clique Aqui" )
		#define STR0009 "Perfil"
		#define STR0010 "Segurança"
		#define STR0011 "Mobilidade"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Productividade", "Produtividade" )
		#define STR0013 "Integração"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Rede de empresas", "Rede de Empresas" )
		#define STR0015 "Fale com o nosso suporte"
	#endif
#endif
