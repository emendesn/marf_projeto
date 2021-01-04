#ifdef SPANISH
	#define STR0001 "S=Si"
	#define STR0002 "N=No"
	#define STR0003 "Envio de informe"
	#define STR0004 "Informe abajo los parametros necesarios para envio de informe a traves del sistema"
	#define STR0005 "Configuracion del Servidor de E-mail"
	#define STR0006 "Nombre del servidor de envio de e-mail (SMTP) utilizado en el envio de informe(s):"
	#define STR0007 "Cuenta por utilizarse para autenticacion SMTP:"
	#define STR0008 "Contrasena de la cuenta de e-mail para autenticacion SMTP:"
	#define STR0009 "�Servidor de e-mail necesita autenticacion?"
	#define STR0010 "Time-out en segundos para envio de e-mail (estandar 120):"
	#define STR0011 "E-mail utilizado en el campo FROM(remitente) en el envio de informe(s):"
	#define STR0012 "Cuenta de e-mail oculta utilizada para fines de auditoria:"
	#define STR0013 "Configuraciones de e-mail y proxy"
	#define STR0014 "Las informaciones abajo se grabaran en el archivo de configuracion (.INI) del servidor"
	#define STR0015 "Protocolo de recepcion de e-mails:"
	#define STR0016 "�Utiliza SMTP Extended?"
	#define STR0017 "Configuraciones proxy"
	#define STR0018 "Las informaciones abajo se utilizaran en la configuracion del proxy"
	#define STR0019 "Utilizar servidor de Proxy"
	#define STR0020 "Servidor de Proxy:"
	#define STR0021 "Puerto del servidor de Proxy:"
	#define STR0022 "Usuario:"
	#define STR0023 "Contrasena:"
	#define STR0024 "�Informe la contrasena utilizada en la autenticacion del proxy!"
	#define STR0025 "Atencion"
	#define STR0026 "�Informe el serv. de proxy!"
	#define STR0027 "�Informe la puerta utilizada por el servidor de proxy!"
	#define STR0028 "A=Automatico"
#else
	#ifdef ENGLISH
		#define STR0001 "S=Yes"
		#define STR0002 "N=No"
		#define STR0003 "Report sending"
		#define STR0004 "Below, enter the parameters which are necessary to send the report through the system"
		#define STR0005 "E-mail Server Configuration"
		#define STR0006 "E-mail sending server name (SMTP) used to send the report(s):"
		#define STR0007 "Account used for SMTP authentication:"
		#define STR0008 "E-mail password for SMTP authentication:"
		#define STR0009 "E-mail server needs authentication"
		#define STR0010 "Time-out in seconds for e-mail sending (standard 120):"
		#define STR0011 "E-mail used on field FROM(sender) during report sending:"
		#define STR0012 "Hidden e-mail account for auditing use:"
		#define STR0013 "Proxy e-mail configuration"
		#define STR0014 "The information below are saved in the server configuration file (.INI)"
		#define STR0015 "E-mails receiving protocol:"
		#define STR0016 "Use extended SMTP"
		#define STR0017 "Proxy configurations"
		#define STR0018 "The information below are used during the proxy configuration"
		#define STR0019 "Use Proxy server"
		#define STR0020 "Proxy Server:"
		#define STR0021 "Proxy server drawer:"
		#define STR0022 "User:"
		#define STR0023 "Password:"
		#define STR0024 "Enter the password used at the proxy authentication"
		#define STR0025 "Warning"
		#define STR0026 "Inform the proxy server!"
		#define STR0027 "Inform the door used by the proxy server!"
		#define STR0028 "A=Automatic "
	#else
		Static STR0001 := "S=Sim"
		Static STR0002 := "N=N�o"
		#define STR0003  "Envio de relat�rio"
		Static STR0004 := "Informe abaixo os parametros necess�rios para o envio de relat�rio atrav�s do sistema"
		Static STR0005 := "Configura��o do Servidor de E-mail"
		Static STR0006 := "Nome do servidor de envio de e-mail (SMTP) utilizado no envio de relat�rio(s):"
		Static STR0007 := "Conta a ser utilizada para autentica��o SMTP:"
		Static STR0008 := "Senha da conta de e-mail para autentica��o SMTP:"
		#define STR0009  "Servidor de e-mail necessita de autentica��o?"
		Static STR0010 := "Time-out em segundos para o envio de e-mail (padr�o 120):"
		Static STR0011 := "E-mail utilizado no campo FROM(remetente) no envio de relat�rio(s):"
		#define STR0012  "Conta de e-mail oculta utilizada para fins de auditoria:"
		#define STR0013  "Configura��es de e-mail e proxy"
		Static STR0014 := "As informa��es abaixo ser�o gravadas no arquivo de configura��o (.INI) do servidor"
		#define STR0015  "Protocolo de recebimento de e-mails:"
		Static STR0016 := "Utiliza SMTP Extended?"
		#define STR0017  "Configura��es proxy"
		#define STR0018  "As informa��es abaixo ser�o utilizadas na configura��o do proxy"
		Static STR0019 := "Utilizar servidor de Proxy"
		Static STR0020 := "Servidor de Proxy:"
		Static STR0021 := "Porta do servidor de Proxy:"
		Static STR0022 := "Usu�rio:"
		Static STR0023 := "Senha:"
		Static STR0024 := "Informe a senha utilizada na autentica��o do proxy!"
		#define STR0025  "Aten��o"
		Static STR0026 := "Informe o servidor de proxy!"
		Static STR0027 := "Informe a porta utilizada pelo servidor de proxy!"
		Static STR0028 := "A=Autom�tico"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "S=sim"
			STR0002 := "N=n�o"
			STR0004 := "Introduza abaixo os par�metros necess�rios para o envio de relat�rio atrav�s do sistema"
			STR0005 := "Configura��o Do Servidor De E-mail"
			STR0006 := "Nome do servidor de envio de e-mail (smtp) utilizado no envio de relat�rio(s):"
			STR0007 := "Conta A Ser Utilizada Para Autentica��o Smtp:"
			STR0008 := "Palavra-passe Da Conta De E-mail Para Autentica��o Smtp:"
			STR0010 := "Tempo-limite em segundos para o envio de e-mail (padr�o 120):"
			STR0011 := "E-mail utilizado no campo from(remetente) no envio de relat�rio(s):"
			STR0014 := "As informa��es abaixo ser�o gravadas no ficheiro de configura��o (.ini) do servidor"
			STR0016 := "Utiliza Smtp Expandido?"
			STR0019 := "Utilizar Servidor De Proxy"
			STR0020 := "Servidor De Proxy:"
			STR0021 := "Porta Do Servidor De Proxy:"
			STR0022 := "Utilizador:"
			STR0023 := "Palavra-passe:"
			STR0024 := "Introduza a palavra-passe utilizada na autentica��o do proxy!"
			STR0026 := "Introduza o servidor de proxy!"
			STR0027 := "Introduza a porta utilizada pelo servidor de proxy!"
			STR0028 := "A=autom�tico"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
