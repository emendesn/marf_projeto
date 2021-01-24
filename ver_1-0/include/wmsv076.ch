#ifdef SPANISH
	#define STR0001 "Verificaci�n"
	#define STR0002 "Par�metro MV_WMSUMI incorrecto..."
	#define STR0003 "Vaya a la direcci�n"
	#define STR0004 "Direcci�n"
	#define STR0005 "Confirme"
	#define STR0006 "Carga"
	#define STR0007 "Pedido"
	#define STR0008 "Informe el producto"
	#define STR0009 "Informe el lote"
	#define STR0010 "Informe el sublote"
	#define STR0011 "�Unidad p/Verificaci�n?"
	#define STR0012 "Unidad"
	#define STR0013 "Cant."
	#define STR0014 "�Desea finalizar la verificaci�n?"
	#define STR0015 "Finalizar"
	#define STR0016 "Interrumpir"
	#define STR0017 "�Direcci�n incorrecta!"
	#define STR0018 "�La direcci�n [VAR01] no est� registrada!"
	#define STR0019 "�Carga inv�lida!"
	#define STR0020 "�Pedido inv�lido!"
	#define STR0021 "�Desea modificar pedido/carga?"
	#define STR0022 "No existen actividades de verificaci�n para la carga informada."
	#define STR0023 "No existen actividades de verificaci�n para el pedido informado."
	#define STR0024 "Actividades de la tarea en ejecuci�n por otro operador."
	#define STR0025 "Atenci�n"
	#define STR0026 "Carga modificada. Ejecutar la verificaci�n de la carga informada."
	#define STR0027 "Pedido modificado. Ejecutar la verificaci�n del pedido informado."
	#define STR0028 "Producto no pertenece a la verificaci�n."
	#define STR0029 "Producto no tiene una cantidad separada para verificaci�n."
	#define STR0030 "Producto/Lote no pertenece a la verificaci�n."
	#define STR0031 "Producto/Lote no tiene una cantidad separada para verificaci�n."
	#define STR0032 "Producto/Rastro no pertenece a la verificaci�n."
	#define STR0033 "Producto/Rastro no tiene una cantidad separada para verificaci�n."
	#define STR0034 "Cantidad informada superior a la cantidad liberada para verificaci�n."
	#define STR0035 "Cantidad informada superior a la cantidad total separada."
	#define STR0036 "No fue posible registrar la cantidad."
	#define STR0037 "Existen actividades anteriores no finalizadas."
	#define STR0038 "Existen �tems no verificados. �Confirma la finalizaci�n de la verificaci�n?"
	#define STR0039 "No fue posible finalizar la verificaci�n."
	#define STR0040 "Cant. Verificada"
	#define STR0041 "Verificados"
	#define STR0042 "Verificaci�n del producto bloqueada."
	#define STR0043 "Verificaci�n del producto finalizada."
	#define STR0044 "Verificaci�n del Producto/Lote bloqueada."
	#define STR0045 "Verificaci�n del Producto/Lote finalizada."
	#define STR0046 "Verificaci�n del Producto/Rastro bloqueada."
	#define STR0047 "Verificaci�n del Producto/Rastro finalizada."
	#define STR0048 "Existen �rdenes de servicio pendientes de ejecuci�n."
	#define STR0049 "�Etiqueta inv�lida!"
	#define STR0050 "�Verificaci�n finalizada con �xito!"
	#define STR0051 " se gener�. Entre en contacto con su Supervisor."
	#define STR0052 "El lote "
	#define STR0053 " actual."
