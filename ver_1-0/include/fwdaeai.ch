#ifdef SPANISH
	#define STR0001 "Filial"
	#define STR0002 "Codigo"
	#define STR0003 "Codigo de la funcion"
	#define STR0004 "Descripcion de la funcion"
	#define STR0005 "Fecha transaccion "
	#define STR0006 "Hora transaccion"
	#define STR0007 "Fecha procesamiento"
	#define STR0008 "Hora procesamiento"
	#define STR0009 "N� Tentativas"
	#define STR0010 "Fecha tentativa"
	#define STR0011 "Hora tentativa"
	#define STR0012 "Tipo del procesamiento"
	#define STR0013 "Tipo de la transaccion"
	#define STR0014 "Estatus"
#else
	#ifdef ENGLISH
		#define STR0001 "Filial"
		#define STR0002 "C�digo"
		#define STR0003 "C�digo da fun��o"
		#define STR0004 "Descri��o da fun��o"
		#define STR0005 "Data transa��o"
		#define STR0006 "Hora transa��o"
		#define STR0007 "Data processamento"
		#define STR0008 "Hora processamento"
		#define STR0009 "N� Tentativas"
		#define STR0010 "Data tentativa"
		#define STR0011 "Hora tentativa"
		#define STR0012 "Tipo do processamento"
		#define STR0013 "Tipo da transa��o"
		#define STR0014 "Status"
	#else
		Static STR0001 := "Filial"
		Static STR0002 := "C�digo"
		Static STR0003 := "C�digo da fun��o"
		Static STR0004 := "Descri��o da fun��o"
		Static STR0005 := "Data transa��o"
		Static STR0006 := "Hora transa��o"
		Static STR0007 := "Data processamento"
		Static STR0008 := "Hora processamento"
		Static STR0009 := "N� Tentativas"
		Static STR0010 := "Data tentativa"
		Static STR0011 := "Hora tentativa"
		Static STR0012 := "Tipo do processamento"
		Static STR0013 := "Tipo da transa��o"
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
			STR0002 := "C�digo"
			STR0003 := "C�digo da fun��o"
			STR0004 := "Descri��o da fun��o"
			STR0005 := "Data transa��o"
			STR0006 := "Hora transa��o"
			STR0007 := "Data processamento"
			STR0008 := "Hora processamento"
			STR0009 := "N� Tentativas"
			STR0010 := "Data tentativa"
			STR0011 := "Hora tentativa"
			STR0012 := "Tipo do processamento"
			STR0013 := "Tipo da transa��o"
			STR0014 := "Status"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
