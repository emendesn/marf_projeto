#ifdef SPANISH
	#define STR0001 "ÌEl campo BICO tiene problemas de estructura, contacte al Administrador de sistema! "
	#define STR0002 "Producto no utiliza Control de Manguera "
	#define STR0003 "Surtidor no registrado "
#else
	#ifdef ENGLISH
		#define STR0001 "The field NOZZLE has structure problems, contact system Administrator!!! "
		#define STR0002 "Product has no Nozzle Control "
		#define STR0003 "Nozzle Not Registered "
	#else
		Static STR0001 := "O campo BICO, encontra-se com problema de estrutura, contate o Administrador de sistema !!! "
		Static STR0002 := "Produto n„o utiliza Contole de Bico "
		Static STR0003 := "Bico da Bomba n„o Cadastrado "
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "O campo BICO encontra-se com problema de estructura, contacte o administrador de sistema! "
			STR0002 := "Artigo n„o utiliza Controle de Bico "
			STR0003 := "Bico da bomba n„o registrado "
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
