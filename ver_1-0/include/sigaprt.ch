#ifdef SPANISH
	#define STR0001 "Error Desconocido"
	#define STR0002 "Tiempo Limite de Impresora"
	#define STR0003 "Error de E/S de Impresora"
	#define STR0004 "Impresora Seleccionada"
	#define STR0005 "Impresora sin Papel"
	#define STR0006 "Reconociendo Impresora"
	#define STR0007 "Impresora Desocupada"
	#define STR0008 "Error de conexión con la impresora"
	#define STR0009 "Estatus: "
	#define STR0010 "No fue posible determinar si la impresora esta conectada al puerto: "
	#define STR0011 ". ¿Que es lo que Ud. desea hacer?"
	#define STR0012 "Obs: Forzar el envio quizas trabe el Remote."
	#define STR0013 "Intentar Nuevamente"
	#define STR0014 "Anular"
	#define STR0015 "Forzar el Envio"
#else
	#ifdef ENGLISH
		#define STR0001 "Unknown Error"
		#define STR0002 "Printer Timeout"
		#define STR0003 "Printer I/O Error"
		#define STR0004 "Printer Selected"
		#define STR0005 "Printer Out of Paper"
		#define STR0006 "Printer in Acknowlegement"
		#define STR0007 "Printer not Busy"
		#define STR0008 "Error connecting to the printer"
		#define STR0009 "Status: "
		#define STR0010 "Unable to specify whether the printer is connected to the port: "
		#define STR0011 ". What would you like to do?"
		#define STR0012 "Obs: Choosing `Force Send` may freeze AP5 Remote."
		#define STR0013 "Try Again"
		#define STR0014 "Cancel"
		#define STR0015 "Force Send"
	#else
		#define STR0001  "Erro Desconhecido"
		Static STR0002 := "Tempo Limite da Impressora"
		Static STR0003 := "Erro de E/S da Impressora"
		Static STR0004 := "Impressora Selecionada"
		Static STR0005 := "Impressora sem Papel"
		Static STR0006 := "Reconhecendo Impressora"
		#define STR0007  "Impressora Livre"
		Static STR0008 := "Erro na conexão com a impressora"
		#define STR0009  "Status: "
		Static STR0010 := "Não foi possível determinar se a impressora esta conectada a porta: "
		Static STR0011 := ". O que você deseja fazer?"
		#define STR0012  "Obs: Forçar o envio poderá travar o Remote."
		#define STR0013  "Tentar Novamente"
		#define STR0014  "Cancelar"
		Static STR0015 := "Forçar o Envio"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0002 := "Tempo Limite Da Impressora"
			STR0003 := "Erro De E/s Da Impressora"
			STR0004 := "Impressora Seleccionada"
			STR0005 := "Impressora Sem Papel"
			STR0006 := "A Reconhecer Impressora"
			STR0008 := "Erro na ligação com a impressora"
			STR0010 := "Não foi possível determinar se a impressora está ligada à porta: "
			STR0011 := ". o que deseja fazer?"
			STR0015 := "Forçar O Envio"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
