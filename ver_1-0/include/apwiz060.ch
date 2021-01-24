#ifdef SPANISH
	#define STR0001 "¿Confirma el borrado de la Configuracion ["
	#define STR0002 "] del Archivo de Configuraciones? "
	#define STR0003 "La Seccion ["
	#define STR0004 "] se borro con exito."
	#define STR0005 "ATENCION: Las configuraciones actualizadas solamente seran validas despues de reinicializar el Servidor Protheus."
	#define STR0006 "Configuraciones de la Seccion"
	#define STR0007 "Asistente de Configuracion del Servidor de Licencias"
	#define STR0008 "Nombre o IP del Servidor de Licencias"
	#define STR0009 "Puerto del Listener"
	#define STR0010 "Habilitar este Servidor para Servidor de Licencias"
	#define STR0011 "¿Confirma la grabacion de las Configuraciones del Servidor de Licencias? "
	#define STR0012 "Configuraciones del Servidor de Licencias actualizadas con exito."
	#define STR0013 "Debe informarse el nombre o IP del Servidor de Licencias."
	#define STR0014 "Debe especificarse el puerto del Listener TCP del Servidor de Licencias."
	#define STR0015 "El puerto del Listener TCP del Servidor de Licencias no puede ser negativo."
	#define STR0016 "Debe especificarse el puerto del Listener TCP del Servidor."
	#define STR0017 "El puerto del Listener TCP del Servidor no puede ser negativo."
	#define STR0018 "Mostrar mensajes de control"
#else
	#ifdef ENGLISH
		#define STR0001 "Do you confirm the Setup deletion ["
		#define STR0002 "] related to the Setup File ? "
		#define STR0003 "Section ["
		#define STR0004 "] was deleted successfully."
		#define STR0005 "WARNING : The uodated configurations will only be valid after re-starting the Protheus Server.            "
		#define STR0006 "Section Setups"
		#define STR0007 "Licence Server Setup Assistant"
		#define STR0008 "License Server Name or IP         "
		#define STR0009 "Listner Drawer   "
		#define STR0010 "Enable this Server for Licence Server"
		#define STR0011 "Do you confirm the Licence Server Setup saving ? "
		#define STR0012 "License Server Configurations updated successfully.           "
		#define STR0013 "License Server Name or IP should be informed.           "
		#define STR0014 "License Server TCP Listener drawer should be specified.                       "
		#define STR0015 "License Server TCP Listener drawer cannot be negative.                        "
		#define STR0016 "Server TCP Listener drawer should be specified.           "
		#define STR0017 "Server TCP Listener drawer cannot be negative.            "
		#define STR0018 'Display control messages'
	#else
		Static STR0001 := "Confirma a deleção da Configuração ["
		Static STR0002 := "] do Arquivo de Configurações ? "
		Static STR0003 := "A Seção ["
		Static STR0004 := "] foi deletada com sucesso."
		Static STR0005 := "ATENÇÃO : As configurações atualizadas somente serão válidas após a re-inicialização do Servidor Protheus."
		Static STR0006 := "Configurações da Seção"
		Static STR0007 := "Assistente de Configuração do Servidor de Licenças"
		Static STR0008 := "Nome ou IP do Servidor de Licenças"
		Static STR0009 := "Porta do Listener"
		Static STR0010 := "Habilitar este Servidor para Servidor de Licenças"
		Static STR0011 := "Confirma a gravação das Configurações do Servidor de Licenças ? "
		Static STR0012 := "Configurações do Servidor de Liecnças atualizadas com sucesso."
		Static STR0013 := "O Nome ou IP do Servidor de Licenças deve ser informado."
		Static STR0014 := "A porta do Listener TCP do Servidor de Licenças deve ser especicifada."
		Static STR0015 := "A porta do Listener TCP do Servidor de Licenças não pode ser negativa."
		Static STR0016 := "A porta do Listener TCP do Servidor deve ser especicifada."
		Static STR0017 := "A porta do Listener TCP do Servidor não pode ser negativa."
		#define STR0018  "Mostrar mensagens de controle"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Confirma a eliminação da configuração ["
			STR0002 := "] do ficheiro de configurações ? "
			STR0003 := "A secção ["
			STR0004 := "] foi eliminada com sucesso."
			STR0005 := "Atenção : As Configurações Actualizadas Serão Válidas Somente Após A Re-inicialização Do Servidor Protheus."
			STR0006 := "Configurações Da Secção"
			STR0007 := "Assistente De Configuração Do Servidor De Licenças"
			STR0008 := "Nome Ou Ip Do Servidor De Licenças"
			STR0009 := "Porta Do Receptor"
			STR0010 := "Instalar Este Servidor Para Servidor De Licenças"
			STR0011 := "Confirma a gravação das configurações do servidor de licenças ? "
			STR0012 := "Configurações do servidor de licenças actualizadas com sucesso."
			STR0013 := "O nome ou ip do servidor de licenças deve ser introduzido."
			STR0014 := "A porta do receptor tcp do servidor de licenças deve ser especicifada."
			STR0015 := "A porta do receptor tcp do servidor de licenças não pode ser negativa."
			STR0016 := "A porta do receptor tcp do servidor deve ser especicifada."
			STR0017 := "A porta do receptor tcp do servidor não pode ser negativa."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
