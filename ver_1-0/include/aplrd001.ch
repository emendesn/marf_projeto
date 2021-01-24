#ifdef SPANISH
	#define STR0001 "Seleccionar Orden..."
	#define STR0002 "Seleccione el orden de la tabla"
	#define STR0003 "Orden:"
	#define STR0004 "Clave:"
	#define STR0005 "Nuevo Indice"
	#define STR0006 "Borrar Indice"
	#define STR0007 "Nuevo indice"
	#define STR0008 "Expresion:"
	#define STR0009 "Consultar Campos"
	#define STR0010 "Descripcion:"
	#define STR0011 "Rellene la expresion y la descripcion"
	#define STR0012 "¿Esta seguro de que desea borrar el indice?"
	#define STR0013 "Este indice no se puede borrar"
#else
	#ifdef ENGLISH
		#define STR0001 "Select the Order..."
		#define STR0002 "Select the table order   "
		#define STR0003 "Order:"
		#define STR0004 "Key:"
		#define STR0005 "New index"
		#define STR0006 "Delete Index"
		#define STR0007 "New index"
		#define STR0008 "Expression:"
		#define STR0009 "Query Fields"
		#define STR0010 "Description:"
		#define STR0011 "Fill out expression and descriptio"
		#define STR0012 "Are you sure you want to delete index ? "
		#define STR0013 "This index cannot be removed     "
	#else
		Static STR0001 := "Selecionar Ordem..."
		#define STR0002  "Escolha a ordem da tabela"
		#define STR0003  "Ordem:"
		#define STR0004  "Chave:"
		Static STR0005 := "Novo Ìndice"
		Static STR0006 := "Excluir Ìndice"
		#define STR0007  "Novo índice"
		#define STR0008  "Expressão:"
		#define STR0009  "Consultar Campos"
		#define STR0010  "Descrição:"
		#define STR0011  "Preencha a expressão e a descrição"
		#define STR0012  "Tem certeza que deseja excluir o índice?"
		#define STR0013  "Este índice não pode ser removido"
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
