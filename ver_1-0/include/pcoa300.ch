#ifdef SPANISH
	#define STR0001 "Reprocesamiento de los Saldos"
	#define STR0002 "  Este programa tien como objetivo recalcular y analizar los saldos dia a dia de un "
	#define STR0003 "  determinado periodo a la fecha base del sistema. "
	#define STR0004 "  Utilizado en caso de haber necesidad de entrada de movimientos  retroactivos. "
	#define STR0005 'Borrando saldos diarios...'
	#define STR0006 'Borrando saldos mensuales...'
	#define STR0007 "Error en la declaracion de movimientos"
	#define STR0008 "Error en la declaracion de saldo mensuales"
	#define STR0009 "Proceso cancelado..."
	#define STR0010 'Seleccionando asientos para procesar el cubo '
	#define STR0011 'Procesando cubo '
	#define STR0012 "Procesamiento iniciado."
	#define STR0013 "Procesamiento encerrado."
#else
	#ifdef ENGLISH
		#define STR0001 "Reprocessing of balances "
		#define STR0002 "  The purpose of this program is to recalculate and analyze the balances dy by day of a"
		#define STR0003 "  certain period to the system base date.  "
		#define STR0004 "  Used in case of need for inflow of retroactive movements.  "
		#define STR0005 'Deleting daily balances...'
		#define STR0006 'Deleting monthly balances.'
		#define STR0007 "Error deleting movements "
		#define STR0008 "Error deleting monthly balances  "
		#define STR0009 "Process cancelled ..."
		#define STR0010 'Selecting entries to process the cube '
		#define STR0011 'Processing cube  '
		#define STR0012 "Processing started."
		#define STR0013 "Processing finished."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Reprocessamento Dos Saldos", "Reprocessamento dos Saldos" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "  este programa tem como objectivo recalcular e analisar os saldos dia a dia de um ", "  Este programa tem como objetivo recalcular e analisar os saldos dia a dia de um " )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "  determinado período até à data base do sistema. ", "  determinado per¡odo ate a data base do sistema. " )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "  utilizado no caso de haver necessidade de entrada de movimentos retroactivos. ", "  Utilizado no caso de haver necessidade de entrada de movimentos  retroativos. " )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", 'Apagando saldos diários...', 'Apagando saldos diarios...' )
		#define STR0006 'Apagando saldos mensais...'
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Erro no apagamento de movimentos ", "Erro na delecao de movimentos " )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Erro no apagamento de saldos mensais ", "Erro na delecao de saldos mensais " )
		#define STR0009 "Processo cancelado..."
		#define STR0010 If( cPaisLoc $ "ANG|PTG", 'seleccionando lancamentos para processar o cubo', 'Selecionando lancamentos para processar o cubo ' )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", 'A processar cubo', 'Processando cubo ' )
		#define STR0012 "Processamento iniciado."
		#define STR0013 "Processamento encerrado."
	#endif
#endif
