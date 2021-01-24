#ifdef SPANISH
	#define STR0001 "Verificación"
	#define STR0002 "No existen verificaciones de recepción pendientes para ejecución."
	#define STR0003 "Recepción"
	#define STR0004 "Reversión"
	#define STR0005 "Informe el producto"
	#define STR0006 "Informe el lote"
	#define STR0007 "Informe el sublote"
	#define STR0008 "¿Unidad p/Verificación?"
	#define STR0009 "Unidad"
	#define STR0010 "¿Desea finalizar la verificación?"
	#define STR0011 "Cant."
	#define STR0012 "Finalizar"
	#define STR0013 "Interrumpir"
	#define STR0014 "Operador"
	#define STR0015 "Nombre"
	#define STR0016 "Producto"
	#define STR0017 "Descripción"
	#define STR0018 "Lote"
	#define STR0019 "Sublote"
	#define STR0020 "Cant. Verificada"
	#define STR0021 "¡Etiqueta inválida!"
	#define STR0022 "No existe cantidad verificada para este operador/producto."
	#define STR0023 "Cantidad por revertir superior a la cantidad verificada."
	#define STR0024 "¡Verificación finalizada por otro proceso!"
	#define STR0025 "Número de recepción informado no registrado."
	#define STR0026 "No fue posible registrar la cantidad."
	#define STR0027 "Finalización no permitida. No se verificó ninguna cantidad."
	#define STR0028 "Se encontraron divergencias en el conteo. ¿Confirma finalización?"
	#define STR0029 "No fue posible finalizar la verificación."
	#define STR0030 "Ningún operador realizó ninguna verificación."
	#define STR0031 "Componente"
	#define STR0032 "¿Considerar verificación para?"
	#define STR0033 "Procesando..."
#else
	#ifdef ENGLISH
		#define STR0001 "Checking"
		#define STR0002 "There are no pending receipt checkings for execution."
		#define STR0003 "Receipt"
		#define STR0004 "Reversal"
		#define STR0005 "Enter the product"
		#define STR0006 "Enter lot"
		#define STR0007 "Enter the Sub Lot"
		#define STR0008 "Unit for check?"
		#define STR0009 "Unit"
		#define STR0010 "Do you want to stop checking?"
		#define STR0011 "Qty."
		#define STR0012 "Close"
		#define STR0013 "Interrupt"
		#define STR0014 "Operator"
		#define STR0015 "Name"
		#define STR0016 "Product"
		#define STR0017 "Description"
		#define STR0018 "Lot"
		#define STR0019 "Sublot"
		#define STR0020 "Checked Qty"
		#define STR0021 "Invalid label!"
		#define STR0022 "There is no amt checked for this operator/product."
		#define STR0023 "Amount to reverse is higher than the amount checked."
		#define STR0024 "Checking already performed by another process!"
		#define STR0025 "Entered receipt number not registered."
		#define STR0026 "Unable to register the amount."
		#define STR0027 "Termination not allowed. No amount was checked."
		#define STR0028 "Divergences found in count. Confirm closing?"
		#define STR0029 "Unable to complete checking."
		#define STR0030 "No checking was performed by any operator."
		#define STR0031 "Component"
		#define STR0032 "Consider checking for?"
		#define STR0033 "Processing..."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Conferência" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Não existem conferências de recebimento pendentes para execução." )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Recebimento" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Estorno" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Informe o Produto" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Informe o Lote" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Informe o Sub-Lote" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Unidade p/Confer?" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Unidade" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Deseja encerrar a conferencia?" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Qtde" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Encerrar" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Interromper" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Operador" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Nome" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Produto" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Descrição" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Lote" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Sub-Lote" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Qtde Conferida" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Etiqueta invalida!" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "Não existe qtd conferida para este operador/produto." )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Quantidade à estornar maior que a qtd conferida." )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "Conferência já finalizada por outro processo!" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "Número recebimento informado não cadastrado." )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "Não foi possível registrar a quantidade." )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "Finalização não permitida. Não foi conferido nenhuma quantidade." )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "Foram encontradas divergencias na contagem. Confirma encerramento?" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", , "Não foi possível finalizar a conferência." )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "Nao foi realizada nenhuma conferencia por nenhum operador." )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", , "Componente" )
		#define STR0032 "Considerar conferência para?"
		#define STR0033 "Processando..."
	#endif
#endif
