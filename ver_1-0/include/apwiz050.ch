#ifdef SPANISH
	#define STR0001 "�ATENCION! Al borrar la ultima sesion del servidor para Balanceamiento de Carga "
	#define STR0002 "se eliminara la configuracion de Balanceamiento de Carga de este servidor."
	#define STR0003 "�Confirma el borrado de la Seccion ["
	#define STR0004 "] del Archivo de Configuraciones? "
	#define STR0005 "La Seccion ["
	#define STR0006 "] fue borrada con exito."
	#define STR0007 "ATENCION: Las configuraciones actualizadas solamente seran validas despues de reinicializar el Servidor Protheus."
	#define STR0008 "Configuraciones da Seccion"
	#define STR0009 "Asistente de Configuracion de Servidores para Balanceamiento de Carga"
	#define STR0010 "Nombre de la Seccion"
	#define STR0011 "Nombre o IP del Servidor (Server)"
	#define STR0012 "Puerto del Listener (Port)"
	#define STR0013 "Numero maximo de conexiones (Connections)"
	#define STR0014 "Setear este Servidor como MASTER"
	#define STR0015 "�Confirma la inclusion de este Servidor para Balanceamiento de Carga? "
	#define STR0016 "�Confirma la grabacion de este Servidor para Balanceamiento de Carga? "
	#define STR0017 "Configuraciones de la seccion  ["
	#define STR0018 "] para Balanceamiento de Carga actualizadas con exito."
	#define STR0019 "Debe especificarse el nombre de la Seccion para Balanceamiento de Carga."
	#define STR0020 "Este nombre de Seccion para Balanceamiento de Carga no es valido, pues se trata de una Configuracion de Entorno ya existente del Protheus Server."
	#define STR0021 "Este nombre de Seccion para Balanceamiento de Carga no es valido, pues se trata de una Configuracion de Job ya existente del Protheus Server."
	#define STR0022 "Este nombre de Seccion para Balanceamiento de Carga no es valido, pues se trata de una Seccion desconocida actualmente ya existente en el Protheus Server."
	#define STR0023 "Este nombre de Seccion para Balanceamiento de Carga no es valido, pues se trata de una Configuracion de Host actualmente aya existente en el Protheus Server."
	#define STR0024 "Este nombre de Secion para Balanceamiento de Carga no es valido, pues se trata de una Configuracion de Driver de Conexion ya existente en el Protheus Server."
	#define STR0025 "Esta Seccion para Balanceamiento de Carga ya esta registrada en el Protheus Server."
	#define STR0026 "Este nombre de Seccion para Balanceamiento de Carga no es valido, pues se trata de una clave reservada de configuracion del Protheus Server."
	#define STR0027 "Debe especificarse el puerto del Listener TCP del Servidor."
	#define STR0028 "El puerto del Listener TCP del Servidor no puede ser negativo."
	#define STR0029 "Debe informarse el nombre o IP del Servidor."
	#define STR0030 "Dene especificarse el numero maximo de conexiones."
	#define STR0031 "El numero maximo de conexiones no puede ser negativo."
	#define STR0032 "ATENCION: Debe considerarse la configuracion "
	#define STR0033 "de Servidores para Balanceamiento de Carga "
	#define STR0034 "si este servidor esta apuntado como Servidor Master."
