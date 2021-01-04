#ifdef SPANISH
	#define STR0001 "Procesamiento de entrega"
	#define STR0002 "No hay Proveedores por consultar."
	#define STR0003 "Purchase Order"
	#define STR0004 "Encabezado"
	#define STR0005 "Transportadora"
	#define STR0006 "Error"
	#define STR0007 "Pedido"
	#define STR0008 "Items"
	#define STR0009 "Mantenimiento de Item"
	#define STR0010 "Documento de Entrada"
	#define STR0011 "¡Informaciones almacenadas con EXITO!"
	#define STR0012 "Atencion"
	#define STR0013 "Modificacion "
	#define STR0014 "¡Registrado con EXITO!"
	#define STR0015 "PEDIDOS DE COMPRA"
	#define STR0016 "Resultado de la Busqueda"
	#define STR0017 "De fecha:"
	#define STR0018 "A fecha:"
	#define STR0019 "De fecha de entrega:"
	#define STR0020 "A fecha de entrega:"
	#define STR0021 "Buscar"
	#define STR0022 "Incluir"
	#define STR0023 "Desea eliminar el item "
	#define STR0024 "Busqueda avanzada: "
	#define STR0025 "Numero del documento "
	#define STR0026 "Volver"
	#define STR0027 "ESTATUS"
	#define STR0028 "Desea eliminar el item "
	#define STR0029 "Modificar documento de entrega"
	#define STR0030 "Totales/Descuentos/Flete/Gastos"
	#define STR0031 "Seleccionar_Pedido"
	#define STR0032 "Calcular"
	#define STR0033 "Grabar"
	#define STR0034 "Items"
	#define STR0035 "Encabezado"
	#define STR0036 "Se encontraron "
	#define STR0037 "Pedidos "
	#define STR0038 "Inclusion"
	#define STR0039 "Acciones"
	#define STR0040 "Accion"
#else
	#ifdef ENGLISH
		#define STR0001 "Delivery processing"
		#define STR0002 "No Suppliers found."
		#define STR0003 "Purchase Order"
		#define STR0004 "Heading"
		#define STR0005 "Transporter"
		#define STR0006 "Error"
		#define STR0007 "Order"
		#define STR0008 "Items"
		#define STR0009 "Item Maintenance"
		#define STR0010 "Entry Document"
		#define STR0011 "Information stored SUCCESSFULLY!"
		#define STR0012 "Attention"
		#define STR0013 "Change "
		#define STR0014 " registered SUCCESSFULLY"
		#define STR0015 "PURCHASE ORDERS"
		#define STR0016 "Search result"
		#define STR0017 "Date from:"
		#define STR0018 "Date to:"
		#define STR0019 "Delivery date from:"
		#define STR0020 "Delivery date to:"
		#define STR0021 "Search"
		#define STR0022 "Add"
		#define STR0023 "Do you really want to exclude the item "
		#define STR0024 "Advanced search: "
		#define STR0025 "Document Number "
		#define STR0026 "RETURN"
		#define STR0027 "STATUS"
		#define STR0028 "Do you really want to exclude the item "
		#define STR0029 "Edit Delivery Document"
		#define STR0030 "Total/Discounts/Freight/Expenses"
		#define STR0031 "Select_Order"
		#define STR0032 "Calculate"
		#define STR0033 "Save"
		#define STR0034 "Items"
		#define STR0035 "Header"
		#define STR0036 "Were found "
		#define STR0037 "Orders "
		#define STR0038 "Addition"
		#define STR0039 "Actions"
		#define STR0040 "Share"
	#else
		#define STR0001 "Processamento de entrega"
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Não há fornecedores a consultar.", "Não há Fornecedores a consultar." )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Ordem De Compra", "Purchase Order" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Cabeçalho", "Cabecalho" )
		#define STR0005 "Transportadora"
		#define STR0006 "Erro"
		#define STR0007 "Pedido"
		#define STR0008 "Itens"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Manutenção De Elemento", "Manutencäo de Item" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Documento De Entrada", "Documento de Entrada" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Informações Armazenadas Com Sucesso!", "Informacöes armazenadas com SUCESSO!" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Atenção", "Atencao" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Alteração ", "Alteracao " )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", " Registado Com Sucesso!", " cadastrado com SUCESSO!" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Pedidos De Compra", "PEDIDOS DE COMPRA" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Resultado Da Procura", "Resultado da Busca" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Data de:", "Data de  :" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Data Até:", "Data Até :" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Data de entrega de:", "Data de Entrega de  :" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Data de entrega até:", "Data de Entrega Até :" )
		#define STR0021 "Buscar"
		#define STR0022 "Incluir"
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Deseja realmente excluir o elemento ", "Deseja realmente excluir o item " )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Busca Avançada: ", "Busca Avançada : " )
		#define STR0025 "Número do Documento "
		#define STR0026 "Voltar"
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "ESTADO", "STATUS" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Deseja realmente excluir o elemento ", "Deseja realmente excluir o item " )
		#define STR0029 "Alterar Documento de Entrega"
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Totais/Descontos/Transporte/Despesas", "Totais/Descontos/Frete/Despesas" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Seleccionar_Pedido", "Selecionar_Pedido" )
		#define STR0032 "Calcular"
		#define STR0033 "Gravar"
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Elementos", "Itens" )
		#define STR0035 "Cabeçalho"
		#define STR0036 "Foram encontrados "
		#define STR0037 "Pedidos "
		#define STR0038 "Inclusão"
		#define STR0039 "Ações"
		#define STR0040 "Ação"
	#endif
#endif
