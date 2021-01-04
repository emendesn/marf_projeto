#ifdef SPANISH
	#define STR0001 "Pesquisar"
	#define STR0002 "Detalhes da pesquisa"
	#define STR0003 "Pesquisa"
	#define STR0004 "Ordem"
	#define STR0005 "Chave"
	#define STR0006 "Buscar"
#else
	#ifdef ENGLISH
		#define STR0001 "Pesquisar"
		#define STR0002 "Detalhes da pesquisa"
		#define STR0003 "Pesquisa"
		#define STR0004 "Ordem"
		#define STR0005 "Chave"
		#define STR0006 "Buscar"
	#else
		Static STR0001 := "Pesquisar"
		Static STR0002 := "Detalhes da pesquisa"
		Static STR0003 := "Pesquisa"
		Static STR0004 := "Ordem"
		Static STR0005 := "Chave"
		Static STR0006 := "Buscar"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Pesquisar"
			STR0002 := "Detalhes da pesquisa"
			STR0003 := "Pesquisa"
			STR0004 := "Ordem"
			STR0005 := "Chave"
			STR0006 := "Buscar"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
