#ifdef SPANISH
	#define STR0001 "Consolidacion de Empresas / Sucursales"
	#define STR0002 "Plan de cuentas"
	#define STR0003 "Asientos contables"
	#define STR0004 "Es mejor que los archivos asociados a "
	#define STR0005 "esta rutina  no  esten siendo utilizados"
	#define STR0006 "por otras estaciones. "
	#define STR0007 "Haga con que los otros usuarios salgan del "
	#define STR0008 "sistema. "
	#define STR0009 " �ATENCION! "
	#define STR0010 "Archivos por consolidar"
	#define STR0011 "Empresas por consolidar"
	#define STR0012 "�Se borrar�n los datos de la empresa!"
	#define STR0013 "�Confirma consolidacion en esta empresa?"
	#define STR0014 " no encontrado"
	#define STR0015 "Seleccionando registros..."
	#define STR0016 "Invierte seleccion"
	#define STR0017 "Error al activar el proceso"
	#define STR0018 "�Proceso ejecutado con exito!"
	#define STR0019 "Error al borrar la procedure"
	#define STR0020 "Actualizacion con Error"
	#define STR0021 "Error en la creacion de la procedure"
	#define STR0022 "Existen asientos en la empresa consolidadora en este per�odo. "
	#define STR0023 "(Recomendado procesamiento borrando per�odo a ser consolidado)."
	#define STR0024 " � Desea realmente continuar ? "
	#define STR0025 "� Periodo ya consolidado !"
	#define STR0026 "Saldo Inicial "
	#define STR0027 "No es permitido marcar dos sucursales de la misma empresa con asientos "
	#define STR0028 "contables compartidos."
	#define STR0029 "Ya existen datos en la fecha de saldo inicial, por eso no se generara saldo inicial."
	#define STR0030 "Si desea continuar el proceso verifique si todas los entes de los asientos est�n en los archivos de las tablas de destino"
	#define STR0031 "No se permite seleccionar una sucursal con tamano de la sucursal diferente del tamano de la sucursal de la consolidadora"
	#define STR0032 "La rutina de consolidacion tiene como objetivo permitir la emision de las demostraciones contables"
	#define STR0033 "consolidadas. Las demostraciones contables consolidades representan la integracion de las"
	#define STR0034 "demostraciones contables relativas a dos o mas sociedades con personas juridicas"
	#define STR0035 "distintas y tienen como objetivo presentar a socios o accionistas, acreedores y otros"
	#define STR0036 "interesados la posicion financiera y los resultados de las operaciones de la empresa controladora y"
	#define STR0037 "de sus controladas, como si el conjunto de esas empresas fuera una unica empresa que tuviera"
	#define STR0038 "una o mas sucursales, departamentos o divisiones."
	#define STR0039 "Procesando..."
	#define STR0040 "Validacion monedas"
	#define STR0041 "Empresa : "
	#define STR0042 "Sucursal : "
	#define STR0043 "La verificacion de archivos creara los archivos en las empresas a consolidar si no existen."
	#define STR0044 "Esta verificacion puede demorar varios minutos de acuerdo con la cantidad de empresas, sin embargo, "
	#define STR0045 "se recomienda en la primera ejecucion de la consolidacion."
	#define STR0046 "�Ejecutar verificacion de archivos antes de la Consolidacion? "
	#define STR0047 "Verificacion de archivos..."
	#define STR0048 "Informar el Lote, Sublote y Documento Iniciales"
	#define STR0049 "Saldo del tipo Presupuestado o campo en blanco no se puede consolidar"
	#define STR0050 "Probables causas: "
	#define STR0051 "-Clave Duplicada en los movimientos contables (rutina ejecutada anteriormente con los mismos parametros)."
	#define STR0052 "-Campos con tamanos diferentes entre las empresas consolidar/consolidadora"
	#define STR0053 "Para mayor detalle consulte mensajes en el monitor del TOTVSDBAccess"
	#define STR0054 "*** Abortando operacion de consolidacion *** "
	#define STR0055 "PREPARACION DEL ENTORNO PARA PROCESAMIENTO DE LA CONSOLIDACION"
	#define STR0056 "PROCESAMIENTO DE LOS ARCHIVOS DE CONSOLIDACION"
	#define STR0057 "VERIFICACION DE LOS ARCHIVOS"
	#define STR0058 "VERIFICACION DE ASIENTOS CONTABLES"
	#define STR0059 "REPROCESAMIENTO PARA ACTUALIZAR LOS SALDOS"
	#define STR0060 "COPIA DE LAS TABLAS PARA LA EMPRESA DESTINO"
	#define STR0061 "CREACION DEL ARCHIVO DE TRABAJO"
