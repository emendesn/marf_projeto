#ifdef SPANISH
	#define STR0001 "�Desea Liberar Atraso de la Prestacion de Cuentas de este Colaborador?"
	#define STR0002 "�Desea Bloquear por Atraso a Rendicion de Cuentas de este Colaborador?"
	#define STR0003 "Esta solicitud esta anulada y no puede modificarse."
	#define STR0004 "Esta solicitud esta finalizada y no puede modificarse."
	#define STR0005 "Esta solicitud esta autorizada y aprobada y no puede modificarse."
	#define STR0006 "Rendicion de cuentas sin solicitud no pueden bloquearse."
	#define STR0007 "Atencion"
	#define STR0008 "�Bloqueo por Atraso finalizado con Exito!"
	#define STR0009 "�Aprobacion de Atraso finalizada con exito!"
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
		Static STR0001 := "Deseja Liberar Atraso da Presta��o de Contas desse Colaborador?"
		Static STR0002 := "Deseja Bloquear por Atraso a Presta��o de Contas desse Colaborador?"
		Static STR0003 := "Esta solicita��o est� cancelada e n�o pode ser alterada."
		Static STR0004 := "Esta solicita��o est� fechada e n�o pode ser alterada."
		#define STR0005  "Esta solicita��o est� autorizada e liberada e n�o pode ser alterada."
		#define STR0006  "Presta��o de contas sem solicita��o n�o podem ser bloqueadas."
		#define STR0007  "Aten��o"
		Static STR0008 := "Bloqueio por Atraso, concluido com Sucesso!"
		Static STR0009 := "Libera��o de Atraso, concluida com Sucesso!"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0001 := "Deseja liberar atraso da presta��o de contas desse colaborador?"
			STR0002 := "Deseja bloquear por atraso a presta��o de contas desse colaborador?"
			STR0003 := "Est� solicita��o est� cancelada e n�o pode ser alterada."
			STR0004 := "Est� solicita��o est� fechada e n�o pode ser alterada."
			STR0008 := "Bloqueio por atraso, conclu�do com successo!"
			STR0009 := "Libera��o de atraso, conclu�da com successo!"
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Deseja liberar atraso da presta��o de contas desse colaborador?"
			STR0002 := "Deseja bloquear por atraso a presta��o de contas desse colaborador?"
			STR0003 := "Est� solicita��o est� cancelada e n�o pode ser alterada."
			STR0004 := "Est� solicita��o est� fechada e n�o pode ser alterada."
			STR0008 := "Bloqueio por atraso, conclu�do com successo!"
			STR0009 := "Libera��o de atraso, conclu�da com successo!"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
