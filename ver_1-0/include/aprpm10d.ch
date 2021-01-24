#ifdef SPANISH
	#define STR0001 "Pregunta"
	#define STR0002 "Tipo"
	#define STR0003 "Tamano"
	#define STR0004 "Decimal"
	#define STR0005 "Objeto"
	#define STR0006 "1=Edit;2=Text;3=Combo"
	#define STR0007 "Consulta Estandar (Edit)"
	#define STR0008 "Contenido (Edit/Text)"
	#define STR0009 "Pre Seleccion (Combo)"
	#define STR0010 "Expresion"
	#define STR0011 "Item 1 (Combo)"
	#define STR0012 "Item 2 (Combo)"
	#define STR0013 "Item 3 (Combo)"
	#define STR0014 "Item 4 (Combo)"
	#define STR0015 "Item 5 (Combo)"
	#define STR0016 "Help"
	#define STR0017 "Configurar Parametros"
	#define STR0018 "Configure los parametros del informe"
	#define STR0019 "Llene los campos Pregunta, Tipo y Tama�o"
	#define STR0020 "El objeto Combo requiere que se llene al menos un item"
	#define STR0021 "1=Caracter;2=Numerico;3=Fecha"
	#define STR0022 "Formato"
	#define STR0023 "Consultar Campos"
#else
	#ifdef ENGLISH
		#define STR0001 "Question"
		#define STR0002 "Type"
		#define STR0003 "Size"
		#define STR0004 "Decimal"
		#define STR0005 "Object"
		#define STR0006 "1=Edit;2=Text;3=Combo"
		#define STR0007 "Standard Search (Edit)"
		#define STR0008 "Contents (Edit/Text)"
		#define STR0009 "Pre-Selection (Combo)"
		#define STR0010 "Expression"
		#define STR0011 "Item 1 (Combo)"
		#define STR0012 "Item 2 (Combo)"
		#define STR0013 "Item 3 (Combo)"
		#define STR0014 "Item 4 (Combo)"
		#define STR0015 "Item 5 (Combo)"
		#define STR0016 "Help"
		#define STR0017 "Set Up Parameters"
		#define STR0018 "Configure the report parameters"
		#define STR0019 "Enter the fields Question, Type and Size"
		#define STR0020 "The object Combo must have at least 1 item entered"
		#define STR0021 "1=Character;2=Number;3=Date"
		#define STR0022 "Format"
		#define STR0023 "Query Fields"
	#else
		#define STR0001  "Pergunta"
		#define STR0002  "Tipo"
		#define STR0003  "Tamanho"
		#define STR0004  "Decimal"
		Static STR0005 := "Objeto"
		Static STR0006 := "1=Edit;2=Text;3=Combo"
		Static STR0007 := "Consulta Padrao (Edit)"
		Static STR0008 := "Conteudo (Edit/Text)"
		Static STR0009 := "Pre Selecao (Combo)"
		#define STR0010  "Express�o"
		Static STR0011 := "Item 1 (Combo)"
		Static STR0012 := "Item 2 (Combo)"
		Static STR0013 := "Item 3 (Combo)"
		Static STR0014 := "Item 4 (Combo)"
		Static STR0015 := "Item 5 (Combo)"
		Static STR0016 := "Help"
		Static STR0017 := "Configurar Parametros"
		Static STR0018 := "Configure os parametros do relat�rio"
		Static STR0019 := "Preencha os campos Pergunta, Tipo e Tamanho"
		Static STR0020 := "O objeto Combo precisa de pelo menos 1 item preenchido"
		Static STR0021 := "1=Caracter;2=Num�rico;3=Data"
		#define STR0022  "Formato"
		#define STR0023  "Consultar Campos"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0005 := "Objecto"
			STR0006 := "1=edit;2=text;3=combo"
			STR0007 := "Consulta padr�o (edit)"
			STR0008 := "Conte�do (edit/text)"
			STR0009 := "Pre selec��o (combo)"
			STR0011 := "Item 1 (combo)"
			STR0012 := "Item 2 (combo)"
			STR0013 := "Item 3 (combo)"
			STR0014 := "Item 4 (combo)"
			STR0015 := "Item 5 (combo)"
			STR0016 := "Ajuda"
			STR0017 := "Configurar Par�metros"
			STR0018 := "Configure os par�metros do relat�rio"
			STR0019 := "Preencha Os Campos Pergunta, Tipo E Tamanho"
			STR0020 := "O objecto combo precisa de pelo menos 1 item preenchido"
			STR0021 := "1=car�cter;2=num�rico;3=data"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
