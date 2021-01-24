#ifdef SPANISH
	#define STR0001 "Pedido"
	#define STR0002 "Producto"
	#define STR0003 "Por favor, verifique los productos que estan en esta condicion para que el Pedido se cargue totalmente."
	#define STR0004 "En el Pedido de compra seleccionado, existen productos que no tienen registro en la Sucursal de entrada de la factura."
	#define STR0005 "Pedido"
	#define STR0006 "Visualiza pedido"
	#define STR0007 "ENCUESTA"
	#define STR0008 "Buscar"
	#define STR0009 "busqueda"
	#define STR0010 "Seleccionar Pedido de compra (por item)"
	#define STR0011 "Producto"
	#define STR0012 "Seleccione el Pedido de compra"
	#define STR0013 "Proveedor:"
	#define STR0014 "El Producto seleccionado del Pedido de compra no tiene registro en la Sucursal de entrada de la factura. Por favor, realice el registro."
	#define STR0015 "Consulta al Pedido de compra"
	#define STR0016 "Consulta Autorizacion de entrega"
	#define STR0017 "Consulta al Pedido de compra"
	#define STR0018 "Pedido"
	#define STR0019 "Visualiza pedido"
	#define STR0020 "ENCUESTA"
	#define STR0021 "Para documentos con lote do PLS solo se permite un pedido."
	#define STR0022 "Emision"
	#define STR0023 "Tienda"
	#define STR0024 "Origen"
	#define STR0025 "Pedido"
	#define STR0026 "Emision"
	#define STR0027 "Tienda"
	#define STR0028 "Origen"
	#define STR0029 "Pedido"
	#define STR0030 "Seleccionar Pedido de compra"
	#define STR0031 "Proveedor"
	#define STR0032 "Contiene"
	#define STR0033 "Exacta"
	#define STR0034 "Parcial"
	#define STR0035 "Buscar"
#else
	#ifdef ENGLISH
		#define STR0001 "Order"
		#define STR0002 "Product"
		#define STR0003 "Check products in this condition in order to completely load the Order !"
		#define STR0004 "On the selected Purchase Order, there are products without record on the Inbound Branch of the Invoice."
		#define STR0005 "Order"
		#define STR0006 "Order View"
		#define STR0007 "SEARCH"
		#define STR0008 "Search"
		#define STR0009 "search"
		#define STR0010 "Select Purchase Order ( per item )"
		#define STR0011 "Product"
		#define STR0012 "Select Purchase Request"
		#define STR0013 "Supplier:"
		#define STR0014 "The product selected from the Purchase Order has no record on the Inbound Branch of the Invoice. Register it !"
		#define STR0015 "Purchase Order Query"
		#define STR0016 "Delivery Authorization Query"
		#define STR0017 "Purchase Order Query"
		#define STR0018 "Order"
		#define STR0019 "Order View"
		#define STR0020 "SEARCH"
		#define STR0021 "For documents with lot PLS is allowed only in order."
		#define STR0022 "Issue"
		#define STR0023 "Store"
		#define STR0024 "Source"
		#define STR0025 "Order"
		#define STR0026 "Issue"
		#define STR0027 "Store"
		#define STR0028 "Source"
		#define STR0029 "Order"
		#define STR0030 "Select Purchase Order"
		#define STR0031 "Supplier"
		#define STR0032 "Contains"
		#define STR0033 "Exact"
		#define STR0034 "Partial"
		#define STR0035 "Search"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Pedido" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Produto" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Favor verificar o(s) produto(s) que estejam nesta condi��o para que o Pedido seja carregado totalmente !" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "No Pedido de Compra selecionado, existem produto(s) que n�o possuem cadastro na Filial de Entrada da Nota Fiscal." )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Pedido" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Visualiza Pedido" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "PESQUISA" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Pesquisar" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "pesquisa" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Selecionar Pedido de Compra ( por item )" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Produto" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Selecione o Pedido de Compra" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Fornecedor:" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "O Produto selecionado do Pedido de compra, n�o possui cadastro na Filial de Entrada da Nota Fiscal. Favor efetuar cadastro !" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Consulta ao Pedido de Compra" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Consulta Autoriza��o de Entrega" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Consulta ao Pedido de Compra" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Pedido" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Visualiza Pedido" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "PESQUISA" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Para documentos com lote do PLS, � permitido somente um pedido." )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "Emissao" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Loja" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "Origem" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "Pedido" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "Emissao" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "Loja" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "Origem" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", , "Pedido" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "Selecionar Pedido de Compra" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", , "Fornecedor" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", , "Contem" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", , "Exata" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", , "Parcial" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", , "Pesquisar" )
	#endif
#endif
