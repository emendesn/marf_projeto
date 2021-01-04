#ifdef SPANISH
	#define STR0001 "Procesamiento de Pedidos de compra"
	#define STR0002 "No hay proveedores por consultar."
	#define STR0003 "Resultado de la busqueda"
	#define STR0004 "Atencion"
	#define STR0005 "Pedido Numero: "
	#define STR0006 "Volver"
	#define STR0007 "Buscar"
	#define STR0008 "De fecha:"
	#define STR0009 "A fecha:"
	#define STR0010 "Busqueda avanzada:"
	#define STR0011 "Numero del pedido"
	#define STR0012 "Totales/Descuentos/Flete/Gastos"
	#define STR0013 "Valor Total"
	#define STR0014 "Valor Seguro"
	#define STR0015 "Valor Gastos"
	#define STR0016 "Valor Flete"
	#define STR0017 "Items"
	#define STR0018 "Accion"
	#define STR0019 "ABIERTO"
	#define STR0020 "CERRADO"
#else
	#ifdef ENGLISH
		#define STR0001 "Purchase Order Processing         "
		#define STR0002 "No suppliers to search.         "
		#define STR0003 "Search results:"
		#define STR0004 "Attention"
		#define STR0005 "Oder number: "
		#define STR0006 "Return"
		#define STR0007 "Search"
		#define STR0008 "Date from:"
		#define STR0009 "Date to:"
		#define STR0010 "Advanced search:"
		#define STR0011 "Order Number"
		#define STR0012 "Total/Discounts/Freight/Expenses"
		#define STR0013 "Total Value"
		#define STR0014 "Insurance Value"
		#define STR0015 "Expenses Value "
		#define STR0016 "Freight Value"
		#define STR0017 "Items"
		#define STR0018 "Share"
		#define STR0019 "OPEN"
		#define STR0020 "CLOSED"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Processamento de pedidos de compra", "Processamento de Pedidos de compra" )
		#define STR0002 "N�o h� fornecedores a consultar."
		#define STR0003 "Resultado da Busca"
		#define STR0004 "Aten��o"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Pedido n�mero: ", "Pedido N�mero: " )
		#define STR0006 "Voltar"
		#define STR0007 "Buscar"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Data de:", "Data de  :" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Data at�:", "Data at� :" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Busca Avan�ada:", "Busca Avan�ada :" )
		#define STR0011 "N�mero do Pedido"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Totais/Descontos/Transporte/Despesas", "Totais/Descontos/Frete/Despesas" )
		#define STR0013 "Valor Total"
		#define STR0014 "Valor Seguro"
		#define STR0015 "Valor Despesas"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Valor Transporte", "Valor Frete" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Elementos", "Itens" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Ac��o", "A��o" )
		#define STR0019 "ABERTO"
		#define STR0020 "FECHADO"
	#endif
#endif
