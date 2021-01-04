#ifdef SPANISH
	#define STR0001 "Motivo de la Anulacion del Viaje"
	#define STR0002 "Informe el Motivo de la Anulacion"
	#define STR0003 "La Rutina no podra anularse sin estar digitado el motivo."
	#define STR0004 "Motivo de la anulacion de la solicitud "
	#define STR0005 "¡Motivo de la anulacion no encontrado!"
#else
	#ifdef ENGLISH
		#define STR0001 "Reason to Cancel The Trip"
		#define STR0002 "Enter reason for Cancellation"
		#define STR0003 "The Routine cannot be cancenled without a reason to be entered."
		#define STR0004 "Reason to cancel the request "
		#define STR0005 "Reason for cancellation not found!"
	#else
		Static STR0001 := "Motivo do Cancelamento da Viagem"
		Static STR0002 := "Informe o Motivo do Cancelamento"
		Static STR0003 := "A Rotina não poderá ser cancelada sem o motivo estar digitado."
		#define STR0004  "Motivo do cancelamento da solicitação "
		Static STR0005 := "Motivo de cancelamento nao encontrado!"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0001 := "Motivo do cancelamento da viagem"
			STR0002 := "Informe o motivo do cancelamento"
			STR0003 := "A rotina não poderá ser cancelada sem que o motivo esteja digitado."
			STR0005 := "Motivo de cancelamento não encontrado!"
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Motivo do cancelamento da viagem"
			STR0002 := "Informe o motivo do cancelamento"
			STR0003 := "A rotina não poderá ser cancelada sem que o motivo esteja digitado."
			STR0005 := "Motivo de cancelamento não encontrado!"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
