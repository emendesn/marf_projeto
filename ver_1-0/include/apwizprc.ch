#ifdef SPANISH
	#define STR0001 "Iniciar Job en el START del Servidor Protheus"
	#define STR0002 "Funcion Ejecutada (main)"
	#define STR0003 "Entorno de Ejacucion (environment)"
	#define STR0004 "Numero de Procesos (instances)"
	#define STR0005 "Numero de Parametros (nParms)"
	#define STR0006 "Parametros"
	#define STR0007 "Editar Proceso"
	#define STR0008 "Borrar Proceso"
#else
	#ifdef ENGLISH
		#define STR0001 "Start Job on START on Protheus Server    "
		#define STR0002 "Executed Function (main)"
		#define STR0003 "Environment in Execution (environment)"
		#define STR0004 "Number of Processes (instances)"
		#define STR0005 "Number of Parameters (nParms)"
		#define STR0006 "Parameters"
		#define STR0007 "Edit Process   "
		#define STR0008 "Delete Process  "
	#else
		Static STR0001 := "Iniciar Job no START do Servidor Protheus"
		Static STR0002 := "Função Executada (main)"
		Static STR0003 := "Ambiente de Execução (environment)"
		Static STR0004 := "Número de Processos (instances)"
		#define STR0005  "Número de Parâmetros (nParms)"
		#define STR0006  "Parâmetros"
		#define STR0007  "Editar Processo"
		Static STR0008 := "Deletar Processo"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Iniciar Job No Iniciar Do Servidor Protheus"
			STR0002 := "Função executada (main)"
			STR0003 := "Ambiente de execução (environment)"
			STR0004 := "Número de processos (instances)"
			STR0008 := "Eliminar Processo"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
