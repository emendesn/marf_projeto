#ifdef SPANISH
	#define STR0001 "Liberacion de Venta"
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Liberar"
	#define STR0005 "Liberacion"
	#define STR0006 "¡Usuario no autorizado! Verificar Equipo Tecnico, campo "
	#define STR0007 "Atencion"
#else
	#ifdef ENGLISH
		#define STR0001 "Release of Sale"
		#define STR0002 "Search"
		#define STR0003 "View"
		#define STR0004 "Release"
		#define STR0005 "Release"
		#define STR0006 "User not authorized! Check Technical Team, field "
		#define STR0007 "Attention"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Liberação de Venda", "Liberacao de Venda" )
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Liberar"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Liberação", "Liberacao" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Utilizador não autorizado! Verificar Equipa Técnica, campo ", "Usuario não autorizado! Verificar Equipe Tecnica, campo " )
		#define STR0007 "Atenção"
	#endif
#endif
