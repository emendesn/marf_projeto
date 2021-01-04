#ifdef SPANISH
	#define STR0001 "Seleccionar Grupos..."
	#define STR0002 "A continuacion, elabore las expresiones para los grupos"
	#define STR0003 "Agregar"
	#define STR0004 "Editar"
	#define STR0005 "Eliminar"
	#define STR0006 "Nuevo Grupo"
	#define STR0007 "Propiedades - "
	#define STR0008 "Expresion:"
	#define STR0009 "Consultar Campos"
	#define STR0010 "Encabezamiento:"
	#define STR0011 "¿Esta seguro que desea borrar el grupo?"
	#define STR0012 "Saltar Pagina"
	#define STR0013 "Resumen"
#else
	#ifdef ENGLISH
		#define STR0001 "Select Groups..."
		#define STR0002 "Create below the group`s expressions"
		#define STR0003 "Add"
		#define STR0004 "Edit"
		#define STR0005 "Remove"
		#define STR0006 "New Group"
		#define STR0007 "Properties - "
		#define STR0008 "Expression:"
		#define STR0009 "Browse Fields"
		#define STR0010 "Header:"
		#define STR0011 "Do you really want to delete the group?"
		#define STR0012 "Break Page"
		#define STR0013 "Summary"
	#else
		Static STR0001 := "Selecionar Grupos..."
		Static STR0002 := "Monte abaixo as expressões para os grupos"
		Static STR0003 := "Adcionar"
		#define STR0004  "Editar"
		#define STR0005  "Remover"
		#define STR0006  "Novo Grupo"
		#define STR0007  "Propriedades - "
		#define STR0008  "Expressão:"
		#define STR0009  "Consultar Campos"
		#define STR0010  "Cabeçalho:"
		Static STR0011 := "Tem certeza que deseja excluir o grupo?"
		#define STR0012  "Quebrar Página"
		#define STR0013  "Resumo"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Seleccionar Grupos..."
			STR0002 := "Crie abaixo as expressões para os grupos"
			STR0003 := "Adicionar"
			STR0011 := "Tem a certeza que deseja excluir o grupo?"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
