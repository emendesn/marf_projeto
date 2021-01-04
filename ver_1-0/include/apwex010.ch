#ifdef SPANISH
	#define STR0001 "Data WareHouse"
	#define STR0002 "Balanced ScoreCard"
	#define STR0003 "Proyecto Makira WEBEX"
	#define STR0004 "Gestion Educativa"
	#define STR0005 "Gestion de Encuesta y Resultado"
	#define STR0006 "Terminal del Empleado (RRHH On-line)"
	#define STR0007 "Portal Protheus"
	#define STR0008 "Aula de Aprendizaje Virtual"
	#define STR0009 "Gestion de Acervos"
	#define STR0010 "WebPrint & WebSpool"
	#define STR0011 "Sistema de Gestion de Indicadores"
#else
	#ifdef ENGLISH
		#define STR0001 "Data WareHouse"
		#define STR0002 "Balanced ScoreCard"
		#define STR0003 "Makira WEBEX Project"
		#define STR0004 "Educational Management"
		#define STR0005 "Search and Result Management"
		#define STR0006 "Employee Terminal (HR Online)"
		#define STR0007 "Protheus Portal"
		#define STR0008 "Virtual Education Room"
		#define STR0009 "Stock Management"
		#define STR0010 "WebPrint & WebSpool"
		#define STR0011 "Indicators Management System "
	#else
		Static STR0001 := "Data WareHouse"
		Static STR0002 := "Balanced ScoreCard"
		Static STR0003 := "Projeto Makira WEBEX"
		Static STR0004 := "Gestão Educacional"
		Static STR0005 := "Gestão de Pesquisa e Resultado"
		Static STR0006 := "Terminal do Funcionário (RH Online)"
		#define STR0007  "Portal Protheus"
		Static STR0008 := "Sala de Aprendizagem Virtual"
		Static STR0009 := "Gestão de Acervos"
		Static STR0010 := "WebPrint & WebSpool"
		Static STR0011 := "Sistema de Gestão de Indicadores"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Armazém De Dados"
			STR0002 := "Balanced Scorecard"
			STR0003 := "Projecto Makira Webex"
			STR0004 := "Gestão educacional"
			STR0005 := "Gestão De Pesquisa E Resultado"
			STR0006 := "Terminal Do Empregado (rh Online)"
			STR0008 := "Sala De Aprendizagem Virtual"
			STR0009 := "Gestão De Acervos"
			STR0010 := "Webprint & Webspool"
			STR0011 := "Sistema De Gestão De Indicadores"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
