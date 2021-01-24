#ifdef SPANISH
	#define STR0001 "Integracion Excel"
	#define STR0002 "MsExcel no instalado"
	#define STR0003 "AddIn ApExcel80 no instalado"
	#define STR0004 "Parametros de conexion invalidos"
	#define STR0005 "inicializando entorno"
	#define STR0006 "Cargando addin"
	#define STR0007 "Conectado"
#else
	#ifdef ENGLISH
		#define STR0001 "Integration with Excel"
		#define STR0002 "MsExcel not installed"
		#define STR0003 "AddIn ApExcel80 not installed"
		#define STR0004 "Invalid connection parameters"
		#define STR0005 "initializing environment"
		#define STR0006 "Loading addin"
		#define STR0007 "Connected"
	#else
		Static STR0001 := "Integracao Excel"
		Static STR0002 := "MsExcel nao instalado"
		Static STR0003 := "AddIn ApExcel80 nao instalado"
		Static STR0004 := "Parametros de conexao invalidos"
		Static STR0005 := "inicializando ambiente"
		Static STR0006 := "Carregando addin"
		Static STR0007 := "Conectado"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Integração Com O Excel"
			STR0002 := "Msexcel não instalado"
			STR0003 := "Addin apexcel80 não instalado"
			STR0004 := "Parâmetros de ligação inválidos"
			STR0005 := "Iniciar ambiente"
			STR0006 := "A carregar addin"
			STR0007 := "Ligado"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
