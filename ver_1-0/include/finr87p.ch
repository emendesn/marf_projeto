#ifdef SPANISH
	#define STR0001 "COMPROBANTE DE PERCEPCION DE IGV"
	#define STR0002 "No existe informacion para este comprobante"
	#define STR0003 "RUC"
	#define STR0004 "COMPROBANTE DE PERCEPCION"
	#define STR0005 "VENTA INTERNA"
	#define STR0006 " - "
	#define STR0007 "Senor(es)"
	#define STR0008 "Fecha de Emision:"
	#define STR0009 "Comprobante de Pago o Factura de"
	#define STR0010 "Debito del Cliente"
	#define STR0011 "Tipo"
	#define STR0012 "Serie-Nro"
	#define STR0013 "Precio de"
	#define STR0014 "Venta"
	#define STR0015 "Porcentaje"
	#define STR0016 "de Percepcion"
	#define STR0017 "Valor de"
	#define STR0018 "Percepcion"
	#define STR0019 "Valor Total"
	#define STR0020 "Cobrado"
	#define STR0021 "Cliente"
	#define STR0022 "EMISOR"
	#define STR0023 "SUNAT"
	#define STR0024 "Valor Total de Percepcion"
	#define STR0025 "Cancelado"
	#define STR0026 "Tipo y numero de documento de identidad del cliente"
#else
	#ifdef ENGLISH
		#define STR0001 "IGV PERCEPTION STATEMENT"
		#define STR0002 "There are no data for this statement"
		#define STR0003 "RUC"
		#define STR0004 "PERCEPTION STATEMENT"
		#define STR0005 "INTERNAL SALES"
		#define STR0006 "-"
		#define STR0007 "Mr."
		#define STR0008 "Issue Date:"
		#define STR0009 "Payment or Invoice Statement"
		#define STR0010 "Debt Client"
		#define STR0011 "Type"
		#define STR0012 "Series - Number"
		#define STR0013 "Price from"
		#define STR0014 "Sale"
		#define STR0015 "Percentage"
		#define STR0016 "from Perception"
		#define STR0017 "Value from"
		#define STR0018 "Perception"
		#define STR0019 "Total value"
		#define STR0020 "Charged"
		#define STR0021 "CLIENT"
		#define STR0022 "ISSUER"
		#define STR0023 "SUNAT"
		#define STR0024 "Perception Total Value"
		#define STR0025 "Canceled"
		#define STR0026 "Type and number of customer identity document"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "COMPROVANTE DE PERCEP��O DE IGV", "COMPROVANTE DE PERCEPCAO DE IGV" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "N�o existem informa��es para este comprovante", "N�o existe informa��es para este comprovante" )
		#define STR0003 "RUC"
		#define STR0004 "COMPROVANTE DE PERCEP��O"
		#define STR0005 "VENDA INTERNA"
		#define STR0006 " - "
		#define STR0007 "Senhor(es)"
		#define STR0008 "Data de Emiss�o:"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Comprovante de Pagamento ou Factura de", "Comprovante de Pagamento ou Nota de" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "D�bito do Cliente", "Debito do Cliente" )
		#define STR0011 "Tipo"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "S�rie-Nr.", "Serie-Nro" )
		#define STR0013 "Pre�o de"
		#define STR0014 "Venda"
		#define STR0015 "Porcentagem"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "de percep��o", "de Percep��o" )
		#define STR0017 "Valor de"
		#define STR0018 "Percep��o"
		#define STR0019 "Valor Total"
		#define STR0020 "Cobrado"
		#define STR0021 "CLIENTE"
		#define STR0022 "EMISSOR"
		#define STR0023 "SUNAT"
		#define STR0024 "Valor Total de Percep��o"
		#define STR0025 "Cancelado"
		#define STR0026 "Tipo e numero de documento da intidade do cliente"
	#endif
#endif
