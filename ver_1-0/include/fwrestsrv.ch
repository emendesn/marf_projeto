#ifdef SPANISH
	#define STR0001 "WS/REST - Iniciando entorno #1 del ERP en :#2"
	#define STR0002 "WS/REST - Iniciado entorno #1 del ERP en :#2"
	#define STR0003 "WS/REST - Iniciado en :#2"
	#define STR0004 "WS/REST ONSTART ERROR ENVIRONMENT: [#1]"
	#define STR0005 "Parametros: "
	#define STR0006 "Grupo de empresa: [#1]"
	#define STR0007 "Sucursal del Sistema: [#1]"
	#define STR0008 "WS/REST - Se recibio el paquete en el entorno #1 para URN #2 Metodo: #3 en :#4"
	#define STR0009 "WS/REST - Se recibio el paquete para URN #1 Metodo: #2 en :#3"
	#define STR0010 "WS/REST - Se proceso el paquete en el entorno [#1] para URN [#2] Metodo: [#3] en :#4"
	#define STR0011 "WS/REST - Se proceso el paquete para URN [#1] Metodo: [#2] en :#3"
	#define STR0012 "RESTFul Statistical Control Execution. Success: #1/#2"
	#define STR0013 "WS REPRESENTATIONAL STATE TRANSFER/REST #1 ERROR"
	#define STR0014 "WS REPRESENTATIONAL STATE TRANSFER/REST INFORMATION"
#else
	#ifdef ENGLISH
		#define STR0001 "WS/REST - Restarting environment  #1 of ERP in :#2"
		#define STR0002 "WS/REST - Started environment  #1 of ERP in :#2"
		#define STR0003 "WS/REST - Started in :#2"
		#define STR0004 "WS/REST ONSTART ERROR ENVIRONMENT: [#1]"
		#define STR0005 "Parameters: "
		#define STR0006 "Companies Group: [#1]"
		#define STR0007 "System Branch: [#1]"
		#define STR0008 "WS/REST - Package received in environment #1 for URN #2 Method: #3 in :#4"
		#define STR0009 "WS/REST - Package received URN #1 Method: #2 in :#3"
		#define STR0010 "WS/REST - Package processed in environment [#1] for URN [#2] Method: #3 in :#4"
		#define STR0011 "WS/REST - Package processed for URN [#1] Method: [#2] in :#3"
		#define STR0012 "RESTFul Statistical Control Execution. Success: #1/#2"
		#define STR0013 "WS REPRESENTATIONAL STATE TRANSFER/REST #1 ERROR"
		#define STR0014 "WS REPRESENTATIONAL STATE TRANSFER/REST INFORMATION"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "WS/REST - A iniciar ambiente #1 do ERP em :#2", "WS/REST - Iniciando ambiente #1 do ERP em :#2" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "WS/REST - A iniciar ambiente #1 do ERP em :#2", "WS/REST - Iniciado ambiente #1 do ERP em :#2" )
		#define STR0003 "WS/REST - Iniciado em :#2"
		#define STR0004 "WS/REST ONSTART ERROR ENVIRONMENT: [#1]"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Parâmetros: ", "Parametros: " )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Grupo de empresa: [#1]", "Grupo de Empresa: [#1]" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Filial do sistema: [#1]", "Filial do Sistema: [#1]" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "WS/REST - Pacote recebido no ambiente #1 para URN #2 Método: #3 em :#4", "WS/REST - Pacote recebido no ambiente #1 para URN #2 Metodo: #3 em :#4" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "WS/REST - Pacote recebido para URN #1 Método: #2 em :#3", "WS/REST - Pacote recebido para URN #1 Metodo: #2 em :#3" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "WS/REST - Pacote processado no ambiente [#1] para URN [#2] Método: [#3] em :#4", "WS/REST - Pacote processado no ambiente [#1] para URN [#2] Metodo: [#3] em :#4" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "WS/REST - Pacote processado para URN [#1] Método: [#2] em :#3", "WS/REST - Pacote processado para URN [#1] Metodo: [#2] em :#3" )
		#define STR0012 "RESTFul Statistical Control Execution. Success: #1/#2"
		#define STR0013 "WS REPRESENTATIONAL STATE TRANSFER/REST #1 ERROR"
		#define STR0014 "WS REPRESENTATIONAL STATE TRANSFER/REST INFORMATION"
	#endif
#endif
