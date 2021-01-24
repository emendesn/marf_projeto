#ifdef SPANISH
	#define STR0001 "Lote proveedor"
	#define STR0002 "Validez"
	#define STR0003 "Saldos por lote"
	#define STR0004 "Cliente/Proveedor"
	#define STR0005 "Tienda"
	#define STR0006 "Factura"
	#define STR0007 "Producto"
	#define STR0008 "Saldo actual 2daUM"
	#define STR0009 "Sublote"
	#define STR0010 "Fch. Emision"
	#define STR0011 "Lote"
	#define STR0012 "Potencia"
	#define STR0013 "Saldo actual"
	#define STR0014 "Serie"
	#define STR0015 "Busca por : "
	#define STR0016 "Cantidad informada es mayor que la cantidad del lote seleccionado, modifique la cantidad del item"
	#define STR0017 "Cantidad informada es mayor que la cantidad disponible del lote seleccionado, modifique la cantidad liberada del item"
	#define STR0018 "Atencion"
	#define STR0019 "Cantidad superior al saldo de la orden de produccion."
	#define STR0020 "Situacion del stock"
	#define STR0021 "Producto: "
	#define STR0022 "Local: "
	#define STR0023 "Pedido de ventas pendiente"
	#define STR0024 "Cantidad reservada"
	#define STR0025 "Cant. Prevista p/Entrar"
	#define STR0026 "Cantidad reservada (A)"
	#define STR0027 "Saldo actual (B)"
	#define STR0028 "Actualizar CFGX051 e instalar procedures"
	#define STR0029 "Disponible (B - A)"
#else
	#ifdef ENGLISH
		#define STR0001 "Supplier Batch"
		#define STR0002 "Validity"
		#define STR0003 "Balance per Batch"
		#define STR0004 "Customer/Supplier"
		#define STR0005 "Store"
		#define STR0006 "Invoice"
		#define STR0007 "Product"
		#define STR0008 "Current Balance 2aUM"
		#define STR0009 "Sub-batch"
		#define STR0010 "Issue Dt."
		#define STR0011 "Batch"
		#define STR0012 "Power"
		#define STR0013 "Current Balance"
		#define STR0014 "Series"
		#define STR0015 "Search by: "
		#define STR0016 "Quantity entered is higher than quantity available of selected batch, change item quantity"
		#define STR0017 "Quantity entered is higher than quantity available of selected batch, change item release quantity"
		#define STR0018 "Attention"
		#define STR0019 "Quantity higher than production order balance."
		#define STR0020 "Stock Position"
		#define STR0021 "Product: "
		#define STR0022 "Location: "
		#define STR0023 "Pending Sales Order"
		#define STR0024 "Allocated Quantity"
		#define STR0025 "Qty Estimated to Enter"
		#define STR0026 "Reserved Quantity (A)"
		#define STR0027 "Current Balance (B)"
		#define STR0028 "Update CFGX051 and Install Procedures"
		#define STR0029 "Available (B - A)"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Lote Fornecedor" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Validade" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Saldos por Lote" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Cliente/Fornecedor" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Loja" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Nota Fiscal" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Produto" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Saldo Atual 2aUM" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Sub-Lote" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Dt Emissao" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Lote" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Potencia" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Saldo Atual" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Serie" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Pesquisa Por: " )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Quantidade informada e maior que a quantidade do lote selecionado, modifique a quantidade do item" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Quantidade informada e maior que a quantidade disponivel do lote selecionado, modifique a quantidade liberada do item" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Aten��o" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Quantidade superior ao saldo da ordem de produ��o." )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Posi��o do Estoque" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Produto   : " )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "Local    : " )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Pedido de Vendas em Aberto" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "Quantidade Empenhada" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "Qtd.Prevista p/Entrar" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "Quantidade Reservada (A)" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "Saldo Atual (B)" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "Atualizar CFGX051 e Instalar Procedures" )
		#define STR0029 "Dispon�vel (B - A)"
	#endif
#endif
