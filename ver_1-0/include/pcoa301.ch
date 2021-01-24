#ifdef SPANISH
	#define STR0001 "Otro usuario esta utilizando esta rutina "
	#define STR0002 "Reprocesamiento de Saldos - (Multi-Threads)"
	#define STR0003 "Esperando reprocesamiento de saldos..."
	#define STR0004 "Error en el borrado de la Tabla: "
	#define STR0005 "Error en el borrado de la Procedure: "
	#define STR0006 ". Borrar manualmente."
	#define STR0007 "Proceso finalizado con exito."
	#define STR0008 "Problema en el procesamiento."
	#define STR0009 "Iniciando reprocesamiento de saldo..."
	#define STR0010 "Llamando reprocesamiento de saldos"
	#define STR0011 "Sucursal: "
	#define STR0012 "Cubo: "
	#define STR0013 " Periodo "
	#define STR0014 " Thread: "
	#define STR0015 " Este programa tiene como objetivo reprocesar los saldos de los cubos de un "
	#define STR0016 " determinado periodo. En este reprocesamiento se utilizan hasta "
	#define STR0017 " procesos simultaneos. Para modificar la cantidad de procesos simultaneos"
	#define STR0018 " consulte el parametro MV_PCOTHRD. "
	#define STR0019 "Programa PCOA300 desactualizado. Actualicelo y ejecute el reprocesamiento nuevamente."
	#define STR0020 "Cantidad de Threads no permitida."
	#define STR0021 "Atencion"
	#define STR0022 " Esperando apertura de Thread para Actualizacion de Saldos."
	#define STR0023 "Reprocesamiento en uso"
	#define STR0024 "Abandonando proceso de reprocesamiento de Saldos. Actualiza saldo de los cubos nuevamente."
#else
	#ifdef ENGLISH
		#define STR0001 "Other user is using the routine "
		#define STR0002 "Balance Reprocessing - (Multi-Threads)"
		#define STR0003 "Waiting for balance reprocessing..."
		#define STR0004 "Error deleting Table: "
		#define STR0005 "Error deleting Procedure: "
		#define STR0006 ". Delete Manually."
		#define STR0007 "Process successfully finished."
		#define STR0008 "Error in the Processing."
		#define STR0009 "Balance reprocessing started..."
		#define STR0010 "Balance reprocessing calling"
		#define STR0011 "Branch: "
		#define STR0012 "Cube: "
		#define STR0013 " Period "
		#define STR0014 " Thread: "
		#define STR0015 " The objective of this program is to reprocess balances on cubes of a "
		#define STR0016 " specific period of time. This reprocessing will use up to "
		#define STR0017 " simultaneous processes. To change the number of simultaneous processes"
		#define STR0018 " check parameter MV_PCOTHRD. "
		#define STR0019 "PCOA300 software out of date. Update and run the reprocessing again."
		#define STR0020 "Number of threads not allowed."
		#define STR0021 "Attention"
		#define STR0022 " Waiting to open Thread for Balance Update."
		#define STR0023 "Reprocessing in use."
		#define STR0024 "Leaving process of Balance reprocessing. Update Balance of Cubes again."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Outro utilizador está a usar este procedimento ", "Outro usuario está utilizando esta rotina " )
		#define STR0002 "Reprocessamento dos Saldos - (Multi-Threads)"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "A aguardar reprocessamento de saldos...", "Aguardando reprocessamento de saldos..." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Erro na eliminação da Tabela: ", "Erro na exclusao da Tabela: " )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Erro na eliminação da Procedure: ", "Erro na exclusao da Procedure: " )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", ". Eliminar manualmente.", ". Excluir manualmente." )
		#define STR0007 "Processo finalizado com sucesso."
		#define STR0008 "Problema no processamento."
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "A iniciar reprocessamento de saldo...", "Iniciando reprocessamento de saldo..." )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "A chamar reprocessamento de saldos", "Chamando reprocessamento de saldos" )
		#define STR0011 "Filial: "
		#define STR0012 "Cubo: "
		#define STR0013 If( cPaisLoc $ "ANG|PTG", " Período ", " Periodo " )
		#define STR0014 " Thread: "
		#define STR0015 If( cPaisLoc $ "ANG|PTG", " Este programa tem como objectivo reprocessar os saldos dos cubos de um ", " Este programa tem como objetivo reprocessar os saldos dos cubos de um " )
		#define STR0016 " determinado período. Neste reprocessamento serão utilizados até "
		#define STR0017 " processos simultâneos. Para alterar a quantidade de processos simultâneos"
		#define STR0018 " consulte o parâmetro MV_PCOTHRD. "
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Programa PCOA300 desactualizado. Actualize-o e execute o reprocessamento novamente.", "Programa PCOA300 desatualizado. Atualize-o e execute o reprocessamento novamente." )
		#define STR0020 "Quantidade de Threads não permitida."
		#define STR0021 "Atenção"
		#define STR0022 " Aguardando abertura da Thread para Atualização de Saldos."
		#define STR0023 "Reprocessamento em Uso"
		#define STR0024 "Abandonando processo de reprocessamento de Saldos. Atualizar Saldo dos Cubos Novamente."
	#endif
#endif
