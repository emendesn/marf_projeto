#ifdef SPANISH
	#define STR0001 "Usuario registrado para programacion, codigoo '#1[codigo del usuario]#', no existe."
	#define STR0002 "Usuario registrado para programacion, codigo '#1[codigo del usuario]#', excedio accesos simultaneos."
#else
	#ifdef ENGLISH
		#define STR0001 "User registered for schedule, code #1[user code]# does not exist."
		#define STR0002 "User registered for schedule, code #1[user code]# exceeded simultaneous accesses."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Utilizador registado para agendamento, c�digo '#1[c�digo do utilizador]#', n�o existe.", "Usu�rio cadastrado para agendamento, c�digo '#1[c�digo do usu�rio]#', n�o existe." )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Utilizador registado para agendamento, c�digo '#1[c�digo do utilizador]#', excedeu acessos simult�neos.", "Usu�rio cadastrado para agendamento, c�digo '#1[c�digo do usu�rio]#', execeu acessos simult�neos." )
	#endif
#endif
