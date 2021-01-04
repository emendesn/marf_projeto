#ifdef SPANISH
	#define STR0003 "Puerto de Conexion (Port)"
	#define STR0006 "Conexion TCP no configurada."
	#define STR0007 "Conexion TCP ["
	#define STR0008 "] no encontrada en el Archivo de Configuraciones."
	#define STR0009 "Datos de la Conexion TCP ["
	#define STR0010 "Seccion del Driver (active)"
	#define STR0012 "Conexion Segura no configurada."
	#define STR0013 "Conexion Segura ["
	#define STR0014 "Datos de la Conexion Segura ["
	#define STR0015 "Seccion del Driver (secure)"
	#define STR0016 "Puerto de Conexion Seguro (port)"
	#define STR0017 "No es posible borar esta configuracion."
	#define STR0018 "Esta configuracion es obligatoria para el Protheus Server."
	#define STR0019 "DRIVERS DE CONEXION NO CONFIGURADOS"
	#define STR0020 "Configuraciones para Conexion Segura"
	#define STR0021 "Editar Configuracion"
	#define STR0022 "Borrar Configuracion"
	#define STR0023 "Archivo Principal del Certificado de Seguridad"
	#define STR0024 "Archivo Clave del Certificado de Seguridad"
	#define STR0025 "Contrasena del Certificado de Seguridad"
#else
	#ifdef ENGLISH
		#define STR0003 "Connection Drawer (Port)"
		#define STR0006 "TCP Connection not configured."
		#define STR0007 "TCP Connection ["
		#define STR0008 "] not found in the Configurations File.      "
		#define STR0009 "TCP Connection Data  ["
		#define STR0010 "Driver Section (active) "
		#define STR0012 "Safe Connection not configured."
		#define STR0013 "Safe Connection ["
		#define STR0014 "Safe Connection Data [   "
		#define STR0015 "Driver Section (secure) "
		#define STR0016 "Safe Connection Drawe (port)  "
		#define STR0017 "Not possible to delete the configuration."
		#define STR0018 "This configuration is mandatory for Protheus Server.   "
		#define STR0019 "CONNECTION DRIVERS NOT CONFIGURED  "
		#define STR0020 "Configurations for Safe Connection"
		#define STR0021 "Edit Configuration "
		#define STR0022 "Delete Configuration"
		#define STR0023 "Main File of the Security Certificate        "
		#define STR0024 "Key File of Security Certificate         "
		#define STR0025 "Security Certificate Password    "
	#else
		Static STR0003 := "Porta de Conex�o (Port)"
		Static STR0006 := "Conex�o TCP n�o configurada."
		Static STR0007 := "Conex�o TCP ["
		Static STR0008 := "] n�o encontrada no Arquivo de Configura��es."
		Static STR0009 := "Dados da Conex�o TCP ["
		Static STR0010 := "Se��o do Driver (active)"
		Static STR0012 := "Conex�o Segura n�o configurada."
		Static STR0013 := "Conex�o Segura ["
		Static STR0014 := "Dados da Conex�o Segura ["
		Static STR0015 := "Se��o do Driver (secure)"
		Static STR0016 := "Porta de Conex�o Segura (port)"
		Static STR0017 := "N�o � poss�vel deletar esta configura��o."
		Static STR0018 := "Esta configura��o � obrigat�ria para o Protheus Server."
		Static STR0019 := "DRIVERS DE CONEX�O N�O CONFIGURADOS"
		Static STR0020 := "Configura��es para Conex�o Segura"
		#define STR0021  "Editar Configura��o"
		Static STR0022 := "Deletar Configura��o"
		Static STR0023 := "Arquivo Principal do Certificado de Seguran�a"
		Static STR0024 := "Arquivo Chave do Certificado de Seguran�a"
		Static STR0025 := "Senha do Certificado de Seguran�a"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0003 := "Porta de liga��o (port)"
			STR0006 := "Liga��o tcp n�o configurada."
			STR0007 := "Liga��o tcp ["
			STR0008 := "] N�o Encontrada No Ficheiro De Configura��es."
			STR0009 := "Dados da liga��o tcp ["
			STR0010 := "Sec��o do driver (activa)"
			STR0012 := "Liga��o segura n�o configurada."
			STR0013 := "Liga��o segura ["
			STR0014 := "Dados da liga��o segura ["
			STR0015 := "Sec��o do driver (segura)"
			STR0016 := "Porta de liga��o segura (port)"
			STR0017 := "N�o � poss�vel eliminar esta configura��o."
			STR0018 := "Esta Configura��o � Obrigat�ria Para o Protheus Server."
			STR0019 := "Drivers De Liga��o N�o Configurados"
			STR0020 := "Configura��es Para Liga��o Segura"
			STR0022 := "Eliminar Configura��o"
			STR0023 := "Ficheiro Principal Do Certificado De Seguran�a"
			STR0024 := "Ficheiro Chave Do Certificado De Seguran�a"
			STR0025 := "Palavra-passe Do Certificado De Seguran�a"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
