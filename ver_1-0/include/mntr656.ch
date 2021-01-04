#ifdef SPANISH
	#define STR0001 "Informe de Estacion de servicios de combustibles, con informaciones de los abastecimientos"
	#define STR0002 "realizados en un determinado periodo informado.                        "
	#define STR0003 "Informe de facturas por puesto"
	#define STR0004 "¿Puesto              ?"
	#define STR0005 "¿Tienda            ?"
	#define STR0006 "¿De Fecha Emision    ?"
	#define STR0007 "¿A Fecha Emision   ?"
	#define STR0008 "¿De Factura     ?"
	#define STR0009 "¿A Factura    ?"
	#define STR0010 "Fact         Fc.Emision  Placa     Flota             Fc.Abast.   Hora         Cant  Valor Total(R$)   Hodometro  Conductor"
	#define STR0011 "Espere..."
	#define STR0012 "Procesando Registros..."
	#define STR0013 "Puesto:"
	#define STR0014 "CNPJ:"
	#define STR0015 "Total de la Factura"
#else
	#ifdef ENGLISH
		#define STR0001 "Report of Gas Stations, with information about refueling"
		#define STR0002 "made within a specific period.                                         "
		#define STR0003 "Invoice Report by station"
		#define STR0004 "Station            ?"
		#define STR0005 "Unit               ?"
		#define STR0006 "From Issue Date    ?"
		#define STR0007 "To Issue Date      ?"
		#define STR0008 "From Invoice      ?"
		#define STR0009 "To Invoice        ?"
		#define STR0010 "Inv.         Issue Date  Plate     Fleet             Refu.Dt.    Hour         Amt   Total Value(R$)   Odometer  Driver"
		#define STR0011 "Wait..."
		#define STR0012 "Processing Records..."
		#define STR0013 "Station:"
		#define STR0014 "CNPJ:"
		#define STR0015 "Invoice Total"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Listagem de postos de combustíveis, com informações dos abastecimentos", "Relatorio de Postos de combustiveis, com informacoes dos abastecimentos" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Realizados num determinado período digitado.                        ", "realizados em um determinado periodo informado.                        " )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Listagem de facturas por posto", "Relatorio de notas fiscais por posto" )
		#define STR0004 "Posto              ?"
		#define STR0005 "Loja               ?"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Da data de emissão    ?", "De Data Emissao    ?" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Até à data de emissão   ?", "Ate Data Emissao   ?" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Da factura     ?", "De Nota Fiscal     ?" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Até à factura    ?", "Ate Nota Fiscal    ?" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Fact         Dt.Emissão  Placa     Frota             Dt.Abast.   Hora         Qtd.  Valor Total(R$)   Hodómetro  Conductor", "Nota         Dt.Emissao  Placa     Frota             Dt.Abast.   Hora         Qtde  Valor Total(R$)   Hodometro  Motorista" )
		#define STR0011 "Aguarde..."
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "A Processar Registos...", "Processando Registros..." )
		#define STR0013 "Posto:"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Nif:", "CNPJ:" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Total Da Factura", "Total da Nota Fiscal" )
	#endif
#endif
