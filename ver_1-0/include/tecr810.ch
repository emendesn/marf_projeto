#ifdef SPANISH
	#define STR0001 "Factura de asignacion"
	#define STR0002 "Factura de servicio"
	#define STR0003 "Modalidad de operacion"
	#define STR0004 "Alquiler de equipamientos"
	#define STR0005 "Cliente"
	#define STR0006 "Direccion"
	#define STR0007 "Item de la factura"
	#define STR0008 "Item"
	#define STR0009 "Un."
	#define STR0010 "Cant."
	#define STR0011 "Unit."
	#define STR0012 "Descuento"
	#define STR0013 "Total"
	#define STR0014 "Periodo"
	#define STR0015 "Observaciones"
	#define STR0016 "Cont. Obs."
	#define STR0017 "Transportadora"
	#define STR0018 "Valor del flete"
	#define STR0019 "Informe el contrato"
	#define STR0020 "Contrato"
	#define STR0021 "Informe la revision."
	#define STR0022 "Revision"
	#define STR0023 "Informe la medicion"
	#define STR0024 "Medición"
	#define STR0025 "Sintetico/Analitico"
	#define STR0026 "Sintetico/Analitico:"
	#define STR0027 "Analitico"
	#define STR0028 "Sintetico"
#else
	#ifdef ENGLISH
		#define STR0001 "Rental Invoice"
		#define STR0002 "Service Invoice"
		#define STR0003 "Operation Class"
		#define STR0004 "Equipment Location"
		#define STR0005 "Customer"
		#define STR0006 "Address"
		#define STR0007 "Invoice Items"
		#define STR0008 "Item"
		#define STR0009 "Un."
		#define STR0010 "Amt."
		#define STR0011 "Unit."
		#define STR0012 "Discount"
		#define STR0013 "Total"
		#define STR0014 "Period"
		#define STR0015 "Notes"
		#define STR0016 "Note Cont."
		#define STR0017 "Carrier"
		#define STR0018 "Freight value"
		#define STR0019 "Enter the contract"
		#define STR0020 "Contract?"
		#define STR0021 "Enter the revision"
		#define STR0022 "Review?"
		#define STR0023 "Enter measurement"
		#define STR0024 "Measurement?"
		#define STR0025 "Summary/Detailed"
		#define STR0026 "Summary/Detailed ?:"
		#define STR0027 "Detailed"
		#define STR0028 "Summarized"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Fatura da Locação" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Fatura de Serviço" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Natureza Operação" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Locação de Equipamentos" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Cliente" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Endereço" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Itens da Nota" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Item" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Un." )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Quant." )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Unit." )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Desconto" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Total" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Período" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Observações" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Cont.Obs." )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Transportadora" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Valor do Frete" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Informe o contrato" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Contrato?" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Informe a revisão" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "Revisão?" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Informe a medição" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "Medição?" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "Sintetico/Analitico" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "Sintetico/Analitico ?:" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "Analitico" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "Sintetico" )
	#endif
#endif
