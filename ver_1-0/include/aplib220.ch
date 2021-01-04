#ifdef SPANISH
	#define STR0001 "Esperando Conexion..."
	#define STR0002 "Planilla Microsoft Excel"
	#define STR0003 "&OK"
	#define STR0004 "&Anular"
	#define STR0005 "Activando el Excel ..."
	#define STR0006 "¡No se pudo activar el Excel!"
	#define STR0007 "Conectado ..."
#else
	#ifdef ENGLISH
		#define STR0001 "Waiting for Connection..."
		#define STR0002 "Microsoft Excel Worksheet"
		#define STR0003 "&OK"
		#define STR0004 "&Quit    "
		#define STR0005 "Initializing MS Excel..."
		#define STR0006 "Unable to Connect to MS Excel ! "
		#define STR0007 "Connected..."
	#else
		Static STR0001 := "Aguardando Conexåo..."
		Static STR0002 := "Planilha Microsoft Excel"
		Static STR0003 := "&OK"
		Static STR0004 := "&Cancelar"
		Static STR0005 := "Inicializando Excel ..."
		Static STR0006 := "Nåo foi possivel conectar o Excel !"
		Static STR0007 := "Conectado ..."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "A Aguardar Ligação..."
			STR0002 := "Folha De Cálculo Microsoft Excel"
			STR0003 := "&ok"
			STR0004 := "&cancelar"
			STR0005 := "A iniciar excel ..."
			STR0006 := "Não foi possível aceder ao excel !"
			STR0007 := "Ligado ..."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
