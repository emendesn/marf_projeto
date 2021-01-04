#ifdef SPANISH
	#define STR0001 "WalkThru"
	#define STR0002 "Ambiente"
	#define STR0003 "Filial"
	#define STR0004 "Selecione a Filial"
	#define STR0005 "Perguntar Filial:"
	#define STR0006 "Sim"
	#define STR0007 "Não"
	#define STR0008 "Visualizar Filiais:"
	#define STR0009 "Confirmar"
#else
	#ifdef ENGLISH
		#define STR0001 "WalkThru"
		#define STR0002 "Ambiente"
		#define STR0003 "Filial"
		#define STR0004 "Selecione a Filial"
		#define STR0005 "Perguntar Filial:"
		#define STR0006 "Sim"
		#define STR0007 "Não"
		#define STR0008 "Visualizar Filiais:"
		#define STR0009 "Confirmar"
	#else
		Static STR0001 := "WalkThru"
		Static STR0002 := "Ambiente"
		Static STR0003 := "Filial"
		Static STR0004 := "Selecione a Filial"
		Static STR0005 := "Perguntar Filial:"
		Static STR0006 := "Sim"
		Static STR0007 := "Não"
		Static STR0008 := "Visualizar Filiais:"
		Static STR0009 := "Confirmar"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "WalkThru"
			STR0002 := "Ambiente"
			STR0003 := "Filial"
			STR0004 := "Selecione a Filial"
			STR0005 := "Perguntar Filial:"
			STR0006 := "Sim"
			STR0007 := "Não"
			STR0008 := "Visualizar Filiais:"
			STR0009 := "Confirmar"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
