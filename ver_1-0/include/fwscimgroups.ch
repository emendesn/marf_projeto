#ifdef SPANISH
	#define STR0001 "Exceso de parametros en la URL. Solo se permite uno para este metodo"
	#define STR0002 "Solo se permite el formato json"
	#define STR0003 "Id del grupo no se encontro"
	#define STR0004 "El SCIM 'Groups' es un protocolo de aplicacion REST, para provision y gerenciamiento de datos de identidad en la web. El protocolo soporta la recuperacion y descubierta de grupos."
	#define STR0005 "Para recuperar un Grupo conocido, los clientes envian solicitudes GET. Si el Grupo existe, el servidor responde con el codigo de estado 200 e incluye el resultado del cuerpo de la respuesta. Tambien se pueden Alistar los Grupos de usuarios, para ello, basta no informar el Id del Grupo."
#else
	#ifdef ENGLISH
		#define STR0001 "Excess of parameters in URL. Only one is allowed for this method"
		#define STR0002 "Only json format allowed"
		#define STR0003 "Group Id not found"
		#define STR0004 "The SCIM Groups is a REST application protocol for web identity and data management and provision. The protocol supports groups discovery and recovery."
		#define STR0005 "To recover a known Group, customers send GET requirements. If the Group exists, the server replies with state 200 code and adds the result in the answer text. You can also List the Groups of users: enter the Group Id."
	#else
		#define STR0001 "Excesso de parâmetros na URL. Apenas um é permitido para este método"
		#define STR0002 "Somente o formato json é permitido"
		#define STR0003 "Id do grupo não encontrado"
		#define STR0004 "O SCIM 'Groups' é um protocolo de  aplicação REST, para provisionamento e gerenciamento de dados de identidade na web. O protocolo suporta a recuperação e descoberta de grupos."
		#define STR0005 "Para recuperar um Grupo conhecido, os clientes enviam requisições GET. Se o Grupo existe o servidor responde com o código de estado 200 e inclui o resultado do corpo da resposta. Também é possível Listar os Grupos de usuários, para tanto, basta não informar o Id do Grupo."
	#endif
#endif
