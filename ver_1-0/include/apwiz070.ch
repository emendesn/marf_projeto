#ifdef SPANISH
	#define STR0002 "(ninguno)"
	#define STR0003 "No es posible borrar la seccion HTTP."
	#define STR0004 "Existen Modulos WEB y HOSTS configurados que dependen de esta configuracion."
	#define STR0005 "ATENCION: Si borra la seccion FTP deshabilitara el servicio de FTP del Servidor Protheus."
	#define STR0006 "�Confirma el borrado de la Configuracion ["
	#define STR0007 "] del Archivo de Configuraciones? "
	#define STR0008 "La Seccion ["
	#define STR0009 "] se borro con exito."
	#define STR0010 "ATENCION: Las configuraciones actualizadas solamente sean validas despues de reinicializar el Servidor Protheus."
	#define STR0011 "Configuraciones da Seccion"
	#define STR0012 "Asistente de Configuracion "
	#define STR0013 "Protocolo Habilitado"
	#define STR0014 "Path de Archivos"
	#define STR0015 "Puerta de Conexion"
	#define STR0016 "Entorno"
	#define STR0017 "Proceso de Respuesta"
	#define STR0018 "Instancias del Protocolo (minimo)"
	#define STR0019 "Instancias del Protocolo (maximo)"
	#define STR0021 "Path para Carga de Archivos"
	#define STR0022 "Time-Out de Sessions WEBEX (en segundos)"
	#define STR0023 "Nombre de la Instancia"
	#define STR0024 "Asistente de Configuracion FTP"
	#define STR0025 "Servidor FTP Habilitado"
	#define STR0026 "Habilitar usuario [anonymous]"
	#define STR0027 "Puerto del Listener FTP"
	#define STR0028 "�Confirma la grabacion de las Configuraciones? "
	#define STR0029 "Configuraciones actualizadas con exito."
	#define STR0030 "Debe especificarse el puerto del Servidor."
	#define STR0031 "El puerto del Servidor no puede ser negativo."
	#define STR0032 "Debe especificarse el Path de Archivos."
	#define STR0033 "No se encontro el Path especificado."
	#define STR0034 "ATENCION: �Desea realmente marcar el tiempo de Time-Out "
	#define STR0035 "de Sessions en entornos APW de este servidor como menos "
	#define STR0036 "de 60 segundos? "
	#define STR0037 "Debe especificarse el puerto del Servidor FTP."
	#define STR0038 "El puerto del Servidor FTP no puede ser negativo."
	#define STR0039 "�Confirma la grabacion de las Configuraciones FTP? "
	#define STR0040 "Configuraciones FTP actualizadas con exito."
	#define STR0041 "El Path de CARGA de imagenes debe iniciar con [\] "
	#define STR0042 "(una barra invertida) y se considera a partir "
	#define STR0043 "del directorio raiz del entorno o proceso de respuesta elegido."
	#define STR0044 "No es posible especificar un path para carga de archivos "
	#define STR0045 "sin un entorno o proceso de respuesta configurado. "
	#define STR0046 "Seleccione primero un entorno o proceso de resposta."
	#define STR0047 "ATENCION: La seccion DEFAULT del Protocolo esta siendo utilizada "
	#define STR0048 "por la Instancia ["
	#define STR0049 "] de um Modulo WEB, "
	#define STR0050 "de modo que no se permitira modificar las configuraciones "
	#define STR0051 "de Path, Entorno y Proceso de Respuesta en esta seccion. "
	#define STR0052 "Para modificar estas definiciones, utilice el "
	#define STR0053 "Asistente de Edicion de configuracion de Modulos WEB "
	#define STR0054 "para crear un host o carpeta virtual especificos "
	#define STR0055 "para ejecutar el Modulo WEB configurado en esta instancia."
	#define STR0056 "�ATENCION! Deshabilitar este protocolo "
	#define STR0057 "podra interferir directamente en el funcionamiento "
	#define STR0058 "de los modulos WEB Instalados en este servidor."
	#define STR0062 "ATENCION: Para que el protocolo HTTPS entre en operacion, "
	#define STR0063 "es necesario configurar el Certificado de Seguridad, "
	#define STR0064 "en la seccion [SSLCONFIGURE]. Sin el Certificado de Seguridad, "
	#define STR0065 "el protocolo HTTPS no entrara en funcionamiento en este Servidor."
	#define STR0066 'El camino especificado debe iniciar con la barra [/].'
