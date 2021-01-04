#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Imprimir"
	#define STR0004 "Consulta/Informe de Abastecimiento por fecha y puesto"
	#define STR0005 "�De Fecha?"
	#define STR0006 "At� Data?"
	#define STR0007 "C�digo do Posto?"
	#define STR0008 "�CNPJ?"
	#define STR0009 "Procesando Registros..."
	#define STR0010 "Usuario"
	#define STR0011 "N� de la Factura"
	#define STR0012 "Valor Total"
	#define STR0013 "Fecha Abast."
	#define STR0014 "Litraje"
	#define STR0015 "Km"
	#define STR0016 "Ciudad"
	#define STR0017 "UF"
	#define STR0018 "Placa"
	#define STR0019 "CNPJ"
	#define STR0020 "No hay abastecimientos para exhibir"
	#define STR0021 "Aten��o"
	#define STR0022 "NO CONFORMIDAD"
	#define STR0023 "Solamente se permite informar el"
	#define STR0024 "o"
	#define STR0025 "�Tipo combustible?"
	#define STR0026 "Relat�rio dos abastecimentos"
	#define STR0027 "A Rayas"
	#define STR0028 "Administra��o"
	#define STR0029 "Abastecimientos por fecha y puesto"
	#define STR0030 "Veiculo    Nota        Posto                                     Km   Lts Abast   Vlr Unit        Vlr Abastec Motorista                                             CNPJ"
	#define STR0031 "Total"
	#define STR0032 "Relat�rio de"
	#define STR0033 "General"
	#define STR0034 "Clasificar"
	#define STR0035 "Fecha"
	#define STR0036 "Puesto"
	#define STR0037 "Veiculo    Nota               Km   Lts Abast   Vlr Unit        Vlr Abastec Motorista                                      CNPJ"
	#define STR0038 "Tienda"
	#define STR0039 "�Tienda            ?"
	#define STR0040 "�Nombre Fantasia   ?"
	#define STR0041 "Espere..."
	#define STR0042 "Informe o C�digo do Posto"
	#define STR0043 "�Fecha final no puede ser inferior a la fecha inicial!"
	#define STR0044 "Flota"
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Print"
		#define STR0004 "Supply Query/Report by date and station"
		#define STR0005 "From Date?"
		#define STR0006 "To Date?"
		#define STR0007 "Station Code?"
		#define STR0008 "CNPJ?"
		#define STR0009 "Processing Records..."
		#define STR0010 "User"
		#define STR0011 "Invoice Number"
		#define STR0012 "Total Value"
		#define STR0013 "Supply Date"
		#define STR0014 "Liters"
		#define STR0015 "Km"
		#define STR0016 "Town"
		#define STR0017 "State"
		#define STR0018 "Plate"
		#define STR0019 "CNPJ"
		#define STR0020 "No supplies to be displayed"
		#define STR0021 "Attention"
		#define STR0022 "NON-CONFORMANCE"
		#define STR0023 "You can only enter"
		#define STR0024 "or"
		#define STR0025 "Fuel type?"
		#define STR0026 "Fueling report"
		#define STR0027 "Z-form"
		#define STR0028 "Administration"
		#define STR0029 "Supplies by date and station"
		#define STR0030 "Vehicle    Invoice        Station                                     Km   Lts Fueling   Unit Vl        Fueling Vl Driver                                             CNPJ"
		#define STR0031 "Total"
		#define STR0032 "Report of"
		#define STR0033 "General"
		#define STR0034 "Classify"
		#define STR0035 "Date"
		#define STR0036 "Station"
		#define STR0037 "Vehicle    Invoice               Km   Lts Fueling   Unit Vl        Fueling Vl Driver                                      CNPJ"
		#define STR0038 "Unit"
		#define STR0039 "Unit               ?"
		#define STR0040 "Company Name       ?"
		#define STR0041 "Wait..."
		#define STR0042 "Enter Gas Station Code"
		#define STR0043 "Final date cannot be earlier than initial date!"
		#define STR0044 "Fleet"
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Imprimir"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Consulta/listagem de abastecimento por data e posto", "Consulta/Relatorio de Abastecimento por data e posto" )
		#define STR0005 "De Data?"
		#define STR0006 "At� Data?"
		#define STR0007 "C�digo do Posto?"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Nr. de contribuinte", "CNPJ?" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "A Processar Registos...", "Processando Registros..." )
		#define STR0010 "Usuario"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Nr. Da Notifica��o", "N. da Nota" )
		#define STR0012 "Valor Total"
		#define STR0013 "Data Abast."
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Litros", "Litragem" )
		#define STR0015 "Km"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Concelho", "Cidade" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Uf", "UF" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Matr�cula", "Placa" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Cnpj", "CNPJ" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "N�o h� abastecimentos para serem mostrados", "Nao ha abastecimentos para serem exibidos" )
		#define STR0021 "Aten��o"
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "N�o Conformidade", "NAO CONFORMIDADE" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", " � permitido somente informar o", "Somente e permitido informar o" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Ou", "ou" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Tipo de combust�vel?", "Tipo combustivel?" )
		#define STR0026 "Relat�rio dos abastecimentos"
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "C�digo de barras", "Zebrado" )
		#define STR0028 "Administra��o"
		#define STR0029 "Abastecimentos por data e posto"
		#define STR0030 "Veiculo    Nota        Posto                                     Km   Lts Abast   Vlr Unit        Vlr Abastec Motorista                                             CNPJ"
		#define STR0031 "Total"
		#define STR0032 "Relat�rio de"
		#define STR0033 "Geral"
		#define STR0034 "Classificar"
		#define STR0035 "Data"
		#define STR0036 "Posto"
		#define STR0037 "Veiculo    Nota               Km   Lts Abast   Vlr Unit        Vlr Abastec Motorista                                      CNPJ"
		#define STR0038 "Loja"
		#define STR0039 "Loja               ?"
		#define STR0040 If( cPaisLoc $ "ANG|PTG", "Nome comercial   ?", "Nome Fantasia      ?" )
		#define STR0041 "Aguarde..."
		#define STR0042 "Informe o C�digo do Posto"
		#define STR0043 "Data final n�o pode ser inferior � data inicial!"
		#define STR0044 "Frota"
	#endif
#endif