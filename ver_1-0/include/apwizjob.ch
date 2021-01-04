#ifdef SPANISH
	#define STR0001 "(ninguna instancia relacionada)"
	#define STR0002 "(indeterminado)"
	#define STR0003 "Nombre del Proceso"
	#define STR0004 "Nombre de la Instancia"
	#define STR0005 "Tipo de Proceso"
	#define STR0006 "Entorno utilizado"
	#define STR0007 "Minimo de Working Threads Activos"
	#define STR0008 "Maximo de Working Threads Activos"
	#define STR0009 'Iniciar Job en el START del Servidor Protheus'
#else
	#ifdef ENGLISH
		#define STR0001 "(no area is listed)            "
		#define STR0002 "(undetermined )"
		#define STR0003 "Process Name    "
		#define STR0004 "Area Name        "
		#define STR0005 "Process Type    "
		#define STR0006 "Used environment  "
		#define STR0007 "Minimum  Active Working Threads "
		#define STR0008 "Maximum Active Working Threads "
		#define STR0009 'Start up Job in Protheus Server START'
	#else
		#define STR0001  "(nenhuma instância relacionada)"
		#define STR0002  "(indeterminado)"
		Static STR0003 := "Nome do Processo"
		Static STR0004 := "Nome da Instancia"
		Static STR0005 := "Tipo do Processo"
		#define STR0006  "Ambiente utilizado"
		Static STR0007 := "Minimo de Working Threads Ativas"
		Static STR0008 := "Maximo de Working Threads Ativas"
		Static STR0009 := 'Iniciar Job no START do Servidor Protheus'
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0003 := "Nome Do Processo"
			STR0004 := "Nome Da Instância"
			STR0005 := "Tipo Do Processo"
			STR0007 := "Mínimo De Working Threads Activas"
			STR0008 := "Máximo De Working Threads Activas"
			STR0009 := 'Iniciar Job No Iniciar Do Servidor Protheus'
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
