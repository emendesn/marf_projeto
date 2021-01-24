#ifdef SPANISH
	#define STR0001 "Usuario registrado para programacion, codigoo '#1[codigo del usuario]#', no existe."
	#define STR0002 "Usuario registrado para programacion, codigo '#1[codigo del usuario]#', excedio accesos simultaneos."
#else
	#ifdef ENGLISH
		#define STR0001 "User registered for schedule, code #1[user code]# does not exist."
		#define STR0002 "User registered for schedule, code #1[user code]# exceeded simultaneous accesses."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Utilizador registado para agendamento, código '#1[código do utilizador]#', não existe.", "Usuário cadastrado para agendamento, código '#1[código do usuário]#', não existe." )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Utilizador registado para agendamento, código '#1[código do utilizador]#', excedeu acessos simultâneos.", "Usuário cadastrado para agendamento, código '#1[código do usuário]#', execeu acessos simultâneos." )
	#endif
#endif
