#ifdef SPANISH
	#define STR0001 "<b>Serviço genérico de integração com o Protheus via TOTVS ESB.</b>"
	#define STR0002 "Metodo que recebe do TOTVS ESB uma mensagem para processamento pelo Microsiga Protheus"
	#define STR0003 "Metodo que retorna para o TOTVS ESB a próxima message de transmissão"
	#define STR0004 "Metodo que retorna o status da conexão de Web Services"
	#define STR0005 "Empresa/Filial inválida"
	#define STR0006 "Não foi possível atribuir o usuário de processamento"
	#define STR0007 "XML inválido"
	#define STR0008 "Não há empresas para processamento"
#else
	#ifdef ENGLISH
		#define STR0001 "<b>Serviço genérico de integração com o Protheus via TOTVS ESB.</b>"
		#define STR0002 "Metodo que recebe do TOTVS ESB uma mensagem para processamento pelo Microsiga Protheus"
		#define STR0003 "Metodo que retorna para o TOTVS ESB a próxima message de transmissão"
		#define STR0004 "Metodo que retorna o status da conexão de Web Services"
		#define STR0005 "Empresa/Filial inválida"
		#define STR0006 "Não foi possível atribuir o usuário de processamento"
		#define STR0007 "XML inválido"
		#define STR0008 "Não há empresas para processamento"
	#else
		Static STR0001 := "<b>Serviço genérico de integração com o Protheus via TOTVS ESB.</b>"
		Static STR0002 := "Metodo que recebe do TOTVS ESB uma mensagem para processamento pelo Microsiga Protheus"
		Static STR0003 := "Metodo que retorna para o TOTVS ESB a próxima message de transmissão"
		Static STR0004 := "Metodo que retorna o status da conexão de Web Services"
		Static STR0005 := "Empresa/Filial inválida"
		Static STR0006 := "Não foi possível atribuir o usuário de processamento"
		Static STR0007 := "XML inválido"
		Static STR0008 := "Não há empresas para processamento"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "<b>Serviço genérico de integração com o Protheus via TOTVS ESB.</b>"
			STR0002 := "Metodo que recebe do TOTVS ESB uma mensagem para processamento pelo Microsiga Protheus"
			STR0003 := "Metodo que retorna para o TOTVS ESB a próxima message de transmissão"
			STR0004 := "Metodo que retorna o status da conexão de Web Services"
			STR0005 := "Empresa/Filial inválida"
			STR0006 := "Não foi possível atribuir o usuário de processamento"
			STR0007 := "XML inválido"
			STR0008 := "Não há empresas para processamento"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