#else
	#ifdef ENGLISH
		#define STR0001 "Companies / Branches Consolidation"
		#define STR0002 "Chart of Accounts"
		#define STR0003 "Accounting Entries"
		#define STR0004 "We recommend that the files associated "
		#define STR0005 "to this routine are not in use on other"
		#define STR0006 "workstations. "
		#define STR0007 "Make sure that other users log off the "
		#define STR0008 "system. "
		#define STR0009 " ATTENTION! "
		#define STR0010 "Files to Consolidate"
		#define STR0011 "Companies to Consolidate"
		#define STR0012 "All Data of the company below will be deleted"
		#define STR0013 "Confirm the Consolidation of this company?"
		#define STR0014 " not found"
		#define STR0015 "Selecting Records..."
		#define STR0016 "Invert Selection"
		#define STR0017 "Error when starting the process."
		#define STR0018 "Process performed successfully!"
		#define STR0019 "Error when deleting the procedure."
		#define STR0020 "Updating with error "
		#define STR0021 "Error when creating the procedure."
		#define STR0022 "There are entries in the consolidating company this period. "
		#define STR0023 "(Recommended processing deleting period to be consolidated).   "
		#define STR0024 "Will you really continue?     "
		#define STR0025 "Period already consolidated"
		#define STR0026 "Initial balance"
		#define STR0027 "Not allowed to check two branches of the same company with shared    "
		#define STR0028 "accountint entries.      "
		#define STR0029 "There is data in the initial balance date, initial balance will not be generated."
		#define STR0030 "If you wish to continue the process, check if all the entities of the entries are in the files of target tables"
		#define STR0031 "It is not allowed to select a branch with a different size of the consolidating branch"
		#define STR0032 "The consolidation routine allows the issue of accounting statements"
		#define STR0033 "consolidated. The consolidated accounting statements represent the integration of"
		#define STR0034 "the accounting statements related to two or more societies with distinct legal personality"
		#define STR0035 "and introduces to partners or stockholders, creditors and other"
		#define STR0036 "interested the financial position and the results of the operations of the controlling company and"
		#define STR0037 "of its controlled, as if the group of all the companies was a single company with"
		#define STR0038 "one or more branches, departments or divisions."
		#define STR0039 "Processing..."
		#define STR0040 "Currency validation"
		#define STR0041 "Company : "
		#define STR0042 "Branch : "
		#define STR0043 "the file checking will create the files in the companies to be consolidated if they do not exist."
		#define STR0044 "This checking may take several minutes according to the amount of companies, but,"
		#define STR0045 "it is strogly recommended in the first consolidation execution."
		#define STR0046 "Execute file checking before the Consolidation ? "
		#define STR0047 "Checking files..."
		#define STR0048 "Enter Lot, Sub lot and Initial Documents"
		#define STR0049 "Balance of Quotation Type or Blanc Field cannot be consolidated"
		#define STR0050 "Possible causes: "
		#define STR0051 "-Doubled Key in the accounting transactions (routine previously run with the same parameters)."
		#define STR0052 "-Fields with different sizes between the consolidate/consolidator companies"
		#define STR0053 "Further details, refer to Messages in TOTVSDBAccess Monitor"
		#define STR0054 "*** Aborting consolidation operation *** "
		#define STR0055 "ENVIRONMENT DEVELOPMENT TO PROCESS CONSOLIDATION"
		#define STR0056 "FILE PROCESSING CONSOLIDATION"
		#define STR0057 "VERIFICATION OF REGISTERS"
		#define STR0058 "VERIFICATION OF ACCOUNTING ENTRIES"
		#define STR0059 "REPROCESSING TO UPDATE BALANCES"
		#define STR0060 "COPY TABLES TO DESTINATION COMPANY"
		#define STR0061 "CREATION OF WORK FILES"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Consolida��o De Empresas / Filiais", "Consolida��o de Empresas / Filiais" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Plano De Contas", "Plano de Contas" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Lan�amentos Contabil�sticos", "Lancamentos Contabeis" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "� melhor que os ficheiros associados a ", "� melhor que os arquivos associados a " )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Este procedimento  n�o  estejam em  utiliza��o  por ", "esta rotina  nao  estejam em  uso  por " )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Outras esta��es.", "outras esta��es." )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Levar os outros utilizadores a sa�rem do", "Fa�a com que os outros usu�rios saiam do " )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Sistema. ", "sistema. " )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", " aten��o! ", " ATENCAO! " )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Ficheiros A Consolidar", "Arquivos a Consolidar" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Empresas A Consolidar", "Empresas a Consolidar" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Os dados da empresa abaixo ser�o apagados!", "Os dados da empresa abaixo serao apagados!" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Confirmar consolida��o nesta empresa?", "Confirma Consolidacao nesta empresa?" )
		#define STR0014 " n�o encontrado"
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "A Seleccionar Registos...", "Selecionando Registros..." )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Inverter Selec��o", "Inverte Selecao" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Houve um erro na chamada do processo", "Erro na chamada do processo" )
		#define STR0018 "Processo executado com sucesso!"
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Erro na exclus�o da procedure", "Erro na exclusao da procedure" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Actualiza��o Com Erros", "Atualizacao com Erro" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Erro na cria��o da procedure", "Erro na criacao da procedure" )
		#define STR0022 "Existem lan�amentos na empresa consolidadora neste per�odo. "
		#define STR0023 "(Recomendado processamento apagando per�odo a ser consolidado)."
		#define STR0024 " Deseja realmente continuar ? "
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Per�odo j� consolidado !", "Periodo j� consolidado !" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Saldo inicial ", "Saldo Inicial " )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "N�o � permitido marcar duas filiais da mesma empresa com lan�amentos ", "Nao � permitido marcar duas filiais da mesma empresa com lan�amentos " )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Contabil�sticos compartilhados.", "cont�beis compartilhados." )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "J� existem dados na data de saldo inicial, saldo inicial n�o ser� gerado.", "Ja existem dados na data de saldo inicial, saldo inicial nao sera gerado." )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Se deseja continuar o processo verifique se todas as entidades dos lan�amentos est�o nos registos das tabelas destino", "Se deseja continuar o processo verifique se todas as entidades dos lancamentos estao nos cadastros das tabelas destino" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "N�o � permitido seleccionar uma filial com tamanho da filial diferente do tamanho da filial da consolidadora", "Nao e permitido selecionar uma filial com tamanho da filial diferente do tamanho da filial da consolidadora" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "O procedimento de consolida��o tem como objectivo permitir a emiss�o das demonstra��es contabil�sticas", "A rotina de consolida��o tem como objetivo permitir a emiss�o das demonstra��es cont�beis" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "consolidadas. As demonstra��es contabil�sticas consolidadas representam a integra��o das", "consolidadas. As demonstra��es cont�beis consolidadas representam a integra��o das" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "demonstra��es contabil�sticas relativas a duas ou mais sociedades com personalidades jur�dicas", "demonstra��es cont�beis relativas a duas ou mais sociedades com personalidades jur�dicas" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "distintas, e t�m como objectivo apresentar a s�cios ou acionistas, credores e outros", "distintas e t�m como objetivo apresentar a s�cios ou acionistas, credores e outros" )
		#define STR0036 "interessados a posi��o financeira e os resultados das opera��es da empresa controladora e"
		#define STR0037 "de suas controladas, como se o conjunto dessas empresas fosse uma �nica empresa que tivesse"
		#define STR0038 "uma ou mais filiais, departamentos ou divis�es."
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "A processar...", "Processando..." )
		#define STR0040 "Valida��o moedas"
		#define STR0041 "Empresa : "
		#define STR0042 "Filial  : "
		#define STR0043 If( cPaisLoc $ "ANG|PTG", "A verifica��o de ficheiros criar� os ficheiros nas empresas a consolidar caso n�o existam.", "A verifica��o de arquivos ir� criar os arquivos nas empresas a consolidar caso n�o existam." )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "Esta verifica��o pode demorar v�rios minutos, de acordo com a quantidade de empresas; por�m,", "Esta verifica��o pode demorar v�rios minutos de acordo com a quantidade de empresas, por�m," )
		#define STR0045 If( cPaisLoc $ "ANG|PTG", "� recomendada na primeira execu��o da consolida��o.", "� fortemente recomendada na primeira execu��o da consolida��o." )
		#define STR0046 If( cPaisLoc $ "ANG|PTG", "Executar verifica��o de ficheiros antes da Consolida��o ? ", "Executar verifica��o de arquivos antes da Consolida��o ? " )
		#define STR0047 If( cPaisLoc $ "ANG|PTG", "Verifica��o de ficheiros...", "Verifica��o de arquivos..." )
		#define STR0048 If( cPaisLoc $ "ANG|PTG", "Informar o lote, sublote e documento iniciais", "Informar o Lote, Sublote e Documento Iniciais" )
		#define STR0049 "Saldo do tipo Or�ado ou campo em Branco n�o pode ser consolidado"
		#define STR0050 "Provaveis causas: "
		#define STR0051 "-Chave Duplicada nos movimentos contabeis (rotina executada anteriormente com mesmos parametros)."
		#define STR0052 "-Campos com tamanhos diferentes entre as empresas consolidar/consolidadora"
		#define STR0053 "Para maior detalhamento consulte Mensagens no Monitor do TOTVSDBAccess"
		#define STR0054 "*** Abortando opera��o de consolida��o *** "
		#define STR0055 "PREPARA��O DO AMBIENTE PARA PROCESSAMENTO DA CONSOLIDA��O"
		#define STR0056 "PROCESSAMENTO DOS ARQUIVOS DE CONSOLIDA��O"
		#define STR0057 "VERIFICA��O DOS CADASTROS"
		#define STR0058 "VERIFICA��O DE LAN�AMENTO CONT�BEIS"
		#define STR0059 "REPROCESSAMENTO PARA ATUALIZAR OS SALDOS"
		#define STR0060 "COPIA DAS TABELAS PARA A EMPRESA DESTINO"
		#define STR0061 "CRIA��O DO ARQUIVO DE TRABALHO"
	#endif
#endif
