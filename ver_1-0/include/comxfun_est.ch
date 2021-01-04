#ifdef SPANISH
	#define STR0001 "Valor neto"
	#define STR0002 " no puede utilizarse como clave para busqueda de Documento origen, debido a filtros de la rutina."
	#define STR0003 "Documentos de origen"
	#define STR0004 "Operacion triangular"
	#define STR0005 "Buscar por:"
	#define STR0006 "Ubicar"
	#define STR0007 "Almacen"
	#define STR0008 "Seleccion de almacenes"
	#define STR0009 "Seleccione el almacen para devolucion"
	#define STR0010 "Saldo en stock"
	#define STR0011 "Cant. Reservada"
	#define STR0012 "Cant. Prevista entrada"
	#define STR0013 "Cant.Disponible"
	#define STR0014 "Sal.Actual"
	#define STR0015 "TOTAL "
	#define STR0016 "Cantidad reservada "
	#define STR0017 "Saldo actual   "
	#define STR0018 "Cant. Entrada prevista"
	#define STR0019 "Cant. Pedido de ventas  "
	#define STR0020 "Cant. Reservada  "
	#define STR0021 "Cant. Reservada S.A."
	#define STR0022 "Especifico"
	#define STR0023 "Atencion"
	#define STR0024 "No registro de stocks para este producto."
	#define STR0025 "Historial de compras - Ultimas facturas"
	#define STR0026 "Documento"
	#define STR0027 "Fch. Emision"
	#define STR0028 "Fch. Entrada"
	#define STR0029 "Proveedor/Cliente"
	#define STR0030 "Cantidad"
	#define STR0031 "Serie"
	#define STR0032 "Tipo Fact"
	#define STR0033 "Val. Unitario"
	#define STR0034 "Visualizar"
	#define STR0035 "No existen Facturas de entrada registradas para este producto."
	#define STR0036 "Volver"
#else
	#ifdef ENGLISH
		#define STR0001 "Net Value"
		#define STR0002 " cannot be used as key for Source Document search due to routine filters."
		#define STR0003 "Source Document"
		#define STR0004 "Triangular Operation"
		#define STR0005 "Search for:"
		#define STR0006 "Find"
		#define STR0007 "Warehouse"
		#define STR0008 "Selection of warehouses"
		#define STR0009 "Select warehouse for return"
		#define STR0010 "Balances in inventory"
		#define STR0011 "Allocated Qty"
		#define STR0012 "Entry Estimated Qty"
		#define STR0013 "Available Qty"
		#define STR0014 "Current Bal"
		#define STR0015 "TOTAL "
		#define STR0016 "Allocated Quantity "
		#define STR0017 "Current Balance   "
		#define STR0018 "Estimated Delivery Qty"
		#define STR0019 "Sales Order Qty  "
		#define STR0020 "Reserved Qty  "
		#define STR0021 "S.A. Allocated Qty"
		#define STR0022 "Specific"
		#define STR0023 "Attention"
		#define STR0024 "No inventory record for this product."
		#define STR0025 "Purchase history - Last invoices"
		#define STR0026 "Document"
		#define STR0027 "Issue Dt."
		#define STR0028 "Inflow Dt."
		#define STR0029 "Supplier/Customer"
		#define STR0030 "Quantity"
		#define STR0031 "Series"
		#define STR0032 "NF Tp"
		#define STR0033 "Unitary Vl."
		#define STR0034 "View"
		#define STR0035 "No Inbound Invoices registered for this product."
		#define STR0036 "Back"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Valor Liquido" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , " não pode ser utilizado como chave para pesquisa de Documento Origem, devido a filtros da rotina." )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Documentos de Origem" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Operacao Triangular" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Pesquisar por:" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Localizar" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Armazem" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Selecao de Armazens" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Selecione o armazem para devolucao" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Saldos em Estoque" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Qtd. Empenhada" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Qtd. Prevista Entrada" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Qtd.Disponivel" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Sld.Atual" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "TOTAL " )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Quantidade Empenhada " )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Saldo Atual   " )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Qtd. Entrada Prevista" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Qtd. Pedido de Vendas  " )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Qtd. Reservada  " )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Qtd. Empenhada S.A." )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "Especifico" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Atencao" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "Nao registro de estoques para este produto." )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "Historico de compras - Ultimas N.Fiscais" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "Documento" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "Dt. Emissao" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "Dt. Entrada" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", , "Fornecedor/Cliente" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "Quantidade" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", , "Serie" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", , "Tipo NF" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", , "Vlr. Unitario" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", , "Visualizar" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", , "Nao existem Notas Fiscais de Entrada cadastradas para este produto." )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", , "Voltar" )
	#endif
#endif
