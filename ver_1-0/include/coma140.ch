#ifdef SPANISH
	#define STR0001 "Esta solicitud ya se libero. ¡Para reenviar es necesario bloquear la solicitud nuevamente!"
	#define STR0002 'Enviando solicitud para aprobacion...'
#else
	#ifdef ENGLISH
		#define STR0001 "Esta solicitação já foi liberada, para reenviar é necessário bloquear a solicitação novamente!"
		#define STR0002 'Enviando solicitação para aprovação...'
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Esta solicitação já foi liberada; para reenviá-la, é necessário bloquear a solicitação novamente.", "Esta solicitação já foi liberada, para reenviar é necessário bloquear a solicitação novamente!" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", 'A enviar solicitação para aprovação...', 'Enviando solicitação para aprovação...' )
	#endif
#endif
