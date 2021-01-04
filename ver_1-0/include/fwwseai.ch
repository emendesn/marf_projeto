#ifdef SPANISH
	#define STR0001 "<b>Servi�o gen�rico de integra��o com o Protheus via TOTVS ESB.</b>"
	#define STR0002 "Metodo que recebe do TOTVS ESB uma mensagem para processamento pelo Microsiga Protheus"
	#define STR0003 "Metodo que retorna para o TOTVS ESB a pr�xima message de transmiss�o"
	#define STR0004 "Metodo que retorna o status da conex�o de Web Services"
	#define STR0005 "Empresa/Filial inv�lida"
	#define STR0006 "N�o foi poss�vel atribuir o usu�rio de processamento"
	#define STR0007 "XML inv�lido"
	#define STR0008 "N�o h� empresas para processamento"
#else
	#ifdef ENGLISH
		#define STR0001 "<b>Servi�o gen�rico de integra��o com o Protheus via TOTVS ESB.</b>"
		#define STR0002 "Metodo que recebe do TOTVS ESB uma mensagem para processamento pelo Microsiga Protheus"
		#define STR0003 "Metodo que retorna para o TOTVS ESB a pr�xima message de transmiss�o"
		#define STR0004 "Metodo que retorna o status da conex�o de Web Services"
		#define STR0005 "Empresa/Filial inv�lida"
		#define STR0006 "N�o foi poss�vel atribuir o usu�rio de processamento"
		#define STR0007 "XML inv�lido"
		#define STR0008 "N�o h� empresas para processamento"
	#else
		Static STR0001 := "<b>Servi�o gen�rico de integra��o com o Protheus via TOTVS ESB.</b>"
		Static STR0002 := "Metodo que recebe do TOTVS ESB uma mensagem para processamento pelo Microsiga Protheus"
		Static STR0003 := "Metodo que retorna para o TOTVS ESB a pr�xima message de transmiss�o"
		Static STR0004 := "Metodo que retorna o status da conex�o de Web Services"
		Static STR0005 := "Empresa/Filial inv�lida"
		Static STR0006 := "N�o foi poss�vel atribuir o usu�rio de processamento"
		Static STR0007 := "XML inv�lido"
		Static STR0008 := "N�o h� empresas para processamento"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "<b>Servi�o gen�rico de integra��o com o Protheus via TOTVS ESB.</b>"
			STR0002 := "Metodo que recebe do TOTVS ESB uma mensagem para processamento pelo Microsiga Protheus"
			STR0003 := "Metodo que retorna para o TOTVS ESB a pr�xima message de transmiss�o"
			STR0004 := "Metodo que retorna o status da conex�o de Web Services"
			STR0005 := "Empresa/Filial inv�lida"
			STR0006 := "N�o foi poss�vel atribuir o usu�rio de processamento"
			STR0007 := "XML inv�lido"
			STR0008 := "N�o h� empresas para processamento"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
