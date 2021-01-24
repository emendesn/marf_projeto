#ifdef SPANISH
	#define STR0001 "Departamento de Viaje"
	#define STR0002 "Solicitud Iniciada					"
	#define STR0003 "Para Aprobacion              		   	"
	#define STR0004 "Aguardando Aprobacion Workflow		"
	#define STR0005 "Solicitud Aprobada        	       	"
	#define STR0006 "Solicitud Reprobada       		   	"
	#define STR0007 "Encaminado Agencia Viaje/Financiero"
	#define STR0008 "Solicitud Anulada				"
	#define STR0009 "Rendicion de Cuentas sin Solicitud 	"
	#define STR0010 "Respectivo Ajuste Concluido 		   	"
	#define STR0011 "Cierre del Viaje 			   		"
	#define STR0012 "Leyenda Depto de Viaje"
#else
	#ifdef ENGLISH
		#define STR0001 "Trip Complement "
		#define STR0002 "Request initiated					"
		#define STR0003 "For  Approval              		   	"
		#define STR0004 "Waiting Workflow Approval 		"
		#define STR0005 "Request Approved        	       	"
		#define STR0006 "Request Denied       		   	"
		#define STR0007 "Forwarded Travel Agency/Financial "
		#define STR0008 "Request Canceled				"
		#define STR0009 "Rendering of Accounts in request 	"
		#define STR0010 "Respective Adjustment Concluded 		   	"
		#define STR0011 "Trip Closing 			   		"
		#define STR0012 "Trip Department Caption"
	#else
		#define STR0001  "Departamento de Viagem"
		#define STR0002  "Solicitação Iniciada					"
		Static STR0003 := "Para Aprovação              		   	"
		Static STR0004 := "Aguardando Aprovacao Workflow		"
		#define STR0005  "Solicitação Aprovada        	       	"
		#define STR0006  "Solicitação Reprovada       		   	"
		Static STR0007 := "Encaminhado Agência Viagem/Financeiro"
		#define STR0008  "Solicitação Cancelada				"
		Static STR0009 := "Prestação de Contas sem Solicitação 	"
		Static STR0010 := "Respectivo Acerto Concluido 		   	"
		#define STR0011  "Fechamento da Viagem 			   		"
		#define STR0012  "Legenda Depto de Viagem"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0003 := "Para aprovação              		   	"
			STR0004 := "A aguardar Aprovação Workflow		"
			STR0007 := "Encaminhado agência viagem/financeiro"
			STR0009 := "Prestação de contas sem solicitação 	"
			STR0010 := "Respectivo acerto concluído 		   	"
		ElseIf cPaisLoc == "PTG"
			STR0003 := "Para aprovação              		   	"
			STR0004 := "A aguardar Aprovação Workflow		"
			STR0007 := "Encaminhado agência viagem/financeiro"
			STR0009 := "Prestação de contas sem solicitação 	"
			STR0010 := "Respectivo acerto concluído 		   	"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
