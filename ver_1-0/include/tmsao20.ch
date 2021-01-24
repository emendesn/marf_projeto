#ifdef SPANISH
	#define STR0001 "Limpieza de posicionamiento de los vehiculos - DAV"
	#define STR0002 "La rutina ejecuta la limpieza de los registros y graba los archivos borrados en un archivo muerto que se genera con el prefijo: 'DAV + Fecha actual.amt'."
	#define STR0003 "La ultima secuencia del posicionamiento de un vehiculo + viaje se mantendra "
	#define STR0004 "Espere..."
	#define STR0005 "Ejecutando limpieza..."
	#define STR0006 "Preparando exclusion..."
#else
	#ifdef ENGLISH
		#define STR0001 "Cleanup of vehicle positioning - DAV"
		#define STR0002 "The routine executes the cleanup of registers and saves the deleted files in a dead file that is generated with the prefix: 'DAV + amt.cur.date'."
		#define STR0003 "The last sequence of a vehicle positioning + trip will be kept "
		#define STR0004 "Wait..."
		#define STR0005 "Executing cleanup..."
		#define STR0006 "Preparing exclusion..."
	#else
		#define STR0001 "Limpeza do posicionamento dos veículos - DAV"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "O procedimento executa a limpeza dos registos e grava os ficheiros apagados em um ficheiro morto que é gerado com o prefixo: 'DAV + data atual.amt'.", "A rotina executa a limpeza dos registros e grava os arquivos apagados em um arquivo morto que é gerado com o prefixo: 'DAV + data atual.amt'." )
		#define STR0003 "A última sequência do posicionamento de um veículo + viagem será mantida "
		#define STR0004 "Aguarde..."
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "A executar limpeza...", "Executando limpeza..." )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "A preparar exclusão...", "Preparando exclusão..." )
	#endif
#endif
