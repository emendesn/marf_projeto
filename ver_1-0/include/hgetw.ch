#ifdef SPANISH
	#define STR0001 "Asistente"
	#define STR0002 " Agregar"
	#define STR0003 " Borrar"
	#define STR0004 " Modificar"
	#define STR0005 " Limpiar"
	#define STR0006 " Restaurar"
	#define STR0007 " Confimar"
	#define STR0008 " Anular"
	#define STR0009 "Agregue aqui los campos por mostrar:"
	#define STR0010 "Muestra:"
	#define STR0011 "¿Esta seguro que desea borrar este campo?"
	#define STR0012 "Texto fijo"
	#define STR0013 "Alfanumerico"
	#define STR0014 "Alfabetico"
	#define STR0015 "Numerico"
	#define STR0016 "Memo"
	#define STR0017 "Salto de linea"
	#define STR0018 "Tipo:"
	#define STR0019 "Texto:"
	#define STR0020 "Tamaño:"
	#define STR0021 "Formato:"
	#define STR0022 "Fecha"
	#define STR0023 "Espacio en blanco"
#else
	#ifdef ENGLISH
		#define STR0001 "Wizard"
		#define STR0002 " Add"
		#define STR0003 " Remove"
		#define STR0004 " Edit"
		#define STR0005 " Clear"
		#define STR0006 " Restore"
		#define STR0007 " Confirm"
		#define STR0008 " Cancel"
		#define STR0009 "Add here the fields to be shown:"
		#define STR0010 "Preview:"
		#define STR0011 "Are you sure you want to remove this field?"
		#define STR0012 "Fixed Text"
		#define STR0013 "Alphanumeric"
		#define STR0014 "Alphabetic"
		#define STR0015 "Numeric"
		#define STR0016 "Memo"
		#define STR0017 "Line Break"
		#define STR0018 "Type:"
		#define STR0019 "Text:"
		#define STR0020 "Size:"
		#define STR0021 "Format:"
		#define STR0022 "Date"
		#define STR0023 "Blank space"
	#else
		#define STR0001  "Assistente"
		#define STR0002  " Adicionar"
		#define STR0003  " Remover"
		#define STR0004  " Editar"
		#define STR0005  " Limpar"
		#define STR0006  " Restaurar"
		Static STR0007 := " Confimar"
		#define STR0008  " Cancelar"
		#define STR0009  "Adicione aqui os campos a serem mostrados:"
		#define STR0010  "Visual:"
		Static STR0011 := "Tem certeza que deseja remover este campo?"
		#define STR0012  "Texto Fixo"
		#define STR0013  "Alfanumérico"
		#define STR0014  "Alfabético"
		#define STR0015  "Numérico"
		#define STR0016  "Memo"
		Static STR0017 := "Quebra de Linha"
		#define STR0018  "Tipo:"
		#define STR0019  "Texto:"
		#define STR0020  "Tamanho:"
		#define STR0021  "Formato:"
		#define STR0022  "Data"
		#define STR0023  "Espaço em branco"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0007 := " Confirmar"
			STR0011 := "Tem a certeza que deseja remover este campo?"
			STR0017 := "Quebra De Linha"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
