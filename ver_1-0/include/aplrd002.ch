#ifdef SPANISH
	#define STR0001 "Seleccionar Campos..."
	#define STR0002 "Seleccione los campos utilizados por la consulta"
	#define STR0003 "Formula"
	#define STR0004 "Agregar"
	#define STR0005 "Agregar Todos"
	#define STR0006 "Borrar"
	#define STR0007 "Borrar Todos"
	#define STR0008 "Propiedades"
	#define STR0009 "Mover arriba"
	#define STR0010 "Mover abajo"
	#define STR0011 "Propiedades - "
	#define STR0012 "Campo:"
	#define STR0013 "Encabezamiento:"
	#define STR0014 "Formato:"
	#define STR0015 "Totaliza"
	#define STR0016 "Nueva Formula"
	#define STR0017 "Tabla:"
	#define STR0018 "Expresion:"
	#define STR0019 "Consultar Campos"
	#define STR0020 "Tamano:"
	#define STR0021 "Error"
#else
	#ifdef ENGLISH
		#define STR0001 "Select the Fields..."
		#define STR0002 "Select the fileds to be used at the query "
		#define STR0003 "Formula"
		#define STR0004 "Add"
		#define STR0005 "Add All"
		#define STR0006 "Remover"
		#define STR0007 "Remove All"
		#define STR0008 "Properties"
		#define STR0009 "Move downward"
		#define STR0010 "Move upward "
		#define STR0011 "Properties   - "
		#define STR0012 "Field:"
		#define STR0013 "Header:"
		#define STR0014 "Formato:"
		#define STR0015 "Total"
		#define STR0016 "New Formula "
		#define STR0017 "Table:"
		#define STR0018 "Expression:"
		#define STR0019 "Query Fields"
		#define STR0020 "Size:"
		#define STR0021 "Error"
	#else
		Static STR0001 := "Selecionar Campos..."
		#define STR0002  "Escolha os campos utilizados pela consulta"
		#define STR0003  "Fórmula"
		#define STR0004  "Adicionar"
		#define STR0005  "Adicionar Todos"
		#define STR0006  "Remover"
		#define STR0007  "Remover Todos"
		#define STR0008  "Propriedades"
		Static STR0009 := "Mover acima"
		Static STR0010 := "Mover abaixo"
		#define STR0011  "Propriedades - "
		#define STR0012  "Campo:"
		#define STR0013  "Cabeçalho:"
		#define STR0014  "Formato:"
		Static STR0015 := "Totaliza"
		#define STR0016  "Nova Fórmula"
		#define STR0017  "Tabela:"
		#define STR0018  "Expressão:"
		#define STR0019  "Consultar Campos"
		#define STR0020  "Tamanho:"
		#define STR0021  "Erro"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Seleccionar Campos..."
			STR0009 := "Mover para cima"
			STR0010 := "Mover para baixo"
			STR0015 := "Totalizar"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
