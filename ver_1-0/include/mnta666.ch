#ifdef SPANISH
	#define STR0001 "Generacion de Honorarios al Despachante"
	#define STR0002 "Seleccionando Registros..."
	#define STR0003 "Bien"
	#define STR0004 "Nombre Bien"
	#define STR0005 "Matricula"
	#define STR0006 "Servicio del Despachante"
	#define STR0007 "Descripci�n"
	#define STR0008 "Valor"
	#define STR0009 "Procesando Archivo..."
	#define STR0010 "Espere"
	#define STR0011 "�No hay datos para montar la pantalla!."
	#define STR0012 "�Atencion!"
	#define STR0013 "Proveedor"
	#define STR0014 "Condicion Pago:"
	#define STR0015 "Valor Total:"
	#define STR0016 "Marcando y/o Desmarcando"
	#define STR0017 "Informe a partir de que fecha de Emision del Documento desea visualizar los datos."
	#define STR0018 "Informe hasta que fecha de Emision del Documento desea visualizar los datos."
	#define STR0019 "Informe el numero de la Factura de Recibo."
	#define STR0020 "Informe que Proveedor recibira los Honorarios de los servicios prestados. Pulse la tecla [F3] para seleccionar un Proveedor."
	#define STR0021 "Informe cual sera la fecha de emision de los honorarios."
	#define STR0022 "Campo que permite al usuario identificar un conjunto de titulos que pertenezcan a un mismo grupo o sucursal."
	#define STR0023 "Tipo de titulo. Relacionado con la tabla de parametrizacion."
	#define STR0024 "Codigo de la naturaleza. Utilizado para identificar la procedencia de los titulos, permitiendo la consolidacion por item y el control presupuestario."
	#define STR0025 "Codigo de la condicion de pago."
	#define STR0026 "Servicio   Descripcion"
	#define STR0027 "   Bien                Nombre                                      Cuota        Valor    Vencimiento   Factura   N� Titulo   "
	#define STR0028 "El informe mostrara los honorarios generados."
	#define STR0029 "A rayas"
	#define STR0030 "Administracion"
	#define STR0031 "Informe de la generacion de honorarios"
	#define STR0032 "TOTAL SERVICIO:"
	#define STR0033 "TOTAL GENERAL:"
	#define STR0034 "Fecha del pago:"
	#define STR0035 "Fecha del vencimiento:"
	#define STR0036 "   Bien                Nombre                                      Cuota        Valor    Vencimiento   Factura   "
	#define STR0037 "Cuotas"
	#define STR0038 "Condicion de Pago no valida."
	#define STR0039 "No fue posible generar las cuotas para el servicio "
	#define STR0040 " del bien "
	#define STR0041 "Informe una condicion de pago valida."
	#define STR0042 "Analizando servicio "
