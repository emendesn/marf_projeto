#ifdef SPANISH
	#define STR0001 "ATENCION: El borrado de las configuraciones del Servicio de Windows "
	#define STR0002 "debe realizarse solo despues de haber desinstalado el Server Protheus "
	#define STR0003 "de la lista de Servicios de Windows."
	#define STR0004 "La Seccion ["
	#define STR0005 "] se borro con exito."
	#define STR0006 "ATENCION: Las configuraciones actualizadas solamente seran validas despues de reiniciar el Servidor Protheus."
	#define STR0007 "Configuracion Actual: "
	#define STR0008 "Nombre Interno del Servicio ....... ["
	#define STR0009 "Nombre en la Lista de Servicios ..... ["
	#define STR0010 "Las modificaciones de estas configuraciones solo tendran efecto si el Servidor "
	#define STR0011 "Protheus no esta instalado en el Windows como un Servicio. Si el Protheus "
	#define STR0012 "ya esta instalado como un Servicio del Widows, debe ser desinstalado de la "
	#define STR0013 "lista de servicios del Windows antes de modificar estas configuraciones y reinstalado "
	#define STR0014 "como un servico despues de las modificaciones. �Desea modificar estas configuraciones? "
	#define STR0015 "La especificacion de estas configuraciones solo tendra efecto si el Servidor "
	#define STR0016 "Configuraciones de la Seccion"
	#define STR0017 "Asistente de Configuracion del Servicio del Windows NT/2000"
	#define STR0018 "Nombre Interno del Servicio"
	#define STR0019 "Nombre en la Lista de Servicios de Windows"
	#define STR0020 "�Confirma la grabacion de las Configuraciones del Servicio del Windows NT/2000? "
	#define STR0021 "Configuraciones del Servicio actualizadas con exito."
	#define STR0022 "Debe informarse el nombre Interno del Servicio."
	#define STR0023 "Debe informarse el nombre para visualizar el Servicio."
#else
	#ifdef ENGLISH
		#define STR0001 "WARNING : Windows Service configurations deletion should     "
		#define STR0002 "be accomplished only after the Protheus Server is    "
		#define STR0003 "disabled from the Windows Service list.      "
		#define STR0004 "Section ["
		#define STR0005 "] was deleted successfully."
		#define STR0006 "WARNING : The uodated configurations will only be valid after re-starting the Protheus Server.            "
		#define STR0007 "Current Configuration:"
		#define STR0008 "Internal Service Name ......... ["
		#define STR0009 "Name on the Services List ..... ["
		#define STR0010 "The changes on this configuration will only occur when the Protheus    "
		#define STR0011 "Server is not installed in Windows as a Service. If Protheus is already   "
		#define STR0012 "installed as a Service in Windows, it should be disabled from the           "
		#define STR0013 "Windows service list before the changing of these configurations and reinstalled as a     "
		#define STR0014 "service after changes. Do tou want to change the configurations?         "
		#define STR0015 "These configuration specifications will only occur when the Server      "
		#define STR0016 "Section Configuration "
		#define STR0017 "Windows NT/2000 Service Configuration Assistant         "
		#define STR0018 "Internal Service Name  "
		#define STR0019 "Name on the Windows Services Liat   "
		#define STR0020 "Confirm saving of  Windows NT/2000 Service Configurations ?           "
		#define STR0021 "Service Configuration updated successfully.      "
		#define STR0022 "Service Internal Name should be informed.    "
		#define STR0023 "The name to view the Service must be informed.         "
	#else
		Static STR0001 := "ATEN��O : A exclus�o das configura��es do Servi�o do Windows "
		#define STR0002  "deve ser realizada apenas ap�s o Server Protheus ser "
		Static STR0003 := "desinslatado da lista de Servi�os do Windows."
		Static STR0004 := "A Se��o ["
		Static STR0005 := "] foi deletada com sucesso."
		Static STR0006 := "ATEN��O : As configura��es atualizadas somente ser�o v�lidas ap�s a re-inicializa��o do Servidor Protheus."
		Static STR0007 := "Configura��o Atual : "
		Static STR0008 := "Nome Interno do Servi�o ....... ["
		Static STR0009 := "Nome na Lista de Servi�os ..... ["
		Static STR0010 := "As altera��es destas configura��es apenas ter�o efeito caso o Servidor "
		Static STR0011 := "Protheus n�o esteja instalado no Windows como um Servi�o. Caso o Protheus "
		Static STR0012 := "j� esteja instalado como um Servi�o do Widows, ele deve ser desinstalado da "
		Static STR0013 := "lista de servi�os do Windows antes de serem alteradas estas configura��es , e reinstalado "
		Static STR0014 := "como um servi�o ap�s as altera��es. Deseja alterar estas configura��es ? "
		Static STR0015 := "A especifica��o destas configura��es apenas ter� efeito caso o Servidor "
		Static STR0016 := "Configura��es da Se��o"
		Static STR0017 := "Assistente de Configura��o do Servi�o do Windows NT/2000"
		Static STR0018 := "Nome Interno do Servi�o"
		Static STR0019 := "Nome na Lista de Servi�os do Windows"
		Static STR0020 := "Confirma a grava��o das Configura��es do Servi�o do Windows NT/2000 ? "
		Static STR0021 := "Configura��es do Servi�o atualizadas com sucesso."
		Static STR0022 := "O Nome Interno do Servi�o deve ser informado."
		Static STR0023 := "O nome para visualiza��o do Servi�o deve ser informado."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Aten��o : a exclus�o das configura��es do servi�o do windows "
			STR0003 := "Desinslatado Da Lista De Servi�os Do Windows."
			STR0004 := "A sec��o ["
			STR0005 := "] foi eliminada com sucesso."
			STR0006 := "Aten��o : As Configura��es Actualizadas Ser�o V�lidas Somente Ap�s A Re-inicializa��o Do Servidor Protheus."
			STR0007 := "Configura��o actual : "
			STR0008 := "Nome interno do servi�o ....... ["
			STR0009 := "Nome na lista de servi�os ..... ["
			STR0010 := "As altera��es destas configura��es apenas ter�o efeito caso o servidor "
			STR0011 := "Protheus n�o esteja instalado no windows como um servi�o. caso o protheus "
			STR0012 := "J� esteja instalado como um servi�o do widows, ele deve ser desinstalado da "
			STR0013 := "Lista de servi�os do windows antes de serem alteradas estas configura��es , e reinstalado "
			STR0014 := "Como um servi�o ap�s as altera��es. deseja alterar estas configura��es ? "
			STR0015 := "A especifica��o destas configura��es apenas ter� efeito caso o servidor "
			STR0016 := "Configura��es Da Sec��o"
			STR0017 := "Assistente De Configura��o Do Servi�o Do Windows Nt/2000"
			STR0018 := "Nome Interno Do Servi�o"
			STR0019 := "Nome Na Lista De Servi�os Do Windows"
			STR0020 := "Confirma a grava��o das configura��es do servi�o do windows nt/2000 ? "
			STR0021 := "Configura��es do servi�o actualizadas com sucesso."
			STR0022 := "O nome interno do servi�o deve ser introduzido."
			STR0023 := "O nome para visualiza��o do servi�o deve ser introduzido."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
