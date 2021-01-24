#ifdef SPANISH
	#define STR0001 "Exceso de parametros na URL. Solo se permite uno para este metodo"
	#define STR0002 "Solo se permite el formato json"
	#define STR0003 "Id del usuario no se encontro"
	#define STR0004 "Fallo en el parser Json"
	#define STR0005 "El parametro 'Id del usuario' es obligatorio para esta operacion"
	#define STR0006 "El SCIM 'Users' es un protocolo de aplicacion REST, para provision y gerenciamiento de datos de identidad en la web. El protocolo soporta la creacion, modificacion, recuperacion y descubierta de usuarios."
	#define STR0007 "Para recuperar un usuario conocido, los clientes envian solicitudes GET. Si el usuario existe, el servidor responde con el codigo de estado 200 e incluye el resultado del cuerpo de la respuesta. Tambien se pueden Alistar los usuarios del sistema, para ello, basta no informar el Id del usuario."
	#define STR0008 "Para criar nuevos usuarios, los clientes envian pedidos POST. La creacion de usuario con exito, se indica con un codigo de respuesta 201 y el cuerpo de la respuesta debe contener el usuario recien creado. Cuando se crea un usuario, su URI debe devolverse en el HEADER Location."
	#define STR0009 "Para actualizar usuarios, los clientes envian pedidos PUT. Para actualizar un usuario se deben enviar todos los datos, con excepcion del atributo de contrasena. Si el atributo de contrasena del usuario no se especifica, el se mantendra."
	#define STR0010 "Para bloquear un usuario, los clientes envian pedidos DELETE."
	#define STR0011 "Falta de esquema de SCIM en el JSON"
	#define STR0012 "E-mail primario no enviado."
#else
	#ifdef ENGLISH
		#define STR0001 "Excess of parameters in URL. Only one is allowed for this method"
		#define STR0002 "Only json format allowed"
		#define STR0003 "User Id not found"
		#define STR0004 "Failure in Json parser"
		#define STR0005 "The parameter 'User Id' is mandatory for this operation"
		#define STR0006 "The SCIM Users is a REST application protocol for web identity and data management and provision. The protocol supports users discovery, recovery, change and creation."
		#define STR0007 "To recover a known user, customers send GET requirements. If the user exists, the server replies with state 200 code and adds the result in the answer text. You can also List the Users of the system: enter the User Id."
		#define STR0008 "To create new users, customers send POST orders. The successful user creation is indicated with answer code 200 and answer text must have recently created user. When the user is created, the user URI must be returned in the HEADER Location. "
		#define STR0009 "To update users, customers send PUT orders. To updated one user, send all data but the password attribute. If the user attribute password is not specified, it is kept."
		#define STR0010 "To block one user, the customer send DELETE orders."
		#define STR0011 "Lack of SCIM scheme in JSON"
		#define STR0012 "Primary e-mail not sent"
	#else
		#define STR0001 "Excesso de par�metros na URL. Apenas um � permitido para este m�todo"
		#define STR0002 "Somente o formato json � permitido"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Id do utilizador n�o encontrado", "Id do usu�rio n�o encontrado" )
		#define STR0004 "Falha no parser Json"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "O par�metro 'Id do utilizador' � obrigat�rio para esta opera��o", "O par�metro 'Id do usu�rio' � obrigat�rio para esta opera��o" )
		#define STR0006 "O SCIM 'Users' � um protocolo de  aplica��o REST, para provisionamento e gerenciamento de dados de identidade na web. O protocolo suporta a cria��o, modifica��o, recupera��o e descoberta de usu�rios."
		#define STR0007 "Para recuperar um usu�rio conhecido, os clientes enviam requisi��es GET. Se o usu�rio existe o servidor responde com o c�digo de estado 200 e inclui o resultado do corpo da resposta. Tamb�m � poss�vel Listar os usu�rios do sistema, para tanto, basta n�o informar o Id do usu�rio."
		#define STR0008 "Para criar novos usu�rios, os clientes enviam pedidos POST. A cria��o de usu�rio bem sucedida � indicada com um c�digo de resposta 201 e o corpo da resposta deve conter o usu�rio rec�m-criado. Quando um usu�rio � criado, seu URI deve ser devolvido no HEADER Location."
		#define STR0009 "Para atualizar usu�rios, os clientes enviam pedidos PUT. Para atualizar um usu�rio deve-se enviar todos os dados, com exce��o do atributo de senha. Se o atributo de senha do usu�rio do usu�rio n�o for especificado, ele ser� mantido."
		#define STR0010 "Para bloquear um usu�rio, os clientes enviam pedidos DELETE."
		#define STR0011 "Falta do esquema do SCIM no JSON"
		#define STR0012 "E-mail prim�rio n�o enviado"
	#endif
#endif
