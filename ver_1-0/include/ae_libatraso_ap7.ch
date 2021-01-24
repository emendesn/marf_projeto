#ifdef SPANISH
	#define STR0001 "¿Desea Liberar Atraso de la Prestacion de Cuentas de este Colaborador?"
	#define STR0002 "¿Desea Bloquear por Atraso a Rendicion de Cuentas de este Colaborador?"
	#define STR0003 "Esta solicitud esta anulada y no puede modificarse."
	#define STR0004 "Esta solicitud esta finalizada y no puede modificarse."
	#define STR0005 "Esta solicitud esta autorizada y aprobada y no puede modificarse."
	#define STR0006 "Rendicion de cuentas sin solicitud no pueden bloquearse."
	#define STR0007 "Atencion"
	#define STR0008 "¡Bloqueo por Atraso finalizado con Exito!"
	#define STR0009 "¡Aprobacion de Atraso finalizada con exito!"
#else
	#ifdef ENGLISH
		#define STR0001 "Do you want to release delay in Rendering of Accounts of this Employee?"
		#define STR0002 "Do you want to block per delay rendering of accounts of this Employee? "
		#define STR0003 "This request is canceled and can not be edited."
		#define STR0004 "This request is closed and can not be edited."
		#define STR0005 "This request is authorized and release, therefore, it can not be edited."
		#define STR0006 "Rendering of accounts without request can not be blocked."
		#define STR0007 "Attention"
		#define STR0008 "Blockage per delay, Successfully concluded!"
		#define STR0009 "Delay Release, Successfully concluded!"
	#else
		Static STR0001 := "Deseja Liberar Atraso da Prestação de Contas desse Colaborador?"
		Static STR0002 := "Deseja Bloquear por Atraso a Prestação de Contas desse Colaborador?"
		Static STR0003 := "Esta solicitação está cancelada e não pode ser alterada."
		Static STR0004 := "Esta solicitação está fechada e não pode ser alterada."
		#define STR0005  "Esta solicitação está autorizada e liberada e não pode ser alterada."
		#define STR0006  "Prestação de contas sem solicitação não podem ser bloqueadas."
		#define STR0007  "Atenção"
		Static STR0008 := "Bloqueio por Atraso, concluido com Sucesso!"
		Static STR0009 := "Liberação de Atraso, concluida com Sucesso!"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0001 := "Deseja liberar atraso da prestação de contas desse colaborador?"
			STR0002 := "Deseja bloquear por atraso a prestação de contas desse colaborador?"
			STR0003 := "Está solicitação está cancelada e não pode ser alterada."
			STR0004 := "Está solicitação está fechada e não pode ser alterada."
			STR0008 := "Bloqueio por atraso, concluído com successo!"
			STR0009 := "Liberação de atraso, concluída com successo!"
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Deseja liberar atraso da prestação de contas desse colaborador?"
			STR0002 := "Deseja bloquear por atraso a prestação de contas desse colaborador?"
			STR0003 := "Está solicitação está cancelada e não pode ser alterada."
			STR0004 := "Está solicitação está fechada e não pode ser alterada."
			STR0008 := "Bloqueio por atraso, concluído com successo!"
			STR0009 := "Liberação de atraso, concluída com successo!"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
