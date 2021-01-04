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
		#define STR0002  "Solicita��o Iniciada					"
		Static STR0003 := "Para Aprova��o              		   	"
		Static STR0004 := "Aguardando Aprovacao Workflow		"
		#define STR0005  "Solicita��o Aprovada        	       	"
		#define STR0006  "Solicita��o Reprovada       		   	"
		Static STR0007 := "Encaminhado Ag�ncia Viagem/Financeiro"
		#define STR0008  "Solicita��o Cancelada				"
		Static STR0009 := "Presta��o de Contas sem Solicita��o 	"
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
			STR0003 := "Para aprova��o              		   	"
			STR0004 := "A aguardar Aprova��o Workflow		"
			STR0007 := "Encaminhado ag�ncia viagem/financeiro"
			STR0009 := "Presta��o de contas sem solicita��o 	"
			STR0010 := "Respectivo acerto conclu�do 		   	"
		ElseIf cPaisLoc == "PTG"
			STR0003 := "Para aprova��o              		   	"
			STR0004 := "A aguardar Aprova��o Workflow		"
			STR0007 := "Encaminhado ag�ncia viagem/financeiro"
			STR0009 := "Presta��o de contas sem solicita��o 	"
			STR0010 := "Respectivo acerto conclu�do 		   	"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
