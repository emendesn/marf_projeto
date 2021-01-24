#ifdef SPANISH
	#define STR0001 "Falla en el Comando de Apertura y Seleccion de Puerta"
	#define STR0002 "Error al conectar con el cajon serial "
	#define STR0003 " en el puerto "
	#define STR0004 "Error al conectar con la balanza serial"
	#define STR0005 "Error al conectar con el lector optico serial "
	#define STR0006 "Error al conectar con el lector de CMC7 "
	#define STR0007 "Error al conectar con la impresora de cheque "
	#define STR0008 "Error en la verificacion del archivo encriptado"
	#define STR0009 "Falla en el comando de apertura de la impresora"
	#define STR0010 "Problemas en la verificacion de los datos de la Estacion con los datos del ECF"
	#define STR0011 "Usuario caja sin impresora fiscal registrada."
	#define STR0012 "Solo se permite la entrada en el caja de usuarios fiscales."
	#define STR0013 "No se encontro impresora/puerto registrado"
	#define STR0014 "Falla en el comando de la apertura de SAT"
	#define STR0015 "NFCE - necesario configuracion de Imp. No-Fiscal"
	#define STR0016 "Aten��o, Nfc-e configurada, � necess�rio logar-se com usu�rio n�o-fiscal "
	#define STR0017 "Intente nuevamente"
	#define STR0018 "Prensa"
#else
	#ifdef ENGLISH
		#define STR0001 "Failure in Opening Command and Port Selection"
		#define STR0002 "Error while connecting to Serial Drawer "
		#define STR0003 " in port "
		#define STR0004 "Error while connecting to Serial Scale"
		#define STR0005 "Error while connecting to Serial Optical Reader "
		#define STR0006 "Error while connecting to CMC7 Reader "
		#define STR0007 "Error while connecting to Check Printer "
		#define STR0008 "Failure in encrypted file checking"
		#define STR0009 "Failure in Printer Opening Command"
		#define STR0010 "Problems checking Station data with ECF data"
		#define STR0011 "Cash User without a registered Fiscal Printer."
		#define STR0012 "Only fiscal users can enter the cashier."
		#define STR0013 "No printer/registered port found"
		#define STR0014 "Failure in SAT opening command"
		#define STR0015 "NFCE - required configuration Imp. Non-Fiscal"
		#define STR0016 "Attention, electronic invoice configured, you must login as a non-tax user "
		#define STR0017 "Try again"
		#define STR0018 "Press"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Falha no comando de abertura e selec��o da porta", "Falha no Comando de Abertura e Selecao da Porta" )
		#define STR0002 "Erro ao conectar com a Gaveta Serial "
		#define STR0003 " na porta "
		#define STR0004 "Erro ao conectar com a Balanca Serial"
		#define STR0005 "Erro ao conectar com o Leitor Optico Serial "
		#define STR0006 "Erro ao conectar com o Leitor de CMC7 "
		#define STR0007 "Erro ao conectar com a Impressora de Cheque "
		#define STR0008 "Falha na verifica��o do arquivo criptografado"
		#define STR0009 "Falha no Comando de Abertura da Impressora"
		#define STR0010 "Problemas na verifica��o dos dados da Esta��o com os Dados do ECF"
		#define STR0011 "Usu�rio Caixa sem impressora Fiscal cadastrada."
		#define STR0012 "S� � permitida a entrada no caixa de usu�rios fiscais."
		#define STR0013 "N�o foi encontrado impressora/porta cadastrada"
		#define STR0014 "Falha no comando da abertura do SAT"
		#define STR0015 "NFCE - necess�rio configua��o de Imp. N�o-Fiscal"
		#define STR0016 "Aten��o, Nfc-e configurada, � necess�rio logar-se com usu�rio n�o-fiscal "
		#define STR0017 "Tentar novamente"
		#define STR0018 "Imprensa"
	#endif
#endif
