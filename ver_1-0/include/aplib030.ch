#ifdef SPANISH
	#define STR0001 "Carpetas"
	#define STR0002 "Buscar:"
	#define STR0003 "&Buscar"
	#define STR0004 "Buscando..."
	#define STR0005 "&Limpiar"
	#define STR0006 "Opciones"
	#define STR0007 "&Coincidir mayusc./minusc."
	#define STR0008 "Localizar palabra &entera"
	#define STR0009 "Resultado de Busqueda"
	#define STR0010 "Buscar   "
	#define STR0011 "Carpetas"
	#define STR0012 " ocurrencias encontradas."
	#define STR0013 "Recortar"
	#define STR0014 "Copiar"
	#define STR0015 "Pegar"
	#define STR0016 "Calculadora"
	#define STR0017 "Agenda"
	#define STR0018 "Spool"
	#define STR0019 "Ayuda"
	#define STR0020 "Registro localizado"
#else
	#ifdef ENGLISH
		#define STR0001 "Folder"
		#define STR0002 "Search for:"
		#define STR0003 "&Search"
		#define STR0004 "Searching..."
		#define STR0005 "&Clear"
		#define STR0006 "Options"
		#define STR0007 "&Match case"
		#define STR0008 "Find whole &word"
		#define STR0009 "Search Result"
		#define STR0010 "Search   "
		#define STR0011 "Folders"
		#define STR0012 " match(es) found."
		#define STR0013 "Cut"
		#define STR0014 "Copy"
		#define STR0015 "Paste"
		#define STR0016 "Calculator"
		#define STR0017 "Agenda"
		#define STR0018 "Spool"
		#define STR0019 "Help"
		#define STR0020 "Localized record"
	#else
		#define STR0001  "Pasta"
		#define STR0002  "Procurar por:"
		Static STR0003 := "&Procurar"
		Static STR0004 := "Procurando..."
		Static STR0005 := "&Limpar"
		#define STR0006  "Opções"
		Static STR0007 := "&Coincidir maiúsc./minúsc."
		#define STR0008  "Localizar palavra &inteira"
		Static STR0009 := "Resultado da Procura"
		#define STR0010  "Pesquisar"
		#define STR0011  "Pastas"
		Static STR0012 := " ocorrencia(s) encontrada(s)."
		Static STR0013 := "Recortar"
		#define STR0014  "Copiar"
		#define STR0015  "Colar"
		#define STR0016  "Calculadora"
		#define STR0017  "Agenda"
		#define STR0018  "Spool"
		#define STR0019  "Ajuda"
		Static STR0020 := "Registro localizado"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0003 := "&procurar"
			STR0004 := "A procurar..."
			STR0005 := "&limpar"
			STR0007 := "&coincidir maiúsc./minúsc."
			STR0009 := "Resultado Da Procura"
			STR0012 := " ocorrência(s) encontrada(s)."
			STR0013 := "Cortar"
			STR0020 := "Registo localizado"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
