#ifdef SPANISH
	#define STR0001 "Medir Latencia"
	#define STR0002 "Medir Velocidad"
	#define STR0003 "Prueba de transferencia"
	#define STR0004 "copiando para la estacion"
	#define STR0005 "Tamano del archivo enviado : "
	#define STR0006 "Velocidad                 : "
	#define STR0007 "Inicio de prueba de latencia  servidor / cliente : "
	#define STR0008 "Actualizacion en la ventana "
	#define STR0009 "Numero de interacciones                    : 500 "
	#define STR0010 "Latencia en mili-segundos por interaccion : "
#else
	#ifdef ENGLISH
		#define STR0001 "Measure Latency"
		#define STR0002 "Measure Speed"
		#define STR0003 "Transference test"
		#define STR0004 "copying to station"
		#define STR0005 "Size of uploaded file: "
		#define STR0006 "Speed                 : "
		#define STR0007 "Start of latency test server / client: "
		#define STR0008 "Update in window "
		#define STR0009 "Number of interactions                    : 500 "
		#define STR0010 "Latency in milliseconds for interaction: "
	#else
		#define STR0001 "Medir Latência"
		#define STR0002 "Medir Velocidade"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Teste de transferência", "Teste de transferencia" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "a copiar para a estação", "copiando para a estação" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Tamanho do ficheiro enviado : ", "Tamanho do arquivo enviado : " )
		#define STR0006 "Velocidade                 : "
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Inicio de teste de latência servidor / cliente : ", "Inicio de teste de latencia  servidor / cliente : " )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Actualização na janela ", "Atualização na janela " )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Número de interações                    : 500 ", "Numero de interacoes                    : 500 " )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Latência em milissegundos por interação: ", "Latencia em milissegundos por interacao : " )
	#endif
#endif
