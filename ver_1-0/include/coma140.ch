#ifdef SPANISH
	#define STR0001 "Esta solicitud ya se libero. �Para reenviar es necesario bloquear la solicitud nuevamente!"
	#define STR0002 'Enviando solicitud para aprobacion...'
#else
	#ifdef ENGLISH
		#define STR0001 "Esta solicita��o j� foi liberada, para reenviar � necess�rio bloquear a solicita��o novamente!"
		#define STR0002 'Enviando solicita��o para aprova��o...'
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Esta solicita��o j� foi liberada; para reenvi�-la, � necess�rio bloquear a solicita��o novamente.", "Esta solicita��o j� foi liberada, para reenviar � necess�rio bloquear a solicita��o novamente!" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", 'A enviar solicita��o para aprova��o...', 'Enviando solicita��o para aprova��o...' )
	#endif
#endif
