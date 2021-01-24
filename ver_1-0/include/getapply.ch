#ifdef SPANISH
	#define STR0001 "No existen informaciones para aplicarse."
	#define STR0002 "Mover arriba"
	#define STR0003 "Mover abajo"
	#define STR0004 "Borrar"
	#define STR0005 "Salvar"
	#define STR0006 "Salir"
	#define STR0007 "Capturar"
	#define STR0008 "Aplicar"
	#define STR0009 "Limpiar"
	#define STR0010 "Administrar"
#else
	#ifdef ENGLISH
		#define STR0001 "No information to be applied."
		#define STR0002 "Move Up"
		#define STR0003 "Move Down"
		#define STR0004 "Delete"
		#define STR0005 "Save"
		#define STR0006 "Exit"
		#define STR0007 "Capture"
		#define STR0008 "Apply"
		#define STR0009 "Clean"
		#define STR0010 "Manage"
	#else
		#define STR0001  "Não existem informações para serem aplicadas."
		Static STR0002 := "Mover Acima"
		Static STR0003 := "Mover Abaixo"
		#define STR0004  "Excluir"
		Static STR0005 := "Salvar"
		#define STR0006  "Sair"
		Static STR0007 := "Capturar"
		#define STR0008  "Aplicar"
		#define STR0009  "Limpar"
		Static STR0010 := "Gerenciar"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0002 := "Mover Para Cima"
			STR0003 := "Mover Para Baixo"
			STR0005 := "Guardar"
			STR0007 := "Obter"
			STR0010 := "Gerir"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
