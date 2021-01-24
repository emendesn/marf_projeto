#ifdef SPANISH
	#define STR0001 "Este informe tiene por objetivo presentar los valores analiticos generados en el calculo del FCI para las Facturas de entrada."
	#define STR0002 "Relacion FCI Analitica - Factura de entrada"
	#define STR0003 "Items de las Facturas"
	#define STR0004 "Codigo"
	#define STR0005 "Descripcion"
	#define STR0006 "Prov."
	#define STR0007 "Tienda"
	#define STR0008 "Fact. Num."
	#define STR0009 "Serie"
	#define STR0010 "Tipo"
	#define STR0011 "Fch. Ent."
	#define STR0012 "Sit. Trib."
	#define STR0013 "Total Fact."
	#define STR0014 "Vl. Flete"
	#define STR0015 "Vl. Seguro"
	#define STR0016 "I.I."
	#define STR0017 "Vl. ICMS"
	#define STR0018 "Cant. (A)"
	#define STR0019 "Vl. Imp. (B)"
	#define STR0020 "Vl. Imp.UN (C)"
	#define STR0021 "Relacion FCI Analitica - Factura de entrada (Periodo: "
	#define STR0022 "Total del producto (C = B / A)"
	#define STR0023 "IPI"
#else
	#ifdef ENGLISH
		#define STR0001 "This report aims at displaying the detailed values calculated in the FCI calculation for Inflow Invoices."
		#define STR0002 "Detailed FCI Relation - Inflow Invoice"
		#define STR0003 "Invoice Items"
		#define STR0004 "Code"
		#define STR0005 "Description"
		#define STR0006 "Suppl."
		#define STR0007 "Store"
		#define STR0008 "Inv No."
		#define STR0009 "Series"
		#define STR0010 "Type"
		#define STR0011 "Inflow Dt"
		#define STR0012 "Stat. Tax"
		#define STR0013 "Inv. Total"
		#define STR0014 "Value Freight"
		#define STR0015 "Value Insurance"
		#define STR0016 "I.I."
		#define STR0017 "Value ICMS"
		#define STR0018 "Amt. (A)"
		#define STR0019 "Tax Val (B)"
		#define STR0020 "Imp Vl UN (C)"
		#define STR0021 "Detailed FCI Relation - Inflow Invoice (Period: "
		#define STR0022 "Product Total (C = B / A)"
		#define STR0023 "IPI"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Este relatório tem como objetivo apresentar os valores analíticos calculados na apuração do FCI para as Notas Fiscais de Entrada." )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Relação FCI Analítica - NF de Entrada" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Itens das Notas Fiscais" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Código" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Descrição" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Forn." )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Lj" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "NF Num." )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Sr." )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "TP" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Dt. Ent." )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "St.Trib." )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Total NF" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Frete" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Seguro" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "I.I." )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "ICMS" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Quant. (A)" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Vl. Imp. (B)" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Vl. Imp.UN (C)" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Relação FCI Analítica - NF de Entrada (Periodo: " )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "Total do Produto (C = B / A)" )
		#define STR0023 "IPI"
	#endif
#endif
