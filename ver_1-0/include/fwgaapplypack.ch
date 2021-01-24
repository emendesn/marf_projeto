#ifdef SPANISH
	#define STR0001 "No se pudo conectar en el servidor '"
	#define STR0002 "' puerta '"
	#define STR0003 "' environment '"
	#define STR0004 "Actualizacion de Paquetes"
	#define STR0005 "Aplicando el paquete de actualizacion "
	#define STR0006 " en el servidor "
	#define STR0007 " puerta "
	#define STR0008 "Aplicando la actualizacion de repositorio en el servidor "
	#define STR0009 "No fue posible realizar la aplicacion del paquete "
	#define STR0010 "Aplicando la actualizacion del diccionario diferencial estandar de TOTVS."
	#define STR0011 "Problema en la aplicacion del diccionario diferencial estandar de TOTVS."
	#define STR0012 "Aplicando la actualizacion del diferencial del Configurador."
	#define STR0013 "Problema en la aplicacion del diccionario diferencial del Configurador"
	#define STR0014 "Paquete de actualizacion "
	#define STR0015 " aplicado con exito en el servidor "
	#define STR0016 "No existen paquetes para aplicar."
	#define STR0017 "No fue posible realizar la conexion exclusiva con los servidores para la aplicacion de la actualizacion."
	#define STR0018 "Ocurrio un problema en la copia del RPO"
	#define STR0019 "Directorio de intalacion de Protheus no informado en el archivo de configuracion del servidor (appserver.ini)."
#else
	#ifdef ENGLISH
		#define STR0001 "Could not connect to server '"
		#define STR0002 "' port '"
		#define STR0003 "' environment '"
		#define STR0004 "Package Updates"
		#define STR0005 "Applying update package "
		#define STR0006 " in server "
		#define STR0007 " port "
		#define STR0008 "Applying repository update in server "
		#define STR0009 "Could not apply package "
		#define STR0010 "Applying TOTVS default differential dictionary update."
		#define STR0011 "Problem in TOTVS default differential dictionary application."
		#define STR0012 "Applying Configurator differential update."
		#define STR0013 "Problem in Configurator differential dictionary application"
		#define STR0014 "Update package "
		#define STR0015 " successfully applied in server "
		#define STR0016 "There are no packages to apply."
		#define STR0017 "Could not create an exclusive connection with the servers to apply the update."
		#define STR0018 "A problem in RPO copy has occurred"
		#define STR0019 "Protheus instalation directory not entered in server (appserver.ini) configuration file."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "N�o foi poss�vel conectar no servidor '", "Nao foi possivel conectar no servidor '" )
		#define STR0002 "' porta '"
		#define STR0003 "' environment '"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Actualiza��o de pacotes", "Atualiza��o de Pacotes" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "A aplicar o pacote de actualiza��o ", "Aplicando o pacote de atualiza��o " )
		#define STR0006 " no servidor "
		#define STR0007 " porta "
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "A aplicar a actualiza��o de reposit�rio no servidor ", "Aplicando a atualizacao de repositorio no servidor " )
		#define STR0009 "N�o foi poss�vel realizar a aplica��o do pacote "
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "A aplicar a actualiza��o do dicion�rio diferencial padr�o da TOTVS.", "Aplicando a atualizacao do dicion�rio diferencial padr�o da TOTVS." )
		#define STR0011 "Problema na aplica��o do dicion�rio diferencial padr�o da TOTVS."
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "A aplicar a actualiza��o do diferencial do Configurador.", "Aplicando a atualizacao do diferencial do Configurador." )
		#define STR0013 "Problema na aplica��o do dicion�rio diferencial do Configurador"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Pacote de actualiza��o ", "Pacote de atualiza��o " )
		#define STR0015 " aplicado com sucesso no servidor "
		#define STR0016 "N�o existem pacotes a serem aplicados."
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "N�o foi poss�vel realizar a conex�o exclusiva com os servidores para aplicar a actualiza��o.", "N�o foi poss�vel realizar a conex�o exclusiva com os servidores para a aplica��o da atualiza��o." )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Ocorreu um problema na c�pia do RPO", "Ocorreu um problema na copia do RPO" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Direct�rio de intala��o do Protheus n�o informado no ficheiro de configura��o do servidor (appserver.ini).", "Diretorio de intalacao do Protheus nao informado no arquivo de configuracao do servidor (appserver.ini)." )
	#endif
#endif
