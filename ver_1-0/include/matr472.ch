#ifdef SPANISH
	#define STR0001 "Atenci�n"
	#define STR0002 "Ingresa el n�mero de remisi�n final"
	#define STR0003 "OK"
	#define STR0004 "Ingresa la serie de remisi�n"
	#define STR0005 "No existen remisiones dentro de los rangos seleccionados"
	#define STR0006 "Remisiones de Venta"
	#define STR0007 "Fecha Emision"
	#define STR0008 "Valor Bruto"
	#define STR0009 "Importe letra"
	#define STR0010 "Transportadora"
	#define STR0011 "Direccion"
	#define STR0012 "NombreEstado"
	#define STR0013 "Descripcion"
	#define STR0014 "Valor Unit."
	#define STR0015 "Valor Total"
	#define STR0016 "Fecha Validez"
	#define STR0017 "Remision Inicial"
	#define STR0018 "Remision Final"
	#define STR0019 "Serie"
	#define STR0020 "Tipo"
	#define STR0021 "No hay datos que cumplan la condicion "
#else
	#ifdef ENGLISH
		#define STR0001 "Attention"
		#define STR0002 "Enter final shipment number"
		#define STR0003 "Ok"
		#define STR0004 "Enter shipment series"
		#define STR0005 "No shipments found in selected ranges"
		#define STR0006 "Sales shipments"
		#define STR0007 "Issue Date"
		#define STR0008 "Gross Value"
		#define STR0009 "Letter import"
		#define STR0010 "Carrier"
		#define STR0011 "Address"
		#define STR0012 "State name"
		#define STR0013 "Description"
		#define STR0014 "Unit Value"
		#define STR0015 "Total Value"
		#define STR0016 "Expiration date"
		#define STR0017 "Initial shipment"
		#define STR0018 "Final shipment"
		#define STR0019 "Series"
		#define STR0020 "Type"
		#define STR0021 "No data meet the term"
	#else
		#define STR0001 If( cPaisLoc $ "ARG|MEX|ANG|PTG", "Atenci�n", "Aten��o" )
		#define STR0002 If( cPaisLoc $ "ARG|MEX|ANG|PTG", "Ingresa el n�mero de remisi�n final", "Insira o n�mero de remessa final" )
		#define STR0003 If( cPaisLoc $ "ARG|MEX|ANG|PTG", "OK", "Ok" )
		#define STR0004 If( cPaisLoc $ "ARG|MEX|ANG|PTG", "Ingresa la serie de remisi�n", "Insira a s�rie de remessa" )
		#define STR0005 If( cPaisLoc $ "ARG|MEX|ANG|PTG", "No existen remisiones dentro de los rangos seleccionados", "N�o h� remessas dentro das faixas selecionadas" )
		#define STR0006 If( cPaisLoc $ "ARG|MEX|ANG|PTG", "Remisiones de Venta", "Remessas de venda" )
		#define STR0007 If( cPaisLoc $ "ARG|MEX|ANG|PTG", "Fecha Emision", "Data emiss�o" )
		#define STR0008 If( cPaisLoc $ "ARG|MEX|ANG|PTG", "Valor Bruto", "Valor bruto" )
		#define STR0009 "Importe letra"
		#define STR0010 "Transportadora"
		#define STR0011 If( cPaisLoc $ "ARG|MEX|ANG|PTG", "Direccion", "Endere�o" )
		#define STR0012 If( cPaisLoc $ "ARG|MEX|ANG|PTG", "NombreEstado", "Nome Estado" )
		#define STR0013 If( cPaisLoc $ "ARG|MEX|ANG|PTG", "Descripcion", "Descri��o" )
		#define STR0014 If( cPaisLoc $ "ARG|MEX|ANG|PTG", "Valor Unit.", "Valor unit." )
		#define STR0015 If( cPaisLoc $ "ARG|MEX|ANG|PTG", "Valor Total", "Valor total" )
		#define STR0016 If( cPaisLoc $ "ARG|MEX|ANG|PTG", "Fecha Validez", "Data validade" )
		#define STR0017 If( cPaisLoc $ "ARG|MEX|ANG|PTG", "Remision Inicial", "Remessa inicial" )
		#define STR0018 If( cPaisLoc $ "ARG|MEX|ANG|PTG", "Remision Final", "Remessa final" )
		#define STR0019 If( cPaisLoc $ "ARG|MEX|ANG|PTG", "Serie", "S�rie" )
		#define STR0020 "Tipo"
		#define STR0021 If( cPaisLoc $ "ARG|MEX|ANG|PTG", "No hay datos que cumplan la condicion ", "N�o h� dados quem cumpram a condi��o" )
	#endif
#endif