#else
	#ifdef ENGLISH
		#define STR0001 "Checking"
		#define STR0002 "Parameter MV_WMSUMI incorrect..."
		#define STR0003 "Go to the address"
		#define STR0004 "Address"
		#define STR0005 "Confirm it"
		#define STR0006 "Load"
		#define STR0007 "Order"
		#define STR0008 "Enter the product"
		#define STR0009 "Enter lot"
		#define STR0010 "Enter the Sub Lot"
		#define STR0011 "Unit for check?"
		#define STR0012 "Unit"
		#define STR0013 "Qty."
		#define STR0014 "Do you want to stop checking?"
		#define STR0015 "Close"
		#define STR0016 "Interrupt"
		#define STR0017 "Incorrect address!"
		#define STR0018 "Address [VAR01] not registered!"
		#define STR0019 "Invalid cargo!"
		#define STR0020 "Invalid order!"
		#define STR0021 "Do you want to change order/load?"
		#define STR0022 "No checking activities exist for the load entered."
		#define STR0023 "No checking activities exist for the order entered."
		#define STR0024 "Task activities in progress by another operator."
		#define STR0025 "Attention"
		#define STR0026 "Load changed. Check the load entered."
		#define STR0027 "Order changed. Check the order entered."
		#define STR0028 "Product does not belong to checking."
		#define STR0029 "Product has no quantity separated for checking."
		#define STR0030 "Product/Lot does not belong to checking."
		#define STR0031 "Product/Lot has no quantity separated for checking."
		#define STR0032 "Product/Trace does not belong to checking."
		#define STR0033 "Product/Trace has no quantity separated for checking."
		#define STR0034 "Quantity entered greater than quantity released for checking."
		#define STR0035 "Quantity entered higher than total separated quantity."
		#define STR0036 "Unable to register the amount."
		#define STR0037 "Prior unfinished activities exist."
		#define STR0038 "Unchecked items exist. Do you want to finish checking?"
		#define STR0039 "Unable to complete checking."
		#define STR0040 "Checked Qty"
		#define STR0041 "Already checked"
		#define STR0042 "Product checking blocked."
		#define STR0043 "Product checking complete."
		#define STR0044 "Product/Lot checking blocked."
		#define STR0045 "Product/Lot checking complete."
		#define STR0046 "Product/Trace checking blocked."
		#define STR0047 "Product/Trace checking complete."
		#define STR0048 "Service orders with executions pending exist."
		#define STR0049 "Label not valid!"
		#define STR0050 "Checking completion successful!"
		#define STR0051 " is generated. Contact your Supervisor."
		#define STR0052 "Batch "
		#define STR0053 " current!"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Confer�ncia" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Parametro MV_WMSUMI incorreto..." )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Va para o endereco" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Endere�o" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Confirme !" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Carga" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Pedido" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Informe o produto" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Informe o lote" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Informe o sub-Lote" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Unidade p/confer?" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Unidade" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Qtde" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Deseja encerrar a conferencia?" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Encerrar" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Interromper" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Endereco incorreto!" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "O endereco [VAR01] n�o est� cadastrado!" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Carga inv�lida!" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Pedido inv�lido!" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Deseja alterar pedido/carga?" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "N�o existem atividades de confer�ncia para a carga informada." )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "N�o existem atividades de confer�ncia para o pedido informado." )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "Atividades da tarefa em andamento por outro operador." )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "Aten��o" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "Carga alterada. Executar a conferencia da carga informada." )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "Pedido alterado. Executar a conferencia do pedido informado." )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "Produto n�o pertence a confer�ncia." )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", , "Produto n�o possui quantidade separada para confer�ncia." )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "Produto/lote n�o pertence a confer�ncia." )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", , "Produto/lote n�o possui quantidade separada para confer�ncia." )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", , "Produto/rastro n�o pertence a confer�ncia." )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", , "Produto/rastro n�o possui quantidade separada para confer�ncia." )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", , "Quantidade informada maior que a quantidade liberada para confer�ncia." )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", , "Quantidade informada maior que quantidade total separada." )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", , "N�o foi poss�vel registrar a quantidade." )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", , "Existem atividades anteriores n�o finalizadas." )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", , "Existem itens n�o conferidos. Confirma a finaliza��o da confer�ncia?" )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", , "N�o foi poss�vel finalizar a confer�ncia." )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", , "Qtde conferida" )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", , "J� conferidos" )
		#define STR0042 If( cPaisLoc $ "ANG|PTG", , "Confer�ncia do produto bloqueada." )
		#define STR0043 If( cPaisLoc $ "ANG|PTG", , "Confer�ncia do produto finalizada." )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", , "Confer�ncia do produto/lote bloqueada." )
		#define STR0045 If( cPaisLoc $ "ANG|PTG", , "Confer�ncia do produto/lote finalizada." )
		#define STR0046 If( cPaisLoc $ "ANG|PTG", , "Confer�ncia do produto/rastro bloqueada." )
		#define STR0047 If( cPaisLoc $ "ANG|PTG", , "Confer�ncia do produto/rastro finalizada." )
		#define STR0048 If( cPaisLoc $ "ANG|PTG", , "Existem ordens de servi�o pendentes de execu��o." )
		#define STR0049 If( cPaisLoc $ "ANG|PTG", , "Etiqueta inv�lida !" )
		#define STR0050 If( cPaisLoc $ "ANG|PTG", , "Confer�ncia encerrada com sucesso!" )
		#define STR0051 If( cPaisLoc $ "ANG|PTG", , "Deseja sair da confer�ncia?" )
		#define STR0052 If( cPaisLoc $ "ANG|PTG", , "N�o existem mais itens para serem conferidos. Confer�ncia ser� finalizada!" )
		#define STR0053 If( cPaisLoc $ "ANG|PTG", , "Processando..." )
	#endif
#endif
