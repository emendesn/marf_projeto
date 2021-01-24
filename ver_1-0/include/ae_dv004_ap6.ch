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
		Static STR0001 := "Prestação de Contas"
		#define STR0002  "Colaborador Viajando"
		Static STR0003 := "Iniciado Processo de Acerto"
		Static STR0004 := "Encaminhado e Aguardando Confirmação "
		#define STR0005  "Autorizado e Liberado"
		#define STR0006  "Solicitação Cancelada"
		#define STR0007  "Fechamento da Viagem"
		#define STR0008  "Iniciado Prest.Contas sem Solicitação "
		Static STR0009 := "Prestação de Contas sem Solicitação "
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
			STR0001 := "Prestação de contas"
			STR0003 := "Iniciado Proccesso de Acerto"
			STR0004 := "Encaminhado e a aguardar confirmação "
			STR0009 := "Prestação de contas sem solicitação "
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Prestação de contas"
			STR0003 := "Iniciado Proccesso de Acerto"
			STR0004 := "Encaminhado e a aguardar confirmação "
			STR0009 := "Prestação de contas sem solicitação "
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
