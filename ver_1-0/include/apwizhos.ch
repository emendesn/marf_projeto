#ifdef SPANISH
	#define STR0001 "(ningun - enlace .aplnäo soportado)"
	#define STR0002 "(apw no soportado)"
	#define STR0003 "(ningun modulo relacionado)"
	#define STR0004 "(ninguna instancia relacionada)"
	#define STR0005 "URL del Host"
	#define STR0006 "Nombre de la Instancia"
	#define STR0007 "Entorno utilizado ( Environment )"
	#define STR0008 "Job Principal (ResponseJob)"
	#define STR0009 "Camino de imagenes ( WebPath )"
#else
	#ifdef ENGLISH
		#define STR0001 "(no links .apl were supported)      "
		#define STR0002 "(apw not supported)"
		#define STR0003 "(no module is listed)      "
		#define STR0004 "(no area is listed)            "
		#define STR0005 "Host URL   "
		#define STR0006 "Area Name        "
		#define STR0007 "Environment used  ( Environment )"
		#define STR0008 "Main job  (ResponseJob)"
		#define STR0009 "Images Path  ( WebPath )"
	#else
		#define STR0001  "(nenhum - links .apl não suportados)"
		#define STR0002  "(apw não suportado)"
		#define STR0003  "(nenhum módulo relacionado)"
		#define STR0004  "(nenhuma instância relacionada)"
		Static STR0005 := "URL do Host"
		Static STR0006 := "Nome da Instancia"
		Static STR0007 := "Ambiente utilizado ( Environment )"
		Static STR0008 := "Job Principal (ResponseJob)"
		Static STR0009 := "Caminho das imagens ( WebPath )"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0005 := "Url Do Host"
			STR0006 := "Nome Da Instância"
			STR0007 := "Ambiente utilizado ( environment )"
			STR0008 := "Job principal (responsejob)"
			STR0009 := "Caminho das imagens ( webpath )"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
