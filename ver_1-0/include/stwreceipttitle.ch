#ifdef SPANISH
	#define STR0001 "Falla en la impresion del comprobante de cobro."
	#define STR0002 "Falla en la impresion de Documento No Fiscal."
	#define STR0003 "No se informe algun valor por cobrar."
	#define STR0004 "El numero de columnas del comprobante debe ser al menos 40. Configure en el archivo de estaciones el campo LG_LARGCOL"
	#define STR0005 "Necesario informar un cliente con RFC o rellenar los datos del titulo"
	#define STR0006 "Falla en la grabacion de la contingencia"
	#define STR0007 "Falla en la impresion del extracto."
	#define STR0008 "Error al cargar titulos "
	#define STR0009 "Error al ejecutar la baja de Titulos en el servidor"
	#define STR0010 "Error al ejecutar la reversion de Titulos en el servidor"
	#define STR0011 "E X T R A C T O"
	#define STR0012 "D E  C U E N T A"
	#define STR0013 "C O M P R O B A N T E"
	#define STR0014 "D E   R E C E P C I O N"
	#define STR0015 "R E V E R S I O N"
	#define STR0016 "D E   R E C E P C I O N"
	#define STR0017 "Documento"
	#define STR0018 "Valor"
	#define STR0019 "T O T A L"
	#define STR0020 "�No se encontro ningun titulo!"
	#define STR0021 "Espere. Efectuando dar de baja t�tulo."
	#define STR0022 "�Reversi�n realizada con �xito!"
	#define STR0023 "Imprimiendo comprobantes de cobro"
	#define STR0024 "Espere. Realizando el extorno de t�tulo."
	#define STR0025 "NO BAJ� EL TITULO, ARCHIVO DE CLIENTE PUEDE ESTAR PENDIENTE"
	#define STR0026 "CAJA SIN PERMISO PARA EFECTUAR EXTORNO"
#else
	#ifdef ENGLISH
		#define STR0001 "Failure in printing receiving receipt."
		#define STR0002 "Failure in printing non-fiscal receipt."
		#define STR0003 "No amount to receive was informed."
		#define STR0004 "The number of columns in the receipt should be lower than 40. Setup in the registry of field stations LG_LARGCOL"
		#define STR0005 "It is necessary to inform a client with CPF or complete data of the title"
		#define STR0006 "Failure to record contingency"
		#define STR0007 "Failure to print statement."
		#define STR0008 "Error loading bills "
		#define STR0009 "Error when writing off Bills in server"
		#define STR0010 "Error when reversing Bills in server"
		#define STR0011 "S T A T E M E N T"
		#define STR0012 "O F  A C C O U N T"
		#define STR0013 "P R O O F"
		#define STR0014 "O F  R E C E I P T"
		#define STR0015 "R E V E R S A L"
		#define STR0016 "O F  R E C E I P T"
		#define STR0017 "Document"
		#define STR0018 "Value"
		#define STR0019 "T O T A L"
		#define STR0020 "No bills found!"
		#define STR0021 "Wait. Writing bill off."
		#define STR0022 "Reversal successful!"
		#define STR0023 "Printing receipts"
		#define STR0024 "Wait. Performing bill reversal."
		#define STR0025 "BILL NOT WRITTEN OFF. CUSTOMER REGISTER MAY BE OPEN"
		#define STR0026 "CASHIER HAS NO PERMISSION TO PERFORM REVERSAL"
	#else
		#define STR0001 "Falha na impress�o do comprovante de recebimento."
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Falha na impress�o do documento n�o fiscal.", "Falha na impressao do Documento Nao Fiscal." )
		#define STR0003 "Nenhum valor a receber foi informado."
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "O n�mero de colunas do comprovante deve ser ao menos 40. Configure, no registo de esta��es, o campo LG_LARGCOL", "O n�mero de colunas do comprovante deve ser ao menos 40. Configure no cadastro de esta��es o campo LG_LARGCOL" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "� necess�rio informar um cliente com No. Contribuinte ou preencher os dados do t�tulo", "Necess�rio informar um cliente com CPF ou preencher os dados do titulo" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Falha na grava��o da conting�ncia", "Falha na gravacao da contingencia" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Falha na impress�o do extracto.", "Falha na impress�o do extrato." )
		#define STR0008 "Erro ao carregar t�tulos "
		#define STR0009 "Erro ao executar a baixa de T�tulos no servidor"
		#define STR0010 "Erro ao executar o estorno de T�tulos no servidor"
		#define STR0011 "E X T R A T O"
		#define STR0012 "D E  C O N T A"
		#define STR0013 "C O M P R O V A N T E"
		#define STR0014 "D E   R E C E B I M E N T O"
		#define STR0015 "E S T O R N O"
		#define STR0016 "D E   R E C E B I M E N T O"
		#define STR0017 "Documento"
		#define STR0018 "Valor"
		#define STR0019 "T O T A L"
		#define STR0020 "Nenhum titulo encontrado!"
		#define STR0021 "Aguarde. Efetuando baixa de titulo."
		#define STR0022 "Estorno efetuado com sucesso!"
		#define STR0023 "Imprimindo comprovantes do recebimento"
		#define STR0024 "Aguarde. Realizando o estorno de t�tulo."
		#define STR0025 "NAO BAIXOU O TITULO, CADASTRO DO CLIENTE PODE ESTAR ABERTO"
		#define STR0026 "CAIXA SEM PERMISSAO PARA EFETUAR ESTORNO"
	#endif
#endif