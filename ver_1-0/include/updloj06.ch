#ifdef SPANISH
	#define STR0001 "Este programa tiene como objetivo ajustar los diccionarios de datos de acuerdo con el BOPS "
	#define STR0002 "�Esta rutina debe procesarse en modo exclusivo! "
	#define STR0003 "�Haga un backup de los diccionarios y la base de datos antes del procesamiento!"
	#define STR0004 "BOPS "
	#define STR0005 "Actualizador de Base"
	#define STR0006 "Anular"
	#define STR0007 "Continuar"
	#define STR0008 "�Operacion anulada!"
	#define STR0009 "Archivos Texto (*.TXT) |*.txt|"
	#define STR0010 "Verificando integridad de los diccionarios..."
	#define STR0011 "Empresa : "
	#define STR0012 "Inicio - Diccionario de Datos"
	#define STR0013 "Analizando Diccionario de Datos..."
	#define STR0014 "Fin - Diccionario de Datos"
	#define STR0015 "Inicio Actualizando Estructuras "
	#define STR0016 "Actualizando estructuras. Espere... ["
	#define STR0017 "�Atencion!"
	#define STR0018 "Ocurrio un error desconocido durante la actualizacion de la tabla : "
	#define STR0019 ". Verifique la integridad del diccionario y de la tabla."
	#define STR0020 "Continuar"
	#define STR0021 "Ocurrio un error desconocido durante la actualizacion de la estructura de la tabla : "
	#define STR0022 "Fin Actualizando Estructuras "
	#define STR0023 "Inicio - Abriendo Tablas"
	#define STR0024 "Fin - Abriendo Tablas"
	#define STR0025 "Actualizacion Concluida."
	#define STR0026 "Log de la Actualizacion "
	#define STR0027 "Actualizacion Concluida."
	#define STR0028 "�No fue posible la apertura de la tabla de empresas de forma exclusiva !"
	#define STR0029 "Ok"
	#define STR0030 "Tp.Validacion"
	#define STR0031 "Tipo de Validacion"
	#define STR0032 "1=Contrasena;2=Tarjeta;3=Ambos"
	#define STR0033 "N� Tarjeta"
	#define STR0034 "N� Tarjeta Superior"
#else
	#ifdef ENGLISH
		#define STR0001 "The purpose of this program is to adjust the data dictionary according to the BOPS "
		#define STR0002 "This routine must be processed in exclusive mode! "
		#define STR0003 "Backup dictionaries and database before processing!"
		#define STR0004 "BOPS "
		#define STR0005 "Base Update Program"
		#define STR0006 "Cancel"
		#define STR0007 "Continue"
		#define STR0008 "Operation canceled!"
		#define STR0009 "Text File (*.TXT) |*.txt|"
		#define STR0010 "Checking dictionaries integrity..."
		#define STR0011 "Company : "
		#define STR0012 "Start -  Data Dictionary"
		#define STR0013 "Analyzing Data Dictionary..."
		#define STR0014 "End - Data Dictionary"
		#define STR0015 "Start Updating Structures "
		#define STR0016 "Updating structures. Wait... ["
		#define STR0017 "Attention!"
		#define STR0018 "Unknown error while updating the table : "
		#define STR0019 ". Check the integrity of dictionary and table."
		#define STR0020 "Continue"
		#define STR0021 "Unknown error while updating the table structure: "
		#define STR0022 "End Updating Structures "
		#define STR0023 "Start -  Opening Tables "
		#define STR0024 "End - Opening Tables"
		#define STR0025 "Update Finished."
		#define STR0026 "Update Log"
		#define STR0027 "Update Concluded."
		#define STR0028 "Unable to open the company table in exclusive mode!"
		#define STR0029 "Ok"
		#define STR0030 "Validation Tp."
		#define STR0031 "Validation Type"
		#define STR0032 "1=Password;2=Card;3=Both"
		#define STR0033 "Card Number"
		#define STR0034 "Superior Card Number"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Este programa tem como objectivo ajustar os dicion�rios de dados em fun��o do bops ", "Este programa tem como objetivo ajustar os dicion�rios de dados em fun��o do BOPS " )
		#define STR0002 "Esta rotina deve ser processada em modo exclusivo! "
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Faca um backup dos dicion�rios e base de dados antes do processamento!", "Fa�a um backup dos dicion�rios e base de dados antes do processamento!" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Bops ", "BOPS " )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Actualizador De Base", "Atualizador de Base" )
		#define STR0006 "Cancelar"
		#define STR0007 "Prosseguir"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Opera��o cancelada!", "Opera�ao cancelada!" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Ficheiros de texto (*.txt) |*.txt|", "Arquivos Texto (*.TXT) |*.txt|" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "A Verificar a Integridade dos Dicion�rios...", "Verificando integridade dos dicion�rios..." )
		#define STR0011 "Empresa : "
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "In�cio - Dicion�rio De Dados", "Inicio - Dicionario de Dados" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "A Analisar Dicion�rio De Dados...", "Analisando Dicionario de Dados..." )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Fim - Dicion�rio De Dados", "Fim - Dicionario de Dados" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "In�cio a actualizar as estruturas ", "Inicio Atualizando Estruturas " )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "A actualizar as estruturas. Aguarde... [", "Atualizando estruturas. Aguarde... [" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Aten��o!", "Atencao!" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Ocorreu um erro desconhecido durante a actualiza��o da tabela : ", "Ocorreu um erro desconhecido durante a atualizacao da tabela : " )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", ". Verifique a integridade do dicion�rio e da tabela.", ". Verifique a integridade do dicionario e da tabela." )
		#define STR0020 "Continuar"
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Ocorreu um erro desconhecido durante a actualiza��o da estrutura da tabela : ", "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : " )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Fim da actualiza��o das estruturas ", "Fim Atualizando Estruturas " )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "In�cio - A Abrir Tabelas", "Inicio - Abrindo Tabelas" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Fim - A Abrir Tabelas", "Fim - Abrindo Tabelas" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Actualiza��o concluida.", "Atualiza��o Conclu�da." )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Log da actualiza��o ", "Log da Atualiza��o " )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Actualiza��o concluida.", "Atualizacao Conclu�da." )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "N�o foi poss�vel a abertura da tabela de empresas de forma exclusiva !", "Nao foi possivel a abertura da tabela de empresas de forma exclusiva !" )
		#define STR0029 "Ok"
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Tp. valida��o", "Tp.Validacao" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Pedido De Valida��o", "Tipo de Validacao" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "1=palavra-passe; 2=cart�o; 3=ambos", "1=Senha;2=Cartao;3=Ambos" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Num. Cart�o", "Num. Cartao" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Num. Cart�o Superior", "Num. Cartao Superior" )
	#endif
#endif
