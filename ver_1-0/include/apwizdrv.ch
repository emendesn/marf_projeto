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
		Static STR0003 := "Porta de Conexão (Port)"
		Static STR0006 := "Conexão TCP não configurada."
		Static STR0007 := "Conexão TCP ["
		Static STR0008 := "] não encontrada no Arquivo de Configurações."
		Static STR0009 := "Dados da Conexão TCP ["
		Static STR0010 := "Seção do Driver (active)"
		Static STR0012 := "Conexão Segura não configurada."
		Static STR0013 := "Conexão Segura ["
		Static STR0014 := "Dados da Conexão Segura ["
		Static STR0015 := "Seção do Driver (secure)"
		Static STR0016 := "Porta de Conexão Segura (port)"
		Static STR0017 := "Não é possível deletar esta configuração."
		Static STR0018 := "Esta configuração é obrigatória para o Protheus Server."
		Static STR0019 := "DRIVERS DE CONEXÃO NÃO CONFIGURADOS"
		Static STR0020 := "Configurações para Conexão Segura"
		#define STR0021  "Editar Configuração"
		Static STR0022 := "Deletar Configuração"
		Static STR0023 := "Arquivo Principal do Certificado de Segurança"
		Static STR0024 := "Arquivo Chave do Certificado de Segurança"
		Static STR0025 := "Senha do Certificado de Segurança"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0003 := "Porta de ligação (port)"
			STR0006 := "Ligação tcp não configurada."
			STR0007 := "Ligação tcp ["
			STR0008 := "] Não Encontrada No Ficheiro De Configurações."
			STR0009 := "Dados da ligação tcp ["
			STR0010 := "Secção do driver (activa)"
			STR0012 := "Ligação segura não configurada."
			STR0013 := "Ligação segura ["
			STR0014 := "Dados da ligação segura ["
			STR0015 := "Secção do driver (segura)"
			STR0016 := "Porta de ligação segura (port)"
			STR0017 := "Não é possível eliminar esta configuração."
			STR0018 := "Esta Configuração é Obrigatória Para o Protheus Server."
			STR0019 := "Drivers De Ligação Não Configurados"
			STR0020 := "Configurações Para Ligação Segura"
			STR0022 := "Eliminar Configuração"
			STR0023 := "Ficheiro Principal Do Certificado De Segurança"
			STR0024 := "Ficheiro Chave Do Certificado De Segurança"
			STR0025 := "Palavra-passe Do Certificado De Segurança"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
