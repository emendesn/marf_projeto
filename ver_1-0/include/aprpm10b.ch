#ifdef SPANISH
	#define STR0001 "Seleccionar Orden..."
	#define STR0002 "Elija el orden de la tabla"
	#define STR0003 "Orden:"
	#define STR0004 "Clave:"
	#define STR0005 "Nuevo Indice"
	#define STR0006 "Borrar Indice"
	#define STR0007 "Expresion:"
	#define STR0008 "Consultar Campos"
	#define STR0009 "Descripcion:"
	#define STR0010 "Llene la expresion y la descripcion"
	#define STR0011 "¿Esta seguro que desea borrar el indice?"
	#define STR0012 "Este indice no puede eliminarse"
#else
	#ifdef ENGLISH
		#define STR0001 "Select Order..."
		#define STR0002 "Choose the table order"
		#define STR0003 "Order:"
		#define STR0004 "Key:"
		#define STR0005 "New Index"
		#define STR0006 "Delete Index"
		#define STR0007 "Expression:"
		#define STR0008 "Browse fields"
		#define STR0009 "Description:"
		#define STR0010 "Enter the expression and description"
		#define STR0011 "Do you really want to delete the index?"
		#define STR0012 "This index cannot be removed"
	#else
		Static STR0001 := "Selecionar Ordem..."
		#define STR0002  "Escolha a ordem da tabela"
		#define STR0003  "Ordem:"
		#define STR0004  "Chave:"
		Static STR0005 := "Novo Ìndice"
		Static STR0006 := "Excluir Ìndice"
		#define STR0007  "Expressão:"
		#define STR0008  "Consultar Campos"
		#define STR0009  "Descrição:"
		#define STR0010  "Preencha a expressão e a descrição"
		#define STR0011  "Tem certeza que deseja excluir o índice?"
		#define STR0012  "Este índice não pode ser removido"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Seleccionar Ordem..."
			STR0005 := "Novo índice"
			STR0006 := "Excluir ìndice"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
