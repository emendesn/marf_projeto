#ifdef SPANISH
	#define STR0001 "Filtro"
	#define STR0002 "Operador"
	#define STR0003 "Igual a"
	#define STR0004 "Diferente de"
	#define STR0005 "Menor que"
	#define STR0006 "Menor o Igual a"
	#define STR0007 "Mayor que"
	#define STR0008 "Mayor o igual a"
	#define STR0009 "Contiene la expresion"
	#define STR0010 "No contiene la expresion"
	#define STR0011 "Esta contenido en"
	#define STR0012 "No esta contenido en"
	#define STR0013 "Valor constante"
	#define STR0014 "Parametro"
	#define STR0015 "&Agregar"
	#define STR0016 "&Limpiar Filtro"
	#define STR0017 "&Expresion"
	#define STR0018 "y"
	#define STR0019 "o"
	#define STR0020 "Visualizar filtro"
	#define STR0021 "Tipo de datos imcompatibles"
	#define STR0022 "Expresion"
	#define STR0023 "¡Expresion de filtro no puede contener mas que 600 caracteres!"
#else
	#ifdef ENGLISH
		#define STR0001 "Filter"
		#define STR0002 "Operator"
		#define STR0003 "Equal to"
		#define STR0004 "Different from"
		#define STR0005 "Less than"
		#define STR0006 "Less than or equal to"
		#define STR0007 "More than"
		#define STR0008 "More than or equal to"
		#define STR0009 "Contains the expression"
		#define STR0010 "Does not contain the expression"
		#define STR0011 "Is contained in"
		#define STR0012 "Is not contained in"
		#define STR0013 "Constant Value"
		#define STR0014 "Parameter"
		#define STR0015 "&Add"
		#define STR0016 "&Clear Filter"
		#define STR0017 "&Expression"
		#define STR0018 "and"
		#define STR0019 "or"
		#define STR0020 "View filter"
		#define STR0021 "Incompatible data type"
		#define STR0022 "Expression"
		#define STR0023 "Filter expression cannot contain more than 600 characters!"
	#else
		#define STR0001  "Filtro"
		#define STR0002  "Operador"
		#define STR0003  "Igual a"
		#define STR0004  "Diferente de"
		#define STR0005  "Menor que"
		Static STR0006 := "Menor ou Igual a"
		#define STR0007  "Maior que"
		#define STR0008  "Maior ou igual a"
		#define STR0009  "Contém a expressão"
		#define STR0010  "Não contém a expressão"
		#define STR0011  "Está contido em"
		#define STR0012  "Não está contido em"
		#define STR0013  "Valor Constante"
		Static STR0014 := "Parametro"
		Static STR0015 := "&Adicionar"
		Static STR0016 := "&Limpar Filtro"
		Static STR0017 := "&Expressão"
		Static STR0018 := "e"
		Static STR0019 := "ou"
		#define STR0020  "Visualizar filtro"
		#define STR0021  "Tipo de dados imcompatíveis"
		#define STR0022  "Expressão"
		Static STR0023 := "Expressao de filtro nao pode conter mais de 600 caracteres!"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0006 := "Menor ou igual a"
			STR0014 := "Parâmetros"
			STR0015 := "&adicionar"
			STR0016 := "&limpar Filtro"
			STR0017 := "&expressão"
			STR0018 := "é"
			STR0019 := "Ou"
			STR0023 := "Expressão de filtro não pode conter mais de 600 caracteres!"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
