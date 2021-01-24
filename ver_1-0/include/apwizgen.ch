#ifdef SPANISH
	#define STR0001 "CTREE - Modo de Operacion"
	#define STR0003 "Consola del Server en modo ISAPI Habilitado"
	#define STR0004 "Grabacion del LOG de los Mensajes de la Consola"
	#define STR0005 "Nombre del Archivo de LOG de Mensajes de Consola"
	#define STR0006 "No es posible borrar esta configuracion."
	#define STR0007 "La sesion [GENERAL] no esta presente en el archivo de configuracion."
	#define STR0008 "Sesion [GENERAL] no configurada."
	#define STR0009 "Editar Configuracion"
	#define STR0010 "Borrar Configuracion"
	#define STR0011 "Sesion Protheus Search no configurada."
	#define STR0012 "Haga clic en editar configuraciones"
	#define STR0013 "ATENCION : "
	#define STR0014 "Antes de configurar el Protheus Search, deben ejecutarse los siguientes pasos:"
	#define STR0015 "1 - Verificar el entorno( environment ) del Protheus Search. Las claves"
	#define STR0016 " SourcePath, RootPath y StartPath deben apuntar para este servidor Protheus."
	#define STR0017 " Verifique la configuracion en la sesion Entornos de este Wizard. "
	#define STR0018 "2 - Configurar el License Client para este servidor."
	#define STR0019 "3 - Habilitar el servidor HTTP en la seccion Servidor Internet(HTTP/FTP)."
	#define STR0020 "4 - Configurar el Ctree Server en la sesion Servidor Ctree."	
	#define STR0021 "Si se hubieran realizado los pasos, haga clic en Editar Configuracion"
#else
	#ifdef ENGLISH
		#define STR0001 "CTREE - Operation Mode  "
		#define STR0003 "Server Console in ISAPI mode is Enabled   "
		#define STR0004 "Console Messages LOG Saving            "
		#define STR0005 "Console Messages LOG File Name                "
		#define STR0006 "It is not possible to delete this configuration."
		#define STR0007 "Section [GENERAL] is not in the configuration file.            "
		#define STR0008 "Section [GENERAL] not configured. "
		#define STR0009 "Edit Configuration "
		#define STR0010 "Delete Configuration"
		#define STR0011 "Protheus Search session not configured."
		#define STR0012 "Click on Edit configuration"
		#define STR0013 "ATTENTION:"
		#define STR0014 "Before configuring Protheus Search, follow these steps:"
		#define STR0015 "1 - Check environment of Protheus Search. Keys "
		#define STR0016 " SourcePath, RootPath and StartPath must point to the Protheus server."
		#define STR0017 " Check configuration in the Environment session of this Wizard."
		#define STR0018 "2 - Configureo License Client for this server."
		#define STR0019 "3 - Enable HTTP server in the Internet server (HTTP/FTP) section."
		#define STR0020 "4 - Configure Ctree Server in Ctree server session."
		#define STR0021 "If the steps have been checked, click on Edit Configuration"
	#else
		Static STR0001 := "CTREE - Modo de Opera��o"
		Static STR0003 := "Console do Server em modo ISAPI Habilitado"
		Static STR0004 := "Grava��o do LOG das Mensagens do Console"
		Static STR0005 := "Nome do Arquivo de LOG de Mensagens do Console"
		Static STR0006 := "N�o � poss�vel deletar esta configura��o."
		Static STR0007 := "A se��o [GENERAL] n�o est� presente no arquivo de configura��o."
		Static STR0008 := "Se��o [GENERAL] n�o configurada."
		#define STR0009  "Editar Configura��o"
		Static STR0010 := "Deletar Configura��o"
		Static STR0011 := "Se��o Protheus Search n�o configurada."
		Static STR0012 := "Clique em Editar Configura��es"
		Static STR0013 := "ATEN��O : "
		Static STR0014 := "Antes de configurar o Protheus Search,os seguintes passos devem ser executados:"
		Static STR0015 := "1 - Verificar o ambiente( environment ) do Protheus Search. As chaves"
		Static STR0016 := " SourcePath, RootPath e StartPath dever�o apontar para este servidor Protheus."
		Static STR0017 := " Verifique a configura��o na se��o Ambientes deste Wizard. "
		Static STR0018 := "2 - Configurar o License Client para este servidor."
		Static STR0019 := "3 - Habilitar o servidor HTTP na se��o Servidor Internet(HTTP/FTP)."
		Static STR0020 := "4 - Configurar o Ctree Server na se��o Servidor Ctree."	
		Static STR0021 := "Caso os passos tenham sido verificados, clique em Editar Configura��o"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Ctree - Modo De Opera��o"
			STR0003 := "Console Do Server No Modo Isapi Activado"
			STR0004 := "Grava��o Do Di�rio Das Mensagens Do Console"
			STR0005 := "Nome Do Ficheiro Do Di�rio De Mensagens Do Console"
			STR0006 := "N�o � poss�vel eliminar esta configura��o."
			STR0007 := "A sec��o [crial] n�o se encontra no ficheiro de configura��o."
			STR0008 := "Sec��o [geral] n�o configurada."
			STR0010 := "Eliminar Configura��o"
			STR0011 := "Sec��o do Protheus Search n�o configurada."
			STR0012 := "Clique em editar configuracoes"
			STR0013 := "Aten��o : "
			STR0014 := "Antes de configurar o Protheus Search, devem ser executados os seguintes passos:"
			STR0015 := "1 - verificar o ambiente( environment ) do  protheus search. e as chaves"
			STR0016 := " Sourcepath, Rootpath E Startpath Dever�o Localizar Este Servidor Protheus."
			STR0017 := " verifique a configura��o na sec��o de ambientes deste assistente. "
			STR0018 := "2 - configurar o License Client para este servidor."
			STR0019 := "3 - Activar O Servidor Http Na Sec��o Do Servidor Internet(http/ftp)."
			STR0020 := "4 - configurar o ctree server na sec��o  servidor ctree."	
			STR0021 := "Caso os passos tenham sido verificados, clique em editar configura��o"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
