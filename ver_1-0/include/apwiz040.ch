#ifdef SPANISH
	#define STR0003 "] del Archivo de Configuraciones? "
	#define STR0006 "ATENCION: Las configuraciones actualizadas solamente seran validas despues de reinicializar el Servidor Protheus."
	#define STR0011 "Puerto del Listener (Port)"
	#define STR0025 "Debe especificarse el puerto del Listener TCP del Servidor."
	#define STR0026 "El puerto del Listener TCP del Servidor no puede ser negativo."
	#define STR0027 "�ATENCION! No es posible borrar las configuraciones del  "
	#define STR0028 "Certificado de Seguridad, pues el protocolo HTTPS "
	#define STR0029 "esta habilitado. Para borrar esta configurac�o, debe borrarse "
	#define STR0030 "la configuracion HTTPS."
	#define STR0031 "�ATENCION! Confirma el borrado de la Configuracion ["
	#define STR0032 "La configuracion ["
	#define STR0033 "] fue borrada con exito."
	#define STR0034 "No es posible borrar esta configuracion."
	#define STR0035 "Esta configuracion es obligatoria para el Protheus Server."
	#define STR0036 "Configuraciones de Conexion Remota"
	#define STR0037 "Asistente de Configuraciones de Conexion"
	#define STR0038 "Sesion de Conexion TCP"
	#define STR0039 "Habilitar Conexion Remota Segura"
	#define STR0040 "Sesion de Conexion SSL"
	#define STR0041 "Configuraciones del Certificado de Seguridad"
	#define STR0042 "Asistente de Configuraciones de Seguridad"
	#define STR0043 "Archivo Principal del Certificado de Seguridad"
	#define STR0044 "Archivo Clave del Certificado de Seguridad"
	#define STR0045 "Contrasena del Certificado de Seguridad"
	#define STR0046 "Los puertos de Conexion TCP y Conexion Segura no pueden ser iguales."
	#define STR0047 "ATENCION: Para habilitar la conexin segura es necesario "
	#define STR0048 "tambien configurar la sesion [SSLCONFIGURE] para "
	#define STR0049 "especificar los parametros adicionales de seguridad. "
	#define STR0050 "La Conexion Segura solamente estara disponible despues de que "
	#define STR0051 "esta configuracion este rellenada."
	#define STR0052 "�Confirma la grabacion de estas configuraciones? "
	#define STR0053 "Configuraciones de conexion actualizadas con exito."
	#define STR0054 "Configuraciones del Certificado de Seguridad actualizadas con exito."
	#define STR0055 "Esta configuracion es obligatoria."
	#define STR0056 "El Path del archivo para esta configuracion debe informarse completo, incluida la unidad de disco."
	#define STR0057 "No se permiten los siguientes caracteres en esta configuracion: "
	#define STR0058 "No se localizo el archivo especificado."
