#ifdef SPANISH
	#define STR0001 "Consulta de Documentos de Flete"
	#define STR0002 "Recibido"
	#define STR0003 "Bloqueado"
	#define STR0004 "Aprobado por el Sistema"
	#define STR0005 "Aprobado por el Usuario"
	#define STR0006 "Buscar"
	#define STR0007 "Visualizar"
	#define STR0008 "Verificacion"
	#define STR0009 "Imprimir"
	#define STR0010 "Campo"
	#define STR0011 "Informado"
	#define STR0012 "Calculado"
	#define STR0013 "Diferencia"
	#define STR0014 "Aprobacion de Documento de Flete"
	#define STR0015 "Diferencias"
	#define STR0016 "Sucursal: "
	#define STR0017 "Especie: "
	#define STR0018 "Emisor: "
	#define STR0019 "Documentos de Carga"
	#define STR0020 "Procesando informaciones"
	#define STR0021 "Espere"
	#define STR0022 "Cantidad de Volumenes"
	#define STR0023 "Peso Real"
	#define STR0024 "Peso Cubicado"
	#define STR0025 "Volumen"
	#define STR0026 "Valor de los items"
	#define STR0027 "Flete Unidad"
	#define STR0028 "Flete Valor"
	#define STR0029 "Tasas"
	#define STR0030 "Valor de Peaje"
	#define STR0031 "Valor total del Flete"
	#define STR0032 "Alicuota"
	#define STR0033 "Valor del Impuesto"
	#define STR0034 "Movimientos Contables"
	#define STR0035 "Identificacion"
	#define STR0036 "Origen/Destino"
	#define STR0037 "Valores"
	#define STR0038 "Datos de la Carga"
	#define STR0039 "Impuestos"
	#define STR0040 "Complementos"
	#define STR0041 "Consignatario"
	#define STR0042 "Documento de Flete de Origen"
	#define STR0043 "Integraciones"
	#define STR0044 "Alicuota PIS"
	#define STR0045 "Alicuota COFINS"
#else
	#ifdef ENGLISH
		#define STR0001 "Freight Document Query"
		#define STR0002 "received"
		#define STR0003 "Blocked"
		#define STR0004 "Approved by the system"
		#define STR0005 "Approved by user"
		#define STR0006 "Search"
		#define STR0007 "View"
		#define STR0008 "Checking"
		#define STR0009 "Print"
		#define STR0010 "Field"
		#define STR0011 "Indicated"
		#define STR0012 "Calculated"
		#define STR0013 "Difference"
		#define STR0014 "Freight Document Approval"
		#define STR0015 "Differences"
		#define STR0016 "Branch: "
		#define STR0017 "Type: "
		#define STR0018 "Issuer: "
		#define STR0019 "Shipping Documents"
		#define STR0020 "Processing information"
		#define STR0021 "Wait"
		#define STR0022 "Number of Volumes"
		#define STR0023 "Actual Weight"
		#define STR0024 "Cubic Weight"
		#define STR0025 "Volume"
		#define STR0026 "Value of Items"
		#define STR0027 "Unit Freight"
		#define STR0028 "Freight Amount"
		#define STR0029 "Rates"
		#define STR0030 "Toll Value"
		#define STR0031 "Freight Total Value"
		#define STR0032 "Rate"
		#define STR0033 "Tax Value"
		#define STR0034 "Accounting Transactions"
		#define STR0035 "Identification"
		#define STR0036 "Origin/Destination"
		#define STR0037 "Values"
		#define STR0038 "Cargo Data"
		#define STR0039 "Taxes"
		#define STR0040 "Supplements"
		#define STR0041 "Consignee"
		#define STR0042 "Origin Freight Document"
		#define STR0043 "Integrations"
		#define STR0044 "PIS Percentage"
		#define STR0045 "COFINS Percentage"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Consulta de documentos de frete", "Consulta de Documentos de Frete" )
		#define STR0002 "Recebido"
		#define STR0003 "Bloqueado"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Aprovado pelo sistema", "Aprovado pelo Sistema" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Aprovado pelo utilizador", "Aprovado pelo Usu�rio" )
		#define STR0006 "Pesquisar"
		#define STR0007 "Visualizar"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Confer�ncia", "Conferencia" )
		#define STR0009 "Imprimir"
		#define STR0010 "Campo"
		#define STR0011 "Informado"
		#define STR0012 "Calculado"
		#define STR0013 "Diferen�a"
		#define STR0014 "Aprova��o de Documento de Frete"
		#define STR0015 "Diferen�as"
		#define STR0016 "Filial: "
		#define STR0017 "Esp�cie: "
		#define STR0018 "Emissor: "
		#define STR0019 "Documentos de Carga"
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "A processar informa��es", "Processando informa��es" )
		#define STR0021 "Aguarde"
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Quantidade de volumes", "Quantidade de Volumes" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Peso real", "Peso Real" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Peso cubado", "Peso Cubado" )
		#define STR0025 "Volume"
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Valor dos itens", "Valor dos Itens" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Frete unidade", "Frete Unidade" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Frete valor", "Frete Valor" )
		#define STR0029 "Taxas"
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Valor do ped�gio", "Valor do Ped�gio" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Valor total do frete", "Valor total do Frete" )
		#define STR0032 "Al�quota"
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Valor do imposto", "Valor do Imposto" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Movimentos contabil�sticos", "Movimentos Cont�beis" )
		#define STR0035 "Identifica��o"
		#define STR0036 "Origem/Destino"
		#define STR0037 "Valores"
		#define STR0038 "Dados da Carga"
		#define STR0039 "Impostos"
		#define STR0040 "Complementos"
		#define STR0041 "Consignat�rio"
		#define STR0042 "Documento de Frete de Origem"
		#define STR0043 "Integra��es"
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "Al�quota PIS", "Aliquota PIS" )
		#define STR0045 If( cPaisLoc $ "ANG|PTG", "Al�quota COFINS", "Aliquota COFINS" )
	#endif
#endif
