#ifdef SPANISH
	#define STR0001 "<Vacio>"
	#define STR0002 "Visualizar Carpeta - "
	#define STR0003 "Nueva Carpeta"
	#define STR0004 "Editar Carpeta - "
	#define STR0005 "Borrar Carpeta - "
	#define STR0006 "Descripcion"
	#define STR0007 "Desc. Esp."
	#define STR0008 "Desc. Ingles"
	#define STR0009 "Confirmar"
	#define STR0010 "Anular"
	#define STR0011 "Campos"
	#define STR0012 "Agregar..."
	#define STR0013 "Campo"
	#define STR0014 "Titulo"
	#define STR0015 "Todos los campos ya estan relacionados con alguna carpeta."
	#define STR0016 "Agregar campo"
	#define STR0017 "Campo"
	#define STR0018 "Titulo"
#else
	#ifdef ENGLISH
		#define STR0001 "<Empty>"
		#define STR0002 "View Folder - "
		#define STR0003 "New Folder"
		#define STR0004 "Edit Folder - "
		#define STR0005 "Delete Folder - "
		#define STR0006 "Description"
		#define STR0007 "Desc. Span."
		#define STR0008 "Desc. Eng."
		#define STR0009 "Confirm"
		#define STR0010 "Cancel"
		#define STR0011 "Fields"
		#define STR0012 "Add..."
		#define STR0013 "Field"
		#define STR0014 "Title"
		#define STR0015 "All fields are already linked to a specific folder."
		#define STR0016 "Add field"
		#define STR0017 "Field"
		#define STR0018 "Header"
	#else
		Static STR0001 := "<Vazio>"
		Static STR0002 := "Visualizar Pasta - "
		#define STR0003  "Nova Pasta"
		Static STR0004 := "Editar Pasta - "
		Static STR0005 := "Excluir Pasta - "
		Static STR0006 := "Descricao"
		#define STR0007  "Desc. Esp."
		Static STR0008 := "Desc. Ingles"
		#define STR0009  "Confirmar"
		#define STR0010  "Cancelar"
		#define STR0011  "Campos"
		#define STR0012  "Adicionar"
		#define STR0013  "Campo"
		#define STR0014  "Título"
		Static STR0015 := "Todos os campos ja estäo relacionados a alguma pasta."
		#define STR0016  "Adicionar campo"
		#define STR0017  "Campo"
		Static STR0018 := "Titulo"
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
			STR0002 := "Visualizar pasta - "
			STR0004 := "Editar pasta - "
			STR0005 := "Excluir pasta - "
			STR0006 := "Descrição"
			STR0008 := "Desc. Inglês"
			STR0015 := "Todos os campos já estão relacionados com alguma pasta."
			STR0018 := "Título"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
