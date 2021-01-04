#ifdef SPANISH
	#define STR0001 "Stock de fardos por tipo de clasificacion"
	#define STR0002 "Stock de fardos por Tipo/Produtor"
	#define STR0003 "Productor"
	#define STR0004 "Tipo"
	#define STR0005 "%Rd"
	#define STR0006 "Ctd. Fardos"
	#define STR0007 "Ctd. Reservas"
	#define STR0008 "Ctd. Salidas"
	#define STR0009 "Ctd. Saldo"
	#define STR0010 "Fardos (KG)"
	#define STR0011 "Reservas (KG)"
	#define STR0012 "Salidas (KG)"
	#define STR0013 "Saldo (KG)"
	#define STR0014 "Total General"
	#define STR0015 "Total Productor"
	#define STR0016 "Resumen por tipo de clasificacion"
	#define STR0017 "Bloques"
	#define STR0018 "Aguarde...."
	#define STR0019 "Processando registro -> "
	#define STR0020 "Sem Classificação"
#else
	#ifdef ENGLISH
		#define STR0001 "Stock of Bales per Classification Type"
		#define STR0002 "Stock of Bales per Type/Producer"
		#define STR0003 "Producer"
		#define STR0004 "Type"
		#define STR0005 "Rd%"
		#define STR0006 "Bales Qty"
		#define STR0007 "Reserves Qty"
		#define STR0008 "Outflows Qty"
		#define STR0009 "Balance Qty"
		#define STR0010 "Bales (KG)"
		#define STR0011 "Reserves (KG)"
		#define STR0012 "Outflows (KG)"
		#define STR0013 "Balance (KG)"
		#define STR0014 "Grand Total"
		#define STR0015 "Producer Total"
		#define STR0016 "Summary per Classification Type"
		#define STR0017 "Blocks"
		#define STR0018 "Wait..."
		#define STR0019 "Processing record -> "
		#define STR0020 "Without Classification"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Stock de fardos por tipo classificação", "Estoque de Fardos por Tipo Classificação" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Stock de fardos por Tipo/Produtor", "Estoque de Fardos por Tipo/Produtor" )
		#define STR0003 "Produtor"
		#define STR0004 "Tipo"
		#define STR0005 "%Rd"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Qtd. Fardos", "Qt Fardos" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Qtd. Reservas", "Qt Reservas" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Qtd. Saídas", "Qt Saídas" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Qtd. Saldo", "Qt Saldo" )
		#define STR0010 "Fardos (KG)"
		#define STR0011 "Reservas (KG)"
		#define STR0012 "Saídas (KG)"
		#define STR0013 "Saldo (KG)"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Total geral", "Total Geral" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Total produtor", "Total Produtor" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Resumo por tipo classificação", "Resumo por Tipo Classificação" )
		#define STR0017 "Blocos"
		#define STR0018 "Aguarde...."
		#define STR0019 "Processando registro -> "
		#define STR0020 "Sem Classificação"
	#endif
#endif
