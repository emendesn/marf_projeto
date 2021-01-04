#ifdef SPANISH
	#define STR0001 "Contrato"
	#define STR0002 "Cliente"
	#define STR0003 "Numero de serie"
	#define STR0004 "Verificacion de facturacion"
	#define STR0005 "Estatus"
	#define STR0006 "Cod. Cliente"
	#define STR0007 "Vlr. Dia"
	#define STR0008 "Ctd. mediciones"
	#define STR0009 "Informe el cliente inicial"
	#define STR0010 "¿De cliente?"
	#define STR0011 "Informe la tienda inicial"
	#define STR0012 "¿De tienda?"
	#define STR0013 "Informe el cliente final"
	#define STR0014 "¿A cliente?"
	#define STR0015 "Informe la tienda final"
	#define STR0016 "¿A tienda?"
	#define STR0017 "Informe el producto inicial"
	#define STR0018 "¿De Producto?"
	#define STR0019 "Informe el producto final"
	#define STR0020 "¿A producto?"
	#define STR0021 "Informe el num. serie inicial"
	#define STR0022 "¿De num. serie?"
	#define STR0023 "Informe el num. serie final"
	#define STR0024 "¿A num. serie?"
	#define STR0025 "Informe la separacion inicial"
	#define STR0026 "¿De fch. separacion?"
	#define STR0027 "Informe la separacion final"
	#define STR0028 "¿A fch. separacion?"
	#define STR0029 "Informe el calculo inicial"
	#define STR0030 "¿De fch. calculo?"
	#define STR0031 "Informe el calculo final"
	#define STR0032 "¿A fch. calculo?"
	#define STR0033 "Informe la situacion"
	#define STR0034 "¿Situacion?"
	#define STR0035 "No iniciado"
	#define STR0036 "Asignado"
	#define STR0037 "Finalizado"
	#define STR0038 "Todos"
#else
	#ifdef ENGLISH
		#define STR0001 "Contract"
		#define STR0002 "Customer"
		#define STR0003 "Serial Number"
		#define STR0004 "Invoicing Verification"
		#define STR0005 "Status"
		#define STR0006 "Customer Code"
		#define STR0007 "Day Val."
		#define STR0008 "Measurements Qty."
		#define STR0009 "Enter initial customer"
		#define STR0010 "Customer from?"
		#define STR0011 "Enter initial store"
		#define STR0012 "Store from?"
		#define STR0013 "Enter final customer"
		#define STR0014 "Customer to?"
		#define STR0015 "Enter final store"
		#define STR0016 "Store to?"
		#define STR0017 "Enter initial product"
		#define STR0018 "Product from?"
		#define STR0019 "Enter final product"
		#define STR0020 "Product to?"
		#define STR0021 "Enter initial serial no."
		#define STR0022 "Serial No. from?"
		#define STR0023 "Enter final serial no."
		#define STR0024 "Serial No. to?"
		#define STR0025 "Enter initial separation"
		#define STR0026 "Separation dt. from?"
		#define STR0027 "Enter final separation"
		#define STR0028 "Separation dt. to?"
		#define STR0029 "Enter initial calculation"
		#define STR0030 "Calculation dt. from?"
		#define STR0031 "Enter final calculation"
		#define STR0032 "Calculation dt. to?"
		#define STR0033 "Enter the status"
		#define STR0034 "Status?"
		#define STR0035 "Not Started"
		#define STR0036 "Rented"
		#define STR0037 "Closed"
		#define STR0038 "All"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Contrato" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Cliente" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Número de Série" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Conferência de Faturamento" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Status" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Cod. Cliente" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Vlr. Dia" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Qtd.Medições" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Informe o cliente inicial" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Cliente de?" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Informe a loja inicial" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Loja de?" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Informe o cliente final" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Cliente até?" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Informe a loja final" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Loja até?" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Informe o produto inicial" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Produto de?" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Informe o produto final" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Produto até?" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Informe o nro.série inicial" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "Nro.Série de?" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Informe o nro.série final" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "Nro.Série até?" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "Informe a separação inicial" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "Dt.Separação de?" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "Informe a separação final" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "Dt.Separação até?" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", , "Informe a apuração inicial" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "Dt.Apuração de?" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", , "Informe a apuração final" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", , "Dt.Apuração até?" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", , "Informe a situação" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", , "Situação?" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", , "Não Iniciado" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", , "Locado" )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", , "Encerrado" )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", , "Todos" )
	#endif
#endif
