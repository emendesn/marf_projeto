#ifdef SPANISH
	#define STR0001 "Error"
	#define STR0002 "E-mail no regsitrado. "
	#define STR0003 "Contrasena acceso curriculo personal"
	#define STR0004 "Contrasena:"
	#define STR0005 "Recursos Humanos"
	#define STR0006 "CONTRASENA DE ACCESO: CURRICULO PERSONAL"
	#define STR0007 "Contrasena enviada con exito al e-mail registrado. "
	#define STR0008 "No fue posible enviar el e-mail:  "
	#define STR0009 "Interno"
	#define STR0010 "Mensaje "
	#define STR0011 "Servidor, Cuenta o Contrasena de e-mail sin configurar."
	#define STR0012 "Contactenos "
	#define STR0013 "De:"
	#define STR0014 "Asunto: "
	#define STR0015 "E-mail enviado con exito.  "
	#define STR0016 "Error:Retorno de WebService invalido"
	#define STR0017 "E-Mail:"
	#define STR0018 "Atencion"
	#define STR0019 "Campo QG_TPCURRI inexistente, por favor aplique el compatibilizador: <br> SIGARSP - 07-Actualizaciones en la tabla SQG - Curriculum (nuevo campo Tipo de curriculum)"
	#define STR0020 "Campo QG_QTDEFIL inexistente, por favor aplique el compatibilizador: <br> SIGARSP - 06- Generacion de las tablas RS0 y RS1 para configuracion de campos del Portal"
	#define STR0021 "Campo QG_TPCURRI inexistente, por favor aplique el compatibilizador: <br> SIGARSP - 09- Actualizaciones en la tabla SQG - Curriculum (nuevo campo Cargo pretendido)"
#else
	#ifdef ENGLISH
		#define STR0001 "Error"
		#define STR0002 "E-mail not registered."
		#define STR0003 "Access password for the curriculum"
		#define STR0004 "Pswrd:"
		#define STR0005 "Human Resources "
		#define STR0006 "ACCESS PASSWORD: CURRICULUM"
		#define STR0007 "Password sent successfully to the e-mail registered"
		#define STR0008 "Unable to send e-mail:            "
		#define STR0009 "Intern."
		#define STR0010 "Message "
		#define STR0011 "E-mail server, account or password not setup."
		#define STR0012 "Contact us  "
		#define STR0013 "Frm"
		#define STR0014 "Subject:"
		#define STR0015 "E-mail sent successfully.  "
		#define STR0016 "Error: invalid Webservice return"
		#define STR0017 "E-mail:"
		#define STR0018 "Attention"
		#define STR0019 "Inexistent QG_TPCURRI field, please apply the compatibilizer: <br>SIGARSP - 07-Updates on SQG table - Curriculum (new field Curriculum Type)"
		#define STR0020 "Inexistent QG_QTDEFIL field, please apply the compatibilizer: <br> SIGARSP - 06- Generation of tables RS0 and RS1 to configure Portal fields"
		#define STR0021 "Inexistent QG_CODFUN field, please apply the compatibility program: <br>SIGARSP - 09-Updates on SQG table - Curriculum (new field Desired Position)"
	#else
		#define STR0001 "Erro"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "E-mail n�o registado.", "E-mail n�o cadastrado." )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Senha De Acesso Ao Curr�culo Pessoal", "Senha de Acesso ao Curr�culo Pessoal" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Palavra-passe:", "Senha:" )
		#define STR0005 "Recursos Humanos"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Senha De Acesso: Curr�culo Pessoal", "SENHA DE ACESSO: CURR�CULO PESSOAL" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Senha enviada com sucesso para o e-mail registado.", "Senha enviada com sucesso para o e-mail cadastrado." )
		#define STR0008 "N�o foi poss�vel enviar o e-mail: "
		#define STR0009 "Interno"
		#define STR0010 "Mensagem"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Servidor, conta ou senha de e-mail n�o configurados.", "Servidor, Conta ou Senha de e-mail nao configurados." )
		#define STR0012 "Fale Conosco"
		#define STR0013 "De:"
		#define STR0014 "Assunto:"
		#define STR0015 "E-mail enviado com sucesso."
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Erro: retorno de webservice inv�lido", "Erro: Retorno de WebService invalido" )
		#define STR0017 "E-mail:"
		#define STR0018 "Aten��o"
		#define STR0019 "Campo QG_TPCURRI inexistente, favor aplicar o compatibilizador: <br> SIGARSP - 07-Atualizacoes na tabela SQG - Curriculo (novo campo Tipo de Curr�culo)"
		#define STR0020 "Campo QG_QTDEFIL inexistente, favor aplicar o compatibilizador: <br> SIGARSP - 06- Gera��o das tabelas RS0 e RS1 para configura��o de campos do Portal"
		#define STR0021 "Campo QG_CODFUN inexistente, favor aplicar o compatibilizador: <br> SIGARSP - 09- Atualizacoes na tabela SQG - Curriculo (novo campo Cargo Pretendido)"
	#endif
#endif
