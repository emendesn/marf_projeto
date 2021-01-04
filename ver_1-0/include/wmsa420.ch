#ifdef SPANISH
	#define STR0001 "Monitor Carga vs. WMS"
	#define STR0002 "Fch. Ultimo movimiento"
	#define STR0003 "Hr. Ultimo movimiento"
	#define STR0004 "Carga"
	#define STR0005 "No iniciado"
	#define STR0006 "En separacion"
	#define STR0007 "Interrumpida"
	#define STR0008 "Esperando facturacion"
	#define STR0009 "Finalizado"
	#define STR0010 "Buscar"
	#define STR0011 "Visualizar"
	#define STR0012 "Modificar prioridad"
	#define STR0013 "Espere"
	#define STR0014 "Finalizando"
	#define STR0015 "Visualizar carga"
	#define STR0016 "Buscando informaciones"
	#define STR0017 "Atencion"
	#define STR0018 "Solo para cargas cuya recoleccion no haya sido realizada."
	#define STR0019 "Modificacion de prioridad"
	#define STR0020 "Prioridad Actual"
	#define STR0021 "Prioridad"
	#define STR0022 "OK "
	#define STR0023 "Anular"
	#define STR0024 "Aviso"
	#define STR0025 "Prioridad modificada."
	#define STR0026 "No tiene prioridad. Servicio no ejecutado."
	#define STR0029 "Informe un valor positivo."
#else
	#ifdef ENGLISH
		#define STR0001 "Monitor Load x WMS"
		#define STR0002 "Last Transaction Dt."
		#define STR0003 "Last Transaction Tm."
		#define STR0004 "Load"
		#define STR0005 "Not Started"
		#define STR0006 "In Separation"
		#define STR0007 "Interrupted"
		#define STR0008 "Waiting Invoicing"
		#define STR0009 "Finished"
		#define STR0010 "Search"
		#define STR0011 "View"
		#define STR0012 "Change Priority"
		#define STR0013 "Wait"
		#define STR0014 "Closing"
		#define STR0015 "View load"
		#define STR0016 "Searching Data"
		#define STR0017 "Attention"
		#define STR0018 "Only for loads where the sort was not executed."
		#define STR0019 "Priority Change"
		#define STR0020 "Current Priority"
		#define STR0021 "Priority"
		#define STR0022 "OK "
		#define STR0023 "Cancel"
		#define STR0024 "Warning"
		#define STR0025 "Priority changed."
		#define STR0026 "No priority. Service not executed."
		#define STR0029 "Enter a positive value!"
	#else
		#define STR0001 "Monitor Carga x WMS"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Dt. �ltima movimenta��o", "Dt. �ltima Movimenta��o" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Hr. �ltima movimenta��o", "Hr. �ltima Movimenta��o" )
		#define STR0004 "Carga"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "N�o iniciado", "N�o Iniciado" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Em separa��o", "Em Separa��o" )
		#define STR0007 "Interrompida"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "A aguardar factura��o", "Aguardando Faturamento" )
		#define STR0009 "Finalizado"
		#define STR0010 "Pesquisar"
		#define STR0011 "Visualizar"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Alterar prioridade", "Alterar Prioridade" )
		#define STR0013 "Aguarde"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "A encerrar", "Encerrando" )
		#define STR0015 "Visualizar carga"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "A buscar informa��es", "Buscando informa��es" )
		#define STR0017 "Aten��o"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Somente para cargas que o recolhimento n�o tenha sido executado.", "Somente para cargas que o apanhe n�o tenha sido executado." )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Altera��o de prioridade", "Altera��o de Prioridade" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Prioridade actual", "Prioridade Atual" )
		#define STR0021 "Prioridade"
		#define STR0022 "OK "
		#define STR0023 "Cancelar"
		#define STR0024 "Aviso"
		#define STR0025 "Prioridade alterada."
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "N�o tem prioridade. Servi�o n�o executado.", "N�o possue prioridade. Servi�o n�o executado." )
		#define STR0029 "Informe um valor positivo."
	#endif
#endif