#else
	#ifdef ENGLISH
		#define STR0001 "Generation of Broker Fees"
		#define STR0002 "Selecting Records..."
		#define STR0003 "Asset"
		#define STR0004 "Asset Name"
		#define STR0005 "License Plate"
		#define STR0006 "Broker Service"
		#define STR0007 "Description"
		#define STR0008 "Value"
		#define STR0009 "Processing file..."
		#define STR0010 "Wait"
		#define STR0011 "There are no data to create the screen!"
		#define STR0012 "Warning!"
		#define STR0013 "Supplier:"
		#define STR0014 "Payment Term:"
		#define STR0015 "Total Value:"
		#define STR0016 "Checking and / or Clearing"
		#define STR0017 "Inform from which Document Issue Date you want to view data."
		#define STR0018 "Inform until which Document Issue Date you want to view data."
		#define STR0019 "Enter the number of the Receipt Invoice."
		#define STR0020 "Enter the supplier that will receive fees for services rendered. Press [F3] to select a Supplier."
		#define STR0021 "Enter the date of issue of fees."
		#define STR0022 "Field allowing user to identify a group of bills belonging to a same group."
		#define STR0023 "Bill type. Related to the parameterization table."
		#define STR0024 "Nature code. Used to identify the origin of the bills, enabling the consolidation of this item and budget control."
		#define STR0025 "Payment term code."
		#define STR0026 "Service   Description"
		#define STR0027 "   Asset              Name                                      Install.       Value    Due Date     Invoice       Bill No.    "
		#define STR0028 "The report will present the fees generated."
		#define STR0029 "Z-form"
		#define STR0030 "Management"
		#define STR0031 "Fee Generation Report"
		#define STR0032 "SERVICE TOTAL:"
		#define STR0033 "GRAND TOTAL:"
		#define STR0034 "Payment Date:"
		#define STR0035 "Due Date:"
		#define STR0036 "   Asset              Name                                      Install.       Value    Due Date     Invoice    "
		#define STR0037 "Installments"
		#define STR0038 "Invalid payment term."
		#define STR0039 "Installments could not be generated for the service "
		#define STR0040 " of asset "
		#define STR0041 "Enter a valid payment term."
		#define STR0042 "Analyzing service... "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Gera��o de honor�rios ao despachante", "Gera��o de Honor�rios ao Despachante" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "A seleccionar registos...", "Selecionando Registros..." )
		#define STR0003 "Bem"
		#define STR0004 "Nome Bem"
		#define STR0005 "Placa"
		#define STR0006 "Servi�o do Despachante"
		#define STR0007 "Descri��o"
		#define STR0008 "Valor"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "A processar ficheiro...", "Processando Arquivo..." )
		#define STR0010 "Aguarde"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "N�o existem dados para montar o ecr�.", "N�o existem dados para montar a Tela!" )
		#define STR0012 "Aten��o!"
		#define STR0013 "Fornecedor:"
		#define STR0014 "Condi��o Pagamento:"
		#define STR0015 "Valor Total:"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "A Marcar e/ou A Desmarcar", "Marcando e/ou Desmarcando" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Informe a partir de qual data de emiss�o do documento deseja visualizar os dados.", "Informe a partir de qual Data de Emiss�o do Documento deseja visualizar os dados." )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Informe at� qual data de emiss�o do documento deseja visualizar os dados.", "Informe at� qual Data de Emiss�o do Documento deseja visualizar os dados." )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Informe o n�mero da Factura de Recibo.", "Informe o n�mero da Nota Fiscal de Recibo." )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Informe qual o Fornecedor receber� os Honor�rios dos servi�os prestados. Pressione a tecla [F3] para seleccionar um Fornecedor.", "Informe qual o Fornecedor que ir� receber os Honor�rios dos servi�os prestados. Pressione a tecla [F3] para selecionar um Fornecedor." )
		#define STR0021 "Informe qual ser� a data de emiss�o dos honor�rios."
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Campo que permite ao utilizador identificar um conjunto de t�tulos que perten�am a um mesmo grupo ou filial.", "Campo que permite ao usu�rio identificar um conjunto de t�tulos que perten�am a um mesmo grupo ou filial." )
		#define STR0023 "Tipo do t�tulo. Relacionado a tabela de parametriza��o."
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "C�digo da natureza. Utilizado para identificar a proced�ncia dos t�tulos, permitindo a consolida��o por este �tem e o controlo or�ament�rio.", "C�digo da natureza. Utilizado para identificar a proced�ncia dos t�tulos, permitindo a consolida��o por este �tem e o controle or�ament�rio." )
		#define STR0025 "C�digo da condi��o de pagamento."
		#define STR0026 "Servi�o   Descri��o"
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "   Bem                Nome                                      Parcela        Valor    Vencimento   Factura   N. T�tulo   ", "   Bem                Nome                                      Parcela        Valor    Vencimento   Nota Fiscal   N. T�tulo   " )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "O relat�rio apresentar� os honor�rios gerados.", "O relatorio ir� apresentar os honor�rios gerados." )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "C�digo de barras", "Zebrado" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Administra��o", "Administracao" )
		#define STR0031 "Relat�rio da Gera��o de Honor�rios"
		#define STR0032 "TOTAL SERVI�O:"
		#define STR0033 "TOTAL GERAL:"
		#define STR0034 "Data do Pagamento:"
		#define STR0035 "Data do Vencimento:"
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "   Bem                Nome                                      Parcela        Valor    Vencimento   Factura", "   Bem                Nome                                      Parcela        Valor    Vencimento   Nota Fiscal" )
		#define STR0037 "Parcelas"
		#define STR0038 "Condi��o de pagamento inv�lida."
		#define STR0039 "N�o foi poss�vel gerar as parcelas para o servi�o "
		#define STR0040 " do bem "
		#define STR0041 "Informe uma condi��o de pagamento v�lida."
		#define STR0042 If( cPaisLoc $ "ANG|PTG", "A analisar servi�o ", "Analisando servi�o " )
	#endif
#endif
