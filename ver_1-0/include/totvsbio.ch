#ifdef SPANISH
	#define STR0001 "No hay registro de las digitales para consistencia, �desea registrar las digitales ahora?"
	#define STR0002 "�Atencion!"
	#define STR0003 "No Existen Digitales Registradas"
	#define STR0004 "digital no confiere"
	#define STR0005 "�Conferencia OK!"
	#define STR0006 "Ok"
	#define STR0007 "Lectura de digital"
	#define STR0008 "Coloque la digital en el dispositivo"
	#define STR0009 "ERROR - DLL no encontrada"
	#define STR0010 "Borra todas las digitales del codigo "
	#define STR0011 "Borra"
	#define STR0012 "Desactiva dispositivo biometrico "
	#define STR0013 "Desactiva"
	#define STR0014 "Activa dispositivo biometrico "
	#define STR0015 "Activa"
	#define STR0016 "Registro de las digitales "
	#define STR0017 " - Dispositivo biometrico "
	#define STR0018 "Activado"
	#define STR0019 "desactivado"
	#define STR0020 "�Desea activar la verificacion biometrica?"
	#define STR0021 "�Desea desactivar la verificacion biometrica?"
	#define STR0022 "Autorizacion"
	#define STR0023 "Usuario"
	#define STR0024 "Sena"
	#define STR0025 "Digitales"
	#define STR0026 "Sena Invalida"
	#define STR0027 "Confirma la exclusion de todas las digitales del codigo "
	#define STR0028 "�Digital Invalida!"
	#define STR0029 "digital no confiere"
	#define STR0030 "�Conferencia OK!"
	#define STR0031 "Continua"
	#define STR0032 "La 1� y 2� lectura no confieren. Por favor, intente nuevamente."
	#define STR0033 "Falla al cargar DLL. Verifique actualizacion de DLL"
#else
	#ifdef ENGLISH
		#define STR0001 "There are no digitals registration for consistency. Do you want to register digitals now?"
		#define STR0002 "Attention"
		#define STR0003 "There are no digitals registered"
		#define STR0004 "Digitals"
		#define STR0005 "Conference OK!"
		#define STR0006 "OK"
		#define STR0007 "Digital reading"
		#define STR0008 "Place digital in the dispositive"
		#define STR0009 "ERROR - DLL not found"
		#define STR0010 "Erases all digitals of the code "
		#define STR0011 "Deletes"
		#define STR0012 "Disables biometric dispositive "
		#define STR0013 "Disable"
		#define STR0014 "Enables biometric dispositive "
		#define STR0015 "Enable"
		#define STR0016 "Digitals registration "
		#define STR0017 " - Biometric dispositive "
		#define STR0018 "Enabled"
		#define STR0019 "Disabled"
		#define STR0020 "Do you want to enable biometric conference?"
		#define STR0021 "Do you want to disable biometric conference?"
		#define STR0022 "Authorization"
		#define STR0023 "User"
		#define STR0024 "Password:"
		#define STR0025 "Digitals"
		#define STR0026 "Invalid password"
		#define STR0027 "Confirm exclusion of all code digitals "
		#define STR0028 "Invalid digital!"
		#define STR0029 "digital does not check"
		#define STR0030 "Conference OK"
		#define STR0031 "Continue"
		#define STR0032 "1st and 2nd reading do not match.Please, try again."
		#define STR0033 "Failure in loading DLL. Check DLL update"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "N�o h� registo das digitais para consist�ncia, deseja registar as digitais agora?", "N�o h� cadastro das digitais para consist�ncia, deseja cadastrar as digitais agora?" )
		#define STR0002 "Aten��o"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "N�o Existem Digitais Registadas", "N�o Existem Digitais Cadastradas" )
		#define STR0004 "Digital n�o confere"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Confer�ncia OK!", "Conferencia OK!" )
		#define STR0006 "Ok"
		#define STR0007 "Leitura de digital"
		#define STR0008 "Coloque a digital no dipositivo"
		#define STR0009 "ERRO - DLL n�o encontrada"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Apaga todas as digitais do c�digo ", "Apaga todas as digitais do codigo " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Apaga", "Deleta" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Desabilita dipositivo biom�trico ", "Desabilita dipositivo biometrico " )
		#define STR0013 "Desabilita"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Habilita dipositivo biom�trico ", "Habilita dipositivo biometrico " )
		#define STR0015 "Habilita"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Registo das digitais ", "Cadastro das digitais " )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", " - Dispositivo biom�trico ", " - Dispositivo biometrico " )
		#define STR0018 "habilitado"
		#define STR0019 "desabilitado"
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Deseja habilitar a confer�ncia biom�trica?", "Deseja habilitar a confer�ncia biometrica?" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Deseja desabilitar a confer�ncia biom�trica?", "Deseja desabilitar a confer�ncia biometrica?" )
		#define STR0022 "Autoriza��o"
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Utilizador", "Usuario" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Palavra-Passe:", "Senha:" )
		#define STR0025 "Digitais"
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Palavra-Passe Inv�lida", "Senha Inv�lida" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Confirma a elimina��o de todas as digitais do c�digo ", "Confirma a exclus�o de todas as digitais do codigo " )
		#define STR0028 "Digital Inv�lida!"
		#define STR0029 "digital n�o confere"
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "confer�ncia ok", "conferencia ok" )
		#define STR0031 "Continua"
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "A 1� e 2� leitura n�o conferem. Por favor, tente novamente.", "A 1� e 2� leitura n�o conferem.Por favor, tente novamente." )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Falha ao carregar DLL. Verifique actualiza��o da DLL", "Falha ao carregar DLL. Verifique atualiza��o da DLL" )
	#endif
#endif
