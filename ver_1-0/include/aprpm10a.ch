#ifdef SPANISH
	#define STR0001 "Seleccionar Campos..."
	#define STR0002 "Elija los campos utilizados por el informe"
	#define STR0003 "Formula"
	#define STR0004 "Agregar"
	#define STR0005 "Agregar Todos"
	#define STR0006 "Eliminar"
	#define STR0007 "Eliminar Todos"
	#define STR0008 "Propiedades"
	#define STR0009 "Mover p/arriba"
	#define STR0010 "Mover p/abajo"
	#define STR0011 "Propiedades - "
	#define STR0012 "Campo:"
	#define STR0013 "Encabezamiento:"
	#define STR0014 "Formato:"
	#define STR0015 "Nueva Formula"
	#define STR0016 "Expresion:"
	#define STR0017 "Consultar Campos"
	#define STR0018 "Totaliza"
	#define STR0019 "Tamaño:"
	#define STR0020 "Decimal:"
#else
	#ifdef ENGLISH
		#define STR0001 "Select Fields..."
		#define STR0002 "Choose the field used in report"
		#define STR0003 "Formula"
		#define STR0004 "Add"
		#define STR0005 "Add All"
		#define STR0006 "Remove"
		#define STR0007 "Remove All"
		#define STR0008 "Properties"
		#define STR0009 "Move Up"
		#define STR0010 "Move Down"
		#define STR0011 "Properties - "
		#define STR0012 "Field:"
		#define STR0013 "Header:"
		#define STR0014 "Format:"
		#define STR0015 "New Formula"
		#define STR0016 "Expression:"
		#define STR0017 "Browse Fields"
		#define STR0018 "Totalize"
		#define STR0019 "Size:"
		#define STR0020 "Decimal:"
	#else
		Static STR0001 := "Selecionar Campos..."
		#define STR0002  "Escolha os campos utilizados pelo relatório"
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
		#define STR0015  "Nova Fórmula"
		#define STR0016  "Expressão:"
		#define STR0017  "Consultar Campos"
		Static STR0018 := "Totaliza"
		#define STR0019  "Tamanho:"
		#define STR0020  "Decimal:"
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
			STR0018 := "Totalizar"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
