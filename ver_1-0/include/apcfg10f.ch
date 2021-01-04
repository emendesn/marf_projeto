#ifdef SPANISH
	#define STR0001 "Visualizar Tabla de Consulta - "
	#define STR0002 "Nueva Tabla de Consulta"
	#define STR0003 "Editar Tabla de Consulta - "
	#define STR0004 "Borrar Tabla de Consulta - "
	#define STR0005 "Confirmar"
	#define STR0006 "Anular"
	#define STR0007 "Itemes"
	#define STR0008 "Sin Descripcion"
	#define STR0009 "El tamaño de la Clave principal no puede ser mayor que 2 (dos)"
#else
	#ifdef ENGLISH
		#define STR0001 "View Search Table - "
		#define STR0002 "New Search Table"
		#define STR0003 "Edit Search Table - "
		#define STR0004 "Delete Search Table - "
		#define STR0005 "Confirm"
		#define STR0006 "Cancel"
		#define STR0007 "Items"
		#define STR0008 "W/o Description"
		#define STR0009 "The total size of the main Key cannot be bigger than 2 (two)"
	#else
		Static STR0001 := "Visualizar Tabela de Consulta - "
		Static STR0002 := "Nova Tabela de Consulta"
		Static STR0003 := "Editar Tabela de Consulta - "
		Static STR0004 := "Excluir Tabela de Consulta - "
		#define STR0005  "Confirmar"
		#define STR0006  "Cancelar"
		#define STR0007  "Itens"
		#define STR0008  "Sem Descrição"
		Static STR0009 := "O tamanho da Chave principal não pode ser maior que 2 (dois)"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Visualizar tabela de consulta - "
			STR0002 := "Nova Tabela De Consulta"
			STR0003 := "Editar tabela de consulta - "
			STR0004 := "Excluir tabela de consulta - "
			STR0009 := "O tamanho da chave principal não pode ser maior que 2 (dois)"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
