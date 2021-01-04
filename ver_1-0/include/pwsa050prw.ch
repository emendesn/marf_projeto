#ifdef SPANISH
	#define STR0001 "Error"
	#define STR0002 "Modificacion de datos de registro"
	#define STR0003 "Nombre"
	#define STR0004 "CPF"
	#define STR0005 "Matricula"
	#define STR0006 "Mensaje"
	#define STR0007 "¡Mensaje enviado con exito!"
	#define STR0008 "No puede enviarse e-mail."
	#define STR0009 "No existe e-mail registrado y/o servidor de e-mail."
	#define STR0010 "No existe historial salarial registrado"
#else
	#ifdef ENGLISH
		#define STR0001 "Error"
		#define STR0002 "Edit registration data "
		#define STR0003 "Name"
		#define STR0004 "CPF"
		#define STR0005 "Registration nbr."
		#define STR0006 "Message "
		#define STR0007 "Message sent successfully!   "
		#define STR0008 "E-mail cannot be sent. "
		#define STR0009 "No e-mail registered and/or e-mail server. "
		#define STR0010 "No salary history recorded    "
	#else
		#define STR0001 "Erro"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Alteração de dados registais", "Alteração de dados cadastrais" )
		#define STR0003 "Nome"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Cpf", "CPF" )
		#define STR0005 "Matrícula"
		#define STR0006 "Mensagem"
		#define STR0007 "Mensagem enviada com sucesso!"
		#define STR0008 "E-mail não pode ser enviado."
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Não existe e-mail registado e/ou servidor de e-mail.", "Não existe e-mail cadastrado e/ou servidor de e-mail." )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Não há historico salarial registrado", "Não há Histórico Salarial registrado" )
	#endif
#endif
