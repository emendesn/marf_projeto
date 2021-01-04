#ifdef SPANISH
	#define STR0001 "Rendicion de Cuentas"
	#define STR0002 "Colaborador Viajando"
	#define STR0003 "Iniciado Proceso de Ajuste"
	#define STR0004 "Encaminado y Esperando Confirmacion"
	#define STR0005 "Autorizado y Aprobado"
	#define STR0006 "Solicitud Anulada"
	#define STR0007 "Cierre del Viaje"
	#define STR0008 "Iniciado Rend.Cuentas sin Solicitud"
	#define STR0009 "Rendicion de Cuentas sin Solicitud"
	#define STR0010 "Ajuste del Gasto Atrasado"
	#define STR0011 "Leyenda"
#else
	#ifdef ENGLISH
		#define STR0001 "Rendering of accounts"
		#define STR0002 "Employee traveling"
		#define STR0003 "Adjustment process started"
		#define STR0004 "Forwarded and expecting confirmation "
		#define STR0005 "Authorized and Released"
		#define STR0006 "Request Canceled"
		#define STR0007 "Trip Closure"
		#define STR0008 "Started Rendering of Accounts without Request "
		#define STR0009 "Rendering of, without Request "
		#define STR0010 "Payment of Expense in Delay"
		#define STR0011 "Caption"
	#else
		Static STR0001 := "Presta��o de Contas"
		#define STR0002  "Colaborador Viajando"
		Static STR0003 := "Iniciado Processo de Acerto"
		Static STR0004 := "Encaminhado e Aguardando Confirma��o "
		#define STR0005  "Autorizado e Liberado"
		#define STR0006  "Solicita��o Cancelada"
		#define STR0007  "Fechamento da Viagem"
		#define STR0008  "Iniciado Prest.Contas sem Solicita��o "
		Static STR0009 := "Presta��o de Contas sem Solicita��o "
		#define STR0010  "Acerto da Despesa em Atraso"
		#define STR0011  "Legenda"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0001 := "Presta��o de contas"
			STR0003 := "Iniciado Proccesso de Acerto"
			STR0004 := "Encaminhado e a aguardar confirma��o "
			STR0009 := "Presta��o de contas sem solicita��o "
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Presta��o de contas"
			STR0003 := "Iniciado Proccesso de Acerto"
			STR0004 := "Encaminhado e a aguardar confirma��o "
			STR0009 := "Presta��o de contas sem solicita��o "
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
