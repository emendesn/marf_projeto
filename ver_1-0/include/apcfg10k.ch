#ifdef SPANISH
	#define STR0001 "<Vacio>"
	#define STR0002 "Visualizar Indice - "
	#define STR0003 "Nuevo Indice"
	#define STR0004 "Editar Indice - "
	#define STR0005 "Borrar Indice - "
	#define STR0006 "Consultar Campos"
	#define STR0007 "Clave:"
	#define STR0008 "Descripcion:"
	#define STR0009 "Desc Español:"
	#define STR0010 "Desc Ingles:"
	#define STR0011 "Campos"
	#define STR0012 "Nickname:"
	#define STR0013 "Ya se utilizoeste Nickname en otro indice"
	#define STR0014 "Digite correctamente la clave"
	#define STR0015 "Muestra busq."
#else
	#ifdef ENGLISH
		#define STR0001 "<Empty>"
		#define STR0002 "View Index - "
		#define STR0003 "New Index"
		#define STR0004 "Edit Index - "
		#define STR0005 "Delete Index - "
		#define STR0006 "Browse Fields"
		#define STR0007 "Key:"
		#define STR0008 "Description:"
		#define STR0009 "Desc Span.:"
		#define STR0010 "Desc Eng.:"
		#define STR0011 "Fields"
		#define STR0012 "Nickname:"
		#define STR0013 "Nickname already used by another index."
		#define STR0014 "Enter the key correctly."
		#define STR0015 "Display search"
	#else
		Static STR0001 := "<Vazio>"
		Static STR0002 := "Visualizar Índice - "
		Static STR0003 := "Novo Índice"
		Static STR0004 := "Editar Índice - "
		Static STR0005 := "Excluir Índice - "
		#define STR0006  "Consultar Campos"
		#define STR0007  "Chave:"
		#define STR0008  "Descrição:"
		#define STR0009  "Desc Epanhol:"
		#define STR0010  "Desc Ingles:"
		#define STR0011  "Campos"
		#define STR0012  "Nickname:"
		Static STR0013 := "Nickname ja utilizado por outro indice"
		Static STR0014 := "Digite corretamente a chave"
		#define STR0015  "Mostra pesq."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "<vazio>"
			STR0002 := "Visualizar índice - "
			STR0003 := "Novo índice"
			STR0004 := "Editar índice - "
			STR0005 := "Excluir índice - "
			STR0013 := "Nickname já utilizado por outro índice"
			STR0014 := "Digite correctamente a chave"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