#else
	#ifdef ENGLISH
		#define STR0001 "WARNING! The server last section deletion for Load Balancing "
		#define STR0002 "will delete the Load Balancing setup in this server."
		#define STR0003 "Do you confirm the Setup File Section ["
		#define STR0004 "] deletion ? "
		#define STR0005 "Section ["
		#define STR0006 "] was deleted successfully."
		#define STR0007 "WARNING : The uodated configurations will only be valid after re-starting the Protheus Server.            "
		#define STR0008 "Section Setups"
		#define STR0009 "Server Setup Assistant for Load Balancing"
		#define STR0010 "Section Name "
		#define STR0011 "Server Name or IP (Server)     "
		#define STR0012 "Listener Drawer (Port)"
		#define STR0013 "Connection Maximum Number (Connections)"
		#define STR0014 "Flag this Server as MASTER"
		#define STR0015 "Do you confirm this Server for Load Balancing ? "
		#define STR0016 "Do you confirm this Server saving for Load Balancing? "
		#define STR0017 "Section setups  ["
		#define STR0018 "] for Load Balancing successfully updated."
		#define STR0019 "The Section name for Load Balancing must be detailed."
		#define STR0020 "This Section name for Load Balancing is not valid as it is an Environment Setup already existent related to Protheus Server."
		#define STR0021 "This section name for Load Balancing is not valid as it is a Joc Setup already existent related to Protheus Server."
		#define STR0022 "This Section name for Load Balancing is not valid as it is an unknown Section already existent in the Protheus Server."
		#define STR0023 "This section name for Load Balancing is not valid as it is a Host Setup already existent in Protheus Server."
		#define STR0024 "This section name for Load Balancing is not valid as it is a Connection Driver Setup already existent in Protheus Server."
		#define STR0025 "This section name for Load Balancing is already registered in the Protheus Server."
		#define STR0026 "This section name for Load Balancing is not valid as it is a Protheus Server setup reserved key."
		#define STR0027 "Server TCP Listener drawer should be specified.           "
		#define STR0028 "Server TCP Listener drawer cannot be negative.            "
		#define STR0029 "Server Name or IP should be informed.       "
		#define STR0030 "The maximum number of connections must be detailed."
		#define STR0031 "The maximum number of connections cannot be negative."
		#define STR0032 "WARNING: The Server setup for "
		#define STR0033 "Load Balancing will only be considered "
		#define STR0034 "if this server is flagged as Master Server."
	#else
		Static STR0001 := "ATEN��O ! A dele��o da ultima se��o de servidor para Balanceamento de Carga "
		Static STR0002 := "ir� eliminar a configura��o de Balanceamento de Carga deste servidor."
		Static STR0003 := "Confirma a dele��o da Se��o ["
		Static STR0004 := "] do Arquivo de Configura��es ? "
		Static STR0005 := "A Se��o ["
		Static STR0006 := "] foi deletada com sucesso."
		Static STR0007 := "ATEN��O : As configura��es atualizadas somente ser�o v�lidas ap�s a re-inicializa��o do Servidor Protheus."
		Static STR0008 := "Configura��es da Se��o"
		Static STR0009 := "Assistente de Configura��o de Servidores para Balanceamento de Carga"
		Static STR0010 := "Nome da Se��o"
		Static STR0011 := "Nome ou IP do Servidor (Server)"
		Static STR0012 := "Porta do Listener (Port)"
		Static STR0013 := "Numer� m�ximo de conex�es (Connections)"
		Static STR0014 := "Setar este Servidor como MASTER"
		Static STR0015 := "Confirma a inclus�o deste Servidor para Balanceamento de Carga ? "
		Static STR0016 := "Confirma a grava��o deste Servidor para Balanceamento de Carga ? "
		Static STR0017 := "Configura��es da se��o  ["
		Static STR0018 := "] para Balanceamento de Carga atualizadas com sucesso."
		Static STR0019 := "O nome da Se��o para Balanceamento de Carga deve ser especificado."
		Static STR0020 := "Este nome de Se��o para Balanceamento de Carga n�o � v�lido, pois trata-se de uma Configura��o de Ambiente j� existente do Protheus Server."
		Static STR0021 := "Este nome de Se��o para Balanceamento de Carga  n�o � v�lido, pois trata-se de uma Configura��o de Job j� existente do Protheus Server."
		Static STR0022 := "Este nome de Se��o para Balanceamento de Carga n�o � v�lido, pois trata-se de uma Se��o desconhecida atualmente j� existente no Protheus Server."
		Static STR0023 := "Este nome de Se��o para Balanceamento de Carga n�o � v�lido, pois trata-se de uma Configura��o de Host atualmente j� existente no Protheus Server."
		Static STR0024 := "Este nome de Se��o para Balanceamento de Carga n�o � v�lido, pois trata-se de uma Configura��o de Driver de Conex�o j� existente no Protheus Server."
		Static STR0025 := "Este Se��o para Balanceamento de Carga j� est� cadastrada no Protheus Server."
		Static STR0026 := "Este nome de Se��o para Balanceamento de Carga n�o � v�lido, pois trata-se de uma chave reservada de configura��o do Protheus Server."
		Static STR0027 := "A porta do Listener TCP do Servidor deve ser especicifada."
		Static STR0028 := "A porta do Listener TCP do Servidor n�o pode ser negativa."
		Static STR0029 := "O Nome ou IP do Servidor deve ser informado."
		Static STR0030 := "O N�mero m�ximo de conex�es deve ser especicifado."
		Static STR0031 := "O N�mero m�ximo de conex�es n�o pode ser negativo."
		Static STR0032 := "ATEN��O: A configura��o de Servidores para "
		Static STR0033 := "Balanceamento de Carga somente ser� considerada "
		Static STR0034 := "caso este servidor seja setado como Servidor Master."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Aten��o ! a elimina��o da �ltima sec��o de servidor para balanceamento de carga "
			STR0002 := "Ir� eliminar a configura��o de balanceamento de carga deste servidor."
			STR0003 := "Confirma a elimina��o da sec��o ["
			STR0004 := "] do ficheiro de configura��es ? "
			STR0005 := "A sec��o ["
			STR0006 := "] foi eliminada com sucesso."
			STR0007 := "Aten��o : As Configura��es Actualizadas Ser�o V�lidas Somente Ap�s A Re-inicializa��o Do Servidor Protheus."
			STR0008 := "Configura��es Da Sec��o"
			STR0009 := "Assistente De Configura��o De Servidores Para Balanceamento De Carga"
			STR0010 := "Nome Da Sec��o"
			STR0011 := "Nome ou ip do servidor (server)"
			STR0012 := "Porta do receptor (port)"
			STR0013 := "N�mero m�ximo de liga��es (connections)"
			STR0014 := "Definir Este Servidor Como Master"
			STR0015 := "Confirma a inclus�o deste servidor para balanceamento de carga ? "
			STR0016 := "Confirma a grava��o deste servidor para balanceamento de carga ? "
			STR0017 := "Configura��es da sec��o  ["
			STR0018 := "] para balanceamento de carga actualizadas com sucesso."
			STR0019 := "O nome da sec��o para balanceamento de carga deve ser especificado."
			STR0020 := "Este nome de Sec��o para Balanceamento de Carga n�o � v�lido, pois trata-se de uma Configura��o de Ambiente j� existente do Protheus Server."
			STR0021 := "Este nome de Sec��o para Balanceamento de Carga  n�o � v�lido, pois trata-se de uma Configura��o de Job j� existente do Protheus Server."
			STR0022 := "Este nome de Sec��o para Balanceamento de Carga n�o � v�lido, pois trata-se de uma Sec��o desconhecida actualmente j� existente no Protheus Server."
			STR0023 := "Este nome de Sec��o para Balanceamento de Carga n�o � v�lido, pois trata-se de uma Configura��o de Host actualmente j� existente no Protheus Server."
			STR0024 := "Este nome de Sec��o para Balanceamento de Carga n�o � v�lido, pois trata-se de uma Configura��o de Driver de Liga��o j� existente no Protheus Server."
			STR0025 := "Esta Sec��o para Balanceamento de Carga j� est� registada no Protheus Server."
			STR0026 := "Este nome de Sec��o para Balanceamento de Carga n�o � v�lido, pois trata-se de uma chave reservada de configura��o do Protheus Server."
			STR0027 := "A porta do receptor tcp do servidor deve ser especicifada."
			STR0028 := "A porta do receptor tcp do servidor n�o pode ser negativa."
			STR0029 := "O nome ou ip do servidor deve ser introduzido."
			STR0030 := "O n�mero m�ximo de liga��es deve ser especicifado."
			STR0031 := "O n�mero m�ximo de liga��es n�o pode ser negativo."
			STR0032 := "Aten��o: a configura��o de servidores para "
			STR0033 := "Balanceamento de carga somente ser� considerada "
			STR0034 := "Caso Este Servidor Seja Definido Como Servidor Master."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
