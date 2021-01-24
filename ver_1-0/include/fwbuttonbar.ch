#ifdef SPANISH
	#define STR0001 "Calculadora"
	#define STR0002 "Imprime Archivo"
	#define STR0003 "Entorno"
	#define STR0004 "Ayuda"
	#define STR0005 "¿Confirma el Borrado?"
	#define STR0006 "Atencion"
	#define STR0007 "Inhibir barra de botones"
	#define STR0008 "Mostrar barra de botones"
	#define STR0009 "Anular"
#else
	#ifdef ENGLISH
		#define STR0001 "Calculator"
		#define STR0002 "Print Register"
		#define STR0003 "Environment"
		#define STR0004 "Help"
		#define STR0005 "Are you sure you want to delete?"
		#define STR0006 "Attention"
		#define STR0007 "Hide buttons bar"
		#define STR0008 "Show buttons bar"
		#define STR0009 "Cancel"
	#else
		#define STR0001  "Calculadora"
		Static STR0002 := "Imprime Cadastro"
		#define STR0003  "Ambiente"
		#define STR0004  "Ajuda"
		Static STR0005 := "Confirma a Exclusao?"
		#define STR0006  "Atenção"
		Static STR0007 := "Inibir barra de botões"
		Static STR0008 := "Exibir barra de botões"
		#define STR0009  "Cancelar"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0002 := "Imprime Registo"
			STR0005 := "Confirmar A Exclusão?"
			STR0007 := "Inibir barra de botoes"
			STR0008 := "Exibir barra de botoes"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
