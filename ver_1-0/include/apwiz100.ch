#ifdef SPANISH
	#define STR0001 "ATENION: El borrar la configuracion CTREESERVER afectara "
	#define STR0002 "a todos los entornos que utilizan CTREE en este Servidor "
	#define STR0003 "Protheus. Todas las solicitudes a tablas y SX "
	#define STR0004 "configurados con CTEEE utilizacion CTREE en modo LOCAL."
	#define STR0005 "¿Confirma el borrado de la configuracion CTREESERVER? "
	#define STR0006 "CTREEMODE apuntado a LOCAL."
	#define STR0007 "La Seccion ["
	#define STR0008 "] se borro con exito."
	#define STR0009 "ATENCION: Las configuraciones actualizadas solamente seran validas despues de reiniciar el Servidor Protheus."
	#define STR0010 "ATENCION: Al habilitar la utilizacion del CTREE en modo SERVER, "
	#define STR0011 "todos los entornos de este Servidor Protheus que utilizan CTREE como Base de "
	#define STR0012 "Datos Principal y/o para administracion de las tablas locales utilizaran el "
	#define STR0013 "Servidor CTREE configurado en esta sesion. Tambien es necesario tener en el entorno "
	#define STR0014 "un Servidor CTREE instalado y configurado. ¿Desea habilitar esta configuracion? "
	#define STR0015 ')"Configuraciones de la Sesion"'
	#define STR0016 "Asistente de Configuracion del Servidor CTREE"
	#define STR0017 "Usuario del Servidor CTREE"
	#define STR0018 "Contrasena del Usuario"
	#define STR0019 "Nombre del Ctree Server (Default=FAIRCOMS)"
	#define STR0020 "Nombre o IP del Servidor CTREE"
	#define STR0021 "¿Confirma la grabacion de las Configuraciones CTREE Server? "
	#define STR0022 "CTREEMODE configurado para SERVER."
	#define STR0023 "Configuraciones del Servicio actualizadas con exito."
	#define STR0024 "Debe informarse el Nombre del Usuario."
	#define STR0025 "Debe informarse la contrasena del usuario."
	#define STR0026 "Debe informarse el nombre del CTREE Server."
	#define STR0027 "Debe informarse el Nombre o IP del Servidor CTREE."
	#define STR0028 '¿Confirma el borrado de la configuracion Protheus Search? '
	#define STR0029 'ATENCION : Al habilitar la utilizacion del PROTHEUS SEARCH,'
	#define STR0030 'Se configurara un entono exclusivo, con utilizacion de WEB SERVICES. '
	#define STR0031 '¿Desea habilitar esta configuracion?'
	#define STR0032 "Configuraciones de la sesion"
	#define STR0033 "Asistente de configuracion del Protheus Search"
	#define STR0034 "Nombre del entorno que se utilizara en el Protheus Search"
	#define STR0035 "Empresa/Sucursal para el Protheus Search. Ej: 01,01"
	#define STR0036 "Numero minimo de instancias(threads)"
	#define STR0037 "Numero maximo de instancias(threads)"
	#define STR0038 "Host para accionar el Protheus Search. Ej: localhost"
	#define STR0039 "Puerto del Protheus Search. Ej: 8080"
	#define STR0040 '¿Confirma la grabacion de las configuraciones del Protheus Search? '
	#define STR0041 'Debe informarse el nombre del entorno.'
	#define STR0042 'Debe informarse el valor minimo de threads.'
	#define STR0043 'Debe informarse el valor maximo de threads.'
	#define STR0044 'Debe informarse el valor del Host.'
	#define STR0045 'Debe informarse el valor del puerto.'