#else
	#ifdef ENGLISH
		#define STR0003 "] of Setup File ? "
		#define STR0006 "WARNING : The uodated configurations will only be valid after re-starting the Protheus Server.            "
		#define STR0011 "Listener Drawer (Port)"
		#define STR0025 "Server TCP Listener drawer should be specified.           "
		#define STR0026 "Server TCP Listener drawer cannot be negative.            "
		#define STR0027 "WARNING! Unable to delete the setups of "
		#define STR0028 "Safety Certificate, as the HTTPS protocol "
		#define STR0029 "is enabled. Requiring to delete this setup, the HTTPS setup "
		#define STR0030 "must be deleted."
		#define STR0031 "WARNING! Confirm the Setup deletion ["
		#define STR0032 "Configuration  ["
		#define STR0033 "] was deleted successfully."
		#define STR0034 "Unable to delete this setup."
		#define STR0035 "This is a mandatory setup for Protheus Server."
		#define STR0036 "Remote Connection Setups"
		#define STR0037 "Connection Setup Assistant"
		#define STR0038 "TCP Connection Section"
		#define STR0039 "Safe Remote Connection Enable"
		#define STR0040 "SSL Connection Section"
		#define STR0041 "Safety Certificate Setups"
		#define STR0042 "Safety Setup Assistant"
		#define STR0043 "Safety Certificate Main File"
		#define STR0044 "Safety Certificate Key File"
		#define STR0045 "Safety Certificate Password"
		#define STR0046 "Drawers for TCP Connection and Secure Connection cannot be the same."
		#define STR0047 "WARNING : requiring to enable a safe connection it is also necessary "
		#define STR0048 "to setup the section [SSLCONFIGURE] to "
		#define STR0049 "detail the additional safety parameters. "
		#define STR0050 "The Safe Connection will only be available after "
		#define STR0051 "this setup is filled out."
		#define STR0052 "Do you confirm the saving of these setups? "
		#define STR0053 "Connection configurations updated successfully.  "
		#define STR0054 "Security Certificate Configurations were updated successfully.    "
		#define STR0055 "This is a mandatory setup."
		#define STR0056 "The file Path for this setup must be fully informed, including the disk unit."
		#define STR0057 "Characters below this setup are not allowed : "
		#define STR0058 "The specified file has not been found."
	#else
		Static STR0003 := "] do Arquivo de Configura��es ? "
		Static STR0006 := "ATEN��O : As configura��es atualizadas somente ser�o v�lidas ap�s a re-inicializa��o do Servidor Protheus."
		Static STR0011 := "Porta do Listener (Port)"
		Static STR0025 := "A porta do Listener TCP do Servidor deve ser especicifada."
		Static STR0026 := "A porta do Listener TCP do Servidor n�o pode ser negativa."
		Static STR0027 := "ATEN��O ! N�o � poss�vel deletar as configura��es do "
		Static STR0028 := "Certificado de Seguran�a, pois o protocolo HTTPS "
		Static STR0029 := "est� habilitado. Para deletar esta configura��o, a configura��o "
		Static STR0030 := "HTTPS deve ser deletada."
		Static STR0031 := "ATEN��O ! Confirma a dele��o da Configura��o ["
		#define STR0032  "A configura��o ["
		Static STR0033 := "] foi deletada com sucesso."
		Static STR0034 := "N�o � poss�vel deletar esta configura��o."
		Static STR0035 := "Esta configura��o � obrigat�ria para o Protheus Server."
		Static STR0036 := "Configura��es de Conex�o Remota"
		Static STR0037 := "Assistente de Configura��es de Conex�o"
		Static STR0038 := "Se��o de Conex�o TCP"
		Static STR0039 := "Habilitar Conex�o Remota Segura"
		Static STR0040 := "Se��o de Conex�o SSL"
		Static STR0041 := "Configura��es do Certificado de Seguran�a"
		Static STR0042 := "Assistente de Configura��es de Seguran�a"
		Static STR0043 := "Arquivo Principal do Certificado de Seguran�a"
		Static STR0044 := "Arquivo Chave do Certificado de Seguran�a"
		Static STR0045 := "Senha do Certificado de Seguran�a"
		Static STR0046 := "As portas para Conex�o TCP e Conex�o Segura n�o podem ser iguais."
		Static STR0047 := "ATEN��O : Para habilitar a conex�o segura, � necess�rio "
		Static STR0048 := "tamb�m configurar a se��o [SSLCONFIGURE] para "
		Static STR0049 := "especificar os par�metros adicionais de seguran�a. "
		Static STR0050 := "A Conex�o Segura somente estar� dispon�vel ap�s "
		Static STR0051 := "esta configura��o estar preenchida."
		#define STR0052  "Confirma a grava��o destas configura��es ? "
		Static STR0053 := "Configura��es de conex�o atualizadas com sucesso."
		Static STR0054 := "Configura��es do Certificado de Seguran�a atualizadas com sucesso."
		#define STR0055  "Esta configura��o � obrigat�ria."
		Static STR0056 := "O Path do arquivo para esta configura��o deve ser informado completo, incluindo a unidade de disco."
		#define STR0057  "N�o s�o permitidos os caracteres abaixo nesta configura��o : "
		Static STR0058 := "O Arquivo especificado n�o foi localizado."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0003 := "] do ficheiro de configura��es ? "
			STR0006 := "Aten��o : As Configura��es Actualizadas Ser�o V�lidas Somente Ap�s A Re-inicializa��o Do Servidor Protheus."
			STR0011 := "Porta do receptor (port)"
			STR0025 := "A porta do receptor tcp do servidor deve ser especicifada."
			STR0026 := "A porta do receptor tcp do servidor n�o pode ser negativa."
			STR0027 := "Aten��o ! n�o � poss�vel eliminar as configura��es do "
			STR0028 := "Certificado de seguran�a, pois o protocolo https "
			STR0029 := "Est� instalado. para eliminar esta configura��o, a configura��o "
			STR0030 := "Https deve ser eliminada."
			STR0031 := "Aten��o ! confirma a elimina��o da configura��o ["
			STR0033 := "] foi eliminada com sucesso."
			STR0034 := "N�o � poss�vel eliminar esta configura��o."
			STR0035 := "Esta Configura��o � Obrigat�ria Para O Servidor Protheus."
			STR0036 := "Configura��es De Liga��o Remota"
			STR0037 := "Assistente De Configura��es De Liga��o"
			STR0038 := "Sec��o De Liga��o Tcp"
			STR0039 := "Instalar Liga��o Remota Segura"
			STR0040 := "Sec��o De Liga��o Ssl"
			STR0041 := "Configura��es Do Certificado De Seguran�a"
			STR0042 := "Assistente De Configura��es De Seguran�a"
			STR0043 := "Ficheiro Principal Do Certificado De Seguran�a"
			STR0044 := "Ficheiro Chave Do Certificado De Seguran�a"
			STR0045 := "Palavra-passe Do Certificado De Seguran�a"
			STR0046 := "As portas para liga��o tcp e liga��o segura n�o podem ser iguais."
			STR0047 := "Aten��o : para instalar a liga��o segura, � necess�rio "
			STR0048 := "Tamb�m configurar a sec��o [sslconfigure] para "
			STR0049 := 'eSpecificar os par�metros adicionais de seguran�a.'
			STR0050 := "A liga��o segura somente estar� dispon�vel ap�s "
			STR0051 := "Esta configura��o estar preenchida."
			STR0053 := "Configura��es de liga��o actualizadas com sucesso."
			STR0054 := "Configura��es do certificado de seguran�a actualizadas com sucesso."
			STR0056 := "O caminho do ficheiro para esta configura��o deve ser introduzido completamente, a incluir a unidade de disco."
			STR0058 := "O ficheiro especificado n�o foi localizado."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF