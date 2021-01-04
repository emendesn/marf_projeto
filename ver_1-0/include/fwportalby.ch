#ifdef SPANISH
	#define STR0001 "Acceder by You"
	#define STR0002 "Acceder Portal"
	#define STR0003 "Quiere saber mas sobre el"
	#define STR0004 "Haga clic aqui"
	#define STR0005 "Contacte nuestro soporte"
	#define STR0006 "Perfil"
	#define STR0007 "Seguridad"
	#define STR0008 "Mobilidad"
	#define STR0009 "Productividad"
	#define STR0010 "Integracion"
	#define STR0011 "Red de empresas"
	#define STR0012 "Haga su login"
	#define STR0013 "Usuario"
	#define STR0014 "Contrasena"
	#define STR0015 "¿Se olvido su contrasena?"
	#define STR0016 "Enviar"
	#define STR0017 "Recuperacion de Contrasena"
	#define STR0018 "Email"
#else
	#ifdef ENGLISH
		#define STR0001 "Access by You"
		#define STR0002 "Access Portal"
		#define STR0003 "Want to know more about"
		#define STR0004 "Click Here"
		#define STR0005 "Contact our support"
		#define STR0006 "Profile"
		#define STR0007 "Security"
		#define STR0008 "Mobility"
		#define STR0009 "Productivity"
		#define STR0010 "Integration"
		#define STR0011 "Company Network"
		#define STR0012 "Login"
		#define STR0013 "User"
		#define STR0014 "Password"
		#define STR0015 "Forgot your password"
		#define STR0016 "Send"
		#define STR0017 "Password Recovery"
		#define STR0018 "E-mail"
	#else
		#define STR0001 "Acessar by You"
		#define STR0002 "Acessar Portal"
		#define STR0003 "Quer saber mais sobre o"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Clique aqui", "Clique Aqui" )
		#define STR0005 "Fale com o nosso suporte"
		#define STR0006 "Perfil"
		#define STR0007 "Segurança"
		#define STR0008 "Mobilidade"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Productividade", "Produtividade" )
		#define STR0010 "Integração"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Rede de empresas", "Rede de Empresas" )
		#define STR0012 "Faça o login"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Utilizador", "Usuário" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Palavra-passe", "Senha" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Esqueceu sua palavra-passe?", "Esqueceu sua senha?" )
		#define STR0016 "Enviar"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Recuperação de palavra-passe", "Recuperação de Senha" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "E-mail", "Email" )
	#endif
#endif
