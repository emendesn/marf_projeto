#ifdef SPANISH
	#define STR0001 "B&usqueda"
	#define STR0002 "Consulta"
	#define STR0003 "Consulta Ventas"
	#define STR0004 "Presupuesto:"
	#define STR0005 "Detalles de la Venta"
	#define STR0006 "Cliente-Sucursal"
	#define STR0007 "Vendedor"
	#define STR0008 "Condiciones de Pago"
	#define STR0009 "Total de las Mercaderias"
	#define STR0010 "Credito/Descuento"
	#define STR0011 "Credito "
	#define STR0012 "Descuento"
	#define STR0013 "Total de la Venta"
	#define STR0014 "Dinero "
	#define STR0015 "Cheque"
	#define STR0016 "Tarjeta"
	#define STR0017 "Convenio"
	#define STR0018 "Vale"
	#define STR0019 "Financiado"
	#define STR0020 "Recortar"
	#define STR0021 "Copiar"
	#define STR0022 "Pegar"
	#define STR0023 "Calculadora..."
	#define STR0024 "Agenda..."
	#define STR0025 "Administrador de Impresion..."
	#define STR0026 "Help de Programa..."
	#define STR0027 "Detalles..(CTRL-T)"
	#define STR0028 "OK - <Ctrl-O>"
	#define STR0029 "Tarjeta de Debito"
	#define STR0030 "Moneda:"
	#define STR0031 "Tasa Moneda:"
	#define STR0032 "Recortar"
	#define STR0033 "Calc."
	#define STR0034 "Agenda"
	#define STR0035 "Gen.Imp."
	#define STR0036 "Help"
	#define STR0037 "Detalles"
	#define STR0038 "OK"
	#define STR0039 "Otros:"
	#define STR0040 "Cond.Negociada"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "Query   "
		#define STR0003 "Sale Query     "
		#define STR0004 "Budget:    "
		#define STR0005 "Sale Datails     "
		#define STR0006 "Customer-Unit"
		#define STR0007 "Seller  "
		#define STR0008 "Payment Terms      "
		#define STR0009 "Total of Goods       "
		#define STR0010 "Credit/Discont  "
		#define STR0011 "Credit  "
		#define STR0012 "Discont "
		#define STR0013 "Sale Total    "
		#define STR0014 "Cash    "
		#define STR0015 "Cheque"
		#define STR0016 "Card  "
		#define STR0017 "Convnetion"
		#define STR0018 "Voucher"
		#define STR0019 "Debitor   "
		#define STR0020 "Cut     "
		#define STR0021 "Copy  "
		#define STR0022 "Paste"
		#define STR0023 "Calculator... "
		#define STR0024 "Schedule."
		#define STR0025 "Printer Manager...         "
		#define STR0026 "Program Help...    "
		#define STR0027 "Details...(CTRL-T)"
		#define STR0028 "Ok - <Ctrl-O>"
		#define STR0029 "Debit Card"
		#define STR0030 "Currency:"
		#define STR0031 "Currency Tax:"
		#define STR0032 "Cut    "
		#define STR0033 "Calc."
		#define STR0034 "Agenda"
		#define STR0035 "Ger.Prt."
		#define STR0036 "Help"
		#define STR0037 "Details "
		#define STR0038 "OK"
		#define STR0039 "Others:"
		#define STR0040 "Negotiated Cond."
	#else
		#define STR0001 "Pesq."
		#define STR0002 "Consulta"
		#define STR0003 "Consulta Vendas"
		#define STR0004 "Or�amento: "
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Detalhes Da Venda", "Detalhes da Venda" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Cliente-loja", "Cliente-Loja" )
		#define STR0007 "Vendedor"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Condi��es De Pagamento.", "Condi��es de Pagto." )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Total Das Mercadorias", "Total das Mercadorias" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Cr�dito/desconto", "Cr�dito/Desconto" )
		#define STR0011 "Cr�dito "
		#define STR0012 "Desconto"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Total Da Venda", "Total da Venda" )
		#define STR0014 "Dinheiro"
		#define STR0015 "Cheque"
		#define STR0016 "Cart�o"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "AcorUdo", "Conv�nio" )
		#define STR0018 "Vale"
		#define STR0019 "Financiado"
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Cortar", "Recortar" )
		#define STR0021 "Copiar"
		#define STR0022 "Colar"
		#define STR0023 "Calculadora..."
		#define STR0024 "Agenda..."
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Gestor De Impress�o...", "Gerenciador de Impress�o..." )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Ajuda Do Programa...", "Help de Programa..." )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Detalhes..(ctrl-t)", "Detalhes..(CTRL-T)" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Ok - <ctrl-o>", "Ok - <Ctrl-O>" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Cart�o D�bito", "Cart�o D�bito" )
		#define STR0030 "Moeda:"
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Taxa Da Moeda:", "Taxa Moeda:" )
		#define STR0032 "Recort."
		#define STR0033 "Calc."
		#define STR0034 "Agenda"
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "Ger.imp.", "Ger.Imp." )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "Ajuda", "Help" )
		#define STR0037 "Detalhes"
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "Ok", "OK" )
		#define STR0039 "Outros:"
		#define STR0040 "Cond.Negociada"
	#endif
#endif