#else
	#ifdef ENGLISH
		#define STR0002 "(none)"
		#define STR0003 "Unable to delete the HTTP section."
		#define STR0004 "There are WEB and HOSTS modules configured that depend on this setup."
		#define STR0005 "WARNING : Deleting the FTP section will disable Protheus Server FTP service."
		#define STR0006 "Do you confirm the Setup deletion ["
		#define STR0007 "] related to the Setup File ? "
		#define STR0008 "Section ["
		#define STR0009 "] was deleted successfully."
		#define STR0010 "WARNING : The uodated configurations will only be valid after re-starting the Protheus Server.            "
		#define STR0011 "Section Configuration "
		#define STR0012 "Configuration Assistant    "
		#define STR0013 "Enabled Protocol    "
		#define STR0014 "Files Path      "
		#define STR0015 "Connection Drawer"
		#define STR0016 "Environment"
		#define STR0017 "Answer Process      "
		#define STR0018 "Protocol Areas (minimum)        "
		#define STR0019 "Protocol Areas (maximum)        "
		#define STR0021 "Path for File Upload        "
		#define STR0022 "WEBEX Sessions Timeout (in seconds)   "
		#define STR0023 "Area Name        "
		#define STR0024 "FTP Configuration assistant       "
		#define STR0025 "Enabled Servidor FTP "
		#define STR0026 "Enable user [anonymous]"
		#define STR0027 "Listener FTP Drawer"
		#define STR0028 "Confirm the Configurations saving?      "
		#define STR0029 "Configurations updated successfully.  "
		#define STR0030 "The server drawer must be specified.      "
		#define STR0031 "The Server drawer cannot be negative.     "
		#define STR0032 "The File Paths must be specified.        "
		#define STR0033 "The specified path was not found.      "
		#define STR0034 "WARNING : Do you really want to flag the Time-Out "
		#define STR0035 "Session time in APW environments in this server for less "
		#define STR0036 "than 60 seconds? "
		#define STR0037 "The FTP Server drawer must be detailed."
		#define STR0038 "The FTP Server drawer cannot be negative."
		#define STR0039 "Do you confirm the FTP Setup saving ? "
		#define STR0040 "FTP Configurations updatd successfully.   "
		#define STR0041 "The image UPLOAD Path must start uo by [\] "
		#define STR0042 "an inverted bar and will be considered from "
		#define STR0043 "the environment root directory or the chosen answer process."
		#define STR0044 "Unable to detail  a path for a file upload "
		#define STR0045 "with no environment or answer process configured. "
		#define STR0046 "First, select an environment or an answer process."
		#define STR0047 "WARNING : The DEFAULT [HTTP] section is being used "
		#define STR0048 "by the Area ["
		#define STR0049 "] of a WEB module, "
		#define STR0050 "in order not to allow the Path, Environment and Answer Process "
		#define STR0051 "setups changings in this section. "
		#define STR0052 "To edit these definitions, use the        "
		#define STR0053 "WEB Module configuration Editin Assistant           "
		#define STR0054 "to set up a host or a specific virtual folder   "
		#define STR0055 "to run the WEB Module, configured in this area.           "
		#define STR0056 "WARNING !! Disable this protocol      "
		#define STR0057 "it may interfere directly on the functioning   "
		#define STR0058 "of the WEM Modules Installed on server.  "
		#define STR0062 "WARNING : For the operating of the HTTPS protocol, it is"
		#define STR0063 " necessary to configure the Security Certificate,   "
		#define STR0064 "section [SSLCONFIGURE]. With no Security Certificate,    "
		#define STR0065 "the HTTPS protocol will not operate in this Server.           "
		#define STR0066 'The defined path must be started by a slash [ / ].'
	#else
		#define STR0002  "(nenhum)"
		Static STR0003 := "N�o � poss�vel deletar a se��o HTTP."
		Static STR0004 := "Existem M�dulos WEB e HOSTS configurados que dependem desta configura��o."
		Static STR0005 := "ATEN��O : Deletar a se��o FTP ir� desabilitar o servi�o de FTP do Servidor Protheus."
		Static STR0006 := "Confirma a dele��o da Configura��o ["
		Static STR0007 := "] do Arquivo de Configura��es ? "
		Static STR0008 := "A Se��o ["
		Static STR0009 := "] foi deletada com sucesso."
		Static STR0010 := "ATEN��O : As configura��es atualizadas somente ser�o v�lidas ap�s a re-inicializa��o do Servidor Protheus."
		Static STR0011 := "Configura��es da Se��o"
		Static STR0012 := "Assistente de Configura��o "
		Static STR0013 := "Protocolo Habilitado"
		Static STR0014 := "Path de Arquivos"
		Static STR0015 := "Porta de Conex�o"
		#define STR0016  "Ambiente"
		Static STR0017 := "Processo de Resposta"
		#define STR0018  "Inst�ncias do Protocolo (m�nimo)"
		#define STR0019  "Inst�ncias do Protocolo (m�ximo)"
		Static STR0021 := "Path para Upload de Arquivos"
		Static STR0022 := "Time-Out de Sessions WEBEX (em segundos)"
		Static STR0023 := "Nome da Inst�ncia"
		Static STR0024 := "Assistente de Configura��o FTP"
		Static STR0025 := "Servidor FTP Habilitado"
		Static STR0026 := "Habilitar usu�rio [anonymous]"
		Static STR0027 := "Porta do Listener FTP"
		Static STR0028 := "Confirma a grava��o das Configura��es ? "
		Static STR0029 := "Configura��es atualizadas com sucesso."
		Static STR0030 := "A porta do Servidor deve ser especicifada."
		Static STR0031 := "A porta do Servidor n�o pode ser negativa."
		Static STR0032 := "O Path de Arquivos deve ser especificado."
		Static STR0033 := "O Path especificado n�o foi encontrado."
		Static STR0034 := "ATEN��O : Deseja realmente setar o tempo de Time-Out "
		Static STR0035 := "de Sessions em ambientes APW deste servidor para menos "
		Static STR0036 := "de 60 segundos ? "
		Static STR0037 := "A porta do Servidor FTP deve ser especicifada."
		Static STR0038 := "A porta do Servidor FTP n�o pode ser negativa."
		Static STR0039 := "Confirma a grava��o das Configura��es FTP ? "
		Static STR0040 := "Configura��es FTP atualizadas com sucesso."
		Static STR0041 := "O Path de UPLOAD de imagens deve iniciar com [\] "
		Static STR0042 := "uma barra inversa, e ser� considerado a partir "
		Static STR0043 := "do diret�rio raiz do ambiente ou processo de resposta escolhido."
		Static STR0044 := "N�o � poss�vel especificar um path para upload de arquivos "
		Static STR0045 := "sem um ambiente ou processo de resposta configurado. "
		Static STR0046 := "Selecione primeiro um ambiente ou processo de resposta."
		Static STR0047 := "ATEN��O : A Se��o DEFAULT [HTTP] est� sendo utilizada "
		Static STR0048 := "pela Inst�ncia ["
		Static STR0049 := "] de um M�dulo WEB, "
		Static STR0050 := "de modo que n�o ser� permitido alterar as configura��es "
		Static STR0051 := "de Path, Ambiente e Processo de Resposta nesta se��o. "
		#define STR0052  "Para alterar estas defini��es , utilize o "
		Static STR0053 := "Assistente de Edi��o de configura��o de M�dulos WEB "
		Static STR0054 := "para criar um host ou pasta virtual espec�ficos "
		#define STR0055  "para a execu��o do M�dulo WEB configurado nesta inst�ncia."
		Static STR0056 := "ATEN��O !! Desabilitar este protocolo "
		Static STR0057 := "poder� interferir diretamente no funcionamento "
		Static STR0058 := "dos m�dulos WEB Instalados neste servidor."
		Static STR0062 := "ATEN��O : Para que o protocolo HTTPS entre em opera��o, "
		Static STR0063 := "� necess�rio configurar o Certificado de Seguran�a, "
		Static STR0064 := "na se��o [SSLCONFIGURE]. Sem o Certificado de seguran�a, "
		Static STR0065 := "o protocolo HTTPS n�o entrar� em funcionamento neste Servidor."
		#define STR0066  'O caminho especificado deve iniciar com a barra [/].'
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0003 := "N�o � Poss�vel Eliminar A Sec��o Http."
			STR0004 := "Existem m�dulos web e hosts configurados que dependem desta configura��o."
			STR0005 := "Aten��o : Eliminar A Sec��o Ftp Ir� Desinstalar O Servi�o De Ftp Do Servidor Protheus."
			STR0006 := "Confirma a elimina��o da configura��o ["
			STR0007 := "] do ficheiro de configura��es ? "
			STR0008 := "A sec��o ["
			STR0009 := "] foi eliminada com sucesso."
			STR0010 := "Aten��o : As Configura��es Actualizadas Ser�o V�lidas Somente Ap�s A Re-inicializa��o Do Servidor Protheus."
			STR0011 := "Configura��es Da Sec��o"
			STR0012 := "Assistente de configura��o "
			STR0013 := "Protocolo Instalado"
			STR0014 := "Caminho De Ficheiros"
			STR0015 := "Porta De Liga��o"
			STR0017 := "Processo De Resposta"
			STR0021 := "Caminho Para Upload De Ficheiros"
			STR0022 := "Limite de tempo de sess�es webex (em segundos)"
			STR0023 := "Nome Da Inst�ncia"
			STR0024 := "Assistente De Configura��o Ftp"
			STR0025 := "Servidor Ftp Instalado"
			STR0026 := "Instalar utilizador [an�nimo]"
			STR0027 := "Porta Do Receptor Ftp"
			STR0028 := "Confirma a grava��o das configura��es ? "
			STR0029 := "Configura��es actualizadas com sucesso."
			STR0030 := "A porta do servidor deve ser especicifada."
			STR0031 := "A porta do servidor n�o pode ser negativa."
			STR0032 := "O caminho de ficheiros deve ser especificado."
			STR0033 := "O caminho especificado n�o foi encontrado."
			STR0034 := "Aten��o : deseja realmente definir o limite de tempo "
			STR0035 := "De sess�es em ambientes apw deste servidor para menos "
			STR0036 := "De 60 segundos ? "
			STR0037 := "A porta do servidor ftp deve ser especicifada."
			STR0038 := "A porta do servidor ftp n�o pode ser negativa."
			STR0039 := "Confirma a grava��o das configura��es ftp ? "
			STR0040 := "Configura��es ftp actualizadas com sucesso."
			STR0041 := "O caminho de upload de imagens deve iniciar com [\] "
			STR0042 := "Uma barra inversa, e ser� considerado a partir "
			STR0043 := "Do direct�rio raiz do ambiente ou processo de resposta escolhido."
			STR0044 := "N�o � poss�vel especificar um caminho para upload de ficheiros "
			STR0045 := "Sem um ambiente ou processo de resposta configurado. "
			STR0046 := "Seleccione primeiro um ambiente ou processo de resposta."
			STR0047 := "Aten��o : a sec��o default [http] est� a ser utilizada "
			STR0048 := "Pela inst�ncia ["
			STR0049 := "] de um m�dulo web, "
			STR0050 := "De modo que n�o ser� permitido alterar as configura��es "
			STR0051 := "De caminho, ambiente e processo de resposta nesta sec��o. "
			STR0053 := "Assistente de edi��o de configura��o de m�dulos web "
			STR0054 := "Para criar um host ou pasta virtual espec�ficos "
			STR0056 := "Aten��o !! desinstalar este protocolo "
			STR0057 := "Poder� interferir directamente no funcionamento "
			STR0058 := "Dos m�dulos web instalados neste servidor."
			STR0062 := "Aten��o : para que o protocolo https entre em opera��o, "
			STR0063 := "� necess�rio configurar o certificado de seguran�a, "
			STR0064 := "Na sec��o [sslconfigure]. sem o certificado de seguran�a, "
			STR0065 := "O Protocolo Https N�o Entrar� Em Funcionamento Neste Servidor."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF