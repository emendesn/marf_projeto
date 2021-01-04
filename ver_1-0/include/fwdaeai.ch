#ifdef SPANISH
	#define STR0001 "Filial"
	#define STR0002 "Codigo"
	#define STR0003 "Codigo de la funcion"
	#define STR0004 "Descripcion de la funcion"
	#define STR0005 "Fecha transaccion "
	#define STR0006 "Hora transaccion"
	#define STR0007 "Fecha procesamiento"
	#define STR0008 "Hora procesamiento"
	#define STR0009 "Nº Tentativas"
	#define STR0010 "Fecha tentativa"
	#define STR0011 "Hora tentativa"
	#define STR0012 "Tipo del procesamiento"
	#define STR0013 "Tipo de la transaccion"
	#define STR0014 "Estatus"
#else
	#ifdef ENGLISH
		#define STR0001 "Filial"
		#define STR0002 "Código"
		#define STR0003 "Código da função"
		#define STR0004 "Descrição da função"
		#define STR0005 "Data transação"
		#define STR0006 "Hora transação"
		#define STR0007 "Data processamento"
		#define STR0008 "Hora processamento"
		#define STR0009 "Nº Tentativas"
		#define STR0010 "Data tentativa"
		#define STR0011 "Hora tentativa"
		#define STR0012 "Tipo do processamento"
		#define STR0013 "Tipo da transação"
		#define STR0014 "Status"
	#else
		Static STR0001 := "Filial"
		Static STR0002 := "Código"
		Static STR0003 := "Código da função"
		Static STR0004 := "Descrição da função"
		Static STR0005 := "Data transação"
		Static STR0006 := "Hora transação"
		Static STR0007 := "Data processamento"
		Static STR0008 := "Hora processamento"
		Static STR0009 := "Nº Tentativas"
		Static STR0010 := "Data tentativa"
		Static STR0011 := "Hora tentativa"
		Static STR0012 := "Tipo do processamento"
		Static STR0013 := "Tipo da transação"
		Static STR0014 := "Status"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Filial"
			STR0002 := "Código"
			STR0003 := "Código da função"
			STR0004 := "Descrição da função"
			STR0005 := "Data transação"
			STR0006 := "Hora transação"
			STR0007 := "Data processamento"
			STR0008 := "Hora processamento"
			STR0009 := "Nº Tentativas"
			STR0010 := "Data tentativa"
			STR0011 := "Hora tentativa"
			STR0012 := "Tipo do processamento"
			STR0013 := "Tipo da transação"
			STR0014 := "Status"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
