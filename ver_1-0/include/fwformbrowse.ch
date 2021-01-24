#ifdef SPANISH
	#define STR0001 "Opções"
	#define STR0002 "Sair"
	#define STR0003 "Detalhes"
	#define STR0004 "Os itens acima estão filtrados, clique aqui para visualizar os filtros"
#else
	#ifdef ENGLISH
		#define STR0001 "Opções"
		#define STR0002 "Sair"
		#define STR0003 "Detalhes"
		#define STR0004 "Os itens acima estão filtrados, clique aqui para visualizar os filtros"
	#else
		Static STR0001 := "Opções"
		Static STR0002 := "Sair"
		Static STR0003 := "Detalhes"
		Static STR0004 := "Os itens acima estão filtrados, clique aqui para visualizar os filtros"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Opções"
			STR0002 := "Sair"
			STR0003 := "Detalhes"
			STR0004 := "Os itens acima estão filtrados, clique aqui para visualizar os filtros"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
