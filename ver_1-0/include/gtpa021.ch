#ifdef SPANISH
	#define STR0001 "Tasa de embarque"
	#define STR0002 "Encabezamiento"
	#define STR0003 "Total"
	#define STR0004 "Tasa embarque"
	#define STR0005 "Encabezamiento"
	#define STR0006 "Totales por día"
	#define STR0007 "Cantidad"
	#define STR0008 "Cantidad"
	#define STR0009 "Valor"
	#define STR0010 "Cant. Pasaje"
	#define STR0011 "Cant. Pasaje"
	#define STR0012 "TS"
	#define STR0013 "Se generó título: "
	#define STR0014 "Prefijo: "
	#define STR0015 "Número: "
	#define STR0016 "Tipo: TS"
	#define STR0017 "Proveedor: "
	#define STR0018 "Valor: "
	#define STR0019 "Título por pagar: "
#else
	#ifdef ENGLISH
		#define STR0001 "Shipment Rate"
		#define STR0002 "Header"
		#define STR0003 "Total"
		#define STR0004 "Shipment Rate"
		#define STR0005 "Header"
		#define STR0006 "Totals per day"
		#define STR0007 "Quantity"
		#define STR0008 "Quantity"
		#define STR0009 "Value"
		#define STR0010 "Qty. Ticket"
		#define STR0011 "Qty. Ticket"
		#define STR0012 "TX"
		#define STR0013 "Bill was Generated: "
		#define STR0014 "Prefix: "
		#define STR0015 "Number: "
		#define STR0016 "Type: TX"
		#define STR0017 "Supplier: "
		#define STR0018 "Value: "
		#define STR0019 "Payable Bill: "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Taxa de Embarque" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Cabeçalho" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Total" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Taxa Emabarque" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Cabeçalho" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Totais por dia" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Quantidade" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Quantidade" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Valor" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Qtd. Passagem" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Qtd. Passagem" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "TX" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Foi Gerado Titulo: " )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Prefixo: " )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Numero: " )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Tipo: TX" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Fornecedor: " )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Valor: " )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Titulo a Pagar: " )
	#endif
#endif
