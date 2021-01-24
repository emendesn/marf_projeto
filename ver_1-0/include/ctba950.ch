#ifdef SPANISH
	#define STR0001 "Instrucciones Normativas"
	#define STR0002 "Este programa crea archivo, formatado previamente, de los asientos fiscales"
	#define STR0003 "Para entrega a las secretarias del fisco estatal, atendiendo al lay-out"
	#define STR0004 "De las resoluciones normativas. Debe ejecutarse en modo monoutilizador."
	#define STR0005 "Instrucciones Normativas"
	#define STR0006 "Esta resolucion normativa tiene archivos de destino especificos, por lo tanto, �no se respeto el parametro de destino!"
	#define STR0007 "�Archivos!"
	#define STR0008 "Verificacion  Ctba950"
	#define STR0009 "Este informe permite imprimir la informacion contenida en los medios magneticos para verificacion, generados por medio de este procedimiento."
	#define STR0010 "Verificacion  Ctba950"
	#define STR0011 "C�digo de barras"
	#define STR0012 "Administracion"
	#define STR0013 " - Continuacion..."
	#define STR0014 "Barras"
	#define STR0015 "Atencion"
	#define STR0016 "Se incluiran los numeros de las sucursales que se procesaran al inicio del nombre de los archivos de destino."
	#define STR0017 "Si los parametros del archivo ini incluyan las opciones 'de sucursal' y 'a sucursal' no complete estos parametros, para que se respete la seleccion de sucursales."
	#define STR0018 "Seleccionando Registros..."
#else
	#ifdef ENGLISH
		#define STR0001 "Normative Instructions"
		#define STR0002 "This program creates a pre-formatted file of fiscal entries"
		#define STR0003 "To deliver to state secretariat, under the payout"
		#define STR0004 "presented by the normative Instructions. it should be executed in mono-user mode."
		#define STR0005 "Normative Instructions"
		#define STR0006 "This normative instruction presents many files with specific destinations. Therefore destination parameter was not respected!"
		#define STR0007 "Files!"
		#define STR0008 "Ctba950 Conference"
		#define STR0009 "This report enables printing of information presented in magnetic means for conference generated through this procedure. "
		#define STR0010 "Ctba950 Conference"
		#define STR0011 "Bar Code"
		#define STR0012 "Administration"
		#define STR0013 " - Continuing..."
		#define STR0014 "Bars"
		#define STR0015 "Attention"
		#define STR0016 "Numbers of branches to be processed are added in the beginning of files name."
		#define STR0017 "If the parameters of the file do not include the options branch from and branch to, do not fill in these parameters, in order to respect branches selection. "
		#define STR0018 "Selecting records..."
	#else
		#define STR0001 "Instru��es Normativas"
		#define STR0002 "Este programa cria ficheiro pr�-formatado dos lan�amentos fiscais"
		#define STR0003 "Para entrega �s secretarias da receita estatal, atendendo ao lay-out"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Das instru��es normativas. deve-se executar em modo mono-utilizador.", "Das instru��es normativas. dever� ser executado em modo mono-utilizador." )
		#define STR0005 "Instru��es Normativas"
		#define STR0006 "Esta instru��o normativa possui ficheiros de destino espec�ficos e portanto o par�metro de destino n�o foi respeitado!"
		#define STR0007 "Ficheiros!"
		#define STR0008 "Confer�ncia  Ctba950"
		#define STR0009 "Este relat�rio possibilita a impress�o de informa��es contidas nos meios magn�ticos para confer�ncia gerados atrav�s desta procedimento."
		#define STR0010 "Confer�ncia  Ctba950"
		#define STR0011 "C�digo de barras"
		#define STR0012 "Administra��o"
		#define STR0013 " - Continua��o..."
		#define STR0014 "Barras"
		#define STR0015 "Aten��o"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Ser�o inclu�dos no in�cio do nome dos ficheiros de destino, os n�meros das filiais que ser�o proccessadas.", "Ser�o inclu�dos no in�cio do nome dos ficheiros de destino os n�meros das filiais que ser�o processadas." )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Caso os par�metros do ficheiro ini incluam as op��es 'filial de' e 'filial at�', n�o preencha estes par�metros, para que a selec��o de filiais seja respeitada.", "Caso os par�metros do ficheiro ini incluam as op��es 'filial de' e 'filial at�' n�o preencha estes par�metros, para que a selec��o de filiais seja respeitada." )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "A seleccionar Registos...", "Selecionando Registros..." )
	#endif
#endif
