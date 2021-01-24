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
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Não foi possível conectar no servidor '", "Nao foi possivel conectar no servidor '" )
		#define STR0002 "' porta '"
		#define STR0003 "' environment '"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Actualização de pacotes", "Atualização de Pacotes" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "A aplicar o pacote de actualização ", "Aplicando o pacote de atualização " )
		#define STR0006 " no servidor "
		#define STR0007 " porta "
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "A aplicar a actualização de repositório no servidor ", "Aplicando a atualizacao de repositorio no servidor " )
		#define STR0009 "Não foi possível realizar a aplicação do pacote "
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "A aplicar a actualização do dicionário diferencial padrão da TOTVS.", "Aplicando a atualizacao do dicionário diferencial padrão da TOTVS." )
		#define STR0011 "Problema na aplicação do dicionário diferencial padrão da TOTVS."
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "A aplicar a actualização do diferencial do Configurador.", "Aplicando a atualizacao do diferencial do Configurador." )
		#define STR0013 "Problema na aplicação do dicionário diferencial do Configurador"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Pacote de actualização ", "Pacote de atualização " )
		#define STR0015 " aplicado com sucesso no servidor "
		#define STR0016 "Não existem pacotes a serem aplicados."
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Não foi possível realizar a conexão exclusiva com os servidores para aplicar a actualização.", "Não foi possível realizar a conexão exclusiva com os servidores para a aplicação da atualização." )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Ocorreu um problema na cópia do RPO", "Ocorreu um problema na copia do RPO" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Directório de intalação do Protheus não informado no ficheiro de configuração do servidor (appserver.ini).", "Diretorio de intalacao do Protheus nao informado no arquivo de configuracao do servidor (appserver.ini)." )
	#endif
#endif
