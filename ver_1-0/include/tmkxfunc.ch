#ifdef SPANISH
	#define STR0001 "Eleccion del usuario"
	#define STR0002 "Usuario"
	#define STR0003 "Transfiriendo la Atencion"
	#define STR0004 "Espere..."
	#define STR0005 "�Desea grabar y transferir la atencion?"
	#define STR0006 "Atencion"
	#define STR0007 "Datos de la Cuenta de E-mail"
	#define STR0008 "Cuenta"
	#define STR0009 "Clave"
	#define STR0010 "Producto no encontrado"
	#define STR0011 "Accesorios - "
	#define STR0012 "Elija los itemes:"
	#define STR0013 "Producto"
	#define STR0014 "Almacen"
	#define STR0015 "Ctd."
	#define STR0016 "Obs"
	#define STR0017 "Autenticacion"
	#define STR0018 "Error de autenticacion"
	#define STR0019 "Verifique la cuenta y la contrasena para envio"
	#define STR0020 "Para utilizar el archivo de accesorios es necesario que el campo UD_PRODUTO este habilitado para uso. Por favor entre en contacto con el Administrador del Sistema."
	#define STR0021 "Copia de Atencion"
	#define STR0022 "COPIA DE ATENCION PARA TELEVENTAS"
	#define STR0023 "Informe los nuevos datos para la nueva Atencion."
	#define STR0024 "Atencion selecionada:"
	#define STR0025 "(Prospect)"
	#define STR0026 "(Cliente)"
	#define STR0027 "Fecha de la nueva Atencion:"
	#define STR0028 "Cliente/Prospect para la nueva atencion:"
	#define STR0029 "Seleccione el Operador para la nueva Atencion:"
	#define STR0030 "Fecha de entrega para todos los items de la nueva Atencion:"
	#define STR0031 "Mantener fecha de entrega de Atencion de origen"
	#define STR0032 "Confirmacion"
	#define STR0033 "Los datos informados fueron: "
	#define STR0034 "Fecha de Atencion: "
	#define STR0035 "Cod. del  Cliente/Prospect: "
	#define STR0036 "Espere mientras se genera la nueva Atencion....... "
	#define STR0037 "Administrador"
	#define STR0038 "PENDENCIAS DE AGENDA DE OPERADOR."
#else
	#ifdef ENGLISH
		#define STR0001 "Select User"
		#define STR0002 "User"
		#define STR0003 "Transfering Service"
		#define STR0004 "Please wait..."
		#define STR0005 "Do you wish to save it and transfer the service?"
		#define STR0006 "Attention"
		#define STR0007 "Email Account Info"
		#define STR0008 "Account"
		#define STR0009 "Password"
		#define STR0010 "Product not found"
		#define STR0011 "Acessories - "
		#define STR0012 "Select the items:"
		#define STR0013 "Product"
		#define STR0014 "Warehouse"
		#define STR0015 "Qtty."
		#define STR0016 "Notes"
		#define STR0017 "Authentication"
		#define STR0018 "Authentication Error"
		#define STR0019 "Check the account and password to be sent"
		#define STR0020 "To use the accesories file, the field UD_PRODUTO must be enabled for use. Please, contact the System Administrator. "
		#define STR0021 "Service Copy"
		#define STR0022 "SERVICE COPY FOR TELESALES"
		#define STR0023 "Entere the new information to the new Servivce."
		#define STR0024 "Service selected:       "
		#define STR0025 "(Prospect)"
		#define STR0026 "(Custom.)"
		#define STR0027 "Date of the new Service: "
		#define STR0028 "Customer/Prospect to the new service:     "
		#define STR0029 "Select the Operator to the new Service:      "
		#define STR0030 "Date to deliver all the items of the new Service:       "
		#define STR0031 "Keep the delivery date of the origin Service   "
		#define STR0032 "Confirmation"
		#define STR0033 "The data entered were:     "
		#define STR0034 "Service Date:        "
		#define STR0035 "Customer/Prospect Code:     "
		#define STR0036 "Wait while the new Service is generated...      "
		#define STR0037 "Administrator"
		#define STR0038 "PENDENCES IN THE OPERATOR SCHEDULE."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Escolha Do Utilizador", "Escolha do Usu�rio" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Usuario", "Usu�rio" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "A Transferir O Atendimento", "Transferindo o Atendimento" )
		#define STR0004 "Aguarde..."
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Deseja gravar e transferir o atendimento?", "Deseja gravar e transferir o atendimento ?" )
		#define STR0006 "Aten��o"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Dados Da Conta De Email", "Dados da Conta de Email" )
		#define STR0008 "Conta"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Palavra-passe", "Senha" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Artigo n�o encontrado", "Produto n�o encontrado" )
		#define STR0011 "Acess�rios - "
		#define STR0012 "Escolha os itens:"
		#define STR0013 "Produto"
		#define STR0014 "Armaz�m"
		#define STR0015 "Qtd."
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Obs.", "Obs" )
		#define STR0017 "Autentica��o"
		#define STR0018 "Erro de autentica��o"
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Verifique a conta e a palavra-passe para envio", "Verifique a conta e a senha para envio" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Para Utilizar O Registo De Acess�rios � Necess�rio Que O Campo Ud_artigo Esteja Preparado Para Utiliza��o. Favor Entrar Em Contacto Com O Administrador Do M�dulo.", "Para utilizar o cadastro de acess�rios � necess�rio que o campo UD_PRODUTO esteja habilitado para uso. Favor entrar em contato com o Administrador do Sistema." )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "C�pia De Atendimento", "C�pia de Atendimento" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "C�pia De Atendimento Para Televendas", "C�PIA DE ATENDIMENTO PARA TELEVENDAS" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Introduza Os Novos Dados Para O Novo Atendimento.", "Informe os novos dados para o novo Atendimento." )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Atendimento seleccionado:", "Atendimento selecionado:" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "(pesquisa)", "(Prospect)" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "(cliente)", "(Cliente)" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Data Do Novo Atendimento:", "Data do novo Atendimento:" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Cliente/pesquisa para o novo atendimento:", "Cliente/Prospect para o novo atendimento:" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Seleccione O Operador Para O Novo Atendimento:", "Selecione o Operador para o novo Atendimento:" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Data Da Entrega Para Todos Os Itens Do Novo Atendimento:", "Data da entrega para todos os itens do novo Atendimento:" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Manter data da entrega do atendimento de origem", "Manter data da entrega do Atendimento de origem" )
		#define STR0032 "Confirma��o"
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Os dados indicados foram: ", "Os dados informados foram: " )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Data do atendimento: ", "Data do Atendimento: " )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "C�digo do cliente/pesquisa: ", "Codigo do Cliente/Prospect: " )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "Aguarde enquanto o novo atendimento � gerado... ", "Aguarde enquanto o novo Atendimento � gerado... " )
		#define STR0037 "Administrador"
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "Pendentes Da Agenda Do Operador.", "PENDENCIAS DA AGENDA DO OPERADOR." )
	#endif
#endif