#else
	#ifdef ENGLISH
		#define STR0001 "WARNING : The deletion of the CTREESERVER configuration will "
		#define STR0002 "affect all environments using CTREE in this Server   "
		#define STR0003 "Protheus. All requisitions to the tables and SXS "
		#define STR0004 "configured with CTEEE using CTREE in Local mode.        "
		#define STR0005 "Confirm deletion of CTREESERVER configuration ?  "
		#define STR0006 "CTREEMODE Set up for LOCAL. "
		#define STR0007 "Section ["
		#define STR0008 "] was deleted successfully."
		#define STR0009 "WARNING : The uodated configurations will only be valid after re-starting the Protheus Server.            "
		#define STR0010 "WARNING : When enabling the usage of CTREE in SERVER mode,   "
		#define STR0011 "all environments of the Protheus Server that use CTREE as the Main Database "
		#define STR0012 "and/or for generating the local tables that will use the CTREE             "
		#define STR0013 "Server configured in this sectiom. It is also necessary to have in the environment "
		#define STR0014 "a CTREE Server configured and installed. Do you want to enable the configuration?"
		#define STR0015 ')"Section Configuration "'
		#define STR0016 "CTREE Server Configuration Assistant        "
		#define STR0017 "CTREE Server User        "
		#define STR0018 "User Password   "
		#define STR0019 "Server Ctree Name (Default=FAIRCOMS)   "
		#define STR0020 "CTREE Server Name or IP     "
		#define STR0021 "Confirm saving of CTREE Server Configurations ?      "
		#define STR0022 "CTREEMODE configured for SERVER.  "
		#define STR0023 "Service Configuration updated successfully.      "
		#define STR0024 "User's name should be informed. "
		#define STR0025 "The User's password must be informed. "
		#define STR0026 "CTREE Server Name should be informed.     "
		#define STR0027 "CTREE Server Name or IP should be informed.       "
		#define STR0028 'Confirm deletion of Protheus Search configuration? '
		#define STR0029 'ATTENTION: When enabling PROTHEUS SEARCH,'
		#define STR0030 'An exclusive environment will be configured with the use of WEB SERVICES. '
		#define STR0031 'Will you enable this configuration?'
		#define STR0032 "Session configuration"
		#define STR0033 "Protheus Search configuration wizard"
		#define STR0034 "Name of environment where Protheus Search will be used"
		#define STR0035 "Company/Branch for Protheus Search. E.g.: 01,01"
		#define STR0036 "Minimum number of instances (threads)"
		#define STR0037 "Maximum number of instances (threads)"
		#define STR0038 "Host for Protheus Search call. E.g.: localhost"
		#define STR0039 "Protheus Search port. E.g.: 8080"
		#define STR0040 'Confirm saving Protheus Search configuration?'
		#define STR0041 'Name of the environment must be entered.'
		#define STR0042 'Minimum value of threads must be entered.'
		#define STR0043 'Maximum value of threads must be entered.'
		#define STR0044 'Host value must be entered.'
		#define STR0045 'Value of the port must be entered.'
	#else
		Static STR0001 := "ATENÇÃO : A deleção da configuração CTREESERVER irá afetar "
		Static STR0002 := "todos os ambientes que utilizam CTREE neste Servidor "
		Static STR0003 := "Protheus. Todas as requisições à tabelas e SXS "
		Static STR0004 := "configurados com CTEEE utilização o CTREE em modo LOCAL."
		Static STR0005 := "Confirma a deleção da configuração CTREESERVER ? "
		Static STR0006 := "CTREEMODE Setado para LOCAL."
		Static STR0007 := "A Seção ["
		Static STR0008 := "] foi deletada com sucesso."
		Static STR0009 := "ATENÇÃO : As configurações atualizadas somente serão válidas após a re-inicialização do Servidor Protheus."
		Static STR0010 := "ATENÇÃO : Ao habilitar a utilização do CTREE em modo SERVER, "
		Static STR0011 := "todos os ambientes deste Servidor Protheus que utilizam CTREE como Banco de "
		Static STR0012 := "Dados Principal e/ou para gerenciamento das tabelas locais irão utilizar o "
		Static STR0013 := "Servidor CTREE configurado nesta seção. É necessário também ter no ambiente "
		Static STR0014 := "um Servidor CTREE instalado e configurado. Deseja habilitar esta configuração ? "
		Static STR0015 := ')"Configurações da Seção"'
		Static STR0016 := "Assistente de Configuração do Servidor CTREE"
		Static STR0017 := "Usuário do Servidor CTREE"
		Static STR0018 := "Senha do Usuário"
		Static STR0019 := "Nome do Ctree Server (Default=FAIRCOMS)"
		Static STR0020 := "Nome ou IP do Servidor CTREE"
		Static STR0021 := "Confirma a gravação das Configurações CTREE Server ? "
		#define STR0022  "CTREEMODE configurado para SERVER."
		Static STR0023 := "Configurações do Serviço atualizadas com sucesso."
		Static STR0024 := "O Nome do Usuário ser informado."
		Static STR0025 := "A Senha do usuário deve ser informada."
		Static STR0026 := "O Nome do CTREE Server deve ser informado."
		Static STR0027 := "O Nome ou IP do Servidor CTREE deve ser informado."
		Static STR0028 := 'Confirma a deleção da configuração Protheus Search ? '
		#define STR0029  'ATENÇÃO : Ao habilitar a utilização do PROTHEUS SEARCH,'
		Static STR0030 := 'Será configurado um ambiente exclusivo, com utilização de WEB SERVICES. '
		#define STR0031  'Deseja habilitar esta configuração ?'
		Static STR0032 := "Configurações da Seção"
		#define STR0033  "Assistente de Configuração do Protheus Search"
		Static STR0034 := "Nome Do Ambiente que será usado o Protheus Search"
		#define STR0035  "Empresa/Filial para o Protheus Search. Ex: 01,01"
		Static STR0036 := "Numero minimo de Instancias(threads)"
		Static STR0037 := "Numero maximo de Instancias(threads)"
		Static STR0038 := "Host para chamada do Protheus Search. Ex: localhost"
		#define STR0039  "Porta do Protheus Search. Ex: 8080"
		Static STR0040 := 'Confirma a gravação das Configurações do Protheus Search ? '
		#define STR0041  'O Nome do ambiente deve ser informado.'
		Static STR0042 := 'O valor de threads Minimo deve ser Informado.'
		Static STR0043 := 'O valor de threads Maximo deve ser Informado.'
		#define STR0044  'O valor do Host deve ser Informado.'
		#define STR0045  'O valor da Porta deve ser Informado.'
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Atenção : a eliminação da configuração ctreeserver irá afectar "
			STR0002 := "Todos os ambientes que utilizam ctree neste servidor "
			STR0003 := 'PRotheus. Todas as requisições à tabelas e SXS'
			STR0004 := "Configurados Com Cteee Utilização O Ctree Em Modo Local."
			STR0005 := "Confirma a eliminação da configuração ctreeserver ? "
			STR0006 := "Ctreemode Definido Para Local."
			STR0007 := "A secção ["
			STR0008 := "] foi eliminada com sucesso."
			STR0009 := "Atenção : As Configurações Actualizadas Serão Válidas Somente Após A Re-inicialização Do Servidor Protheus."
			STR0010 := "Atenção : Ao activar a utilização do CTREE em modo SERVER, "
			STR0011 := "Todos os ambientes deste servidor protheus que utilizam ctree como base de "
			STR0012 := "Dados principal e/ou para ção das tabelas locais irão utilizar o "
			STR0013 := "Servidor ctree configurado nesta secção. e necessário também ter no ambiente "
			STR0014 := "Um servidor ctree instalado e configurado. deseja instalar esta configuração ? "
			STR0015 := ')"configurações da secao"'
			STR0016 := "Assistente De Configuração Do Servidor Ctree"
			STR0017 := "Utilizador Do Servidor Ctree"
			STR0018 := "Pal.-Passe do utilizador"
			STR0019 := "Nome do Ctree Server (por defeito=FAIRCOMS)"
			STR0020 := "Nome Ou Ip Do Servidor Ctree"
			STR0021 := "Confirma a gravação das configurações do CTREE Server ? "
			STR0023 := "Configurações do serviço actualizadas com sucesso."
			STR0024 := "O nome do utilizador deve ser introduzido."
			STR0025 := "A palavra-passe do utilizador deve ser introduzida."
			STR0026 := "O nome do ctree server deve ser introduzido."
			STR0027 := "O nome ou ip do servidor ctree deve ser introduzido."
			STR0028 := 'Confirma a exclusão da configuração Protheus Search ?'
			STR0030 := 'Será configurado um ambiente exclusivo, com utilização de WEB SERVICES.'
			STR0032 := "Configurações Da Secção"
			STR0034 := "Nome Do Ambiente Que Será Utilizado No Protheus Search"
			STR0036 := "Número Mínimo De Instâncias(threads)"
			STR0037 := "Número Máximo De Instâncias(threads)"
			STR0038 := "Host para chamada do protheus search. ex: localhost"
			STR0040 := 'Confirma a gravação das Configurações do Protheus Search ?'
			STR0042 := 'O valor de threads Mínimo deve ser Informado.'
			STR0043 := 'O valor de threads Máximo deve ser Informado.'
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
